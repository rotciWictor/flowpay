# Changelog do FlowPay

Este documento registra as implementações do projeto em detalhes, explicando não apenas *o que* foi feito, mas o *porquê* das decisões arquiteturais e de design em cada etapa.

---

## [0.8.2] - Screenshots e Documentação Visual no README

### Documentação
- **Seção de Screenshots no README.md**: Adicionada uma grade visual com 6 screenshots do aplicativo (Login, Dashboard, Extrato, Detalhes da Transação, Vendas e Perfil) organizadas em uma tabela Markdown 3x2, proporcionando uma visão rápida do fluxo e da identidade visual do FlowPay.
- **Assets Organizados**: As imagens foram nomeadas de forma semântica (`login.jpeg`, `dashboard.jpeg`, `extrato.jpeg`, `detalhes_transacao.jpeg`, `vendas.jpeg`, `perfil.jpeg`) e alocadas em `assets/images/readme/` para facilitar a manutenção futura.

---

## [0.8.1] - Internacionalização Absoluta (i18n) e Idioma Espanhol

### Varredura Fina de i18n
- **Novo Idioma Suportado (Espanhol)**: Adicionado o `app_es.arb` e o registro nativo de `Locale('es')` no `main.dart`, suportando a vasta gama de strings da interface.
- **Transição de Strings Fixas para Contextuais**: 
  - Gráficos e Ações Rápidas (`WeeklySalesChart`, `QuickActionsRow`) no Dashboard agora respondem ativamente à seleção de idiomas.
  - A saudação principal do Dashboard (`DashboardHeader`) foi internacionalizada utilizando suporte avançado a parâmetros (`dashboardGreeting('nome')`).
- **Hub de Transações Multi-idioma**: 
  - Extensões de Domínio Refatoradas: Os enumeradores de base (`TransactionStatus` e `PaymentMethod`) sofreram injeção do dicionário `AppLocalizations`, eliminando literais no front-end de toda a tabela de histórico. A tradução obedece o mercado local ("Chargeback" mantido no Brasil, enquanto no idioma espanhol reflete "Contestación").
  - Etiquetas do Filtro Rápido e Datas Relativas (`DateFormatter`) foram convertidas para variáveis da UI, corrigindo a anomalia visual onde "Ontem" ou "Vendas" permaneciam travados no idioma padrão.
  - Label contábil `"Líquido"` que era cego à linguagem agora é devidamente renderizado em pt-BR/en-US/es-ES na Listagem e nos Detalhes.

---

## [0.8.0] - Perfil do Lojista, Proteção de UX e Configurações

### Hub do Lojista (Perfil)
- **Criação da Tela de Perfil**: Construída a tela `ProfilePage` estruturada de acordo com o Design System. Dividida semanticamente em áreas de "Minha Conta" (Dados e CNPJ), "Financeiro" (Taxas e Conta Bancária), "Configurações" (Idioma, Push, Biometria e Tema) e "Suporte" (Central de Ajuda, Termos).
- **Tabela de Taxas Dinâmica**: Implementação do modal de Tabela de Taxas mapeando os dados do banco fictício, exibindo a gratuidade (`0,00%`) para o Pix, e taxas segmentadas de débito e crédito para as bandeiras nativas. As propriedades `useSafeArea` e `isScrollControlled` foram acionadas para evitar que o modal ficasse encoberto (cortado) pela doca de navegação inferior.
- **Identidade Visual Híbrida**: Para renderização das bandeiras de cartão (Visa, Master, Elo, Amex) no painel de perfil, integramos o uso de `Image.asset` consumindo imagens embutidas no pacote `flutter_credit_card_brazilian`. Essa decisão equaliza a identidade visual da Tabela de Taxas com o componente de *Detalhes de Transação*, provendo experiência Premium de ponta a ponta.

