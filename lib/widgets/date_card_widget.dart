import 'package:flutter/material.dart';

class DateCardWidget extends StatelessWidget {
  final DateTime date;
  final DateTime? selectedDate;
  final Function(DateTime) onSelected;

  const DateCardWidget({
    super.key,
    required this.date,
    required this.selectedDate,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<String> weekDays = [
      'LUN',
      'MAR',
      'MIE',
      'JUE',
      'VIE',
      'SAB',
      'DOM',
    ];
    final String weekDay = weekDays[date.weekday - 1];

    final bool isSelected =
        selectedDate?.day == date.day && selectedDate?.month == date.month;

    return GestureDetector(
      onTap: () => onSelected(date),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weekDay,
              style: TextStyle(
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${date.day}",
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
