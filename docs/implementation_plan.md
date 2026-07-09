# FlowPay — Merchant Payment App

## Visão de Produto

O **FlowPay** é o app que o lojista de uma subadquirente usa no dia a dia. O dono da padaria, o freelancer, a loja de roupa abre toda manhã pra ver: *"quanto vendi ontem? quanto cai na minha conta amanhã? preciso cobrar aquele cliente."*

### Por que esse produto?
- **Fala a língua da fintech** que te procurou (gateway/subadquirente)
- **É o tipo de app que a InfinitePay tem** — mostra que você viveu esse mundo
- **Visual rico** — dashboards financeiros são naturalmente impressionantes
- **Complexidade ideal pra 5 dias** — demonstra arquitetura sem ser impossível

---

## User Review Required

> [!IMPORTANT]
> **Nome**: "FlowPay" está ok? Opções: NexPay, VoltPay, PayHub.

> [!IMPORTANT]
> **Supabase**: Você vai precisar criar uma conta gratuita em [supabase.com](https://supabase.com). Eu vou gerar o script SQL para criar as tabelas e popular com dados, mas preciso que você crie o projeto no dashboard e me passe a **URL** e a **anon key**. O free tier cobre tudo que precisamos:
> - ✅ 50.000 MAUs de auth
> - ✅ 500MB de database
> - ✅ Auth com email/senha
> - ✅ API REST automática
> - ✅ Row Level Security

> [!IMPORTANT]
> **Idioma**: App em **PT-BR** (produto brasileiro), código e docs em **inglês**. Ok?

---

## Supabase — Backend Real

### Por que Supabase ao invés de mock?
1. **Auth real** — login com email/senha de verdade, sessão persistente, token JWT
2. **Dados reais no PostgreSQL** — queries, filtros, paginação real
3. **Row Level Security** — cada merchant só vê seus dados (segurança real)
4. **Impressiona mais** — recrutador vê que o app conecta num backend de verdade
5. **A arquitetura isola tudo** — trocar Supabase por qualquer outro backend = mudar só o datasource

### Schema do Database

```sql
-- Tabela de merchants (perfil do lojista)
CREATE TABLE merchants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  business_name TEXT NOT NULL,
  legal_name TEXT NOT NULL,
  document TEXT NOT NULL,          -- CNPJ
  segment TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela de transações
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE,
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

-- Tabela de recebíveis
CREATE TABLE receivables (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE,
  transaction_id UUID REFERENCES transactions(id),
  amount INTEGER NOT NULL,           -- valor em centavos
  expected_date DATE NOT NULL,       -- data prevista de liquidação
  status TEXT NOT NULL,              -- scheduled, settled, anticipated
  installment_number INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela de cobranças (payment links)
CREATE TABLE charges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  description TEXT NOT NULL,
  status TEXT NOT NULL,              -- active, paid, expired, cancelled
  payment_url TEXT,
  expires_at TIMESTAMPTZ,
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Row Level Security: merchant só vê seus dados
ALTER TABLE merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE receivables ENABLE ROW LEVEL SECURITY;
ALTER TABLE charges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Merchants see own data" ON merchants
  FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Merchants see own transactions" ON transactions
  FOR ALL USING (merchant_id IN (SELECT id FROM merchants WHERE user_id = auth.uid()));
CREATE POLICY "Merchants see own receivables" ON receivables
  FOR ALL USING (merchant_id IN (SELECT id FROM merchants WHERE user_id = auth.uid()));
CREATE POLICY "Merchants see own charges" ON charges
  FOR ALL USING (merchant_id IN (SELECT id FROM merchants WHERE user_id = auth.uid()));
```

### Seed Data
Vou criar um script SQL de seed que popula **+100 transações realistas** dos últimos 30 dias, com:
- Valores entre R$ 8,50 e R$ 3.200,00
- Mix de bandeiras (Visa 40%, Master 30%, Elo 10%, Pix 20%)
- Mix de status (85% approved, 5% declined, 5% pending, 3% refunded, 2% chargeback)
- Nomes de clientes brasileiros realistas
- Recebíveis correspondentes gerados automaticamente
- 5 cobranças de exemplo

---

## Isolamento SOLID — A Alma do App

Isso é o que você aprendeu na InfinitePay e é o que vai brilhar nesse app. Vou detalhar exatamente como cada peça é isolada.

### O Princípio: "Nada sabe da existência do outro"

```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION                       │
│  (BLoC/Cubit, Pages, Widgets)                       │
│                                                      │
│  • Conhece: UseCases, Entities, States              │
│  • NÃO conhece: Supabase, Models, Datasources      │
│                                                      │
│  O BLoC chama useCase.execute() e pronto.            │
│  Não sabe se veio do Supabase, Firebase, ou mock.    │
├─────────────────────────────────────────────────────┤
│                     DOMAIN                           │
│  (Entities, Repository Interfaces, UseCases)        │
│                                                      │
│  • Conhece: NADA externo. Zero imports de packages.  │
│  • É Dart puro.                                      │
│                                                      │
│  Entity é o objeto de negócio LIMPO.                 │
│  Repository é uma INTERFACE (abstract class).        │
│  UseCase tem UMA responsabilidade.                   │
├─────────────────────────────────────────────────────┤
│                      DATA                            │
│  (Models, Datasources, Repository Implementations)  │
│                                                      │
│  • Conhece: Supabase, JSON, Domain interfaces       │
│  • IMPLEMENTA as interfaces do Domain               │
│                                                      │
│  Model sabe fazer fromJson/toJson.                   │
│  Model sabe se converter em Entity.                  │
│  Datasource fala com o Supabase.                     │
│  Repository Implementation orquestra tudo.           │
└─────────────────────────────────────────────────────┘
```

### Exemplo Concreto: Feature `transactions`

#### 1. Entity (Domain) — Dart puro, sem dependências

```dart
// domain/entities/transaction.dart
// NÃO importa nenhum package. É só Dart.

class Transaction {
  final String id;
  final int amount;          // centavos
  final int netAmount;
  final int feeAmount;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;
  final String? cardBrand;
  final int installments;
  final String? customerName;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.amount,
    // ...
  });
}

// Enum de domínio — não depende de nada
enum TransactionStatus { approved, declined, refunded, pending, chargeback }
enum PaymentMethod { credit, debit, pix }
```

#### 2. Repository Interface (Domain) — Contrato abstrato

```dart
// domain/repositories/transactions_repository.dart
// Importa só coisas do DOMAIN e do dartz (Either)

abstract class TransactionsRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions({
    TransactionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, Transaction>> getTransactionById(String id);
}

// Quem IMPLEMENTA isso? O Data layer.
// Se amanhã trocar Supabase por Firebase? Muda só a implementação.
// Domain não muda NADA.
```

#### 3. UseCase (Domain) — Uma responsabilidade

```dart
// domain/usecases/get_transactions.dart

class GetTransactions implements UseCase<List<Transaction>, GetTransactionsParams> {
  final TransactionsRepository repository;  // recebe a INTERFACE, não a implementação

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(GetTransactionsParams params) {
    return repository.getTransactions(
      status: params.status,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
```

#### 4. Model (Data) — Sabe lidar com JSON, sabe virar Entity

```dart
// data/models/transaction_model.dart
// ESTE cara importa json_annotation, conhece o formato do Supabase

@JsonSerializable()
class TransactionModel {
  final String id;
  final int amount;
  @JsonKey(name: 'net_amount')     // snake_case do Supabase → camelCase
  final int netAmount;
  @JsonKey(name: 'fee_amount')
  final int feeAmount;
  final String status;              // no JSON é String, não enum
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  // ...

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  // 👇 ESTE é o ponto crucial: Model → Entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      netAmount: netAmount,
      feeAmount: feeAmount,
      status: TransactionStatus.values.byName(status),
      paymentMethod: PaymentMethod.values.byName(paymentMethod),
      // ...
    );
  }
}
```

#### 5. Datasource (Data) — Fala com Supabase

```dart
// data/datasources/transactions_remote_datasource.dart

abstract class TransactionsRemoteDatasource {
  Future<List<TransactionModel>> getTransactions({...});
}

class TransactionsRemoteDatasourceImpl implements TransactionsRemoteDatasource {
  final SupabaseClient client;  // 👈 Supabase fica AQUI e só aqui

  TransactionsRemoteDatasourceImpl(this.client);

  @override
  Future<List<TransactionModel>> getTransactions({...}) async {
    final response = await client
        .from('transactions')
        .select()
        .order('created_at', ascending: false);

    return response.map((json) => TransactionModel.fromJson(json)).toList();
  }
}
```

#### 6. Repository Implementation (Data) — Orquestra e trata erros

```dart
// data/repositories/transactions_repository_impl.dart

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDatasource remoteDatasource;

  TransactionsRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({...}) async {
    try {
      final models = await remoteDatasource.getTransactions(...);
      final entities = models.map((m) => m.toEntity()).toList();  // 👈 Model → Entity
      return Right(entities);  // sucesso
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));  // erro tratado
    }
  }
}
```

#### 7. BLoC (Presentation) — Só conhece UseCase e Entity

```dart
// presentation/bloc/transactions_bloc.dart

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetTransactions getTransactions;  // 👈 recebe o UseCase, não o repository

  TransactionsBloc({required this.getTransactions}) : super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoad);
  }

  Future<void> _onLoad(LoadTransactions event, Emitter<TransactionsState> emit) async {
    emit(TransactionsLoading());

    final result = await getTransactions(GetTransactionsParams(status: event.status));

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }
}
// O BLoC não sabe o que é Supabase. Não sabe o que é JSON.
// Ele chama useCase, recebe Either, emite state.
```

### Injeção de Dependência — Onde tudo se conecta

```dart
// injection.dart — ÚNICO lugar onde as peças se conhecem

final sl = GetIt.instance;  // sl = service locator

void setupDependencies() {
  // External
  sl.registerLazySingleton(() => Supabase.instance.client);

  // Datasources
  sl.registerLazySingleton<TransactionsRemoteDatasource>(
    () => TransactionsRemoteDatasourceImpl(sl()),
  );

  // Repositories — registra a INTERFACE, injeta a IMPLEMENTAÇÃO
  sl.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetTransactions(sl()));

  // BLoCs
  sl.registerFactory(() => TransactionsBloc(getTransactions: sl()));
}
```

### O Que Isso Prova Pro Recrutador

| Princípio SOLID | Como aparece |
|:---|:---|
| **S — Single Responsibility** | Cada UseCase faz UMA coisa. `GetTransactions` só busca. `CreateCharge` só cria. |
| **O — Open/Closed** | Adicionar filtro novo? Estende `GetTransactionsParams`. Não muda o UseCase. |
| **L — Liskov Substitution** | `TransactionsRepositoryImpl` pode ser trocado por `MockTransactionsRepository` nos testes sem quebrar nada. |
| **I — Interface Segregation** | Repository do Domain tem só os métodos que o Domain precisa. Datasource tem interface própria. |
| **D — Dependency Inversion** | BLoC depende de `UseCase` (abstração), não de `RepositoryImpl` (detalhe). Repository depende de `Datasource` interface. Ninguém depende de concreto. |

---

## Features do App

### 🏠 1. Home / Dashboard
| Componente | O que mostra |
|:---|:---|
| **Saldo disponível** | Quanto tem disponível para saque |
| **Vendas do dia** | Total vendido hoje (valor + nº de transações) |
| **Gráfico semanal** | Barras com vendas dos últimos 7 dias |
| **Taxa de aprovação** | % de transações aprovadas vs total |
| **Próximo recebimento** | Valor e data do próximo depósito |
| **Atalhos rápidos** | "Cobrar", "Extrato", "Antecipação" |
| **Últimas transações** | Preview das 5 últimas vendas |

### 💳 2. Transações
| Funcionalidade | Detalhe |
|:---|:---|
| **Lista paginada** | Scroll infinito com dados reais do Supabase |
| **Filtros** | Status, período, bandeira, método de pagamento |
| **Search** | Busca por valor ou nome do cliente |
| **Card da transação** | Valor, bandeira, status chip, horário, tipo |
| **Detalhe** | Timeline: criada → autorizada → capturada → liquidada. NSU, auth code, parcelas, taxa, líquido |

### 💰 3. Recebíveis
| Funcionalidade | Detalhe |
|:---|:---|
| **Timeline** | Lista dia a dia dos próximos recebimentos |
| **Resumo** | Total a receber em 7, 15, 30 dias |
| **Detalhe por dia** | Quais transações compõem aquele valor |
| **Simulador de antecipação** | Slider de valor → calcula taxa → mostra líquido |

### 🔗 4. Cobranças
| Funcionalidade | Detalhe |
|:---|:---|
| **Criar cobrança** | Valor + descrição → salva no Supabase |
| **QR Code** | Gerado automaticamente |
| **Compartilhar** | Share nativo (WhatsApp, etc.) |
| **Lista** | Cobranças com status: ativa, paga, expirada |

### 👤 5. Perfil
| Funcionalidade | Detalhe |
|:---|:---|
| **Dados do negócio** | Nome fantasia, CNPJ, segmento |
| **Conta bancária** | Banco, agência, conta |
| **Taxas** | Tabela de taxas praticadas |
| **Logout** | Encerrar sessão (Supabase Auth signOut) |

---

## Stack de Packages

| Package | Uso | Por que |
|:---|:---|:---|
| `supabase_flutter` | Auth + Database | Backend real, free tier generoso |
| `flutter_bloc` | BLoC/Cubit | Padrão InfinitePay, testável |
| `get_it` | DI container | Service locator padrão de mercado |
| `dartz` | Either type | Error handling funcional |
| `equatable` | Value equality | States imutáveis comparáveis |
| `freezed` + `json_serializable` | Code gen | Models imutáveis + serialização |
| `go_router` | Navegação | Declarativa, deep linking |
| `fl_chart` | Gráficos | Barras (vendas), donut (distribuição) |
| `intl` | Formatação | R$ 1.234,56 / datas PT-BR |
| `shimmer` | Loading | Skeleton screens profissionais |
| `google_fonts` | Tipografia | Inter — clean e moderno |
| `qr_flutter` | QR Code | Gerar QR das cobranças |
| `share_plus` | Share | Compartilhar links de cobrança |

---

## Design Visual

### Paleta de Cores (Dark Fintech)

| Token | Hex | Uso |
|:---|:---|:---|
| `background` | `#0F1117` | Fundo principal |
| `surface` | `#1A1D27` | Cards e containers |
| `surfaceVariant` | `#242836` | Cards elevados, inputs |
| `primary` | `#6C5CE7` | Ações principais, botões |
| `primaryLight` | `#A29BFE` | Textos de destaque |
| `success` | `#00B894` | Aprovado, positivo |
| `error` | `#FF6B6B` | Recusado, negativo |
| `warning` | `#FDCB6E` | Pendente, atenção |
| `info` | `#74B9FF` | Informativo |
| `textPrimary` | `#F5F6FA` | Texto principal |
| `textSecondary` | `#8B8FA3` | Labels, subtítulos |

### Tipografia
- **Font**: Inter (Google Fonts)
- **Valores monetários**: Tabular figures + SemiBold
- **Labels**: Regular, cor secundária

---

## Cronograma — 5 Dias

### Dia 1 — Core + Supabase + Auth + Navegação
- Estrutura de pastas completa
- `pubspec.yaml` com dependências
- Core: `Failure`, `Exception`, `UseCase` abstrato
- Supabase: init, config, auth datasource
- Tema completo (cores, tipografia, espaçamentos)
- `GoRouter` + bottom nav (Home, Transações, Cobranças, Perfil)
- Auth: `SplashPage`, `LoginPage`, `AuthBloc`
- DI: `get_it` configurado
- SQL: scripts de criação de tabelas + seed data
- Git init + primeiro commit

### Dia 2 — Dashboard + Transações
- Home: `DashboardCubit` + widgets (saldo, vendas, gráfico, últimas transações)
- Transações: `TransactionsBloc` + lista paginada + filtros + detalhe com timeline

### Dia 3 — Recebíveis + Cobranças
- Recebíveis: `ReceivablesCubit` + agenda + simulador de antecipação
- Cobranças: `ChargesCubit` + CRUD + QR Code + share

### Dia 4 — Perfil + Polish
- Perfil: dados do merchant, taxas, logout
- Shimmer loading, empty states, error states
- Animações de transição
- Micro-interações

### Dia 5 — Testes + README + Deploy
- ~15-20 testes unitários (UseCases, BLoCs, Repositories)
- README profissional com screenshots, diagrama, setup
- `flutter build apk --release`
- Push para GitHub

---

## Verification Plan

### Automated Tests
```bash
flutter test
flutter analyze
```

### Manual Verification
- Auth: signup → login → sessão persiste → logout
- Dashboard: dados carregam do Supabase
- Transações: lista, filtra, vê detalhe
- Cobranças: cria, gera QR, compartilha
- Build release compila sem erros
