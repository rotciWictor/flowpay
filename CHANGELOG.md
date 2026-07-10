# Changelog do FlowPay

Este documento registra as implementações do projeto em detalhes, explicando não apenas *o que* foi feito, mas o *porquê* das decisões arquiteturais e de design em cada etapa.

---

## [0.3.0] - Dashboard Financeiro Premium & UX Overhaul

### `(tbd)` - Diário de Design (O Processo e Iterações)
- **Fase 1: O "Efeito Foom"**: A primeira versão do dashboard utilizava componentes nativos e rígidos (Roboto, BarCharts e cores sólidas), resultando num aspecto "sem vida" (wireframe funcional). Após consultoria de design via IA (Gemini), identificamos a falta de "ar" (padding), a dissonância da tipografia padrão e a falta de hierarquia.
- **Fase 2: A Busca pela Tipografia e Contraste**: Inicialmente dividimos as fontes (`Space Grotesk` para números e `Inter` para texto) e tentamos substituir o Verde Neon por um Verde Menta mais calmo. Porém, o Verde Menta "chapou" o design. Voltamos o **Verde Neon Original** como Primário para manter a agressividade da marca, mas isolamos o Verde Menta (`successMint`) apenas para valores positivos na lista de transações, resolvendo o contraste com o branco.
- **Fase 3: Os Bugs Visuais do Gráfico (fl_chart)**: A transição de gráfico de barras para linha (Bezier) expôs três problemas reais: (1) O eixo X repetia os dias, resolvido forçando `interval: 1`; (2) O Tooltip vazava a tela nas extremidades, corrigido com `fitInsideHorizontally/Vertically`; (3) Quedas bruscas de valor faziam a curva furar o eixo zero (overshooting), contido com `preventCurveOverShooting: true`.
- **Fase 4: A Decisão Final (Figma & Outfit)**: Baseado em uma referência premium do Figma focada na *Product Sans*, abandonamos a abordagem multi-fontes e migramos 100% da tipografia para **Outfit** (a gêmea open-source da fonte do Google). Acentuamos o "Glassmorphism" aumentando as bordas semitransparentes para `alpha: 0.08`.
- **Fase 5: O Glitch do Spinner**: Tentativa de aplicar o gradiente neon no `CircularProgressIndicator` da Splash via `ShaderMask`. O redimensionamento orgânico do loading corrompia a máscara gerando "flashes brancos". Solucionado prendendo o spinner em um `SizedBox(40x40)` estático e trocando para um `SweepGradient` atrelado ao `BlendMode.srcIn`.

### `(tbd)` - UI/UX: Implementação "Dark Fintech"
- **Tipografia Consolidada (Outfit)**: Refatoração global da tipografia para a fonte geométrica `Outfit`, replicando o padrão visual de fintechs tier-1 (semelhante ao Product Sans). Implementada hierarquia de tamanhos extrema (ex: `fontSize: 44` para saldos) e tracking negativo (`letterSpacing: -1.0`) para condensar o volume visual, conferindo um design denso, premium e autoritário.
- **Glassmorphism e Contorno Luminoso**: Substituição de caixas sem vida por cartões ancorados. Aplicação de um *border* branco translúcido (`alpha: 0.08`) nas bordas arredondadas e nos botões de ação rápida (`BoxShape.circle`), gerando um efeito de refração sutil que destaca a profundidade da superfície contra o fundo escuro de carvão.
- **Gradients de Foco (Neon & Cyan)**: Criação de um `LinearGradient` na camada do saldo "A receber amanhã", transitando do Verde Neon para Azul Ciano antes de desaparecer em transparente (`Colors.transparent`). Essa iluminação direciona o olho do Gestor Matinal diretamente para os dados cruciais.
- **Fix de Artefatos no Spinner (ShaderMask)**: Correção avançada de rendering no `CircularProgressIndicator` da Splash Screen. Devido à constante animação de expansão, a máscara sofria de "glitch". Enclausuramos o loading em um `SizedBox(40x40)` travando o *bounding box* matemático da máscara e utilizamos um `SweepGradient` atrelado ao `BlendMode.srcIn`, resultando num giro de gradiente neon suave e sem frames vazados (flickering).

### `(tbd)` - Dashboard: Gráficos Interativos (fl_chart) e Shimmer Loading
- **Gráfico de Linhas Interativo e Curvo**: Substituição de barras sólidas (estilo Excel) por um gráfico de linha contínua (Bezier curve) via pacote `fl_chart`. Ativado o `preventCurveOverShooting` para suprimir "quedas irreais" da linha matemática em picos bruscos de dados.
- **Data Tooltips Financeiras**: Implementado o `touchTooltipData` com detecção de toque (`lineTouchData`). Ao escanear o gráfico com o dedo, o aplicativo renderiza em bolhas dinâmicas com fundo escuro os valores reais diários formatados e a exata data (`dd/mm`) embaixo da linha de Bezier sem estourar as margens da tela (`fitInsideHorizontally` e `fitInsideVertically`).
- **Shimmer de Skeleton Personalizado**: Removido o padrão nativo agressivo e incluído o pacote `shimmer`. O app agora emite, durante chamadas assíncronas de rede, marcações suaves "skeleton" com máscaras dimensionais espelhando fielmente os contornos dos objetos finais.

