import 'package:flutter/material.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  void _logout(BuildContext context) {
    // later: clear Firebase auth here
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Colors.white;
    final Color labelColor = Colors.grey.shade600;
    final Color valueColor = Colors.black87;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD 1: Name + Age/Gender + Avatar
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left side: name, age, gender
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Age 21 • Gender: M',
                            style: TextStyle(
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side: avatar
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.green.withOpacity(0.15),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // CARD 2: Phone + Location
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 13,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '9876543210',
                      style: TextStyle(
                        fontSize: 16,
                        color: valueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 13,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hubli, Karnataka',
                      style: TextStyle(
                        fontSize: 16,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // CARD 3 & 4: Height & Weight side by side
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    label: 'Height',
                    value: '175 cm',
                    cardColor: cardColor,
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Weight',
                    value: '68 kg',
                    cardColor: cardColor,
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // CARD 5: Medical Conditions
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical Conditions',
                      style: TextStyle(
                        fontSize: 13,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Diabetes, Thyroid',
                      style: TextStyle(
                        fontSize: 16,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // CARD 6 & 7: Goals & Diet side by side
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    label: 'Goals',
                    value: 'Weight Loss',
                    cardColor: cardColor,
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Diet',
                    value: 'Veg',
                    cardColor: cardColor,
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons: Edit Profile & Logout
            ElevatedButton(
              onPressed: () {
                // later: open edit profile
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(color: Colors.red.shade300),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable small card for Height, Weight, Goals, Diet
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color cardColor;
  final Color labelColor;
  final Color valueColor;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.cardColor,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
