# Changelog do FlowPay

Este documento registra as implementações do projeto em detalhes, explicando não apenas *o que* foi feito, mas o *porquê* das decisões arquiteturais e de design em cada etapa.

---

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