### Funcionalidades e Conexões Globais
- **Troca de Idioma Síncrona**: O componente "Idioma" do painel de Configurações foi injetado com o `LocaleCubit`. A troca instantânea entre PT/BR e EN/US afeta todo o aplicativo (AppBar, Menus, Filtros) em tempo real. Adicionalmente, o estado lido via `context.watch<LocaleCubit>()` assegura que a legenda do botão descreva corretamente o idioma em vigor.
- **Motor de Autenticação (Logout)**: Implementada a ruptura de segurança (Logout) chamando a delegação do `AuthCubit` (`logout()`) e empurrando o usuário violentamente e de forma segura (`context.go('/login')`) para fora do funil autenticado.

### Proteção de UX e Empty States (Fechamento Falso)
- **Barreira Sensorial de "Em Breve"**: Construída uma heurística defensiva para testes com stakeholders. Foi detectada a existência de inúmeros *Unhappy Paths* vazios. Ao redor de todo o app (Dashboard, Vendas, Perfil, Transações), mais de 20 "Caminhos Fantasmas" receberam o acoplamento de um componente de feedback nativo (`SnackBar` flutuante e escuro) reportando "Em breve!", evitando a quebra de expectativa ao tocar em botões sem rotas.
- **Sinergia nas Ações Rápidas (Dashboard)**: A área de Ações Rápidas (`QuickActionsRow`) foi criticada do ponto de vista do lojista e reconstruída. O foco tático mirou as quatro grandes dores de Adquirência: **Transferir, Antecipar, Pagar, Criar Link**. Os ícones e labels foram atualizados sistemicamente para refletir essas ações (sem sobreposição visual com outros recursos, como boletos). Adicionado atalhos de "Ajuda" global em todos os cabaçalhos (`AppBars`) principais.

### Governança e Mapeamento de Produto (GitHub CLI)
- **Gênese Épica**: A Issue primordial #4 sofreu mutação no repositório remoto para representar o *[Epic][Feature] Hub de Configurações e Perfil do Lojista*.
- **Taskification**: Foram mapeadas, geradas no GitHub e conectadas estruturalmente à Epic seis sub-issues técnicas com escopo delineado:
  - #7 Editar Dados do Negócio (Supabase CRUD)
  - #8 Gestão de Documentos (CNPJ/CPF) com Máscara e Receita
  - #9 Configuração de Conta Bancária de Domicílio
  - #10 Segurança: Mutação de Senha e Setup de 2FA
  - #11 Toggle Profundo de Biometria (`local_auth`)
  - #12 Toggle Reativo de Modo Escuro / Claro

## [0.7.0] - Core Financeiro, SecOps e Refinamentos UI

### Detalhamento da Transação e Mapeamento de Erros
- **Modal de Detalhes da Transação:** Criamos um componente visual rico para detalhar vendas.
  - Implementado tratamento responsivo com `SafeArea` para evitar sobreposição da StatusBar.
  - Implementada a exibição inteligente do valor "Líquido" (apenas para transações de cartão, não aparece para Pix).
  - O botão de ação principal foi configurado para exibir "Estornar" para Pix, ou "Contestar / Fraude" condicionalmente, com estilo adaptativo (Outline vermelho para estornos).
- **Tradução de Códigos de Retorno (ISO/SPI):** 
  - Adicionado suporte à coluna `return_code` nas entidades e modelos (`transaction.dart`, `transaction_model.dart`).
  - Mapeado o dicionário do BCB e Redes Adquirentes: Falhas de Pix agora exibem detalhes (ex: *AM04 - Saldo Insuficiente*, *BE17 - QR Code Rejeitado*), e erros de cartão mostram códigos ISO (ex: *51 - Saldo Insuficiente*, *05 - Não Autorizada*).
