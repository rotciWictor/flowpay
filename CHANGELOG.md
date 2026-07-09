# Changelog do FlowPay

Este documento registra as implementações do projeto em detalhes, explicando não apenas *o que* foi feito, mas o *porquê* das decisões arquiteturais e de design em cada etapa.

---

## [0.2.0] - Autenticação: Camada de Apresentação (UI e BLoC)

### `(tbd)` - Splash, Login Premium e Auth Guard
- **Gerência de Estado com BLoC**: Implementado o `AuthCubit` e seus estados (`AuthLoading`, `AuthAuthenticated`, etc) injetado globalmente na árvore do aplicativo usando o `get_it`. Isso permite que qualquer aba do app saiba imediatamente se o usuário está logado.
- **Integração de UI & Design System**: Criação da `LoginPage` empregando um visual premium em total alinhamento com a arquitetura definida (Fundo com *RadialGradient* escuro e formulário em *Glassmorphism* usando `BackdropFilter` e bordas semitransparentes). Integração da Logo Oficial recortada da imagem prototipada.
- **Proteção de Rotas Inteligentes**: Adição de uma trava no `app_router.dart`. A função `redirect` do `GoRouter` agora intercepta todas as navegações consultando sincronamente a sessão atual do Supabase (`Supabase.instance.client.auth.currentSession`). Se o token estiver nulo, o usuário é bloqueado e redirecionado para a `/login`.
- **Prevenção de Janks (Splash)**: Adicionado a `SplashPage` inteligente que serve para absorver o tempo de latência e de inicialização de conexões e checagem da sessão sem exibir ecrãs brancos aos usuários, encaminhando-os corretamente.

## [0.1.2] - Autenticação: Camada de Dados (Supabase)

### `(tbd)` - Supabase SDK, DataSources e Models
- **Infraestrutura**: Adicionados `supabase_flutter` e `flutter_dotenv` e inicialização global do cliente (PostgreSQL via API) e carregamento de `.env` nas variáveis de ambiente.
- **Database Schema**: Criação do script relacional em `supabase/schema.sql` definindo a arquitetura do banco (`merchants`, `transactions` e gatilhos de criação baseados no Postgres `auth.users`), RLS habilitado com políticas rígidas baseadas em `auth.uid()`.
- **Implementação do Data Layer**: Desenvolvimento do `MerchantModel` encapsulando as chaves JSON seguras do lado do cliente (convertendo da DB para `Merchant`), `AuthRemoteDatasource` tratando conexões HTTP diretas via pacote Supabase, e a `AuthRepositoryImpl` concretizando a ponte (try-catch retornando `Left(Failure)` para consumo do *UseCase*).

## [0.1.1] - Autenticação: Camada de Domínio (SOLID)

### `44dd236` - Auth Domain: Entity, Repository e UseCases
- **Entidade Limpa (`Merchant`)**: Modelagem do usuário lojista como objeto puro de negócio usando `Equatable`. Seguindo as regras do negócio, os campos foram marcados como `final` e o segmento da loja foi fortemente tipado usando um Enum (`MerchantSegment`), garantindo que o sistema só aceite categorias pré-aprovadas (Alimentação, Varejo, Serviços, etc).
- **Inversão de Dependência (`AuthRepository`)**: Criação da interface/contrato de autenticação. A interface foi desenhada visando o futuro, abstraindo métodos para Login Clássico (`loginWithEmail`), Recuperação Silenciosa de Sessão (`checkAuthSession`) e Suporte a Login Social (`loginWithGoogle`).
- **Responsabilidade Única (`UseCases`)**: Isolamento total de cada ação (Login Email, Login Google, CheckAuth, Logout) em suas próprias classes independentes. O caso de uso de login clássico implementa validações síncronas de regras de negócio (como bloquear e-mails inválidos) retornando `InvalidInputFailure`, evitando idas desnecessárias à camada de rede.


## [0.1.0] - Fundação, Arquitetura e Navegação

### `7f52bea` - GoRouter Setup & Glassmorphism Bottom Navigation
- **Arquitetura de Navegação**: Substituição da navegação padrão pelo `go_router`. Utilizamos o `StatefulShellRoute`, um padrão avançado que permite manter o estado (posição de scroll, inputs) de cada aba independentemente. Se o usuário navegar na "Home", mudar para "Transações" e voltar, o estado da Home permanece intacto.
- **Implementação UI (Glassmorphism)**: Criação do `AppBottomNav` aplicando estritamente as regras do Design System. Utilizamos a composição de `ClipRRect` para conter o desfoque, seguido de um `BackdropFilter` (sigma 10) e um container com 60% de opacidade (`#1A1D27`), gerando o efeito premium de vidro fosco para a navegação do lojista.
- **Scaffolding**: Criação das 4 páginas estruturais base (Home, Transações, Cobranças e Perfil) em branco, apenas para garantir os caminhos da roteirização.

### `ca586a4` - Renomeação Profissional do Package (FlowPay)
- **Refatoração Interna**: O projeto foi gerado com um nome de boilerplate (fintech_app). Para refletir a maturidade de um app de produção, renomeamos o `applicationId` nativo do Android no `build.gradle.kts` e ajustamos a hierarquia de pastas do Kotlin (`com.flowpay.app.MainActivity`).
- **Clean Imports**: Todos os imports do Dart foram refatorados para `package:flowpay/...`, eliminando dívidas técnicas antes do crescimento da base de código.

### `3962709` - Documentação do Design System
- **Single Source of Truth**: Documentação explícita criada em `docs/design_system_guide.md` para garantir consistência visual no time.
- **Decisões Registradas**: O documento consolida a estratégia de *Performance vs Estética*, limitando o uso de *Glass Cards* (alto custo de GPU) a elementos estáticos e utilizando *Solid Cards* (`#242836`) para listas longas, mantendo o app a 60fps constantes sem sacrificar a beleza.

### `ff9eb21` - Internacionalização (i18n) e Localização
- **Setup Padrão-Ouro**: Introduzido suporte oficial com `flutter_localizations`.
- **Dicionários (ARB)**: Criação dos arquivos JSON/ARB traduzidos para Português (padrão) e Inglês (`app_pt.arb`, `app_en.arb`). Em vez de strings fixas nas telas (hardcoded), o Flutter gera código tipado que previne erros de tradução em runtime.

### `fd08433` - Estrutura Base Clean Architecture & Core
- **Diretórios**: Implementação da estrutura *Feature-First* isolando Domain, Data e Presentation para o futuro da aplicação.
- **Tratamento Funcional de Erros**: O pacote `dartz` foi integrado na camada Core. Criamos a classe base genérica de contrato `UseCase<T, Params>`, que força qualquer lógica de negócios a retornar um `Either<Failure, T>`. Isso bloqueia a propagação de Exceptions não tratadas (Try/Catch hell) para a camada de UI, um pilar de apps bancários estáveis.
- **Design Tokens**: Configuração do `AppTheme` centralizando Cores, Espaçamentos e Tipografia (Google Fonts / Inter). Componentes não usam valores soltos (`Colors.red`), mas sempre acessam via tema (`AppColors.error`), permitindo temas dinâmicos futuros facilmente.
