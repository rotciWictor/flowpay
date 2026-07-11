-- Tabela de merchants (perfil do lojista)
CREATE TABLE merchants (
  id UUID PRIMARY KEY, -- O ID vem direto da tabela auth.users do Supabase
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  handle TEXT NOT NULL,
  business_name TEXT NOT NULL,
  document TEXT NOT NULL,          -- CNPJ ou CPF
  segment TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela de transações
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE,
  transaction_type TEXT NOT NULL DEFAULT 'sale', -- sale, transfer_in, transfer_out
  amount INTEGER NOT NULL,           -- valor em centavos (R$ 150,00 = 15000)
  net_amount INTEGER NOT NULL,       -- valor líquido (após taxas)
  fee_amount INTEGER NOT NULL,       -- valor da taxa
  status TEXT NOT NULL,              -- approved, declined, refunded, pending, chargeback
  payment_method TEXT NOT NULL,      -- credit, debit, pix
  card_brand TEXT,                   -- visa, mastercard, elo (null se pix)
  installments INTEGER DEFAULT 1,
  customer_name TEXT,
  card_last_four TEXT,               -- últimos 4 dígitos
  authorization_code TEXT,
  nsu TEXT,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Row Level Security (RLS) - Garante que um lojista só veja e edite os próprios dados
ALTER TABLE merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Merchants see own data" ON merchants
  FOR ALL USING (id = auth.uid());
  
CREATE POLICY "Merchants see own transactions" ON transactions
  FOR ALL USING (merchant_id = auth.uid());

-- Trigger para automatizar a inserção inicial de um merchant vazio ao se cadastrar via Auth
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.merchants (id, user_id, email, handle, business_name, document, segment)
  values (new.id, new.id, new.email, '', '', '', 'other');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
