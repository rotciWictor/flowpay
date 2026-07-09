# Plano do Design System Consolidado: FlowPay

## 🌌 1. O Conceito Central: Dark Glass Fintech
O FlowPay será um app escuro, elegante e focado em legibilidade financeira, utilizando o efeito de vidro fosco estrategicamente para criar hierarquia visual e sensação premium, sem comprometer a taxa de quadros (FPS) nas listas de rolagem.

## 🎨 2. Paleta de Cores & Efeitos (Tokens)
Tabela de aplicação das cores originais adaptadas para o efeito Glass:

| Elemento                | Token Original             | Aplicação no Glassmorphism                                                                |
| :------------------------| :---------------------------| :------------------------------------------------------------------------------------------|
| **Fundo (Scaffold)**    | `#0F1117` (Background)     | Sólido, mas com "orbs" (círculos esfumaçados) em `#6C5CE7` a 15% de opacidade nos cantos. |
| **Superfície de Vidro** | `#1A1D27` (Surface)        | Fundo a 60% de opacidade + BackdropFilter (Blur 10px) + Borda Branca a 10%.               |
| **Superfície Sólida**   | `#242836` (SurfaceVariant) | Usado para cards de listas infinitas (sem blur) e inputs de texto.                        |
| **Ação Principal**      | `#6C5CE7` (Primary)        | Botões preenchidos, botões flutuantes (FAB) e indicadores de abas ativas.                 |
| **Ação Secundária**     | `#A29BFE` (PrimaryLight)   | Textos de destaque, links clicáveis ou detalhes em gráficos.                              |
| **Status Positivo**     | `#00B894` (Success)        | Badges de status "Aprovado" e valores de entrada (+).                                     |
| **Status Negativo**     | `#FF6B6B` (Error)          | Badges de "Recusado/Chargeback" e valores de saída (-).                                   |
| **Texto Primário**      | `#F5F6FA` (TextPrimary)    | Títulos, valores monetários ($) e labels de alto contraste.                               |
| **Texto Secundário**    | `#8B8FA3` (TextSecondary)  | Subtítulos, datas, NSU, horários e textos de apoio.                                       |

## 🔤 3. Tipografia (Inter)
A fonte Inter (via google_fonts) será a espinha dorsal da legibilidade:
- **Títulos e Destaques (H1, H2):** Peso SemiBold (600), cor primária ou texto primário.
- **Valores Monetários (Saldos, Transações):** Peso Bold (700) com recurso Tabular Figures (faz com que todos os números tenham a mesma largura, alinhando perfeitamente em listas de transações).
- **Corpo de Texto (Body):** Peso Regular (400), cor secundária para não cansar a vista.

## 🧩 4. Catálogo de Componentes Base
Como a UI será construída modularizando as coisas no Flutter, esta regra de aplicação será mantida:

### A. O "Glass Card" (Destaques)
- **Onde usar:** Card de "Saldo Disponível", Simulador de Recebíveis, Modal (Bottom Sheet) de detalhes da transação e a Bottom Navigation Bar flutuante.
- **Estrutura:** `ClipRRect` (para não vazar o blur) -> `BackdropFilter` -> `Container` com cor translúcida e borda iluminada.

### B. O "Solid Card" (Desempenho)
- **Onde usar:** Itens da lista de transactions e receivables (ListTiles).
- **Por quê:** Uma lista com 50+ itens fazendo cálculos de desfoque em tempo real vai travar o scroll. Use o `#242836` sólido com BorderRadius leve (8px a 12px). A distinção entre o vidro no topo e o sólido rolando por baixo cria um efeito de profundidade incrível.

### C. Botões e Ações
- **Primary Button:** Sólido na cor `#6C5CE7`, sem bordas, cantos arredondados (Radius 12px), com feedback de clique (InkWell).
- **Glass Button (Ícones/Atalhos):** Botões redondos no topo (como o atalho de perfil ou QR Code) usando a mesma lógica do Glass Card, para se integrarem ao fundo de forma transparente.

## 🚀 5. Resumo da Implementação Técnica
- Criar um arquivo central de tema (ex: `app_theme.dart` ou `design_tokens.dart`) para isolar essas configurações do resto da camada de Presentation.
- Toda vez que for chamado um `GlassContainer` (transformado em um Widget reutilizável no core), será garantido que a tela fale exatamente a mesma língua visual, mantendo tudo limpo e respeitando a arquitetura definida.

O plano está fechado e extremamente alinhado com o que há de mais moderno em design de produtos financeiros. Mãos à obra nesses próximos 5 dias para dar vida ao FlowPay!
