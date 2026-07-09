import 'package:intl/intl.dart';

/// Utility for formatting monetary values in Brazilian Real (BRL).
///
/// All monetary values in the app are stored as [int] in centavos
/// (e.g., R$ 150,00 = 15000 centavos) to avoid floating-point issues.
class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final _compactFormatter = NumberFormat.compactCurrency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 1,
  );

  /// Formats centavos to "R$ 1.234,56"
  static String format(int centavos) {
    return _formatter.format(centavos / 100);
  }

  /// Formats centavos to compact form: "R$ 1,2 mil", "R$ 1,5 mi"
  static String formatCompact(int centavos) {
    return _compactFormatter.format(centavos / 100);
  }

  /// Formats centavos to plain number: "1.234,56" (no symbol)
  static String formatPlain(int centavos) {
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    return formatter.format(centavos / 100);
  }
}
