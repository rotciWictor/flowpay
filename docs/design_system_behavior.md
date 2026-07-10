# Design System: Behavior & The Feel (Comportamento e Sensação)

Quando falamos de um Design System moderno para aplicativos móveis (como o FlowPay), a consistência visual (cores, tipografia, espaçamento) é apenas a ponta do iceberg. O que realmente separa um aplicativo "bom" de um aplicativo "premium" é o **Comportamento (Behavior)** e a **Sensação (Feel)**.

## O que é o "Feel"?

O *Feel* é como o aplicativo responde ao toque do usuário. É a soma de estados interativos, animações, feedback tátil (haptics) e fluidez. Se a interface parece morta, rígida ou lenta, o usuário perde a confiança — especialmente em um aplicativo financeiro.

---

## 1. Gestos e Interações (Touch & Gestures)

Aplicativos móveis não têm mouse. Eles dependem de dedos, que são imprecisos. O comportamento do Design System deve ditar:

- **Touch Targets (Áreas de Toque):** O tamanho mínimo de qualquer elemento clicável deve ser de `44x44pt` (iOS) ou `48x48dp` (Android), mesmo que o ícone visual seja menor.
- **Swipe & Pull:** Ações naturais como "Pull to Refresh" em listas de transações ou "Swipe to Delete/Action" em itens de lista.
- **Scroll Bouncing:** O comportamento elástico ao chegar no fim de uma lista (Overscroll).

> [!TIP]
> **Gestos Naturais:** Sempre permita que os modais e *bottom sheets* sejam dispensados com um deslize para baixo (swipe down) em vez de obrigar o usuário a caçar um botão "X".

## 2. Estados Interativos (Interactive States)

No celular, não existe estado de `hover` (passar o mouse). Portanto, os estados de interação precisam ser óbvios no momento do toque.

- **Default (Padrão):** O estado de repouso do componente.
- **Pressed / Active (Pressionado):** O botão ou card deve responder instantaneamente ao toque. No FlowPay, usamos o *Ripple Effect* ou um leve *Scale Down* (encolhimento do botão em 5%) para dar peso tátil à ação.
- **Disabled (Desabilitado):** Opacidade reduzida (geralmente 30% a 50%) e desativação semântica para leitores de tela. NUNCA use `grey-out` se a cor original for importante para a compreensão.
- **Loading (Carregando):** Feedback imediato. Em vez de travar o app, mostre um *Skeleton Loading* nas listas ou um *Spinner* dentro do próprio botão clicado.

## 3. Motion & Micro-interações (Animação)

Animações não são apenas "enfeites". Elas direcionam o olhar do usuário e explicam o que aconteceu.

- **Duração:** Micro-interações (ex: favoritar, ligar um switch) devem durar entre `150ms` e `250ms`. Transições de tela (ex: abrir uma nova página) entre `300ms` e `400ms`.
- **Easing (Curvas de Animação):** Nada na natureza se move de forma linear (`linear`). Use:
  - `Ease-Out`: Para elementos entrando na tela (começa rápido e freia suavemente).
  - `Ease-In`: Para elementos saindo da tela (começa devagar e acelera até sumir).
- **Esforço Cognitivo:** O movimento deve explicar o fluxo. Se um modal de sucesso aparece, ele deve vir de baixo para cima.

## 4. Feedback Tátil (Haptics)

O celular é o único dispositivo que "conversa" fisicamente com o usuário. O motor vibratório (Taptic Engine) deve ser mapeado no Design System:

- **Light Impact:** Para ações comuns (ligar um switch, marcar um checkbox).
- **Medium Impact:** Para ações de confirmação primárias (ex: "Transação Aprovada").
- **Heavy / Error Impact:** Padrão duplo de vibração para alertar sobre erros (ex: "Senha Inválida") sem precisar ler o modal.

## 5. Comportamento Nativo (Platform Respect)

Um Design System móvel precisa respeitar as diferenças entre iOS e Android.

- **Navegação:** No iOS, o usuário volta deslizando a borda esquerda. No Android, ele pode usar o botão de voltar do sistema. O aplicativo precisa estar preparado para ambos.
- **Tipografia:** San Francisco (iOS) e Roboto (Android) têm pesos diferentes. No FlowPay, optamos pela fonte unificada `Outfit` para forçar a identidade da marca em ambas as plataformas.

---

> [!IMPORTANT]
> **Resumo Tático para o FlowPay:**
> 1. Todo botão deve reagir visualmente quando tocado (`Pressed State`).
> 2. Transações e saldos devem carregar com `Shimmer/Skeleton` e não telas brancas.
> 3. Haptics (vibração leve) serão injetados ao concluir uma cobrança ou transação com sucesso.
