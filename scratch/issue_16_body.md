A mecânica de geração do relatório PDF na nuvem via Supabase (Edge Function) está 100% funcional. No entanto, o visual gerado pelo `pdf-lib` atualmente é cru (raw text) e se assemelha a um log de sistema.

### Objetivo
Desenhar e implementar uma UI/UX **Premium** para o PDF exportado, alinhando com o Design System da FlowPay. O lojista (e o contador dele) devem receber um documento que transmita profissionalismo e clareza financeira.

### Requisitos Funcionais / Visuais
- [ ] **Cabeçalho Corporativo:** Inserir a logotipo oficial da FlowPay, Razão Social/Nome do Lojista, e Período do Relatório no topo.
- [ ] **Resumo Executivo:** Apresentar um sumário financeiro no início (Total Bruto, Taxas, Total Líquido) para que o lojista não precise somar as linhas.
- [ ] **Tabela Dinâmica:** Desenhar uma tabela (`drawRectangle` / `drawLine`) com colunas bem definidas (Data, Descrição, Forma de Pagamento, Valor).
- [ ] **Acessibilidade e Leitura:** Usar cores alternadas (Zebra striping) nas linhas da tabela para facilitar a leitura de relatórios longos, ou linhas divisórias finas e sutis.
- [ ] **Tipografia:** Garantir que fontes legíveis e com hierarquia de peso (Negrito para títulos e totais) sejam utilizadas.

### Tarefas
- Refatorar o algoritmo no `supabase/functions/generate-report/index.ts` que monta a página PDF.
- Ajustar margens e quebra de páginas (paginação) se a tabela ultrapassar o limite da folha A4.
