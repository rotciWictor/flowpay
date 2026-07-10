import 'package:money2/money2.dart';

final Currency brlCurrency = Currency.create(
  'BRL',
  2,
  symbol: r'R$',
  pattern: 'S #,##0.00',
  decimalSeparator: ',',
  groupSeparator: '.',
);
