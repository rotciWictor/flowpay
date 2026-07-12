# Changelog do FlowPay

Este documento registra as implementações do projeto em detalhes, explicando não apenas *o que* foi feito, mas o *porquê* das decisões arquiteturais e de design em cada etapa.

---

## [0.6.0] - Refinamento de UX/UI e Consistência

### `(tbd)` - Dashboard: Ajustes Técnicos de UX (Capítulo 10)
- **WeeklySalesChart**: 
  - Aumentamos o `fontSize` do eixo X (`bottomTitles`) de `labelSmall` (10px) para `labelMedium` (12px) para melhorar legibilidade.
  - Como não há *hover* em mobile, envolvemos o `LineChart` em um `Stack` e adicionamos um `Positioned` no topo esquerdo com um `Icon(Icons.touch_app)` e o texto "Toque no gráfico para detalhes" para indicar interatividade explícita.
- **LatestTransactionsList (Espelhamento do Extrato)**: 
  - Substituímos a implementação básica que mostrava apenas o valor numérico solto no título.
  - Reconstruímos o item copiando a lógica do `_TransactionItem` (do Extrato):
    - O título agora é o nome do cliente (`customerName`).
    - O subtítulo agora concatena a hora, o método e a bandeira do cartão.
    - O `trailingWidget` exibe o valor contábil com sinal (ex: `- R$ 600,00` em vermelho) e o badge de status (ex: `Aprovada`).
  - Adicionado o ícone de affordance explícito (`chevron_right`) do lado direito, para indicar que a linha inteira é clicável.
- **Correção de Scroll Vazio na Dashboard**:
  - Havia um `SizedBox(height: 80)` *hardcoded* no fim do `CustomScrollView` (em `dashboard_page.dart`) colocado com a intenção de não esconder o fim da lista atrás do menu de navegação.
  - Removemos esse widget, pois o `Scaffold` com bottom nav já delega e gerencia esse espaço (safe area). Reduzido para `SizedBox(height: FlowSpacing.md)` apenas para evitar que o último item encoste perfeitamente na barra inferior.

### `(tbd)` - Refatoração do Filtro (TransactionsFilterBottomSheet)
- **Correção de Contraste**: Os botões do tipo `ChoiceChip` (Vendas, Períodos, etc) que não estavam selecionados usavam `FlowColors.surface` sem borda, ficando praticamente invisíveis contra o fundo escuro. Alteramos para `FlowColors.surfaceVariant` (cinza claro) + borda branca translúcida (`Colors.white.withValues(alpha: 0.08)`).
- **Tipografia Menos Corporativa**: Substituímos os cabeçalhos das sessões (TIPO DE MOVIMENTAÇÃO) que usavam ALL CAPS esticado, para tipografia natural em caixa baixa `labelLarge`.
- **Animações (Micro-interações)**: Trocamos o `Container` dos chips por um `AnimatedContainer(duration: 200ms)` para a cor de preenchimento suavizar ao clicar.
- **Simplificação de Cores**: As opções de Status (Aprovado, Pendente) usavam um azul ciano ao selecionar (`primaryGradientEnd`), enquanto as demais usavam o verde primário. Refatoramos para que **todos** os chips do filtro usem `FlowColors.primary` ao serem selecionados.
- **Limpar Filtros**: Adicionamos um texto clicável "Limpar tudo" ancorado no `Row` superior. Ele possui uma condicional `hasActiveFilters` para só renderizar se o usuário modificou o padrão, disparando um `setState` que reseta as variáveis internas.

### `(tbd)` - Componentização: Botão Primário
- **Criação do FlowButton**: O botão principal do app (com gradiente na borda e fundo em vidro escuro) existia com cerca de 60 linhas literais (hardcoded) dentro da `LoginPage`. 
- Extraímos esse bloco completo para `lib/shared/design_system/components/buttons/flow_button.dart`.
- Injetamos o `FlowButton` na `LoginPage` e o substituímos no `TransactionsFilterBottomSheet` (que antes usava uma versão simplificada verde sólida e depois uma versão de código duplicado). Agora o Design System blinda a coesão do botão primário do app.

---

