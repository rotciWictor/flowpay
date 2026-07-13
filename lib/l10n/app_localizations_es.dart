// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'FlowPay';

  @override
  String get dashboardTitle => 'Panel de Ventas';

  @override
  String dashboardGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get availableBalance => 'Saldo disponible';

  @override
  String get todaySales => 'Ventas de hoy';

  @override
  String get transactions => 'Transacciones';

  @override
  String get charges => 'Cobrar';

  @override
  String get profile => 'Perfil';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get loginEmailLabel => 'Correo';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginGoogleButton => 'Entrar con Google';

  @override
  String get loginRegisterPrompt => '¿No tienes una cuenta? Regístrate';

  @override
  String get registerTitle => 'Crear Cuenta';

  @override
  String get registerComingSoonTitle => 'Flujo de Registro en Construcción';

  @override
  String get registerComingSoonDesc =>
      'Aquí tendremos un formulario paso a paso para recopilar datos del comerciante.';

  @override
  String get profileLogout => 'Salir';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get profileComingSoon => 'Próximamente: Ajustes del Comerciante';

  @override
  String get bottomNavHome => 'Inicio';

  @override
  String get bottomNavTransactions => 'Transacciones';

  @override
  String get bottomNavCharges => 'Cobrar';

  @override
  String get bottomNavProfile => 'Perfil';

  @override
  String get dashboardErrorTitle => 'Uy, algo salió mal';

  @override
  String get dashboardTryAgain => 'Intentar de nuevo';

  @override
  String get dashboardWeeklySales => 'Ventas Semanales';

  @override
  String get dashboardNextSettlement => 'A recibir próx. día hábil';

  @override
  String get dashboardQuickActionPix => 'Cobrar vía Pix';

  @override
  String get dashboardQuickActionTransfer => 'Transferir';

  @override
  String get dashboardQuickActionMore => 'Más';

  @override
  String get dashboardLatestTransactions => 'Últimas Transacciones';

  @override
  String get dashboardSeeAll => 'Ver todas';

  @override
  String get transactionsTitle => 'Extracto';

  @override
  String get transactionsEmpty => 'No se encontraron transacciones.';

  @override
  String get filterTitle => 'Filtrar Extracto';

  @override
  String get filterTypeLabel => 'TIPO DE MOVIMIENTO';

  @override
  String get filterTypeAll => 'Todas';

  @override
  String get filterTypeSales => 'Ventas';

  @override
  String get filterTypeBanking => 'Movimientos bancarios';

  @override
  String get filterPeriodLabel => 'PERÍODO';

  @override
  String get filterPeriodAny => 'Cualquier fecha';

  @override
  String get filterPeriodToday => 'Hoy';

  @override
  String get filterPeriod7d => 'Últimos 7 días';

  @override
  String get filterPeriodCustom => 'Personalizado';

  @override
  String get dateToday => 'Hoy';

  @override
  String get dateYesterday => 'Ayer';

  @override
  String get dateTomorrow => 'Mañana';

  @override
  String get filterStatusLabel => 'ESTADO';

  @override
  String get filterStatusApproved => 'Aprobada';

  @override
  String get filterStatusPending => 'Pendiente';

  @override
  String get filterStatusFailed => 'Fallida';

  @override
  String get filterStatusRefunded => 'Reembolsada';

  @override
  String get filterApplyBtn => 'Aplicar Filtros';

  @override
  String get profileSectionMyAccount => 'Mi Cuenta';

  @override
  String get profileBusinessData => 'Datos del Negocio';

  @override
  String get profileDocument => 'Documento';

  @override
  String get profileSecurity => 'Seguridad y Contraseña';

  @override
  String get profileSecurityDesc => 'Cambiar contraseña, 2FA';

  @override
  String get profileSectionFinancial => 'Financiero';

  @override
  String get profileFeeTable => 'Tabla de Tasas';

  @override
  String get profileFeeTableDesc => 'Pix, Link, Boleto, Tap to Pay';

  @override
  String get profileBankAccount => 'Cuenta Bancaria';

  @override
  String get profileBankAccountDesc => 'Datos para recibir';

  @override
  String get profileTaxData => 'Datos Fiscales';

  @override
  String get profileTaxDataDesc => 'Facturas y ajustes';

  @override
  String get profileSectionSettings => 'Ajustes';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguagePt => 'Português (BR)';

  @override
  String get profileLanguageEn => 'English (US)';

  @override
  String get profileLanguageEs => 'Español (ES)';

  @override
  String get profilePushNotifications => 'Notificaciones Push';

  @override
  String get profilePushNotificationsDesc => 'Ventas, recibos, alertas';

  @override
  String get profileBiometrics => 'Biometría';

  @override
  String get profileBiometricsDesc => 'Desbloqueo con huella o rostro';

  @override
  String get profileAppearance => 'Apariencia';

  @override
  String get profileAppearanceDesc => 'Tema oscuro';

  @override
  String get profileSectionSupport => 'Soporte';

  @override
  String get profileHelpCenter => 'Centro de Ayuda';

  @override
  String get profileHelpCenterDesc => 'Preguntas frecuentes';

  @override
  String get profileContactUs => 'Contáctanos';

  @override
  String get profileContactUsDesc => 'Chat o correo';

  @override
  String get profileTermsPolicies => 'Términos y Políticas';

  @override
  String get profileTermsPoliciesDesc => 'Términos de uso y privacidad';

  @override
  String get feeTableModalSubtitle => 'Valores por transacción aprobada';

  @override
  String get feeTableCredit => 'Crédito al Contado';

  @override
  String get feeTableCreditDesc => '+1.50% por cuota adicional';

  @override
  String get feeTableDisclaimer => 'Tasas válidas para el plan actual';

  @override
  String get comingSoon => '¡Próximamente!';

  @override
  String get segmentFoodBeverage => 'Alimentos y Bebidas';

  @override
  String get segmentRetail => 'Venta al por menor';

  @override
  String get segmentServices => 'Servicios';

  @override
  String get segmentHealthBeauty => 'Salud y Belleza';

  @override
  String get segmentTechnology => 'Tecnología';

  @override
  String get segmentOther => 'Otros';

  @override
  String get chargesHowToSell => '¿Cómo quieres vender hoy?';

  @override
  String get chargesPaymentLink => 'Enlace de Pago';

  @override
  String get chargesPaymentLinkDesc => 'Venta a distancia rápida';

  @override
  String get chargesTapToPay => 'Tap to Pay';

  @override
  String get chargesBoleto => 'Boleto';

  @override
  String get chargesSubscription => 'Suscripción';

  @override
  String get chargesPendingSales => 'Ventas Pendientes';

  @override
  String get chargesSeeAll => 'Ver todas';

  @override
  String get dashboardChartTooltip => 'Toca el gráfico para más detalles';

  @override
  String get dashboardQuickActionAnticipate => 'Adelantar';

  @override
  String get dashboardQuickActionPay => 'Pagar';

  @override
  String get dashboardQuickActionLink => 'Crear Enlace';

  @override
  String get transactionDetailsReceipt => 'Comprobante';

  @override
  String get transactionDetailsNetValue => 'Valor neto';

  @override
  String get transactionListNetValue => 'Neto';

  @override
  String get transactionDetailsRefundBtn => 'Reembolsar';

  @override
  String get transactionDetailsDisputeBtn => 'Contestación';

  @override
  String get paymentMethodCredit => 'Crédito';

  @override
  String get paymentMethodDebit => 'Débito';

  @override
  String get paymentMethodPix => 'Pix';

  @override
  String get paymentMethodBoleto => 'Boleto';

  @override
  String get statusApproved => 'Aprobada';

  @override
  String get statusDeclined => 'Rechazada';

  @override
  String get statusRefunded => 'Reembolsada';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusChargeback => 'Contestación';
}