- **Bandeiras Renderizadas:** Integrado o pacote `flutter_credit_card_brazilian` apenas como provider de Assets visuais. A UI agora extrai a logo nativa (Visa, Master, Elo, Amex) e exibe ao lado do nome da bandeira na tela de detalhes.
- **Refinamento Tipográfico e Lógico (Extrato e Dashboard):** 
  - Removida a redundância de texto (`R$ R$`) causada pela injeção dupla do símbolo da moeda.
  - A label "Líquido" agora só aparece estritamente para **Vendas Aprovadas** no cartão de crédito ou débito. Transações Pix, chargebacks, estornos e declínios possuem regras de liquidação síncronas que dispensam a distinção de um valor contábil secundário.
  - O componente `FlowListTile` na lista de extrato e na dashboard ganhou "respiro" lateral (remoção do padding global que limitava os cards) e margin inferior (`FlowSpacing.md`) para aliviar a densidade visual da lista e deixar a UI mais clara.
- **Refatoração do Filtro (TransactionsFilterBottomSheet):**
  - **Fim do "Scroll Cortado":** O carrossel horizontal de períodos (`SingleChildScrollView`) que deixava o chip "Customiza..." cortado na tela foi substituído por um componente `Wrap` dinâmico. Agora os botões fluem e quebram linha de forma responsiva.
  - **Datas Nativas:** Ao invés de um texto falso "hardcoded", agora ao clicar em Customizado ou Alterar, o sistema invoca o `showDateRangePicker` nativo do Flutter. Envelopamos ele em um `ThemeData.dark` injetado com `FlowColors.primary` para manter a imersão visual do design system.
  - **Filtro Avançado de Horas:** O container customizado agora exibe o texto "+ horário". Ao tocar, o usuário consegue refinar a filtragem até o minuto exato usando o `showTimePicker`. Caso ele não adicione, a lógica por trás adota `00:00:00` para a data de início e `23:59:59` para a data de fim automaticamente.

### Hub de Vendas (Esboço UX/UI)
- **Grid de Conversão:** A antiga aba estática "Cobranças (Em breve)" foi completamente reimaginada.
- **Identidade de Vendas:** O texto e contexto mudaram de "Cobrar" para "Vender", removendo a carga semântica negativa. Criado um Grid dinâmico 2x2 exibindo atalhos rápidos para *Vender via Pix, Link de Pagamento, Boleto Bancário e Tap to Pay*, com cores vibrantes do Design System.
- **Histórico Pendente:** Adicionado um *mock* da seção "Vendas Pendentes" com ícone de status amarelo (`warning`) indicando cobranças criadas que aguardam liquidação.

### Componentes Nativos de Carregamento (Loading & Refresh)
- **`FlowProgressIndicator`:** Construído um componente nativo de Design System do zero (`CustomPainter`) para substituir o `CircularProgressIndicator` do Flutter. Ele desenha um arco contínuo que rotaciona sem o efeito de "engasgo/recuo", utilizando o *SweepGradient* Ciano e Verde oficial.
- **`FlowSplashIndicator`:** Restaurado o componente original da Splash Screen para preservar o anel giratório 100% fechado, encapsulando-o nas regras do Design System.
- **`FlowRefreshIndicator` (Pull-to-Refresh):** Instalado o pacote `custom_refresh_indicator` e substituída a seta genérica do Android/iOS pelo nosso anel Ciano/Verde. Aplicado globalmente nas listas do Extrato e da Dashboard para total consistência de marca.

### Organização e Governança de Backlog
- **Migração para GitHub Issues:** Todos os débitos técnicos e *features* remanescentes do roadmap foram transformados em rastreamento oficial no GitHub (via CLI local):
  - *#1 [Tech Debt]*: i18n & Textos, com seletor de idiomas (PT/ES).
  - *#2 [Bug/Investigação]*: Observabilidade e otimização do PDF da Edge Function.
  - *#3 [Feature]*: Detalhes da Transação & Infinite Scroll.
  - *#4 [Feature]*: Perfil do Lojista e Empty States.
  - *#5 [Code Review]*: Revisão de arquitetura (`get_it`, `dartz`, e criação de `barrel files`).
  - *#6 [Feature]*: Implementação Completa do Hub de Vendas (Pix, Link, Boleto, Tap e listagem real de pendências).