## [0.5.0] - Extrato Financeiro, Filtros e Lista de Movimentações

### `(tbd)` - Fundação do Extrato (Página de Transações)
- **Nova Tela de Extrato (TransactionsPage)**: Criamos a tela completa do Extrato Financeiro, integrando a navegação na barra inferior. A tela possui um cabeçalho fixo com o saldo total do usuário e uma lista interativa que mostra o histórico de tudo o que entrou e saiu da conta.
- **Lista de Movimentações (FlowListTile)**: Construímos a interface da lista onde cada transação exibe informações vitais de forma clara:
  - **Ícones de Dinâmica Visual**: Setinhas apontando para fora (vermelhas) para saídas, logo de lojas para vendas, e ícones do Pix, Master e Visa quando necessário.
  - **Identificação de Valores**: Valores positivos (vendas e recebimentos) ficam em cor neutra na interface, enquanto saídas de dinheiro (boletos, transferências) ganham a cor vermelha com sinal negativo para alertar rapidamente.
  - **Badges de Status (Etiquetas)**: O status de cada transação (Aprovada, Pendente, Falha, Reembolsada, Cancelada) ganhou etiquetas visuais no canto direito da lista, com cores semânticas que ajudam o gestor a bater o olho e entender se deu certo.
- **Gerenciamento de Estado (TransactionsCubit)**: Implementamos o controle inteligente da página. Quando a tela abre, ela mostra automaticamente um "esqueleto de carregamento" (Shimmer) enquanto busca os dados, e trata possíveis erros de rede mostrando mensagens amigáveis ao usuário.
- **Camada de Conexão com o Banco (Domain & Data)**: Criamos toda a estrutura por trás da tela (Arquitetura Limpa): a Entidade `Transaction`, o caso de uso `GetTransactions` e o `TransactionsRemoteDatasource`, que faz a requisição pro servidor Supabase puxando todas as transações, ordenadas da mais recente para a mais antiga.

### `(tbd)` - UI/UX: Filtro, Cores e Pull-to-Refresh
- **Criação do Painel de Filtros**: Desenhamos e implementamos o `TransactionsFilterBottomSheet`, um painel deslizante para o usuário filtrar as transações por Tipo (Vendas, Movimentações), Período (Hoje, 7 dias, etc) e Status.
- **Memória do Filtro**: O filtro agora salva as opções que o usuário marcou. Ao fechar e abrir de novo, os botões continuam selecionados. O `TransactionsCubit` guarda esses dados para você não precisar reconfigurar tudo.
- **Estilo dos Botões e Cores**: Todos os botões do filtro agora ficam preenchidos com cor sólida quando ativados. Usamos o verde primário para as opções de cima e o azul ciano para a opção de Status. O texto "Todos" no período mudou para "Qualquer data".
- **Pull-to-Refresh em Listas Vazias**: Adicionado o componente `RefreshIndicator` com a propriedade `AlwaysScrollableScrollPhysics` na lista. Isso permite que a tela seja puxada de cima para baixo para atualizar mesmo quando não existem transações.
- **Loading Silencioso (Pull-to-Refresh)**: Alteramos a lógica de carregamento. O Shimmer (esqueleto cinza piscando na tela inteira) só aparece quando você abre a tela pela primeira vez. Se você usar o gesto de puxar a tela para baixo, o Shimmer não apaga o que você estava lendo; apenas a setinha de carregar aparece no topo, colorida em verde e ciano.

### `(tbd)` - Internacionalização (i18n) e Chaves Agnósticas
- **Extrato Multilíngue**: Todas as palavras e frases (hardcoded) do Extrato e do Filtro foram extraídas e colocadas nos arquivos `.arb` (`app_pt.arb` e `app_en.arb`). A tela agora traduz em tempo real se o idioma do app mudar.
- **Estado Seguro Contra Tradução**: Ao invés do filtro salvar as palavras que estavam na tela (ex: "Vendas") para lembrar o estado, ele agora usa chaves imutáveis por baixo dos panos (ex: `'sales'`). Assim, o filtro continua funcionando perfeitamente independente do idioma escolhido.

