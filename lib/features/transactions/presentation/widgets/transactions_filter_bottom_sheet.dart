import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/buttons/flow_button.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class TransactionsFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialFilter;
  
  const TransactionsFilterBottomSheet({super.key, this.initialFilter});

  @override
  State<TransactionsFilterBottomSheet> createState() => _TransactionsFilterBottomSheetState();
}

class _TransactionsFilterBottomSheetState extends State<TransactionsFilterBottomSheet> {
  String _selectedPeriod = 'all'; 
  String _selectedMovementType = 'all'; 
  List<String> _selectedStatuses = [];
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  TimeOfDay? _customStartTime;
  TimeOfDay? _customEndTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _selectedPeriod = widget.initialFilter!['period'] ?? 'all';
      _selectedMovementType = widget.initialFilter!['movementType'] ?? 'all';
      _selectedStatuses = List<String>.from(widget.initialFilter!['statuses'] ?? []);
      _customStartDate = widget.initialFilter!['customStartDate'];
      _customEndDate = widget.initialFilter!['customEndDate'];
      _customStartTime = widget.initialFilter!['customStartTime'];
      _customEndTime = widget.initialFilter!['customEndTime'];
      if (_selectedStatuses.isEmpty) {
        _selectedStatuses = ['all'];
      }
    } else {
      _selectedStatuses = ['all'];
    }
  }

  Widget _buildPickerTheme(Widget child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: FlowColors.primary,
          onPrimary: FlowColors.background,
          surface: FlowColors.surface,
          onSurface: FlowColors.textPrimary,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: FlowColors.background,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          headerBackgroundColor: FlowColors.surface,
          headerForegroundColor: FlowColors.textPrimary,
          rangePickerBackgroundColor: FlowColors.background,
          rangePickerHeaderBackgroundColor: FlowColors.surface,
          rangePickerShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          dividerColor: Colors.white.withValues(alpha: 0.05),
          rangeSelectionOverlayColor: WidgetStateProperty.all(FlowColors.primary.withValues(alpha: 0.15)),
          dayStyle: FlowTypography.bodyMedium,
          yearStyle: FlowTypography.bodyLarge,
          todayForegroundColor: WidgetStateProperty.resolveWith((states) => 
            states.contains(WidgetState.selected) ? FlowColors.background : FlowColors.primary
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: FlowColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          hourMinuteColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? FlowColors.primary.withValues(alpha: 0.15) : FlowColors.surface
          ),
          hourMinuteTextColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? FlowColors.primary : FlowColors.textPrimary
          ),
          dialBackgroundColor: FlowColors.surface,
          dialHandColor: FlowColors.primary,
          dialTextColor: WidgetStateColor.resolveWith((states) => 
            states.contains(WidgetState.selected) ? FlowColors.background : FlowColors.textPrimary
          ),
          entryModeIconColor: FlowColors.textSecondary,
          helpTextStyle: FlowTypography.labelMedium.copyWith(color: FlowColors.textSecondary),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: FlowColors.primary,
            textStyle: FlowTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      child: child,
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customStartDate != null && _customEndDate != null 
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!) 
          : null,
      builder: (context, child) {
        return _buildPickerTheme(child!);
      },
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedPeriod = 'custom';
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initialTime = isStart 
        ? (_customStartTime ?? const TimeOfDay(hour: 0, minute: 0))
        : (_customEndTime ?? const TimeOfDay(hour: 23, minute: 59));

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return _buildPickerTheme(child!);
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _customStartTime = picked;
        } else {
          _customEndTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final bool hasActiveFilters = _selectedPeriod != 'all' || 
        _selectedMovementType != 'all' || 
        !_selectedStatuses.contains('all') || _selectedStatuses.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: FlowColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: FlowColors.primary.withValues(alpha: 0.15), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: FlowSpacing.md,
        right: FlowSpacing.md,
        top: FlowSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + FlowSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FlowColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: FlowSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.filterTitle,
                style: FlowTypography.headlineSmall.copyWith(color: FlowColors.primary),
              ),
              if (hasActiveFilters)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPeriod = 'all';
                      _selectedMovementType = 'all';
                      _selectedStatuses = ['all'];
                    });
                  },
                  child: Text(
                    'Limpar tudo',
                    style: FlowTypography.labelMedium.copyWith(color: FlowColors.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FlowSpacing.xl),

          // 1. Tipo de Movimentação
          Text(l10n.filterTypeLabel, style: _sectionHeaderStyle()),
          const SizedBox(height: FlowSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChoiceChip(l10n.filterTypeAll, _selectedMovementType == 'all', () {
                  setState(() => _selectedMovementType = 'all');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterTypeSales, _selectedMovementType == 'sales', () {
                  setState(() => _selectedMovementType = 'sales');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterTypeBanking, _selectedMovementType == 'banking', () {
                  setState(() => _selectedMovementType = 'banking');
                }),
              ],
            ),
          ),
          const SizedBox(height: FlowSpacing.lg),

          // 2. Período
          Text(l10n.filterPeriodLabel, style: _sectionHeaderStyle()),
          const SizedBox(height: FlowSpacing.sm),
          Wrap(
            spacing: FlowSpacing.sm,
            runSpacing: FlowSpacing.sm,
            children: [
              _buildChoiceChip(l10n.filterPeriodAny, _selectedPeriod == 'all', () {
                setState(() => _selectedPeriod = 'all');
              }),
              _buildChoiceChip(l10n.filterPeriodToday, _selectedPeriod == 'today', () {
                setState(() => _selectedPeriod = 'today');
              }),
              _buildChoiceChip(l10n.filterPeriod7d, _selectedPeriod == '7d', () {
                setState(() => _selectedPeriod = '7d');
              }),
              _buildChoiceChip(l10n.filterPeriodCustom, _selectedPeriod == 'custom', () async {
                setState(() => _selectedPeriod = 'custom');
                if (_customStartDate == null) {
                  await _pickDateRange();
                }
              }),
            ],
          ),
          if (_selectedPeriod == 'custom') ...[
            const SizedBox(height: FlowSpacing.md),
            Container(
              padding: const EdgeInsets.all(FlowSpacing.md),
              decoration: BoxDecoration(
                color: FlowColors.surface,
                borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.date_range, color: FlowColors.primary, size: 16),
                          const SizedBox(width: FlowSpacing.sm),
                          Text('Período Selecionado', style: FlowTypography.labelMedium.copyWith(color: FlowColors.textSecondary)),
                        ],
                      ),
                      GestureDetector(
                        onTap: _pickDateRange,
                        child: Text('Alterar datas', style: FlowTypography.labelMedium.copyWith(color: FlowColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: FlowSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateCard('Início', _customStartDate, _customStartTime, true),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: FlowSpacing.sm),
                        child: Icon(Icons.arrow_forward, color: FlowColors.textTertiary, size: 16),
                      ),
                      Expanded(
                        child: _buildDateCard('Fim', _customEndDate, _customEndTime, false),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
          const SizedBox(height: FlowSpacing.lg),

          // 3. Status
          Text(l10n.filterStatusLabel, style: _sectionHeaderStyle()),
          const SizedBox(height: FlowSpacing.sm),
          Wrap(
            spacing: FlowSpacing.sm,
            runSpacing: FlowSpacing.sm,
            children: [
              _buildFilterChip('Todos', 'all'),
              _buildFilterChip(l10n.filterStatusApproved, 'approved'),
              _buildFilterChip(l10n.filterStatusPending, 'pending'),
              _buildFilterChip(l10n.filterStatusFailed, 'failed'),
              _buildFilterChip(l10n.filterStatusRefunded, 'refunded'),
            ],
          ),
          const SizedBox(height: FlowSpacing.xxl),

          // Botão com gradiente consistente com o app
          FlowButton(
            label: l10n.filterApplyBtn,
            onPressed: () {
              List<TransactionType>? types;
              if (_selectedMovementType == 'sales') types = [TransactionType.sale];
              if (_selectedMovementType == 'banking') {
                types = [TransactionType.transferOut, TransactionType.transferIn];
              }
              
              DateTime? start;
              DateTime? end;
              final now = DateTime.now();
              if (_selectedPeriod == 'today') {
                start = DateTime(now.year, now.month, now.day);
              } else if (_selectedPeriod == '7d') {
                start = now.subtract(const Duration(days: 7));
              } else if (_selectedPeriod == 'custom') {
                if (_customStartDate != null) {
                  start = DateTime(
                    _customStartDate!.year,
                    _customStartDate!.month,
                    _customStartDate!.day,
                    _customStartTime?.hour ?? 0,
                    _customStartTime?.minute ?? 0,
                  );
                }
                
                if (_customEndDate != null) {
                  end = DateTime(
                    _customEndDate!.year,
                    _customEndDate!.month,
                    _customEndDate!.day,
                    _customEndTime?.hour ?? 23,
                    _customEndTime?.minute ?? 59,
                    _customEndTime == null ? 59 : 0, 
                  );
                }
              }
              
              List<TransactionStatus> statuses = [];
              if (_selectedStatuses.contains('approved') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.approved);
              if (_selectedStatuses.contains('pending') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.pending);
              if (_selectedStatuses.contains('failed') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.declined);
              if (_selectedStatuses.contains('refunded') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.refunded);

              Navigator.pop(context, {
                'transactionTypes': types,
                'startDate': start,
                'endDate': end,
                'statuses': statuses,
                'uiFilterState': {
                  'period': _selectedPeriod,
                  'movementType': _selectedMovementType,
                  'statuses': _selectedStatuses,
                  'customStartDate': _customStartDate,
                  'customEndDate': _customEndDate,
                  'customStartTime': _customStartTime,
                  'customEndTime': _customEndTime,
                }
              });
            },
          ),
        ],
      ),
    );
  }

  TextStyle _sectionHeaderStyle() {
    return FlowTypography.labelLarge.copyWith(
      color: FlowColors.textSecondary,
    );
  }

  Widget _buildDateCard(String label, DateTime? date, TimeOfDay? time, bool isStart) {
    return Container(
      padding: const EdgeInsets.all(FlowSpacing.md),
      decoration: BoxDecoration(
        color: FlowColors.surfaceHighlight,
        borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FlowTypography.labelSmall.copyWith(color: FlowColors.textTertiary)),
          const SizedBox(height: FlowSpacing.xs),
          Text(
            _formatDate(date),
            style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: FlowSpacing.sm),
          GestureDetector(
            onTap: () => _pickTime(isStart: isStart),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.sm, vertical: 6),
              decoration: BoxDecoration(
                color: time != null ? FlowColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                border: Border.all(
                  color: time != null ? FlowColors.primary.withValues(alpha: 0.3) : FlowColors.textTertiary.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    time != null ? Icons.access_time_filled : Icons.access_time, 
                    size: 12, 
                    color: time != null ? FlowColors.primary : FlowColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time != null ? _formatTime(time) : 'Adicionar hora',
                    style: FlowTypography.labelSmall.copyWith(
                      color: time != null ? FlowColors.primary : FlowColors.textTertiary,
                      fontWeight: time != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => isStart ? _customStartTime = null : _customEndTime = null),
                      child: const Icon(Icons.close, size: 12, color: FlowColors.primary),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.lg, vertical: FlowSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.primary : FlowColors.surfaceVariant,
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primary : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.background : FlowColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _selectedStatuses.contains(key);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (key == 'all') {
            _selectedStatuses = ['all'];
          } else {
            _selectedStatuses.remove('all');
            if (isSelected) {
              _selectedStatuses.remove(key);
              if (_selectedStatuses.isEmpty) _selectedStatuses = ['all'];
            } else {
              _selectedStatuses.add(key);
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.lg, vertical: FlowSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.primary : FlowColors.surfaceVariant,
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primary : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.background : FlowColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
