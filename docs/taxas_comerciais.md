# Tabela de Taxas Comerciais (FlowPay)

Esta tabela define as taxas aplicadas sobre as transações de venda da plataforma, com base no método de pagamento, bandeira do cartão e número de parcelas. Essas regras estão refletidas no banco de dados (seed) e serão integradas à visualização do perfil do lojista no futuro.

## Pix
Para pagamentos e recebimentos via Pix (Transferências In/Out e Venda Pix), a taxa é **zerada** para contas pessoa física e repassada promocionalmente para lojistas na versão atual.
- **Taxa Pix:** `0.00%`

## Cartão de Débito
Taxa fixa por transação aprovada.
- **Visa / Mastercard:** `1.50%`
- **Elo / Outros:** `2.00%`
- **Amex:** `2.50%` *(raramente emitido no débito, mantido por consistência)*

## Cartão de Crédito (À Vista e Parcelado)
A taxa de crédito é composta por uma **Taxa Base** (aplicada à transação de 1 parcela) mais uma **Taxa Adicional de Parcelamento** de `1.50%` para cada parcela extra.

### Taxa Base (1x)
- **Visa / Mastercard:** `3.50%`
- **Elo / Outros:** `4.50%`
- **Amex:** `5.50%`

### Exemplo de Cálculo (Parcelado)
Fórmula: `Taxa Final = Taxa Base + ((Parcelas - 1) * 1.50%)`

**Simulação Visa/Mastercard:**
- 1x (À Vista): `3.50%`
- 2x: `3.50% + 1.50% = 5.00%`
- 6x: `3.50% + (5 * 1.50%) = 11.00%`
- 12x: `3.50% + (11 * 1.50%) = 20.00%`

**Simulação Elo:**
- 1x (À Vista): `4.50%`
- 2x: `4.50% + 1.50% = 6.00%`
- 12x: `4.50% + (11 * 1.50%) = 21.00%`

**Simulação Amex:**
- 1x (À Vista): `5.50%`
- 2x: `5.50% + 1.50% = 7.00%`
- 12x: `5.50% + (11 * 1.50%) = 22.00%`

## Casos Isentos (Estorno/Falha)
Transações com os seguintes status não possuem cobrança de taxa comercial (ou a taxa é revertida no caso de estorno completo):
- Recusada (`declined`)
- Estornada/Reembolsada (`refunded`)
- Contestada (`chargeback`)

*(Nota: Taxas de chargeback/disputa são cobradas separadamente do valor da transação e não compõem a `fee_amount` descrita no extrato).*
