import 'package:flutter/material.dart';

class DietTimeSlot extends StatelessWidget {
  final String label; // e.g. "6–9 AM"
  final TextEditingController controller;
  final bool editable;

  // ✅ NEW
  final bool completed;
  final ValueChanged<bool>? onStatusChanged;

  const DietTimeSlot({
    super.key,
    required this.label,
    required this.controller,
    required this.editable,
    this.completed = false,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header row (label + checkbox)
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              // ✅ Checkbox for BOTH
              Checkbox(
                value: completed,
                onChanged: editable
                    ? null // 👨‍⚕️ doctor → view only
                    : (val) {
                  if (val != null && onStatusChanged != null) {
                    onStatusChanged!(val);
                  }
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🔹 Editable / Read-only field
          editable
              ? TextField(
            controller: controller,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Enter diet details",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          )
              : Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              controller.text.isEmpty
                  ? "No diet specified"
                  : controller.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
