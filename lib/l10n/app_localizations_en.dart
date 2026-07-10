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

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginGoogleButton => 'Sign in with Google';

  @override
  String get loginRegisterPrompt => 'Don\'t have an account? Sign up';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerComingSoonTitle => 'Registration Flow under construction';

  @override
  String get registerComingSoonDesc =>
      'Here we will have a stepper form to collect the merchant data (Tax ID, Legal Name, etc).';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileComingSoon => 'Coming soon: Merchant Settings';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavTransactions => 'Transactions';

  @override
  String get bottomNavCharges => 'Charge';

  @override
  String get bottomNavProfile => 'Profile';

  @override
  String get dashboardErrorTitle => 'Oops, something went wrong';

  @override
  String get dashboardTryAgain => 'Try Again';

  @override
  String get dashboardWeeklySales => 'Weekly Sales';

  @override
  String get dashboardNextSettlement => 'Next Settlement';

  @override
  String get dashboardQuickActionPix => 'Receive via Pix';

  @override
  String get dashboardQuickActionLink => 'Pay. Link';

  @override
  String get dashboardQuickActionTransfer => 'Transfer';

  @override
  String get dashboardQuickActionMore => 'More';

  @override
  String get dashboardLatestTransactions => 'Latest Transactions';

  @override
  String get dashboardSeeAll => 'See all';
}
