-- ==========================================
-- SCRIPT DE SEED: Modo Demo do FlowPay
-- ==========================================
-- IMPORTANTE: Para rodar este script, copie e cole no SQL Editor do Supabase.

-- 1. Inserir o usuário "Demo" na tabela de Autenticação do Supabase (ignora e-mail de verificação)
INSERT INTO auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  recovery_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
)
VALUES (
  '00000000-0000-0000-0000-000000000000', -- ID estático para podermos vincular transações
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'demo@flowpay.com',
  crypt('FlowPayDemo2026!', gen_salt('bf')), -- Senha criptografada nativamente pelo pgcrypto
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  now(),
  now(),
  '',
  '',
  '',
  ''
)
ON CONFLICT (id) DO NOTHING;

-- Nota: O gatilho on_auth_user_created que criamos no schema inicial vai automaticamente
-- criar a linha na tabela 'merchants' com este mesmo ID.
-- Vamos apenas atualizar o nome da empresa e o segmento do usuário Demo.
UPDATE public.merchants
SET business_name = 'FlowPay Demo Store',
    segment = 'retail'
WHERE user_id = '00000000-0000-0000-0000-000000000000';

-- 2. Limpar transações antigas do usuário Demo (Evita dados duplicados/sujos)
DELETE FROM public.transactions 
WHERE merchant_id = '00000000-0000-0000-0000-000000000000';

-- 3. Inserir 150 Transações Realistas para os últimos 30 dias
-- Vamos usar uma CTE (Common Table Expression) e randomização do Postgres para gerar dados orgânicos.

WITH data_generator AS (
  SELECT 
    generate_series(1, 150) AS i,
    '00000000-0000-0000-0000-000000000000'::uuid AS merchant_id,
    floor((random() * 4475 + 25) * 100)::integer AS amount,
    (ARRAY['sale', 'sale', 'sale', 'sale', 'transfer_out', 'transfer_in'])[floor(random() * 6 + 1)] AS transaction_type,
    (ARRAY['credit', 'credit', 'credit', 'pix', 'pix', 'debit'])[floor(random() * 6 + 1)] AS payment_method,
    (ARRAY['approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'pending', 'declined', 'refunded', 'chargeback'])[floor(random() * 11 + 1)] AS status,
    (ARRAY['visa', 'mastercard', 'elo', 'mastercard', 'visa', 'amex'])[floor(random() * 6 + 1)] AS card_brand,
    (ARRAY['João Silva', 'Maria Oliveira', 'Carlos Santos', 'Ana Souza', 'Empresa XYZ', 'Cliente Final', 'Pedro Costa', 'Fernanda Lima'])[floor(random() * 8 + 1)] AS customer_name_sale,
    (ARRAY['Fornecedor A', 'Conta de Luz', 'Internet', 'Marketing Ads'])[floor(random() * 4 + 1)] AS customer_name_transfer_out,
    (now() - (random() * 30 || ' days')::interval) AS created_at
)
INSERT INTO public.transactions (merchant_id, transaction_type, amount, net_amount, fee_amount, payment_method, card_brand, customer_name, status, created_at)
SELECT 
  merchant_id, 
  
  -- Ajustar transaction type pra ter certeza
  transaction_type,
  
  amount, 
  
  -- Lógica de valor líquido (dinheiro no bolso)
  CASE 
    WHEN transaction_type = 'transfer_out' THEN -amount -- Transferência é saída total
    WHEN transaction_type = 'transfer_in' THEN amount -- Transferência recebida é entrada total
    WHEN status IN ('chargeback', 'refunded') THEN -amount -- Devolução é saída
    WHEN status = 'declined' THEN 0
    ELSE floor(amount * 0.95)::integer -- Venda normal tira a taxa
  END AS net_amount,
  
  -- Taxa cobrada
  CASE 
    WHEN transaction_type = 'transfer_out' OR transaction_type = 'transfer_in' THEN 0 -- Pix não tem taxa pra transferir
    WHEN status IN ('declined', 'chargeback', 'refunded') THEN 0
    ELSE floor(amount * 0.05)::integer 
  END AS fee_amount,
  
  CASE WHEN transaction_type IN ('transfer_out', 'transfer_in') THEN 'pix' ELSE payment_method END AS payment_method, 
  CASE WHEN transaction_type IN ('transfer_out', 'transfer_in') OR payment_method = 'pix' THEN NULL ELSE card_brand END AS card_brand,
  CASE 
    WHEN transaction_type = 'transfer_out' THEN customer_name_transfer_out 
    ELSE customer_name_sale 
  END AS customer_name,
  
  -- Regras Reais de Negócio para o Status
  CASE 
    -- 1. Transferências (IN/OUT): Podem estar pendentes (agendadas), aprovadas ou falhas, mas nunca chargeback/estorno
    WHEN transaction_type IN ('transfer_out', 'transfer_in') THEN 
      CASE 
        WHEN status IN ('chargeback', 'refunded') THEN 'pending' -- Transforma os impossíveis em Agendamentos/Pendentes
        ELSE status 
      END
    -- 2. Pix (Vendas): Não tem chargeback de cartão, vira Devolução (refunded). E falhas são mais raras.
    WHEN payment_method = 'pix' THEN 
      CASE 
        WHEN status = 'chargeback' THEN 'refunded'
        WHEN status = 'declined' THEN 'approved' -- Evita o "Pix recusado"
        ELSE status 
      END
    -- 3. Cartões: Segue o sorteio normal (pode ter tudo)
    ELSE status 
  END AS status, 
  created_at
FROM data_generator
ON CONFLICT DO NOTHING;
