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
}
