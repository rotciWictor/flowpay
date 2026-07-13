import 'package:intl/intl.dart';

import 'package:flutter/widgets.dart';
import 'package:flowpay/l10n/app_localizations.dart';

/// Utility for formatting dates in Brazilian Portuguese.
class DateFormatter {
  /// "08 de jul. de 2026"
  static String formatFull(DateTime date) {
    return DateFormat("dd 'de' MMM. 'de' yyyy", 'pt_BR').format(date);
  }

  /// "08/07/2026"
  static String formatShort(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  /// "08 jul"
  static String formatDayMonth(DateTime date) {
    return DateFormat('dd MMM', 'pt_BR').format(date);
  }

  /// "14:30"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'pt_BR').format(date);
  }

  /// "08/07 às 14:30"
  static String formatDateTimeShort(DateTime date) {
    return '${DateFormat('dd/MM', 'pt_BR').format(date)} às ${DateFormat('HH:mm').format(date)}';
  }

  /// "Hoje", "Ontem", or formatted date
  static String formatRelative(DateTime date, {BuildContext? context}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return context != null ? AppLocalizations.of(context)!.dateToday : 'Hoje';
    if (dateOnly == today.subtract(const Duration(days: 1))) return context != null ? AppLocalizations.of(context)!.dateYesterday : 'Ontem';
    if (dateOnly == today.add(const Duration(days: 1))) return context != null ? AppLocalizations.of(context)!.dateTomorrow : 'Amanhã';

    return formatShort(date);
  }

  /// "Seg", "Ter", "Qua", etc.
  static String formatWeekdayShort(DateTime date) {
    return DateFormat('E', 'pt_BR').format(date);
  }
}
