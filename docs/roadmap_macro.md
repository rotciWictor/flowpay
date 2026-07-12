# Roadmap Macro do FlowPay (Status Geral)

Este documento reflete o cronograma de 5 dias traçado no Plano de Implementação (`docs/implementation_plan.md`), atualizado com o status em tempo real do nosso progresso. Isso ajuda a visualizar exatamente o que já foi conquistado e o que vem pela frente.

## Status Geral do Projeto: 🚧 FASE 2 EM ANDAMENTO

---

### 🟢 DIA 1 — Core, Infraestrutura, Autenticação e Navegação (CONCLUÍDO)
A fundação do aplicativo foi construída com foco em escalabilidade e arquitetura sólida.
- ✅ Estrutura de pastas Clean Architecture (Feature-First)
- ✅ `pubspec.yaml` com todas as dependências core (`get_it`, `dartz`, `go_router`, etc)
- ✅ Core: `Failure`, `Exception`, `UseCase` abstrato (`dartz` + `Either`)
- ✅ Supabase configurado (API + Auth Datasource)
- ✅ Banco de dados modelado e populado (`seed_demo.sql`)
- ✅ Design System e Tema (cores, tipografia Outfit, espaçamentos)
- ✅ Navegação Global (`GoRouter` + StatefulShellRoute para Abas Independentes)
- ✅ Funcionalidade de Login Premium (AuthGuard, BLoC, Google Auth e Demo Mode)
- ✅ **[Extra]** Internacionalização Base (i18n configurado)
- ✅ **[Extra - Adiantado do Dia 5]** Testes Unitários de Autenticação (Agentic TDD)

---

### 🟢 DIA 2 — Dashboard Financeiro e Design System (CONCLUÍDO)
Foco na visão principal do lojista (Dash) e fundação do Design System.
- ✅ **Dashboard UI Premium**: Saldos, gráfico semanal de barras/curvas e Atalhos.
- ✅ **Dashboard i18n**: Totalmente traduzido para inglês/português.
- ✅ **Dashboard BLoC**: BLoC isolado acessando Repository e UseCases Reais.
- ✅ **Design System (Tokens & Behavior)**: Extração de Cores semânticas, Tipografia e Haptics.
- ✅ **Design System (Componentes)**: Criação do FlowCard, FlowIconButton e FlowListTile.
- ✅ **[Extra]** Testes Unitários do DashboardCubit e TransactionsRepository.

---

### 🟡 DIA 3 — Extrato, Filtros e Recebíveis (EM ANDAMENTO)
- ✅ **Extrato de Transações**: Tela dedicada de Histórico (TransactionsPage) com agrupamento de datas.
- ✅ **Filtros de Extrato**: Painel inteligente (TransactionsFilterBottomSheet) integrado ao BLoC e Design System.
- ⏳ **Detalhe da Transação**: Timeline (criada → autorizada → liquidada) e dados completos via Modal ou Página Detaillhe.
- ⏳ **Paginação (Infinite Scroll)**: Scroll infinito na tela de Transações para grandes volumes de dados.
- ⏳ **Agenda de Recebíveis**: Timeline dia a dia dos próximos pagamentos (ReceivablesCubit).

---

### 🔴 DIA 4 — Cobranças, Perfil do Lojista e Polimento (PENDENTE)
Acabamento profissional, Empty States e controle de usuário.
- ⏳ **Geração de Cobranças (Links/QR)**: Criar nova cobrança com valor/descrição e compartilhar nativamente via SharePlus.
- ⏳ **Tela de Perfil Completa**: Dados da empresa, conta bancária, taxas aplicadas.
- ⏳ **Unhappy Paths Globais**: Padronização de telas vazias (Empty States) em todo o app.

---

### 🟡 DIA 5 — Qualidade, Documentação e Entrega (EM ANDAMENTO)
As bases dessa fase já foram adiantadas para garantir qualidade contínua.
- ✅ **Cobertura de Testes**: Agentic TDD já estabelecido nos blocos mais críticos (Auth e Dashboard).
- ✅ **CI/CD Integrado**: Github Actions rodando `flutter test` e `flutter analyze` em cada commit.
- ⏳ **README Profissional**: Documentação arquitetural "senior level" com arquitetura desenhada, justificativas, diagramas e prints de tela.
- ⏳ **Build Release**: Compilação final `APK/AAB` para demonstração.

---

> **Próximo Alvo Recomendado:** Construir o modal de **Detalhes da Transação**, onde o usuário poderá ver a linha do tempo exata de uma venda, e na sequência, plugar a **Paginação Infinita (Infinite Scroll)** na lista do Extrato.
