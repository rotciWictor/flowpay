// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FlowPay';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get availableBalance => 'Available balance';

  @override
  String get todaySales => 'Today\'s sales';

  @override
  String get transactions => 'Transactions';

  @override
  String get charges => 'Charges';

  @override
  String get profile => 'Profile';
}
