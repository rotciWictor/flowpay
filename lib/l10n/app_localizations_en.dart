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
  String dashboardGreeting(String name) {
    return 'Hello, $name';
  }

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
  String get dashboardQuickActionTransfer => 'Transfer';

  @override
  String get dashboardQuickActionMore => 'More';

  @override
  String get dashboardLatestTransactions => 'Latest Transactions';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get transactionsTitle => 'Statement';

  @override
  String get transactionsEmpty => 'No transactions found.';

  @override
  String get filterTitle => 'Filter Statement';

  @override
  String get filterTypeLabel => 'MOVEMENT TYPE';

  @override
  String get filterTypeAll => 'All';

  @override
  String get filterTypeSales => 'Sales';

  @override
  String get filterTypeBanking => 'Banking movements';

  @override
  String get filterPeriodLabel => 'PERIOD';

  @override
  String get filterPeriodAny => 'Any date';

  @override
  String get filterPeriodToday => 'Today';

  @override
  String get filterPeriod7d => 'Last 7 days';

  @override
  String get filterPeriodCustom => 'Custom';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String get filterStatusLabel => 'STATUS';

  @override
  String get filterStatusApproved => 'Approved';

  @override
  String get filterStatusPending => 'Pending';

  @override
  String get filterStatusFailed => 'Failed';

  @override
  String get filterStatusRefunded => 'Refunded';

  @override
  String get filterApplyBtn => 'Apply Filters';

  @override
  String get profileSectionMyAccount => 'My Account';

  @override
  String get profileBusinessData => 'Business Data';

  @override
  String get profileDocument => 'Document (Tax ID)';

  @override
  String get profileSecurity => 'Security and Password';

  @override
  String get profileSecurityDesc => 'Change password, 2FA';

  @override
  String get profileSectionFinancial => 'Financial';

  @override
  String get profileFeeTable => 'Fee Table';

  @override
  String get profileFeeTableDesc => 'Pix, Link, Boleto, Tap to Pay';

  @override
  String get profileBankAccount => 'Bank Account';

  @override
  String get profileBankAccountDesc => 'Data for receiving';

  @override
  String get profileTaxData => 'Tax Data';

  @override
  String get profileTaxDataDesc => 'Invoices and settings';

  @override
  String get profileSectionSettings => 'Settings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguagePt => 'Português (BR)';

  @override
  String get profileLanguageEn => 'English (US)';

  @override
  String get profileLanguageEs => 'Español (ES)';

  @override
  String get profilePushNotifications => 'Push Notifications';

  @override
  String get profilePushNotificationsDesc => 'Sales, receipts, alerts';

  @override
  String get profileBiometrics => 'Biometrics';

  @override
  String get profileBiometricsDesc => 'Unlock with fingerprint or face';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileAppearanceDesc => 'Dark theme';

  @override
  String get profileSectionSupport => 'Support';

  @override
  String get profileHelpCenter => 'Help Center';

  @override
  String get profileHelpCenterDesc => 'Frequently asked questions';

  @override
  String get profileContactUs => 'Contact Us';

  @override
  String get profileContactUsDesc => 'Chat or email';

  @override
  String get profileTermsPolicies => 'Terms and Policies';

  @override
  String get profileTermsPoliciesDesc => 'Terms of use and privacy';

  @override
  String get feeTableModalSubtitle => 'Values per approved transaction';

  @override
  String get feeTableCredit => 'Credit (Spot)';

  @override
  String get feeTableCreditDesc => '+1.50% per additional installment';

  @override
  String get feeTableDisclaimer => 'Rates valid for current plan';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get segmentFoodBeverage => 'Food and Beverage';

  @override
  String get segmentRetail => 'Retail';

  @override
  String get segmentServices => 'Services';

  @override
  String get segmentHealthBeauty => 'Health and Beauty';

  @override
  String get segmentTechnology => 'Technology';

  @override
  String get segmentOther => 'Other';

  @override
  String get chargesHowToSell => 'How do you want to sell today?';

  @override
  String get chargesPaymentLink => 'Payment Link';

  @override
  String get chargesPaymentLinkDesc => 'Fast remote sales';

  @override
  String get chargesTapToPay => 'Tap to Pay';

  @override
  String get chargesBoleto => 'Boleto';

  @override
  String get chargesSubscription => 'Subscription';

  @override
  String get chargesPendingSales => 'Pending Sales';

  @override
  String get chargesSeeAll => 'See all';

  @override
  String get dashboardChartTooltip => 'Tap the chart for details';

  @override
  String get dashboardQuickActionAnticipate => 'Anticipate';

  @override
  String get dashboardQuickActionPay => 'Pay';

  @override
  String get dashboardQuickActionLink => 'Create Link';

  @override
  String get transactionDetailsReceipt => 'Receipt';

  @override
  String get transactionDetailsNetValue => 'Net value';

  @override
  String get transactionListNetValue => 'Net';

  @override
  String get transactionDetailsRefundBtn => 'Refund';

  @override
  String get transactionDetailsDisputeBtn => 'Dispute';

  @override
  String get paymentMethodCredit => 'Credit';

  @override
  String get paymentMethodDebit => 'Debit';

  @override
  String get paymentMethodPix => 'Pix';

  @override
  String get paymentMethodBoleto => 'Boleto';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusDeclined => 'Declined';

  @override
  String get statusRefunded => 'Refunded';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusChargeback => 'Chargeback';
}
