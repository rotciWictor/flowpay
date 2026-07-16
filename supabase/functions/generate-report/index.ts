import { serve } from "std/http/server.ts"
import { createClient } from '@supabase/supabase-js'
import { PDFDocument, rgb } from 'pdf-lib'
import fontkit from 'https://esm.sh/@pdf-lib/fontkit@1.1.1'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // CORS Preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Verificação de Autenticação (Protegendo contra chamadas não autorizadas)
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      console.error('[Auth Error] No authorization header provided')
      throw new Error('No authorization header')
    }
    
    console.log('[Auth] Verifying user token...')
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser(authHeader.replace('Bearer ', ''))
    if (userError || !user) {
      console.error('[Auth Error] Invalid token or user not found:', userError?.message)
      throw new Error('Unauthorized')
    }
    console.log(`[Auth Success] User ID: ${user.id}`)

    const { filters, format } = await req.json()
    console.log(`[Request] Format: ${format}, Filters:`, filters)

    // 1. Buscar transações otimizadas via RPC no PostgreSQL
    console.log(`[RPC Fetch] Calling get_transactions_for_report for merchant ${user.id}...`)
    const { data: transactions, error: fetchError } = await supabaseClient.rpc('get_transactions_for_report', {
      p_merchant_id: user.id,
      p_start_date: filters?.startDate ?? null,
      p_end_date: filters?.endDate ?? null,
      p_types: filters?.types && filters.types.length > 0 ? filters.types : null,
      p_statuses: filters?.statuses && filters.statuses.length > 0 ? filters.statuses : null,
    })

    if (fetchError) {
      console.error('[RPC Error] Failed to fetch transactions:', fetchError.message, fetchError.details)
      throw new Error(`Erro ao buscar dados: ${fetchError.message}`)
    }
    if (!transactions || transactions.length === 0) {
      console.warn('[RPC Warning] No transactions returned')
      throw new Error('Nenhuma transação encontrada neste período')
    }
    console.log(`[RPC Success] Retrieved ${transactions.length} transactions.`)

    let fileBytes: Uint8Array
    let mimeType: string
    let fileName: string

    if (format === 'xml') {
      // Gerar XML
      let xml = '<?xml version="1.0" encoding="UTF-8"?>\n<report>\n'
      transactions.forEach((t: any) => {
        xml += `  <transaction id="${t.id}">\n`
        xml += `    <amount>${t.amount}</amount>\n`
        xml += `    <net_amount>${t.net_amount}</net_amount>\n`
        xml += `    <fee_amount>${t.fee_amount}</fee_amount>\n`
        xml += `    <status>${t.status}</status>\n`
        xml += `    <type>${t.transaction_type}</type>\n`
        xml += `    <date>${t.created_at}</date>\n`
        xml += `  </transaction>\n`
      })
      xml += '</report>'
      fileBytes = new TextEncoder().encode(xml)
      mimeType = 'application/xml'
      fileName = `report_${Date.now()}.xml`
    } else {
      console.log('[PDF Generation] Starting PDF generation...')
      // 2. Adquirir Fonte TTF segura (Roboto) do bucket de assets para suportar R$ e Acentos
      let fontBytes: Uint8Array
      console.log('[Assets] Fetching Roboto font from storage...')
      const { data: fontData, error: fontError } = await supabaseClient.storage.from('reports_assets').download('Roboto-Regular.ttf')
      
      if (fontError || !fontData) {
        console.warn('[Assets] Font not found locally. Downloading from CDN (jsDelivr)...')
        // Se a fonte ainda não existir no bucket local, baixa da CDN e salva
        const res = await fetch('https://cdn.jsdelivr.net/fontsource/fonts/roboto@latest/latin-400-normal.ttf')
        if (!res.ok) {
          console.error('[Assets Error] Failed to download font from CDN')
          throw new Error('Falha ao baixar fonte externa')
        }
        const arrayBuffer = await res.arrayBuffer()
        fontBytes = new Uint8Array(arrayBuffer)
        console.log('[Assets] Saving font to reports_assets bucket for future use...')
        // Guardar no bucket para acelerar futuras execuções
        await supabaseClient.storage.from('reports_assets').upload('Roboto-Regular.ttf', fontBytes, { contentType: 'font/ttf' })
      } else {
        console.log('[Assets Success] Font loaded from bucket.')
        fontBytes = new Uint8Array(await fontData.arrayBuffer())
      }

      console.log('[PDF-LIB] Embedding font and building document structure...')
      const pdfDoc = await PDFDocument.create()
      
      // Registrar fontkit e embutir a fonte Roboto (TrueType)
      pdfDoc.registerFontkit(fontkit)
      const customFont = await pdfDoc.embedFont(fontBytes)
      
      const page = pdfDoc.addPage([595.28, 841.89]) // A4
      const { width, height } = page.getSize()
      
      // Fundo branco explícito para evitar "tela preta" em visualizadores nativos (ex: Android/iOS Dark Mode)
      page.drawRectangle({
        x: 0,
        y: 0,
        width: width,
        height: height,
        color: rgb(1, 1, 1), // Branco
      })
      
      page.drawText('Relatório de Transações - FlowPay', {
        x: 50,
        y: height - 50,
        size: 20,
        font: customFont,
        color: rgb(0.0, 0.9, 0.46), // FlowColors.primary
      })

      page.drawText(`Gerado em: ${new Date().toLocaleString('pt-BR')}`, {
        x: 50,
        y: height - 70,
        size: 10,
        font: customFont,
      })

      let y = height - 120
      page.drawText('DATA / HORA         TIPO         STATUS         VALOR', {
        x: 50,
        y,
        size: 10,
        font: customFont,
      })
      y -= 20

      transactions.slice(0, 40).forEach((t: any) => { 
        const date = new Date(t.created_at).toLocaleString('pt-BR')
        const amount = `R$ ${(t.amount/100).toFixed(2)}`
        // A fonte customFont suporta 'R$', 'ç', 'ã', etc.
        page.drawText(`${date.substring(0, 16)} | ${t.transaction_type} | ${t.status} | ${amount}`, {
          x: 50,
          y,
          size: 10,
          font: customFont,
        })
        y -= 15
      })

      if (transactions.length > 40) {
        page.drawText(`... mais ${transactions.length - 40} transações não listadas (demo limita visualização).`, {
          x: 50,
          y: y - 10,
          size: 10,
          font: customFont,
        })
      }

      fileBytes = await pdfDoc.save()
      mimeType = 'application/pdf'
      fileName = `report_${Date.now()}.pdf`
      console.log(`[PDF Success] Document assembled successfully: ${fileBytes.length} bytes`)
    }

    // 3. Upload seguro para o Storage (Private Bucket)
    console.log(`[Storage] Uploading ${fileName} to 'reports' bucket...`)
    const { error: uploadError } = await supabaseClient.storage
      .from('reports')
      .upload(fileName, fileBytes, {
        contentType: mimeType,
        upsert: false
      })

    if (uploadError) {
      console.error('[Storage Error] Failed to upload document:', uploadError.message)
      throw new Error(`Falha no arquivamento: ${uploadError.message}`)
    }

    // 4. Gerar Signed URL para download temporário (60 minutos) com flag 'download'
    console.log(`[Storage] Requesting 60-min Signed URL for ${fileName}...`)
    const { data: signedUrlData, error: signedUrlError } = await supabaseClient.storage
      .from('reports')
      .createSignedUrl(fileName, 60 * 60, { download: fileName })

    if (signedUrlError) {
      console.error('[Storage Error] Failed to create signed URL:', signedUrlError.message)
      throw new Error(`Falha ao gerar link seguro: ${signedUrlError.message}`)
    }

    console.log('[Function Success] Returning signed URL to client.')
    return new Response(
      JSON.stringify({ status: 'success', url: signedUrlData.signedUrl }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

  } catch (error) {
    console.error('[Function Fatal Error]', error)
    return new Response(
      JSON.stringify({ error: error instanceof Error ? error.message : 'Erro interno desconhecido no gerador de relatórios.' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})