### `(tbd)` - Lógica do Filtro e Base de Dados
- **Filtro de "Movimentações da Conta"**: O Usecase `GetTransactions` foi alterado para aceitar uma lista de tipos (`List<TransactionType>`) em vez de um único tipo. Com isso, ao selecionar "Movimentações da Conta", o app agora busca tanto as saídas (`transfer_out`) quanto as entradas (`transfer_in`) ao mesmo tempo.
- **Consultas Otimizadas no Supabase**: A chamada no servidor foi atualizada para usar a instrução `.filter('coluna', 'in', lista)` do Supabase, o que permite fazer a busca de vários tipos ou vários status de uma vez só no banco, deixando a busca mais rápida.
- **Conserto na Comparação de Estado**: Corrigimos um bug no domínio onde filtros diferentes não forçavam a atualização da tela.
- **Dados Fictícios Corrigidos e Novas Transações**: O script de criação do banco (`seed_demo.sql`) foi consertado. Retiramos os erros de dados impossíveis como "Chargeback" para "Pix". Além disso, adicionamos `transfer_in` (recebimento de transferências em verde) e configuramos as contas de luz fixas como saída.


## [0.4.0] - Fundação do Design System e Refatoração UI

### `(tbd)` - Tokens, Behavior e Componentes (Arquitetura)
- **Extração de Tokens**: Foi abolido o antigo sistema de temas soltos (`AppColors`, `AppSpacing`). O ecossistema agora reside em `lib/shared/design_system/tokens/`. As cores foram estritamente divididas entre **Primitives** (intocáveis, ex: `_green500`) e **Semantics** (aplicáveis, ex: `FlowColors.primary`), eliminando qualquer brecha para "UI Drift".
- **Haptic Feedback Nativo**: Criado o `flow_haptics.dart` na camada de Behavior. Interações com botões agora disparam gatilhos táteis automáticos (`lightImpact`, `mediumImpact`), provendo uma resposta física Premium ao toque do usuário.
- **Componentização Avançada**: O design abstrato e denso construído inicialmente no Dashboard foi componentizado e salvo no catálogo global de `components/`:
  - `FlowCard`: Card padrão com Liquid Glass e gradiente.
  - `FlowIconButton`: Botão Neon/Metálico com sombra bicolor.
  - `FlowListTile`: Item de lista financeiro com suporte a avatar e `Tabular Figures` para os números.

### `(tbd)` - Refatoração Global e Correções
- **Migração Sistêmica**: Um script autônomo em Python escaneou e reescreveu mais de 30 arquivos da codebase, alterando importações e instâncias de `AppColors` para `FlowColors`, consolidando a nova fundação sem quebrar a lógica de presentation.
- **Refatoração do Dashboard**: Os widgets `next_settlement_card.dart`, `quick_actions_row.dart` e `latest_transactions_list.dart` sofreram uma limpeza drástica de UI Code (mais de 100 linhas removidas), passando a delegar a responsabilidade estética inteiramente para os componentes da biblioteca `Flow`.
- **Tradução (Bugfix)**: Corrigida a string `dashboardNextSettlement` de "A receber amanhã" para "A receber próx. dia útil" (`app_pt.arb`), mantendo a precisão das regras de negócio de D+1 (onde D+1 numa sexta não é sábado).


## [0.3.0] - Dashboard Financeiro Premium & UX Overhaul

