// lib/screens/doctor/chat/doctor_chat_screen.dart
import 'package:flutter/material.dart';
import 'doctor_chat_detail_screen.dart';
import '../../../services/chat_service.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  late Future<List<_Thread>> _threadsFuture;

  @override
  void initState() {
    super.initState();
    _threadsFuture = _loadChats();
  }

  Future<List<_Thread>> _loadChats() async {
    final chats = await ChatService.getDoctorChats();

    return chats.map((c) {
      return _Thread(
        chatId: c['chatId'],
        name: c['patientName'] ?? 'Patient',
        last: (c['lastMessage'] == null || c['lastMessage'].toString().isEmpty)
            ? 'Start conversation'
            : c['lastMessage'],
        time: _formatTime(c['updatedAt']),
        isMale: true, // UI-only, backend doesn’t store gender here
      );
    }).toList();
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(
          timestamp['_seconds'] * 1000);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return '';
    }
  }

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
              child: FutureBuilder<List<_Thread>>(
                future: _threadsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No conversations yet"));
                  }

                  final threads = snapshot.data!;

                  return ListView.separated(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    itemCount: threads.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.grey.shade300, height: 0.5),
                    itemBuilder: (context, index) {
                      final t = threads[index];

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
                                      child: DoctorChatDetailScreen(
                                        chatId: t.chatId,
                                        patientName: t.name,
                                      ),
                                    ),
                                transitionsBuilder:
                                    (context, anim, secAnim, child) {
                                  final offsetAnim = Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                      .animate(CurvedAnimation(
                                      parent: anim,
                                      curve: Curves.easeOut));
                                  return SlideTransition(
                                      position: offsetAnim, child: child);
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
                                      backgroundColor: t.isMale
                                          ? Colors.blue.shade50
                                          : Colors.pink.shade50,
                                      child: Icon(Icons.person,
                                          color: t.isMale
                                              ? Colors.blue
                                              : Colors.pink),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                            fontSize: 14),
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
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
  final String chatId;
  final String name;
  final String last;
  final String time;
  final bool isMale;

  const _Thread({
    required this.chatId,
    required this.name,
    required this.last,
    required this.time,
    required this.isMale,
  });
}
