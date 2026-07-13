// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'FlowPay';

  @override
  String get dashboardTitle => 'Painel de Vendas';

  @override
  String dashboardGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get availableBalance => 'Saldo disponível';

  @override
  String get todaySales => 'Vendas de hoje';

  @override
  String get transactions => 'Transações';

  @override
  String get charges => 'Vender';

  @override
  String get profile => 'Perfil';

  @override
  String get loginTitle => 'Acessar Conta';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginGoogleButton => 'Entrar com Google';

  @override
  String get loginRegisterPrompt => 'Não tem uma conta? Cadastre-se';

  @override
  String get registerTitle => 'Criar Conta';

  @override
  String get registerComingSoonTitle => 'Fluxo de Cadastro em Construção';

  @override
  String get registerComingSoonDesc =>
      'Aqui teremos um formulário passo-a-passo (Stepper) para coletar os dados do lojista (CNPJ, Razão Social, etc).';

  @override
  String get profileLogout => 'Sair';

  @override
  String get profileTitle => 'Meu Perfil';

  @override
  String get profileComingSoon => 'Em breve: Configurações do Lojista';

  @override
  String get bottomNavHome => 'Início';

  @override
  String get bottomNavTransactions => 'Transações';

  @override
  String get bottomNavCharges => 'Vender';

  @override
  String get bottomNavProfile => 'Perfil';

  @override
  String get dashboardErrorTitle => 'Ops, algo deu errado';

  @override
  String get dashboardTryAgain => 'Tentar Novamente';

  @override
  String get dashboardWeeklySales => 'Vendas da Semana';

  @override
  String get dashboardNextSettlement => 'A receber próx. dia útil';

  @override
  String get dashboardQuickActionPix => 'Vender via Pix';

  @override
  String get dashboardQuickActionTransfer => 'Transferir';

  @override
  String get dashboardQuickActionMore => 'Mais';

  @override
  String get dashboardLatestTransactions => 'Últimas Transações';

  @override
  String get dashboardSeeAll => 'Ver todas';

  @override
  String get transactionsTitle => 'Extrato';

  @override
  String get transactionsEmpty => 'Nenhuma transação encontrada.';

  @override
  String get filterTitle => 'Filtrar Extrato';

  @override
  String get filterTypeLabel => 'TIPO DE MOVIMENTAÇÃO';

  @override
  String get filterTypeAll => 'Todas';

  @override
  String get filterTypeSales => 'Vendas';

  @override
  String get filterTypeBanking => 'Movimentações da conta';

  @override
  String get filterPeriodLabel => 'PERÍODO';

  @override
  String get filterPeriodAny => 'Qualquer data';

  @override
  String get filterPeriodToday => 'Hoje';

  @override
  String get filterPeriod7d => 'Últimos 7 dias';

  @override
  String get filterPeriodCustom => 'Personalizado';

  @override
  String get dateToday => 'Hoje';

  @override
  String get dateYesterday => 'Ontem';

  @override
  String get dateTomorrow => 'Amanhã';

  @override
  String get filterStatusLabel => 'STATUS';

  @override
  String get filterStatusApproved => 'Aprovada';

  @override
  String get filterStatusPending => 'Pendente';

  @override
  String get filterStatusFailed => 'Falha';

  @override
  String get filterStatusRefunded => 'Reembolsada';

  @override
  String get filterApplyBtn => 'Aplicar Filtros';

  @override
  String get profileSectionMyAccount => 'Minha Conta';

  @override
  String get profileBusinessData => 'Dados do Negócio';

  @override
  String get profileDocument => 'Documento (CNPJ)';

  @override
  String get profileSecurity => 'Segurança e Senha';

  @override
  String get profileSecurityDesc => 'Alterar senha, 2FA';

  @override
  String get profileSectionFinancial => 'Financeiro';

  @override
  String get profileFeeTable => 'Tabela de Taxas';

  @override
  String get profileFeeTableDesc => 'Pix, Link, Boleto, Tap to Pay';

  @override
  String get profileBankAccount => 'Conta Bancária';

  @override
  String get profileBankAccountDesc => 'Dados para recebimento';

  @override
  String get profileTaxData => 'Dados Fiscais';

  @override
  String get profileTaxDataDesc => 'Nota fiscal e configuração';

  @override
  String get profileSectionSettings => 'Configurações';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguagePt => 'Português (BR)';

  @override
  String get profileLanguageEn => 'English (US)';

  @override
  String get profileLanguageEs => 'Español (ES)';

  @override
  String get profilePushNotifications => 'Notificações Push';

  @override
  String get profilePushNotificationsDesc => 'Vendas, recebimentos, alertas';

  @override
  String get profileBiometrics => 'Biometria';

  @override
  String get profileBiometricsDesc => 'Desbloqueio com digital ou face';

  @override
  String get profileAppearance => 'Aparência';

  @override
  String get profileAppearanceDesc => 'Tema escuro';

  @override
  String get profileSectionSupport => 'Suporte';

  @override
  String get profileHelpCenter => 'Central de Ajuda';

  @override
  String get profileHelpCenterDesc => 'Dúvidas frequentes';

  @override
  String get profileContactUs => 'Fale Conosco';

  @override
  String get profileContactUsDesc => 'Chat ou e-mail';

  @override
  String get profileTermsPolicies => 'Termos e Políticas';

  @override
  String get profileTermsPoliciesDesc => 'Termos de uso e privacidade';

  @override
  String get feeTableModalSubtitle => 'Valores por transação aprovada';

  @override
  String get feeTableCredit => 'Crédito à Vista';

  @override
  String get feeTableCreditDesc => '+1,50% por parcela adicional';

  @override
  String get feeTableDisclaimer => 'Taxas válidas para o plano atual';

  @override
  String get comingSoon => 'Em breve!';

  @override
  String get segmentFoodBeverage => 'Alimentação e Bebidas';

  @override
  String get segmentRetail => 'Varejo';

  @override
  String get segmentServices => 'Serviços';

  @override
  String get segmentHealthBeauty => 'Saúde e Beleza';

  @override
  String get segmentTechnology => 'Tecnologia';

  @override
  String get segmentOther => 'Outros';

  @override
  String get chargesHowToSell => 'Como você quer vender hoje?';

  @override
  String get chargesPaymentLink => 'Link de Pagamento';

  @override
  String get chargesPaymentLinkDesc => 'Venda a distância rápido';

  @override
  String get chargesTapToPay => 'Tap to Pay';

  @override
  String get chargesBoleto => 'Boleto';

  @override
  String get chargesSubscription => 'Assinatura';

  @override
  String get chargesPendingSales => 'Vendas Pendentes';

  @override
  String get chargesSeeAll => 'Ver todas';

  @override
  String get dashboardChartTooltip => 'Toque no gráfico para detalhes';

  @override
  String get dashboardQuickActionAnticipate => 'Antecipar';

  @override
  String get dashboardQuickActionPay => 'Pagar';

  @override
  String get dashboardQuickActionLink => 'Criar Link';

  @override
  String get transactionDetailsReceipt => 'Comprovante';

  @override
  String get transactionDetailsNetValue => 'Valor líquido';

  @override
  String get transactionListNetValue => 'Líquido';

  @override
  String get transactionDetailsRefundBtn => 'Estornar';

  @override
  String get transactionDetailsDisputeBtn => 'Contestar / Fraude';

  @override
  String get paymentMethodCredit => 'Crédito';

  @override
  String get paymentMethodDebit => 'Débito';

  @override
  String get paymentMethodPix => 'Pix';

  @override
  String get paymentMethodBoleto => 'Boleto';

  @override
  String get statusApproved => 'Aprovada';

  @override
  String get statusDeclined => 'Recusada';

  @override
  String get statusRefunded => 'Reembolsada';

  @override
  String get statusPending => 'Pendente';

  @override
  String get statusChargeback => 'Contestação';
}