### `(tbd)` - Diário de Design (O Processo e Iterações)
- **Fase 1: O "Efeito Foom"**: A primeira versão do dashboard utilizava componentes nativos e rígidos (Roboto, BarCharts e cores sólidas), resultando num aspecto "sem vida" (wireframe funcional). Após consultoria de design via IA (Gemini), identificamos a falta de "ar" (padding), a dissonância da tipografia padrão e a falta de hierarquia.
- **Fase 2: A Busca pela Tipografia e Contraste**: Inicialmente dividimos as fontes (`Space Grotesk` para números e `Inter` para texto) e tentamos substituir o Verde Neon por um Verde Menta mais calmo. Porém, o Verde Menta "chapou" o design. Voltamos o **Verde Neon Original** como Primário para manter a agressividade da marca, mas isolamos o Verde Menta (`successMint`) apenas para valores positivos na lista de transações, resolvendo o contraste com o branco.
- **Fase 3: Os Bugs Visuais do Gráfico (fl_chart)**: A transição de gráfico de barras para linha (Bezier) expôs três problemas reais: (1) O eixo X repetia os dias, resolvido forçando `interval: 1`; (2) O Tooltip vazava a tela nas extremidades, corrigido com `fitInsideHorizontally/Vertically`; (3) Quedas bruscas de valor faziam a curva furar o eixo zero (overshooting), contido com `preventCurveOverShooting: true`.
- **Fase 4: A Decisão Final (Figma & Outfit)**: Baseado em uma referência premium do Figma focada na *Product Sans*, abandonamos a abordagem multi-fontes e migramos 100% da tipografia para **Outfit** (a gêmea open-source da fonte do Google). Acentuamos o "Glassmorphism" aumentando as bordas semitransparentes para `alpha: 0.08`.
- **Fase 5: O Glitch do Spinner (CustomPainter)**: O `CircularProgressIndicator` nativo aliado a uma `ShaderMask` continuou apresentando falhas severas de "clipping" (vazamentos brancos). Após pesquisa e iteração, descartamos a máscara e construímos do zero um widget nativo (`GradientCircularProgressIndicator`) usando `CustomPaint` e um `AnimationController` explícito. Agora o canvas desenha fisicamente uma circunferência vazada (`PaintingStyle.stroke`) com `SweepGradient` atrelado a um `RotationTransition`, gerando um "neon spinner" absoluto, sem engasgos e sem uso de pacotes externos.
- **Fase 6: O Refinamento Final (Affordances e Micro-Interações)**: Guiados pelas heurísticas de usabilidade (Capítulo 10), consertamos o Ripple Effect dos botões refatorando a árvore de containers e ativamos "Halo Glows" (sombras neons nas cores primárias) nos cards clicáveis, injetando uma aura premium e feedback tátil ao lojista. O letreiro gigante de saldo foi aprimorado com uma fina borda neon animada em loop assíncrono (SweepGradient + Stroke), evocando tecnologia sem parecer brega. O gráfico de Bezier ganhou respiro lateral através da técnica avançada de "Bleed" (Sangria), cortando dados excedentes com `FlClipData` para que a linha atravesse o painel organicamente.
- **Fase 7: Desacoplamento Arquitetural, Resiliência e CI/CD**: Com base em um feedback focado em maturidade de código, isolamos totalmente o `DashboardCubit` (Presentation Layer), extirpando sua importação indevida do `SupabaseClient`. Agora o *Data Source* se apoia inteiramente na infraestrutura de *Row Level Security (RLS)* via JWT do usuário autenticado, mantendo os contratos do Domínio imaculados (remoção do `merchantId`). Para garantir a resiliência (*Unhappy Paths*), inserimos blocos cirúrgicos de captura de `PostgrestException`, projetados em conjunto com um novo "Empty/Error State" premium interativo na UI. Como marca final de senioridade, estreamos o pipeline de Integração Contínua (CI/CD) via GitHub Actions para análise de Lint e Qualidade de Código a cada commit.
- **Fase 8: Engenharia de Testes de Qualidade (Agentic TDD)**: Consolidamos a resiliência do app seguindo o documento de *Estratégias de Teste da Era da IA*. Aderimos ao princípio "DAMP over DRY", extinguindo os simulacros excessivos (Over-Mocking). Nos testes da `Apresentação` (`DashboardCubit` e `AuthCubit`), instanciamos as classes reais de `UseCases` e `Repositórios`, mockando estritamente a fronteira remota (I/O). Também criamos testes puros nas agregações matemáticas (`TransactionsRepositoryImpl`) para mitigar anomalias. Por fim, engatamos a execução unificada do `flutter test` na nossa esteira do GitHub Actions.
- **Fase 9: Renomeação da Home e Internacionalização (i18n)**: Aplicamos um "UX Overhaul" baseado nas dicas da IA de design. A pasta e os arquivos da tela principal foram refatorados de `Home` para `Dashboard` (`dashboard_page.dart`), refletindo a essência corporativa da Fintech. **Decisão de Arquitetura**: Mantivemos deliberadamente o `DashboardCubit` alocado na feature `transactions` em vez de movê-lo para `dashboard`, preservando a coesão com a base de testes recém-estabelecida (caso o Cubit e os testes migrem de pasta no futuro, será exigido um refactoring cuidadoso nos imports de teste). Além disso, extraímos 100% das strings fixas para os dicionários `app_pt.arb` e `app_en.arb`, habilitando tradução fluída (i18n) em tempo real.
### `(tbd)` - UI/UX: Implementação "Dark Fintech"
- **Tipografia Consolidada (Outfit)**: Refatoração global da tipografia para a fonte geométrica `Outfit`, replicando o padrão visual de fintechs tier-1 (semelhante ao Product Sans). Implementada hierarquia de tamanhos extrema (ex: `fontSize: 44` para saldos) e tracking negativo (`letterSpacing: -1.0`) para condensar o volume visual, conferindo um design denso, premium e autoritário.
- **Glassmorphism e Contorno Luminoso**: Substituição de caixas sem vida por cartões ancorados. Aplicação de um *border* branco translúcido (`alpha: 0.08`) nas bordas arredondadas e nos botões de ação rápida (`BoxShape.circle`), gerando um efeito de refração sutil que destaca a profundidade da superfície contra o fundo escuro de carvão.
- **Gradients de Foco (Neon & Cyan)**: Criação de um `LinearGradient` na camada do saldo "A receber amanhã", transitando do Verde Neon para Azul Ciano antes de desaparecer em transparente (`Colors.transparent`). Essa iluminação direciona o olho do Gestor Matinal diretamente para os dados cruciais.
- **Animação Nativa Extremamente Otimizada (Custom Painter Spinner)**: Substituição absoluta da estrutura de `CircularProgressIndicator` e gambiarras de máscara de cor. Foi orquestrado um componente customizado de *Loading* (`GradientCircularProgressIndicator`) na base nativa do Flutter (`CustomPainter` com `AnimationController` assíncrono acoplado num `SingleTickerProviderStateMixin`). Isso eliminou definitivamente qualquer anomalia de rendering ("flashes" e "flickers") e proporcionou uma borda arredondada (`StrokeCap.round`) que brilha em verde e ciano.

