import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { PDFDocument, rgb, StandardFonts } from 'https://cdn.skypack.dev/pdf-lib@1.17.1?dts'

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

    // Pegar o usuário logado a partir do token para garantir RLS manual na Edge Function
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) throw new Error('No authorization header')
    
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser(authHeader.replace('Bearer ', ''))
    if (userError || !user) throw new Error('Unauthorized')

    const { filters, format } = await req.json()

    // 1. Buscar transações
    let query = supabaseClient.from('transactions').select('*').eq('merchant_id', user.id).order('created_at', { ascending: false })
    
    if (filters?.startDate) query = query.gte('created_at', filters.startDate)
    if (filters?.endDate) query = query.lte('created_at', filters.endDate)
    if (filters?.types && filters.types.length > 0) query = query.in('transaction_type', filters.types)
    if (filters?.statuses && filters.statuses.length > 0) query = query.in('status', filters.statuses)

    const { data: transactions, error: fetchError } = await query
    if (fetchError) throw fetchError

    if (!transactions) throw new Error('No transactions found')

    let fileBytes: Uint8Array
    let mimeType: string
    let fileName: string

    if (format === 'xml') {
      // Gerar XML
      let xml = '<?xml version="1.0" encoding="UTF-8"?>\n<report>\n'
      transactions.forEach(t => {
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
      // Gerar PDF via pdf-lib
      const pdfDoc = await PDFDocument.create()
      const timesRomanFont = await pdfDoc.embedFont(StandardFonts.TimesRoman)
      const page = pdfDoc.addPage([595.28, 841.89]) // A4
      const { width, height } = page.getSize()
      
      page.drawText('Relatorio de Transacoes - FlowPay', {
        x: 50,
        y: height - 50,
        size: 20,
        font: timesRomanFont,
        color: rgb(0.0, 0.9, 0.46), // FlowColors.primary aprox (neon green)
      })

      page.drawText(`Gerado em: ${new Date().toLocaleString()}`, {
        x: 50,
        y: height - 70,
        size: 10,
        font: timesRomanFont,
      })

      let y = height - 120
      page.drawText('DATA / HORA         TIPO         STATUS         VALOR', {
        x: 50,
        y,
        size: 10,
        font: timesRomanFont,
      })
      y -= 20

      // Limitando a 40 para não estourar a página no demo (na vida real usaríamos loop criando novas páginas)
      transactions.slice(0, 40).forEach(t => { 
        const date = new Date(t.created_at).toLocaleString()
        const amount = `R$ ${(t.amount/100).toFixed(2)}`
        page.drawText(`${date.substring(0, 16)} | ${t.transaction_type} | ${t.status} | ${amount}`, {
          x: 50,
          y,
          size: 10,
          font: timesRomanFont,
        })
        y -= 15
      })

      if (transactions.length > 40) {
        page.drawText(`... mais ${transactions.length - 40} transações não mostradas no demo.`, {
          x: 50,
          y: y - 10,
          size: 10,
          font: timesRomanFont,
        })
      }

      fileBytes = await pdfDoc.save()
      mimeType = 'application/pdf'
      fileName = `report_${Date.now()}.pdf`
    }

    // 2. Upload para Storage
    const { error: uploadError } = await supabaseClient.storage
      .from('reports')
      .upload(fileName, fileBytes, {
        contentType: mimeType,
        upsert: false
      })

    if (uploadError) throw uploadError

    // 3. Gerar URL Assinada
    const { data: signedUrlData, error: signedUrlError } = await supabaseClient.storage
      .from('reports')
      .createSignedUrl(fileName, 60 * 60) // 1 hora

    if (signedUrlError) throw signedUrlError

    return new Response(
      JSON.stringify({ status: 'success', url: signedUrlData.signedUrl }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
