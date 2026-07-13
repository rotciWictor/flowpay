import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// Nome do aplicativo
  ///
  /// In pt, this message translates to:
  /// **'FlowPay'**
  String get appName;

  /// No description provided for @dashboardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Painel de Vendas'**
  String get dashboardTitle;

  /// No description provided for @availableBalance.
  ///
  /// In pt, this message translates to:
  /// **'Saldo disponível'**
  String get availableBalance;

  /// No description provided for @todaySales.
  ///
  /// In pt, this message translates to:
  /// **'Vendas de hoje'**
  String get todaySales;

  /// No description provided for @transactions.
  ///
  /// In pt, this message translates to:
  /// **'Transações'**
  String get transactions;

  /// No description provided for @charges.
  ///
  /// In pt, this message translates to:
  /// **'Vender'**
  String get charges;

  /// No description provided for @profile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acessar Conta'**
  String get loginTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @loginGoogleButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com Google'**
  String get loginGoogleButton;

  /// No description provided for @loginRegisterPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta? Cadastre-se'**
  String get loginRegisterPrompt;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get registerTitle;

  /// No description provided for @registerComingSoonTitle.
  ///
  /// In pt, this message translates to:
  /// **'Fluxo de Cadastro em Construção'**
  String get registerComingSoonTitle;

  /// No description provided for @registerComingSoonDesc.
  ///
  /// In pt, this message translates to:
  /// **'Aqui teremos um formulário passo-a-passo (Stepper) para coletar os dados do lojista (CNPJ, Razão Social, etc).'**
  String get registerComingSoonDesc;

  /// No description provided for @profileLogout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get profileLogout;

  /// No description provided for @profileTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meu Perfil'**
  String get profileTitle;

  /// No description provided for @profileComingSoon.
  ///
  /// In pt, this message translates to:
  /// **'Em breve: Configurações do Lojista'**
  String get profileComingSoon;

  /// No description provided for @bottomNavHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get bottomNavHome;

  /// No description provided for @bottomNavTransactions.
  ///
  /// In pt, this message translates to:
  /// **'Transações'**
  String get bottomNavTransactions;

  /// No description provided for @bottomNavCharges.
  ///
  /// In pt, this message translates to:
  /// **'Vender'**
  String get bottomNavCharges;

  /// No description provided for @bottomNavProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get bottomNavProfile;

  /// No description provided for @dashboardErrorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ops, algo deu errado'**
  String get dashboardErrorTitle;

  /// No description provided for @dashboardTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar Novamente'**
  String get dashboardTryAgain;

  /// No description provided for @dashboardWeeklySales.
  ///
  /// In pt, this message translates to:
  /// **'Vendas da Semana'**
  String get dashboardWeeklySales;

  /// No description provided for @dashboardNextSettlement.
  ///
  /// In pt, this message translates to:
  /// **'A receber próx. dia útil'**
  String get dashboardNextSettlement;

  /// No description provided for @dashboardQuickActionPix.
  ///
  /// In pt, this message translates to:
  /// **'Vender via Pix'**
  String get dashboardQuickActionPix;

  /// No description provided for @dashboardQuickActionLink.
  ///
  /// In pt, this message translates to:
  /// **'Link de Pag.'**
  String get dashboardQuickActionLink;

  /// No description provided for @dashboardQuickActionTransfer.
  ///
  /// In pt, this message translates to:
  /// **'Transferir'**
  String get dashboardQuickActionTransfer;

  /// No description provided for @dashboardQuickActionMore.
  ///
  /// In pt, this message translates to:
  /// **'Mais'**
  String get dashboardQuickActionMore;

  /// No description provided for @dashboardLatestTransactions.
  ///
  /// In pt, this message translates to:
  /// **'Últimas Transações'**
  String get dashboardLatestTransactions;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver todas'**
  String get dashboardSeeAll;

  /// No description provided for @transactionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Extrato'**
  String get transactionsTitle;

  /// No description provided for @transactionsEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma transação encontrada.'**
  String get transactionsEmpty;

  /// No description provided for @filterTitle.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar Extrato'**
  String get filterTitle;

  /// No description provided for @filterTypeLabel.
  ///
  /// In pt, this message translates to:
  /// **'TIPO DE MOVIMENTAÇÃO'**
  String get filterTypeLabel;

  /// No description provided for @filterTypeAll.
  ///
  /// In pt, this message translates to:
  /// **'Todas'**
  String get filterTypeAll;

  /// No description provided for @filterTypeSales.
  ///
  /// In pt, this message translates to:
  /// **'Vendas'**
  String get filterTypeSales;

  /// No description provided for @filterTypeBanking.
  ///
  /// In pt, this message translates to:
  /// **'Movimentações da conta'**
  String get filterTypeBanking;

  /// No description provided for @filterPeriodLabel.
  ///
  /// In pt, this message translates to:
  /// **'PERÍODO'**
  String get filterPeriodLabel;

  /// No description provided for @filterPeriodAny.
  ///
  /// In pt, this message translates to:
  /// **'Qualquer data'**
  String get filterPeriodAny;

  /// No description provided for @filterPeriodToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get filterPeriodToday;

  /// No description provided for @filterPeriod7d.
  ///
  /// In pt, this message translates to:
  /// **'Últimos 7 dias'**
  String get filterPeriod7d;

  /// No description provided for @filterPeriodCustom.
  ///
  /// In pt, this message translates to:
  /// **'Customizado'**
  String get filterPeriodCustom;

  /// No description provided for @filterStatusLabel.
  ///
  /// In pt, this message translates to:
  /// **'STATUS'**
  String get filterStatusLabel;

  /// No description provided for @filterStatusApproved.
  ///
  /// In pt, this message translates to:
  /// **'Aprovada'**
  String get filterStatusApproved;

  /// No description provided for @filterStatusPending.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get filterStatusPending;

  /// No description provided for @filterStatusFailed.
  ///
  /// In pt, this message translates to:
  /// **'Falha'**
  String get filterStatusFailed;

  /// No description provided for @filterStatusRefunded.
  ///
  /// In pt, this message translates to:
  /// **'Reembolsada'**
  String get filterStatusRefunded;

  /// No description provided for @filterApplyBtn.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar Filtros'**
  String get filterApplyBtn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