### `(tbd)` - Dashboard: Gráficos Interativos (fl_chart) e Shimmer Loading
- **Gráfico de Linhas Interativo e Curvo**: Substituição de barras sólidas (estilo Excel) por um gráfico de linha contínua (Bezier curve) via pacote `fl_chart`. Ativado o `preventCurveOverShooting` para suprimir "quedas irreais" da linha matemática em picos bruscos de dados.
- **Data Tooltips Financeiras e Hit Slop**: Implementado o `touchTooltipData` com detecção de toque (`lineTouchData`). Aumentamos a área física de toque invisível (`touchSpotThreshold: 30`) para garantir fluidez, renderizando balões dinâmicos sem estourar as margens da tela (`fitInsideHorizontally`).
- **Shimmer de Skeleton Personalizado**: Removido o padrão nativo agressivo e incluído o pacote `shimmer`. O app agora emite, durante chamadas assíncronas de rede, marcações suaves "skeleton".
- **Técnica de Bleed (Sangria de Gráfico)**: Ajustamos a Viewport do `LineChart` e alimentamos o motor com 9 dias de dados (sendo 1 invisível no passado e 1 no futuro), e ligamos o clipData absoluto (`FlClipData.all()`). O gráfico agora não "nasce" na parede do card, mas sim atravessa ele como um feixe contínuo de energia.

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
- **Botão CTA Premium (Gradient Border)**: Substituição do botão sólido verde escandaloso na tela de Login por um botão "Ghost" moderno com *Gradient Border*. Usando a composição de dois containers, o botão principal agora possui um preenchimento escuro e sutil (`#1A1D27`), mas é emoldurado por uma linha brilhante que transita do Verde Primário para o Azul Ciano, gerando hierarquia e preservando a visão do usuário.
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
