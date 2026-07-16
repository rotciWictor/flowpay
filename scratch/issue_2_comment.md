### Resolução Arquitetural: Pivot do Motor de Relatórios

Esta issue tratava da performance e mecânica de geração de relatórios em PDF. Abaixo está o detalhamento das decisões tomadas e do caminho percorrido até a solução final.

#### 1. Ponto de Partida e Tentativas Iniciais
- **Geração Local (Flutter):** A ideia inicial era gerar o PDF inteiramente no front-end e salvar no dispositivo usando pacotes como `path_provider` e `open_filex`.
  - *Problema:* Lidar com permissões de armazenamento granulares no Android 13/14 (Scoped Storage) e iOS é custoso e propenso a falhas (crashes de permissão).
- **Mock de E-mail Assíncrono:** Tentamos usar a Edge Function do Supabase para formatar os dados e disparar um e-mail com anexo via Resend API.
  - *Problema:* Quebra a UX (experiência do usuário). O lojista clica em "Exportar" e fica esperando algo acontecer na tela, mas o e-mail demora ou cai no spam. Precisávamos de uma resposta *imediata*.

#### 2. O Pivot (Inspirado no ecossistema FlutterFlow)
Decidimos centralizar o motor de renderização 100% na Nuvem, mas com entrega nativa e instantânea no app:
- A **Supabase Edge Function** (`generate-report`) recebe os filtros, busca os dados no PostgreSQL, e usa a biblioteca `pdf-lib` para desenhar o PDF em memória (bypassando as limitações da V8 Engine no Deno).
- O binário gerado é upado para um bucket privado (`reports`) no Supabase Storage.
- A função gera e devolve para o Flutter uma **Signed URL** válida por 1 hora.

#### 3. Ponto de Chegada (O App)
O Flutter foi enxugado. Ele apenas recebe a URL assinada e delega para o sistema operacional usando o pacote oficial `url_launcher`.
- **O Hack do Android (Google Docs Viewer):** Descobrimos um edge case severo onde emuladores Android (e alguns aparelhos limpos) exibiam uma "Tela Preta" ao abrir URLs de PDF, pois não possuíam leitor de PDF nativo instalado.
- **A Solução Final:** Adicionamos um fallback arquitetural. Antes de disparar o `url_launcher`, o app envelopa o link do Supabase com a API pública do Google Docs (`https://docs.google.com/gview?embedded=true&url=...`). Isso força qualquer aparelho (com ou sem leitor de PDF) a renderizar o relatório instantaneamente como um canvas HTML dentro do navegador.

#### 4. Correções Adicionais
- Corrigido um crash (`popped the last page`) no `go_router` causado por *race conditions* entre o fechamento do BottomSheet e a abertura do Dialog de carregamento.
- Removido o uso restritivo do `canLaunchUrl` que sofria bloqueios silenciosos do Android 11+ devido a políticas de *Package Visibility* (`<queries>`).

A mecânica está 100% funcional, segura e sem overhead no dispositivo do usuário.
