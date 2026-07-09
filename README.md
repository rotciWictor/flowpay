# FlowPay

O FlowPay é um aplicativo de portfólio desenvolvido em Flutter, criado para demonstrar as melhores práticas de engenharia de software para o mercado de pagamentos e fintechs (subadquirentes/gateways).

O objetivo deste projeto é simular o painel (dashboard) de um lojista/merchant, com arquitetura robusta, código escalável e design moderno.

## 🚀 Arquitetura e Padrões
- **Clean Architecture:** Separação estrita em camadas (Domain, Data, Presentation) com injeção de dependências (Dependency Inversion).
- **BLoC Pattern (flutter_bloc):** Gerenciamento de estado previsível e testável.
- **Princípios SOLID:** Responsabilidade única, aberto/fechado e substituição de Liskov aplicados rigorosamente.
- **Backend Real com Supabase:** Autenticação real e banco de dados PostgreSQL com Row Level Security (RLS) garantindo que cada merchant veja apenas os próprios dados.
- **Tratamento de Erros Funcional (dartz):** Uso do padrão `Either` para garantir que exceções de infraestrutura nunca cheguem à UI sem tratamento.
- **Internacionalização (i18n):** Estrutura preparada para múltiplos idiomas (padrão em PT-BR).

## 🛠️ Tecnologias
- **Flutter & Dart** (Versões mais recentes)
- **Supabase** (Auth & Database)
- **get_it** (Injeção de dependências)
- **freezed & json_serializable** (Code generation e imutabilidade)
- **go_router** (Navegação declarativa)
- **fl_chart** (Gráficos de vendas)

---
*Este aplicativo foi desenhado focando em densidade de dados e confiança, os pilares da UX para produtos financeiros B2B.*
