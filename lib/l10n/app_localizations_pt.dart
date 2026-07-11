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
  String get availableBalance => 'Saldo disponível';

  @override
  String get todaySales => 'Vendas de hoje';

  @override
  String get transactions => 'Transações';

  @override
  String get charges => 'Cobranças';

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
  String get bottomNavCharges => 'Cobrar';

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
  String get dashboardQuickActionPix => 'Cobrar via Pix';

  @override
  String get dashboardQuickActionLink => 'Link de Pag.';

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
  String get filterPeriodCustom => 'Customizado';

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
}
