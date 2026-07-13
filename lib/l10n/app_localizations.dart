import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('es'),
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

  /// No description provided for @dashboardGreeting.
  ///
  /// In pt, this message translates to:
  /// **'Olá, {name}'**
  String dashboardGreeting(String name);

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
  /// **'Personalizado'**
  String get filterPeriodCustom;

  /// No description provided for @dateToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get dateYesterday;

  /// No description provided for @dateTomorrow.
  ///
  /// In pt, this message translates to:
  /// **'Amanhã'**
  String get dateTomorrow;

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

  /// No description provided for @profileSectionMyAccount.
  ///
  /// In pt, this message translates to:
  /// **'Minha Conta'**
  String get profileSectionMyAccount;

  /// No description provided for @profileBusinessData.
  ///
  /// In pt, this message translates to:
  /// **'Dados do Negócio'**
  String get profileBusinessData;

  /// No description provided for @profileDocument.
  ///
  /// In pt, this message translates to:
  /// **'Documento (CNPJ)'**
  String get profileDocument;

  /// No description provided for @profileSecurity.
  ///
  /// In pt, this message translates to:
  /// **'Segurança e Senha'**
  String get profileSecurity;

  /// No description provided for @profileSecurityDesc.
  ///
  /// In pt, this message translates to:
  /// **'Alterar senha, 2FA'**
  String get profileSecurityDesc;

  /// No description provided for @profileSectionFinancial.
  ///
  /// In pt, this message translates to:
  /// **'Financeiro'**
  String get profileSectionFinancial;

  /// No description provided for @profileFeeTable.
  ///
  /// In pt, this message translates to:
  /// **'Tabela de Taxas'**
  String get profileFeeTable;

  /// No description provided for @profileFeeTableDesc.
  ///
  /// In pt, this message translates to:
  /// **'Pix, Link, Boleto, Tap to Pay'**
  String get profileFeeTableDesc;

  /// No description provided for @profileBankAccount.
  ///
  /// In pt, this message translates to:
  /// **'Conta Bancária'**
  String get profileBankAccount;

  /// No description provided for @profileBankAccountDesc.
  ///
  /// In pt, this message translates to:
  /// **'Dados para recebimento'**
  String get profileBankAccountDesc;

  /// No description provided for @profileTaxData.
  ///
  /// In pt, this message translates to:
  /// **'Dados Fiscais'**
  String get profileTaxData;

  /// No description provided for @profileTaxDataDesc.
  ///
  /// In pt, this message translates to:
  /// **'Nota fiscal e configuração'**
  String get profileTaxDataDesc;

  /// No description provided for @profileSectionSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get profileSectionSettings;

  /// No description provided for @profileLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get profileLanguage;

  /// No description provided for @profileLanguagePt.
  ///
  /// In pt, this message translates to:
  /// **'Português (BR)'**
  String get profileLanguagePt;

  /// No description provided for @profileLanguageEn.
  ///
  /// In pt, this message translates to:
  /// **'English (US)'**
  String get profileLanguageEn;

  /// No description provided for @profileLanguageEs.
  ///
  /// In pt, this message translates to:
  /// **'Español (ES)'**
  String get profileLanguageEs;

  /// No description provided for @profilePushNotifications.
  ///
  /// In pt, this message translates to:
  /// **'Notificações Push'**
  String get profilePushNotifications;

  /// No description provided for @profilePushNotificationsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Vendas, recebimentos, alertas'**
  String get profilePushNotificationsDesc;

  /// No description provided for @profileBiometrics.
  ///
  /// In pt, this message translates to:
  /// **'Biometria'**
  String get profileBiometrics;

  /// No description provided for @profileBiometricsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Desbloqueio com digital ou face'**
  String get profileBiometricsDesc;

  /// No description provided for @profileAppearance.
  ///
  /// In pt, this message translates to:
  /// **'Aparência'**
  String get profileAppearance;

  /// No description provided for @profileAppearanceDesc.
  ///
  /// In pt, this message translates to:
  /// **'Tema escuro'**
  String get profileAppearanceDesc;

  /// No description provided for @profileSectionSupport.
  ///
  /// In pt, this message translates to:
  /// **'Suporte'**
  String get profileSectionSupport;

  /// No description provided for @profileHelpCenter.
  ///
  /// In pt, this message translates to:
  /// **'Central de Ajuda'**
  String get profileHelpCenter;

  /// No description provided for @profileHelpCenterDesc.
  ///
  /// In pt, this message translates to:
  /// **'Dúvidas frequentes'**
  String get profileHelpCenterDesc;

  /// No description provided for @profileContactUs.
  ///
  /// In pt, this message translates to:
  /// **'Fale Conosco'**
  String get profileContactUs;

  /// No description provided for @profileContactUsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Chat ou e-mail'**
  String get profileContactUsDesc;

  /// No description provided for @profileTermsPolicies.
  ///
  /// In pt, this message translates to:
  /// **'Termos e Políticas'**
  String get profileTermsPolicies;

  /// No description provided for @profileTermsPoliciesDesc.
  ///
  /// In pt, this message translates to:
  /// **'Termos de uso e privacidade'**
  String get profileTermsPoliciesDesc;

  /// No description provided for @feeTableModalSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Valores por transação aprovada'**
  String get feeTableModalSubtitle;

  /// No description provided for @feeTableCredit.
  ///
  /// In pt, this message translates to:
  /// **'Crédito à Vista'**
  String get feeTableCredit;

  /// No description provided for @feeTableCreditDesc.
  ///
  /// In pt, this message translates to:
  /// **'+1,50% por parcela adicional'**
  String get feeTableCreditDesc;

  /// No description provided for @feeTableDisclaimer.
  ///
  /// In pt, this message translates to:
  /// **'Taxas válidas para o plano atual'**
  String get feeTableDisclaimer;

  /// No description provided for @comingSoon.
  ///
  /// In pt, this message translates to:
  /// **'Em breve!'**
  String get comingSoon;

  /// No description provided for @segmentFoodBeverage.
  ///
  /// In pt, this message translates to:
  /// **'Alimentação e Bebidas'**
  String get segmentFoodBeverage;

  /// No description provided for @segmentRetail.
  ///
  /// In pt, this message translates to:
  /// **'Varejo'**
  String get segmentRetail;

  /// No description provided for @segmentServices.
  ///
  /// In pt, this message translates to:
  /// **'Serviços'**
  String get segmentServices;

  /// No description provided for @segmentHealthBeauty.
  ///
  /// In pt, this message translates to:
  /// **'Saúde e Beleza'**
  String get segmentHealthBeauty;

  /// No description provided for @segmentTechnology.
  ///
  /// In pt, this message translates to:
  /// **'Tecnologia'**
  String get segmentTechnology;

  /// No description provided for @segmentOther.
  ///
  /// In pt, this message translates to:
  /// **'Outros'**
  String get segmentOther;

  /// No description provided for @chargesHowToSell.
  ///
  /// In pt, this message translates to:
  /// **'Como você quer vender hoje?'**
  String get chargesHowToSell;

  /// No description provided for @chargesPaymentLink.
  ///
  /// In pt, this message translates to:
  /// **'Link de Pagamento'**
  String get chargesPaymentLink;

  /// No description provided for @chargesPaymentLinkDesc.
  ///
  /// In pt, this message translates to:
  /// **'Venda a distância rápido'**
  String get chargesPaymentLinkDesc;

  /// No description provided for @chargesTapToPay.
  ///
  /// In pt, this message translates to:
  /// **'Tap to Pay'**
  String get chargesTapToPay;

  /// No description provided for @chargesBoleto.
  ///
  /// In pt, this message translates to:
  /// **'Boleto'**
  String get chargesBoleto;

  /// No description provided for @chargesSubscription.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura'**
  String get chargesSubscription;

  /// No description provided for @chargesPendingSales.
  ///
  /// In pt, this message translates to:
  /// **'Vendas Pendentes'**
  String get chargesPendingSales;

  /// No description provided for @chargesSeeAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver todas'**
  String get chargesSeeAll;

  /// No description provided for @dashboardChartTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Toque no gráfico para detalhes'**
  String get dashboardChartTooltip;

  /// No description provided for @dashboardQuickActionAnticipate.
  ///
  /// In pt, this message translates to:
  /// **'Antecipar'**
  String get dashboardQuickActionAnticipate;

  /// No description provided for @dashboardQuickActionPay.
  ///
  /// In pt, this message translates to:
  /// **'Pagar'**
  String get dashboardQuickActionPay;

  /// No description provided for @dashboardQuickActionLink.
  ///
  /// In pt, this message translates to:
  /// **'Criar Link'**
  String get dashboardQuickActionLink;

  /// No description provided for @transactionDetailsReceipt.
  ///
  /// In pt, this message translates to:
  /// **'Comprovante'**
  String get transactionDetailsReceipt;

  /// No description provided for @transactionDetailsNetValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor líquido'**
  String get transactionDetailsNetValue;

  /// No description provided for @transactionListNetValue.
  ///
  /// In pt, this message translates to:
  /// **'Líquido'**
  String get transactionListNetValue;

  /// No description provided for @transactionDetailsRefundBtn.
  ///
  /// In pt, this message translates to:
  /// **'Estornar'**
  String get transactionDetailsRefundBtn;

  /// No description provided for @transactionDetailsDisputeBtn.
  ///
  /// In pt, this message translates to:
  /// **'Contestar / Fraude'**
  String get transactionDetailsDisputeBtn;

  /// No description provided for @paymentMethodCredit.
  ///
  /// In pt, this message translates to:
  /// **'Crédito'**
  String get paymentMethodCredit;

  /// No description provided for @paymentMethodDebit.
  ///
  /// In pt, this message translates to:
  /// **'Débito'**
  String get paymentMethodDebit;

  /// No description provided for @paymentMethodPix.
  ///
  /// In pt, this message translates to:
  /// **'Pix'**
  String get paymentMethodPix;

  /// No description provided for @paymentMethodBoleto.
  ///
  /// In pt, this message translates to:
  /// **'Boleto'**
  String get paymentMethodBoleto;

  /// No description provided for @statusApproved.
  ///
  /// In pt, this message translates to:
  /// **'Aprovada'**
  String get statusApproved;

  /// No description provided for @statusDeclined.
  ///
  /// In pt, this message translates to:
  /// **'Recusada'**
  String get statusDeclined;

  /// No description provided for @statusRefunded.
  ///
  /// In pt, this message translates to:
  /// **'Reembolsada'**
  String get statusRefunded;

  /// No description provided for @statusPending.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get statusPending;

  /// No description provided for @statusChargeback.
  ///
  /// In pt, this message translates to:
  /// **'Contestação'**
  String get statusChargeback;
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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
