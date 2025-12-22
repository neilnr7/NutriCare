import 'package:flutter/material.dart';
import 'models.dart';

class DoctorCalendarCard extends StatelessWidget {
  final DateTime focusedMonth;   // first day of month
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const DoctorCalendarCard({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    const monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final startOffset = firstDayOfMonth.weekday % 7; // sunday-first
    final startDate = firstDayOfMonth.subtract(Duration(days: startOffset));
    final days = List.generate(
      42,
          (index) => startDate.add(Duration(days: index)),
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // month / year + arrows
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    onMonthChanged(
                      DateTime(
                        focusedMonth.year,
                        focusedMonth.month - 1,
                        1,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '${monthNames[focusedMonth.month - 1]} ${focusedMonth.year}',
                        key: ValueKey(
                            '${focusedMonth.month}-${focusedMonth.year}'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    onMonthChanged(
                      DateTime(
                        focusedMonth.year,
                        focusedMonth.month + 1,
                        1,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // weekday labels
            Row(
              children: const [
                _WeekdayLabel('S', isSunday: true),
                _WeekdayLabel('M'),
                _WeekdayLabel('T'),
                _WeekdayLabel('W'),
                _WeekdayLabel('T'),
                _WeekdayLabel('F'),
                _WeekdayLabel('S'),
              ],
            ),
            const SizedBox(height: 8),

            // dates grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonth = date.month == focusedMonth.month;
                final isSelected = isSameDay(date, selectedDate);
                final isToday = isSameDay(date, DateTime.now());

                Color textColor;
                if (!isCurrentMonth) {
                  textColor = Colors.grey.shade400;
                } else if (date.weekday == DateTime.sunday) {
                  textColor = Colors.red;
                } else {
                  textColor = Colors.black87;
                }

                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday && !isSelected
                          ? Border.all(color: Colors.black54, width: 1)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  final bool isSunday;

  const _WeekdayLabel(this.text, {this.isSunday = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSunday ? Colors.red : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