### Motor de Relatórios Serverless (PDF e XML)
- **Supabase Edge Function (`generate-report`):**
  - Implementação de um microserviço em Deno/TypeScript no ecossistema do Supabase. Para contornar as limitações de memória da V8 Engine (que não suportaria renderizar HTML via Chromium/Playwright sem esgotar o limite da Edge Function), a geração do PDF foi feita programaticamente utilizando a biblioteca Javascript pura `pdf-lib` via CDN.
  - O motor recebe os filtros ativos (ou o mês escolhido), efetua a query nas transações (respeitando o RLS validado pelo token JWT) e converte os dados em uma tabela PDF formatada ou num arquivo XML estruturado.
  - Upload automático do binário gerado para o bucket privado `reports` no Supabase Storage e devolução instantânea de uma *Signed URL* válida por 1 hora.
- **Integração no App e Fixes de Visualização:**
  - Criado o `ReportService` que gerencia o fluxo de requisição para a Edge Function e o download binário seguro.
  - **Correção "Tela Preta" (Dark Mode):** Os PDFs gerados pelo `pdf-lib` possuem fundo transparente, que ao serem abertos em visualizadores de Dark Mode (iOS/Android), deixavam o texto preto invisível. Resolvido forçando um `page.drawRectangle` branco preenchendo o fundo antes da renderização.
  - O UX de visualização foi refinado utilizando `open_filex` em conjunto com `share_plus` em um diálogo limpo ("Abrir" ou "Compartilhar"), descartando o uso de *BottomSheets* redundantes para a ação.
- **UX do Modal de Exportação (`TransactionsPage`):**
  - Adicionado ícone de download na AppBar. Ao clicar, o lojista aciona um BottomSheet sofisticado com 3 opções:
    1. **Relatório Mensal (PDF):** Ignora os filtros da tela e abre um segundo BottomSheet (Month Picker) listando os últimos 12 meses nomeados de forma amigável para extração direta de caixa mensal.
    2. **Período Atual (PDF):** Utiliza as datas exatas filtradas pelo lojista na tela de extrato.
    3. **Período Atual (XML):** Voltado para contabilidade e ERPs, utilizando os filtros ativos.
- **Infraestrutura de Storage:**
  - Inserida instrução de criação automática do bucket `reports` (privado) ao final do arquivo `seed_demo.sql` (`insert into storage.buckets...`), garantindo que o pipeline de deploy e resets de banco mantenham a arquitetura de relatórios funcionando em qualquer ambiente local ou remoto.


### Ajustes no Motor Financeiro (SQL e Domínio)
- **Correção Crítica no `seed_demo.sql`:** 
  - Resolvido o aborto de execução no Supabase Studio alterando o comando falho `WHERE user_id =` para `WHERE id =` na atualização de `merchants`.
  - Adicionado instrução DDL protetiva (`ALTER TABLE IF EXISTS`) para auto-criação da coluna `return_code` antes das inserções, blindando o ambiente de erros fatais de migração de banco de dados.
  - Reescrita da inteligência orgânica da geração de Pix: não são mais gerados falsos "reembolsados" via Pix. Em transações Pix, fluxos de falha são convertidos para `approved` (visto que Pix estornado na vida real segue um rito separado de MED, não sendo um estorno de aprovação simples).
- **Corrigido Data Source (`return_code` nulo):** As requisições `select()` do Supabase RPC omitiam o campo `return_code`. Adicionamos a coluna nas *views* para injetá-lo na modelagem.
- **Precisão Métrica no Dashboard (DashboardData):**
  - **A receber:** Agora isola e soma unicamente vendas (Sale) de Cartão que estejam Aprovadas. Foi corrigida a anomalia que incluía transferências pendentes (gerando valores negativos no caixa projetado de D+1).
  - **Saldo Disponível:** Ajustado para excluir vendas em cartão (que agora ficam retidas na esteira D+1 de recebíveis) e consolidar rigorosamente: Pix, Transferências de Entrada (recebimentos D+0) menos Estornos/Chargebacks.

