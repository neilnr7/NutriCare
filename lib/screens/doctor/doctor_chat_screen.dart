// lib/screens/doctor/chat/doctor_chat_screen.dart
import 'package:flutter/material.dart';
import 'doctor_chat_detail_screen.dart';

class DoctorChatScreen extends StatelessWidget {
  const DoctorChatScreen({super.key});

  // dummy chat threads
  final List<_Thread> _threads = const [
    _Thread(name: 'Ram', last: 'Thanks doctor!', time: 'Sep 3', isMale: true),
    _Thread(name: 'Akhilesh Joshi', last: '👍', time: 'Jun 11', isMale: true),
    _Thread(name: 'Anand Sagar', last: 'Oh ok thanks', time: 'Feb 9', isMale: true),
    _Thread(name: 'Manthan Kesti', last: 'Good afternoon', time: 'Oct 13, 2024', isMale: true),
    _Thread(name: 'Sara Patel', last: 'See you tomorrow', time: 'Mar 2', isMale: false),
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
          title: const Text('Messages', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700)),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _threads.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300, height: 0.5),
                itemBuilder: (context, index) {
                  final t = _threads[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, anim, secAnim) => FadeTransition(
                              opacity: anim,
                              child: DoctorChatDetailScreen(patientName: t.name),
                            ),
                            transitionsBuilder: (context, anim, secAnim, child) {
                              final offsetAnim = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
                              return SlideTransition(position: offsetAnim, child: child);
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: t.isMale ? Colors.blue.shade50 : Colors.pink.shade50,
                                  child: Icon(Icons.person, color: t.isMale ? Colors.blue : Colors.pink),
                                ),
                                // small online indicator mock
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
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
                                    style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    t.last,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.time,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const DoctorChatDetailScreen(patientName: 'New Patient'),
              ),
            );
          },
          backgroundColor: Colors.green.shade600,
          child: const Icon(Icons.create, color: Colors.white),
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
