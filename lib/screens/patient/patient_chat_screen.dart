// lib/screens/patient/chat/patient_chat_screen.dart
import 'package:flutter/material.dart';
import 'patient_chat_detail_screen.dart';

class PatientChatScreen extends StatelessWidget {
  const PatientChatScreen({super.key});

  // dummy chat thread (doctor)
  final List<_Thread> _threads = const [
    _Thread(
      name: 'Dr Jaimie Smith',
      last: 'Please follow the prescribed diet.',
      time: 'Today',
      isMale: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF5F6F8);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'Messages',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _threads.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade300, height: 0.5),
                itemBuilder: (context, index) {
                  final t = _threads[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                            const Duration(milliseconds: 300),
                            pageBuilder: (context, anim, secAnim) =>
                                FadeTransition(
                                  opacity: anim,
                                  child: PatientChatDetailScreen(
                                    doctorName: t.name,
                                  ),
                                ),
                            transitionsBuilder:
                                (context, anim, secAnim, child) {
                              final offsetAnim = Tween(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: anim,
                                  curve: Curves.easeOut,
                                ),
                              );
                              return SlideTransition(
                                position: offsetAnim,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 8),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.blue.shade50,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(
                                      right: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.name,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    t.last,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.time,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thread {
  final String name;
  final String last;
  final String time;
  final bool isMale;
  const _Thread({
    required this.name,
    required this.last,
    required this.time,
    required this.isMale,
  });
}
