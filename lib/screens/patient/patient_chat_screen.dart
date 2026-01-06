// lib/screens/patient/chat/patient_chat_screen.dart
import 'package:flutter/material.dart';
import 'patient_chat_detail_screen.dart';
import '../../../services/chat_service.dart';
import '../../../services/doctor_service.dart';
import '../../../services/api_auth_storage.dart';

class PatientChatScreen extends StatefulWidget {
  const PatientChatScreen({super.key});

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  late Future<List<_Thread>> _threadsFuture;
  late Future<List<_Doctor>> _doctorsFuture; // ✅ FIX: never nullable

  @override
  void initState() {
    super.initState();
    _threadsFuture = _loadChats();
    _doctorsFuture = _loadDoctors(); // ✅ FIX: initialize early
  }

  // --------------------------------------------------
  Future<List<_Thread>> _loadChats() async {
    final chats = await ChatService.getPatientChats();

    return chats.map((c) {
      return _Thread(
        chatId: c['chatId'],
        name: c['doctorName'] ?? 'Doctor',
        last: (c['lastMessage'] == null || c['lastMessage'].toString().isEmpty)
            ? 'Start conversation'
            : c['lastMessage'],
        time: _formatTime(c['updatedAt']),
        isMale: true,
      );
    }).toList();
  }

  // --------------------------------------------------
  Future<List<_Doctor>> _loadDoctors() async {
    final res = await DoctorService.getDoctors();

    if (res["success"] != true) return [];

    return (res["doctors"] as List)
        .map((d) => _Doctor(id: d["uid"], name: d["name"]))
        .toList();
  }

  // --------------------------------------------------
  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final date =
      DateTime.fromMillisecondsSinceEpoch(timestamp['_seconds'] * 1000);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return '';
    }
  }

  // --------------------------------------------------
  Future<void> _startChat(_Doctor doctor) async {
    try {
      final patientId = await ApiAuthStorage.getUid();
      if (patientId == null) {
        debugPrint("❌ patientId is null");
        return;
      }

      debugPrint("➡️ Calling createOrGetChat");
      final chatId = await ChatService.createOrGetChat(
        doctorId: doctor.id,
        patientId: patientId,
      );

      debugPrint("✅ Received chatId: $chatId");

      if (!mounted) return;

      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (_) => PatientChatDetailScreen(
            chatId: chatId,
            doctorName: doctor.name,
          ),
        ),
      )
          .then((_) {
        // ✅ refresh chat list when coming back
        setState(() {
          _threadsFuture = _loadChats();
        });
      });
    } catch (e) {
      debugPrint("❌ _startChat failed: $e");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to start chat")),
      );
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
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  // =========================
                  // 🔵 EMPTY STATE → SHOW DOCTORS
                  // =========================
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return FutureBuilder<List<_Doctor>>(
                      future: _doctorsFuture,
                      builder: (context, dSnap) {
                        if (dSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final doctors = dSnap.data ?? [];

                        if (doctors.isEmpty) {
                          return const Center(
                              child: Text("No doctors available"));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          itemCount: doctors.length,
                          separatorBuilder: (_, __) => Divider(
                              color: Colors.grey.shade300,
                              height: 0.5),
                          itemBuilder: (context, index) {
                            final d = doctors[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                Colors.blue.shade50,
                                child: const Icon(Icons.person,
                                    color: Colors.blue),
                              ),
                              title: Text(
                                d.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () => _startChat(d),
                            );
                          },
                        );
                      },
                    );
                  }

                  // =========================
                  // 🟢 NORMAL CHAT LIST
                  // =========================
                  final threads = snapshot.data!;

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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
                              MaterialPageRoute(
                                builder: (_) => PatientChatDetailScreen(
                                  chatId: t.chatId,
                                  doctorName: t.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                  Colors.blue.shade50,
                                  child: const Icon(Icons.person,
                                      color: Colors.blue),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        t.last,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(t.time),
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

// =====================
// INTERNAL MODELS
// =====================
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

class _Doctor {
  final String id;
  final String name;
  const _Doctor({required this.id, required this.name});
}
