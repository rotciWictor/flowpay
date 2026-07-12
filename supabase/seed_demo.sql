-- ==========================================
-- SCRIPT DE SEED DEMO (FLOWPAY)
-- ==========================================

-- Garante que a coluna de código de erro existe (caso o schema.sql não tenha rodado)
ALTER TABLE IF EXISTS public.transactions ADD COLUMN IF NOT EXISTS return_code TEXT;

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
WHERE id = '00000000-0000-0000-0000-000000000000';

-- 2. Limpar dados antigos do usuário Demo (Evita duplicados)
ALTER TABLE public.transactions ADD COLUMN IF NOT EXISTS return_code TEXT;

DELETE FROM public.transactions 
WHERE merchant_id = '00000000-0000-0000-0000-000000000000';

DELETE FROM public.merchant_fees
WHERE merchant_id = '00000000-0000-0000-0000-000000000000';

-- 3. Inserir taxas comerciais para o Lojista Demo
INSERT INTO public.merchant_fees (merchant_id, payment_method, card_brand, base_rate, installment_rate)
VALUES 
  ('00000000-0000-0000-0000-000000000000', 'pix', NULL, 0.0000, 0.0000),
  ('00000000-0000-0000-0000-000000000000', 'debit', 'visa', 0.0150, 0.0000),
  ('00000000-0000-0000-0000-000000000000', 'debit', 'mastercard', 0.0150, 0.0000),
  ('00000000-0000-0000-0000-000000000000', 'debit', 'elo', 0.0200, 0.0000),
  ('00000000-0000-0000-0000-000000000000', 'debit', 'amex', 0.0250, 0.0000),
  ('00000000-0000-0000-0000-000000000000', 'credit', 'visa', 0.0350, 0.0150),
  ('00000000-0000-0000-0000-000000000000', 'credit', 'mastercard', 0.0350, 0.0150),
  ('00000000-0000-0000-0000-000000000000', 'credit', 'elo', 0.0450, 0.0150),
  ('00000000-0000-0000-0000-000000000000', 'credit', 'amex', 0.0550, 0.0150);

-- 4. Inserir 150 Transações Realistas para os últimos 30 dias
-- Vamos usar uma CTE (Common Table Expression) e randomização do Postgres para gerar dados orgânicos.

