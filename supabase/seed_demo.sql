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

-- 2. Inserir 100 Transações Realistas para os últimos 30 dias
-- Vamos usar uma CTE (Common Table Expression) e randomização do Postgres para gerar dados orgânicos.

WITH data_generator AS (
  SELECT 
    generate_series(1, 100) AS i,
    '00000000-0000-0000-0000-000000000000'::uuid AS merchant_id,
    -- Valor aleatório entre 25.00 e 4500.00 convertido para centavos (INTEGER)
    floor((random() * 4475 + 25) * 100)::integer AS amount,
    -- Tipo de pagamento randômico (credit, debit, pix)
    (ARRAY['credit', 'credit', 'credit', 'pix', 'pix', 'debit'])[floor(random() * 6 + 1)] AS payment_method,
    -- Status da transação randômico (80% aprovado, o resto varia)
    (ARRAY['approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'approved', 'pending', 'declined', 'refunded', 'chargeback'])[floor(random() * 12 + 1)] AS status,
    -- Data variando de 30 dias atrás até agora
    (now() - (random() * 30 || ' days')::interval) AS created_at
)
INSERT INTO public.transactions (merchant_id, amount, net_amount, fee_amount, payment_method, status, created_at)
SELECT 
  merchant_id, 
  amount, 
  floor(amount * 0.95)::integer AS net_amount, -- Simulando taxa de 5%
  floor(amount * 0.05)::integer AS fee_amount,
  payment_method, 
  status, 
  created_at
FROM data_generator
ON CONFLICT DO NOTHING;

-- Opcionalmente, pode ser gerado mais dados para faturas e recebíveis (charges) depois.
