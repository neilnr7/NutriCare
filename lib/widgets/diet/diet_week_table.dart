import 'package:flutter/material.dart';
import 'diet_time_slot.dart';
import '../../services/diet_service.dart';

class DietWeekTable extends StatefulWidget {
  final bool editable; // true = doctor, false = patient

  const DietWeekTable({
    super.key,
    required this.editable,
  });

  @override
  State<DietWeekTable> createState() => DietWeekTableState();
}

class DietWeekTableState extends State<DietWeekTable> {
  final List<String> _days = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  // ✅ MUST MATCH BACKEND EXACTLY
  final List<String> _slots = const [
    "6–9 AM",
    "9–12 PM",
    "12–3 PM",
    "3–6 PM",
    "6–9 PM",
    "9–12 AM",
  ];

  late final Map<String, List<TextEditingController>> _controllers;

  // ✅ NEW: completion tracking
  late final Map<String, List<bool>> _completed;

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (final day in _days)
        day: List.generate(
          _slots.length,
              (_) => TextEditingController(),
        )
    };

    _completed = {
      for (final day in _days)
        day: List.generate(
          _slots.length,
              (_) => false,
        )
    };
  }

  /// ✅ FOR BACKEND SAVE (diet text only – unchanged)
  Map<String, Map<String, String>> getWeeklyDiet() {
    return {
      for (final day in _days)
        day: {
          for (int i = 0; i < _slots.length; i++)
            _slots[i]: _controllers[day]![i].text,
        }
    };
  }

  /// ✅ FOR BACKEND LOAD (diet text only – unchanged)
  void setWeeklyDiet(Map<String, dynamic> weeklyDiet) {
    for (final day in _days) {
      if (!weeklyDiet.containsKey(day)) continue;

      for (int i = 0; i < _slots.length; i++) {
        _controllers[day]![i].text =
            weeklyDiet[day][_slots[i]] ?? "";
      }
    }

    setState(() {});
  }

  /// ✅ NEW: expose completion status (for later backend use)
  Map<String, Map<String, bool>> getCompletionStatus() {
    return {
      for (final day in _days)
        day: {
          for (int i = 0; i < _slots.length; i++)
            _slots[i]: _completed[day]![i],
        }
    };
  }

  /// ✅ LOAD COMPLETION STATUS FROM BACKEND
  void setCompletionStatus(Map<String, dynamic> weeklyStatus) {
    for (final day in _days) {
      if (!weeklyStatus.containsKey(day)) continue;

      for (int i = 0; i < _slots.length; i++) {
        _completed[day]![i] =
            weeklyStatus[day][_slots[i]] ?? false;
      }
    }

    setState(() {});
  }


  @override
  void dispose() {
    for (final list in _controllers.values) {
      for (final c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _days.length,
      itemBuilder: (context, index) {
        final day = _days[index];
        final controllers = _controllers[day]!;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              for (int i = 0; i < _slots.length; i++)
                DietTimeSlot(
                  label: _slots[i],
                  controller: controllers[i],
                  editable: widget.editable,
                  completed: _completed[day]![i],
                  onStatusChanged: widget.editable
                      ? null
                      : (val) async {
                    setState(() {
                      _completed[day]![i] = val;
                    });

                    await DietService.updateDietStatus(
                      day: day,
                      slot: _slots[i],
                      completed: val,
                    );
                  },

                ),
            ],
          ),
        );
      },
    );
  }
}