### Database-Driven Fee Engine (Motor de Taxas Comerciais)
- **Documentação de Taxas (`docs/taxas_comerciais.md`):** Consolidamos as taxas comerciais da Adquirente fictícia (Débito: 1.5%, Crédito: 3.5% + 1.5% ao mês, Elo: 4.5%, Pix: 0%).
- **Schema e Tabela Dedicada:** 
  - Ao invés de *hardcodar* regras de negócio no código-fonte, criamos a tabela `merchant_fees` no `schema.sql` (Database-Driven Architecture), com políticas de segurança (RLS).
- **Seed Refatorado:** 
  - O `seed_demo.sql` foi reescrito utilizando 3 camadas lógicas em CTEs (`data_generator`, `refined_data`, `fee_calculation`).
  - A geração de transações passou a fazer um `JOIN` relacional com `merchant_fees`, simulando exatamente a cobrança real (descontando 20% numa venda em 12x, por exemplo).

### Migração de SecOps (Segurança de Ambiente)
- **Substituição do `flutter_dotenv`:** 
  - O `.env` embutido no APK é uma falha de segurança potencial (vazamento via engenharia reversa). 
  - Removemos o pacote do `pubspec.yaml` e deletamos o asset para impedir injeção.
- **Injeção em Tempo de Compilação (`--dart-define`):** 
  - Criada a classe `lib/core/config/env.dart` encapsulando as variáveis secretas através do `String.fromEnvironment`.
  - Essa abordagem protege as credenciais do backend (Supabase) e prepara o terreno perfeitamente para esteiras automatizadas de CI/CD (ex: GitHub Actions) sem depender de artefatos não comitados.
  - Para Developer Experience (DX), geramos automaticamente a configuração `.vscode/launch.json` injetando as variáveis no ambiente de Debug local.

### Ajustes Estéticos (Design System)
- **Liquid Glass Restaurado:** O `FlowButton` teve seu design revisto para garantir fidelidade ao estilo *Glassmorphism* (fundo translúcido `0xFF1A1D27` 95%, com bordas neon finas).
- **Refatoração do FlowListTile:** Removemos o widget nativo do Flutter e reescrevemos o componente do zero usando `Row` e `Column` encapsulados em um `Container` limitador, extinguindo totalmente os problemas de *Overflow* no extrato na renderização dos nomes de lojistas muito longos.

## [0.6.0] - Refinamento de UX/UI e Consistência

### `(tbd)` - Perfumaria Nativa e Fundo Global
- **Ícone e Splash Screen (Nativo)**:
  - Instalamos `flutter_launcher_icons` e `flutter_native_splash`.
  - No ícone do app (`launcher_icon`), removemos a logo em texto que espremia a arte. Configuramos o Android Adaptive Icons para usar o fundo nativo `#0F111A` e o "F" em alta resolução.
  - Na Splash Screen nativa, notamos que o "F" ficava enorme. Criamos um script Python (`pad_icon.py`) para reduzir a imagem a 60% e gerar uma margem invisível (`logoF_padded.png`), aplicando ela na splash para uma abertura minimalista.
- **Correção de Nome de Build**: Corrigido `android:label` no `AndroidManifest.xml` de "fintech_app" para "FlowPay" (agora o nome real aparece sob o ícone no Android).
- **FlowBackground Global**: 
  - Para evitar uma quebra brusca entre a Splash Nativa (sólida) e a Tela de Login (gradiente), decidimos unificar a identidade visual de *todo o app*.
  - Extraímos o `RadialGradient` do Login para um componente `FlowBackground`.
  - Injetamos o `FlowBackground` na raiz do `AppBottomNav` (tornando os `Scaffolds` da Dashboard e do Extrato transparentes), o que significa que o degradê tecnológico premium agora banha o app inteiro por trás das listas e gráficos.

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