### `(tbd)` - Core: Dinheiro Estrito e Camada de Domínio do Dashboard
- **Value Equality e Moeda (money2)**: Configurada infraestrutura de tipo estrito `Money` usando o pacote `money2`, com parsing rigoroso na formatação de `BRL`. As propriedades `decimalSeparator` e `groupSeparator` do padrão internacional blindam falhas de casting entre Inteiros e Floats (Floating Point errors), blindando o motor financeiro contra centavos perdidos.
- **Domain Layer (DashboardData)**: Criação dos casos de uso, Entidades e DTOs (`GetDashboardData`, `DashboardDataEntity`, `DailySale`). A camada de dados filtra organicamente os inputs das transações em `TransactionsRepositoryImpl`, extraindo saldo aprovado e repasses pendentes para criar arrays agrupados dos últimos 7 dias, despachando tudo unificado para o `DashboardCubit`.

---

## [0.2.2] - Localização (i18n): Dicionários e Seletor Dinâmico

### `(tbd)` - Dicionários ARB e Integração do flutter_localizations
- **Tradução Total da UI (i18n)**: Limpeza profunda de dívida técnica. Todas as strings físicas (hardcoded) nas páginas `LoginPage`, `RegisterPage`, `ProfilePage` e `AppBottomNav` foram extraídas e registradas em dicionários tipados no formato ARB (`app_pt.arb` e `app_en.arb`). O `flutter gen-l10n` foi executado para prover a reatividade via `AppLocalizations.of(context)`.

### `(tbd)` - Seletor de Idiomas Dinâmico (LocaleCubit)
- **Gerenciador de Estado de Localidade (`LocaleCubit`)**: Implementação de um Cubit dedicado à retenção do estado de idioma ativo.
- **Árvore de Widget Reativa**: O `MaterialApp` base no `main.dart` foi envelopado dentro de um `BlocBuilder<LocaleCubit, Locale>`. Isso converte o aplicativo inteiro em uma árvore reativa onde qualquer alteração de idioma propaga a renderização de strings de maneira global, síncrona e "em tempo real".
- **UX (Flags)**: Integração do pacote `country_flags` substituindo ícones genéricos por bandeiras SVG circulares autênticas (BR e US) no botão flutuante superior. Implementada lógica UI intuitiva: a bandeira exibida reflete sempre o *idioma alvo* da troca (ex: exibindo a bandeira US quando a interface está em português) para deixar a ação previsível ao usuário.

---

## [0.2.1] - Auth: Melhorias UX, Google Sign-in e Modo Demo

### `(tbd)` - Easter Egg, Roteamento e Setup Google Auth
- **Modo Demo (Easter Egg)**: Implementação de um atalho escondido na `LoginPage`. Ao tocar 3 vezes rápidas na logo do FlowPay, o formulário é preenchido automaticamente com `demo@flowpay.com` e o login é disparado. Isso permite que recrutadores e avaliadores testem a aplicação (Frictionless Demo) sem precisarem realizar um cadastro, acessando os dados fictícios criados.
- **Database Seeding (`seed_demo.sql`)**: Criação de um script SQL avançado para popular a base de dados de demonstração. O script gera a conta do usuário Demo e insere 100 transações financeiras orgânicas e randômicas (com variações de método de pagamento, status de aprovação, taxa de plataforma de 5% sobre o valor líquido e datas nos últimos 30 dias).
- **Google Auth e Deep Linking**: Finalização da integração com o Google OAuth. O `AndroidManifest.xml` foi atualizado para escutar o esquema de deep link `io.supabase.flowpay://login-callback`. A chamada do `Supabase` agora envia a flag de `redirectTo`, permitindo que o navegador nativo devolva o token OAuth para a engine do Flutter fechar o ciclo de login perfeitamente.
- **Correções de Roteamento (GoRouter)**: Ajustado o mapeamento da rota principal no redirecionamento do BLoC. As páginas de Login e Splash tentavam rotear para `/home`, porém a árvore de rotas estrutural (Shell Route) estava na raiz `/`. O bug da "Página não encontrada" foi resolvido.
- **Placeholder de Cadastro e Logout**: Adicionado um botão "Cadastre-se" na tela de Login roteando para um *stub* (`RegisterPage`) que será construído futuramente com um Stepper. Também adicionado um esboço na `ProfilePage` com um botão funcional de Sair (Logout) no topo, destruindo a sessão do Cubit e voltando para a tela de Login.

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