WITH data_generator AS (
  SELECT 
    generate_series(1, 150) AS i,
    '00000000-0000-0000-0000-000000000000'::uuid AS merchant_id,
    floor((random() * 4475 + 25) * 100)::integer AS amount,
    (ARRAY['sale', 'sale', 'sale', 'sale', 'transfer_out', 'transfer_in'])[floor(random() * 6 + 1)] AS raw_transaction_type,
    (ARRAY['credit', 'credit', 'credit', 'pix', 'pix', 'debit'])[floor(random() * 6 + 1)] AS raw_payment_method,
    (ARRAY['approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'pending', 'declined', 'refunded', 'chargeback'])[floor(random() * 11 + 1)] AS raw_status,
    (ARRAY['visa', 'mastercard', 'elo', 'mastercard', 'visa', 'amex'])[floor(random() * 6 + 1)] AS raw_card_brand,
    (ARRAY['João Silva', 'Maria Oliveira', 'Carlos Santos', 'Ana Souza', 'Empresa XYZ', 'Cliente Final', 'Pedro Costa', 'Fernanda Lima'])[floor(random() * 8 + 1)] AS customer_name_sale,
    (ARRAY['Fornecedor A', 'Conta de Luz', 'Internet', 'Marketing Ads'])[floor(random() * 4 + 1)] AS customer_name_transfer_out,
    (now() - (random() * 30 || ' days')::interval) AS created_at,
    floor(random() * 12 + 1)::integer AS rand_installments
),
refined_data AS (
  SELECT 
    merchant_id,
    amount,
    created_at,
    -- Tipo e Método de Pagamento Limpos
    raw_transaction_type AS transaction_type,
    CASE 
      WHEN raw_transaction_type IN ('transfer_out', 'transfer_in') THEN 'pix' 
      ELSE raw_payment_method 
    END AS payment_method,
    -- Bandeira Limpa
    CASE 
      WHEN raw_transaction_type IN ('transfer_out', 'transfer_in') OR raw_payment_method = 'pix' THEN NULL 
      ELSE raw_card_brand 
    END AS card_brand,
    -- Status Limpo
    CASE
      WHEN raw_transaction_type IN ('transfer_out', 'transfer_in') THEN 
        CASE WHEN raw_status IN ('chargeback', 'refunded', 'declined') THEN 'pending' ELSE raw_status END
      WHEN raw_payment_method = 'pix' THEN 
        CASE WHEN raw_status IN ('chargeback', 'refunded', 'declined') THEN 'approved' ELSE raw_status END
      ELSE raw_status 
    END AS status,
    -- Nome do Cliente
    CASE 
      WHEN raw_transaction_type = 'transfer_out' THEN customer_name_transfer_out 
      ELSE customer_name_sale 
    END AS customer_name,
    -- Parcelas
    CASE
      WHEN raw_payment_method = 'credit' AND raw_transaction_type = 'sale' THEN rand_installments
      ELSE 1
    END AS installments,
    -- Dados de rede (Mock)
    lpad(floor(random() * 999999999999)::text, 12, '0') AS nsu,
    substring(md5(random()::text) from 1 for 6) AS authorization_code
  FROM data_generator
),
fee_calculation AS (
  SELECT 
    r.*,
    -- Cálculo de Taxa Baseado na Tabela Comercial REAL (JOIN)
    CASE 
      WHEN r.transaction_type IN ('transfer_out', 'transfer_in') OR r.payment_method = 'pix' THEN 0.0
      ELSE COALESCE(f.base_rate + ((r.installments - 1) * f.installment_rate), 0.0)
    END AS fee_percentage,
    -- Código de Retorno
    CASE
      WHEN r.payment_method = 'pix' OR r.transaction_type IN ('transfer_out', 'transfer_in') THEN NULL
      WHEN r.status = 'approved' THEN (ARRAY['00', '08', '11'])[floor(random() * 3 + 1)]
      WHEN r.status = 'declined' THEN (ARRAY['04', '05', '14', '33', '41', '43', '51', '54', '57', '61', '62', '12', '91'])[floor(random() * 13 + 1)]
      ELSE NULL
    END AS return_code
  FROM refined_data r
  LEFT JOIN public.merchant_fees f 
    ON f.merchant_id = r.merchant_id 
   AND f.payment_method = r.payment_method 
   AND f.card_brand IS NOT DISTINCT FROM r.card_brand
)
INSERT INTO public.transactions (merchant_id, transaction_type, amount, net_amount, fee_amount, payment_method, card_brand, installments, customer_name, status, created_at, nsu, authorization_code, return_code)
SELECT 
  merchant_id,
  transaction_type,
  amount,
  -- Lógica de valor líquido (dinheiro no bolso) e Taxas
  CASE 
    WHEN transaction_type = 'transfer_out' THEN -amount
    WHEN transaction_type = 'transfer_in' THEN amount
    WHEN status IN ('chargeback', 'refunded') THEN -amount
    WHEN status = 'declined' THEN 0
    ELSE amount - floor(amount * fee_percentage)::integer
  END AS net_amount,
  CASE 
    WHEN transaction_type IN ('transfer_out', 'transfer_in') THEN 0
    WHEN status IN ('declined', 'chargeback', 'refunded') THEN 0
    ELSE floor(amount * fee_percentage)::integer 
  END AS fee_amount,
  payment_method,
  card_brand,
  installments,
  customer_name,
  status,
  created_at,
  nsu,
  authorization_code,
  return_code
FROM fee_calculation
ON CONFLICT DO NOTHING;
