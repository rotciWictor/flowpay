/// FlowPay Spacing System (Tokens)
///
/// Grid baseado no ritmo clássico de 8pt, garantindo que o design
/// flua nativamente tanto no iOS (pt) quanto Android (dp).
abstract class FlowSpacing {
  // ===========================================================================
  // 1. SPACING (Margens, Paddings, Gaps)
  // ===========================================================================
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;

  // ===========================================================================
  // 2. BORDER RADIUS (Arredondamento de superfícies)
  // ===========================================================================
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusPill = 100.0; // Para botões pílula/arredondados
}
