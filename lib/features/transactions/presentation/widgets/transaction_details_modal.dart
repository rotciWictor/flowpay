import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flowpay/core/utils/date_formatter.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/buttons/flow_button.dart';
import 'dart:ui';

class TransactionDetailsModal extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailsModal({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          color: FlowColors.surface.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(FlowSpacing.radiusLg)),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: FlowSpacing.md),
                      _buildAmountHero(),
                      const SizedBox(height: FlowSpacing.lg),
                      _buildStatusTimeline(),
                      const SizedBox(height: FlowSpacing.lg),
                      _buildFinancialBreakdown(),
                      const SizedBox(height: FlowSpacing.lg),
                      _buildTechnicalDetails(context),
                      const SizedBox(height: FlowSpacing.xl),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FlowSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Detalhes da Transação',
            style: FlowTypography.titleMedium.copyWith(
              color: FlowColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: FlowColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountHero() {
    final amountColor = _getAmountColor();
    final isNegative = transaction.type == TransactionType.transferOut || 
                       transaction.status == TransactionStatus.refunded || 
                       transaction.status == TransactionStatus.chargeback;
    final sign = isNegative ? '-' : '+';

    IconData heroIcon;
    Color iconColor;

    // A cor do ícone deve respeitar primordialmente o Status (Pendente = Amarelo, Falhou = Cinza)
    if (transaction.status == TransactionStatus.declined) {
      iconColor = FlowColors.textSecondary;
    } else if (transaction.status == TransactionStatus.pending) {
      iconColor = FlowColors.warning;
    } else {
      if (transaction.type == TransactionType.transferOut || 
          transaction.status == TransactionStatus.refunded || 
          transaction.status == TransactionStatus.chargeback) {
        iconColor = FlowColors.error;
      } else if (transaction.type == TransactionType.transferIn) {
        iconColor = FlowColors.success;
      } else {
        iconColor = FlowColors.primary;
      }
    }

    if (transaction.type == TransactionType.transferOut) {
      heroIcon = Icons.arrow_outward;
    } else if (transaction.type == TransactionType.transferIn) {
      heroIcon = Icons.south_west;
    } else if (transaction.paymentMethod == PaymentMethod.pix) {
      heroIcon = Icons.pix;
    } else {
      heroIcon = Icons.credit_card;
    }

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            heroIcon,
            color: iconColor,
            size: 32,
          ),
        ),
        const SizedBox(height: FlowSpacing.md),
        Text(
          transaction.customerName ?? 'Cliente não identificado',
          style: FlowTypography.headlineSmall.copyWith(color: FlowColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: FlowSpacing.xs),
        Text(
          '$sign ${transaction.amount}',
          style: FlowTypography.moneyMedium.copyWith(
            color: amountColor,
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline() {
    final statusColor = _getStatusColor();
    
    return Container(
      padding: const EdgeInsets.all(FlowSpacing.md),
      decoration: BoxDecoration(
        color: FlowColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: FlowSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.status.displayName,
                  style: FlowTypography.titleSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormatter.formatFull(transaction.createdAt),
                  style: FlowTypography.bodySmall.copyWith(color: FlowColors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valores da Transação',
          style: FlowTypography.labelMedium.copyWith(color: FlowColors.textSecondary),
        ),
        const SizedBox(height: FlowSpacing.sm),
        Container(
          padding: const EdgeInsets.all(FlowSpacing.md),
          decoration: BoxDecoration(
            color: FlowColors.background.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildBreakdownRow('Valor Bruto', transaction.amount.toString(), FlowColors.textPrimary),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: FlowSpacing.sm),
                child: Divider(color: FlowColors.surfaceVariant, height: 1),
              ),
              _buildBreakdownRow('Taxa FlowPay', '- ${transaction.feeAmount}', FlowColors.error),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: FlowSpacing.sm),
                child: Divider(color: FlowColors.surfaceVariant, height: 1),
              ),
              _buildBreakdownRow(
                'Valor Líquido', 
                transaction.netAmount.toString(), 
                FlowColors.success, 
                isBold: true
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textSecondary),
        ),
        Text(
          value,
          style: FlowTypography.bodyMedium.copyWith(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dados Técnicos',
          style: FlowTypography.labelMedium.copyWith(color: FlowColors.textSecondary),
        ),
        const SizedBox(height: FlowSpacing.sm),
        Container(
          padding: const EdgeInsets.all(FlowSpacing.md),
          decoration: BoxDecoration(
            color: FlowColors.background.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildCopyableRow(context, 'ID da Transação', transaction.id),
              if (transaction.nsu != null) ...[
                const SizedBox(height: FlowSpacing.sm),
                _buildCopyableRow(context, 'NSU', transaction.nsu!),
              ],
              if (transaction.authorizationCode != null) ...[
                const SizedBox(height: FlowSpacing.sm),
                _buildCopyableRow(context, 'Autorização', transaction.authorizationCode!),
              ],
              if (transaction.status == TransactionStatus.declined && transaction.returnCode != null) ...[
                const SizedBox(height: FlowSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Motivo da Recusa', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary)),
                    Text(
                      _getReturnCodeDescription(transaction.returnCode),
                      style: FlowTypography.bodySmall.copyWith(color: FlowColors.error),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: FlowSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Operação', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary)),
                  Text(
                    transaction.type == TransactionType.sale 
                        ? 'Venda / Pagamento' 
                        : (transaction.type == TransactionType.transferIn ? 'Transferência Recebida' : 'Transferência Enviada'),
                    style: FlowTypography.bodySmall.copyWith(color: FlowColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: FlowSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Método', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary)),
                  Text(transaction.paymentMethod.displayName, style: FlowTypography.bodySmall.copyWith(color: FlowColors.textPrimary)),
                ],
              ),
              if (transaction.paymentMethod != PaymentMethod.pix) ...[
                const SizedBox(height: FlowSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bandeira', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary)),
                    Row(
                      children: [
                        if (transaction.cardBrand != null) ...[
                          _getCardBrandIcon(transaction.cardBrand!),
                          const SizedBox(width: FlowSpacing.xs),
                        ],
                        Text(transaction.cardBrand?.displayName ?? 'Não informada', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: FlowSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Parcelamento', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary)),
                    Text('${transaction.installments}x', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textPrimary)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary)),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label copiado!'),
                backgroundColor: FlowColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                value.length > 15 ? '${value.substring(0, 15)}...' : value,
                style: FlowTypography.bodySmall.copyWith(
                  color: FlowColors.primary,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: FlowSpacing.xs),
              const Icon(Icons.copy, size: 14, color: FlowColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final isNegative = transaction.type == TransactionType.transferOut || 
                       transaction.status == TransactionStatus.refunded || 
                       transaction.status == TransactionStatus.chargeback;

    return Container(
      padding: const EdgeInsets.all(FlowSpacing.lg),
      decoration: BoxDecoration(
        color: FlowColors.surface,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          FlowButton(
            label: 'Compartilhar Comprovante',
            onPressed: () {
              // TODO: Implementar geração de imagem e WhatsApp
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Em breve: Integração WhatsApp')),
              );
            },
            icon: Icons.share,
          ),
          if (transaction.paymentMethod == PaymentMethod.pix) ...[
            const SizedBox(height: FlowSpacing.md),
            FlowButton(
              label: isNegative ? 'Reportar Fraude / Contestar' : 'Realizar Estorno',
              onPressed: () {
                // TODO: Abrir fluxo do MED ou Estorno
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em breve: Fluxo de Atendimento')),
                );
              },
              variant: FlowButtonVariant.outline,
              textColor: isNegative ? FlowColors.error : FlowColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }

  Color _getAmountColor() {
    if (transaction.status == TransactionStatus.declined) return FlowColors.textSecondary;
    if (transaction.status == TransactionStatus.pending) return FlowColors.warning;
    if (transaction.type == TransactionType.transferOut || 
        transaction.status == TransactionStatus.refunded || 
        transaction.status == TransactionStatus.chargeback) {
      return FlowColors.error; 
    }
    return FlowColors.success;
  }

  Widget _getCardBrandIcon(CardBrand brand) {
    String assetName;
    switch (brand) {
      case CardBrand.visa:
        assetName = 'icons/visa.png';
        break;
      case CardBrand.mastercard:
        assetName = 'icons/mastercard.png';
        break;
      case CardBrand.elo:
        assetName = 'icons/elo.png';
        break;
      case CardBrand.amex:
        assetName = 'icons/amex.png';
        break;
    }
    return Image.asset(
      assetName,
      package: 'flutter_credit_card_brazilian',
      width: 24,
      height: 16,
      fit: BoxFit.contain,
    );
  }

  String _getReturnCodeDescription(String? code) {
    if (code == null) return 'Desconhecido';
    switch (code) {
      // Pix
      case 'AM04': return 'AM04 - Saldo insuficiente';
      case 'AM02': return 'AM02 - Limite excedido';
      case 'AC03': return 'AC03 - Conta inválida';
      case 'AC06': return 'AC06 - Conta bloqueada';
      case 'BE17': return 'BE17 - QR Code rejeitado';
      case 'FRAD': return 'FRAD - Suspeita de fraude';
      case 'AB03': return 'AB03 - Timeout no sistema';
      case 'AB09': return 'AB09 - Erro no banco recebedor';
      // ISO Cartões
      case '04': return '04 - Cartão bloqueado';
      case '05': return '05 - Não autorizada';
      case '14': return '14 - Cartão inválido';
      case '33': return '33 - Cartão vencido';
      case '41': return '41 - Cartão perdido';
      case '43': return '43 - Cartão roubado';
      case '51': return '51 - Saldo insuficiente';
      case '54': return '54 - Cartão expirado';
      case '57': return '57 - Não permitida';
      case '61': return '61 - Limite excedido';
      case '62': return '62 - Cartão restrito';
      case '12': return '12 - Transação inválida';
      case '91': return '91 - Falha na rede';
      
      default: return code;
    }
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case TransactionStatus.approved: return FlowColors.success;
      case TransactionStatus.pending: return FlowColors.warning;
      case TransactionStatus.declined: return FlowColors.textSecondary;
      case TransactionStatus.refunded:
      case TransactionStatus.chargeback: return FlowColors.error;
    }
  }
}
