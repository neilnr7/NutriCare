// lib/screens/doctor/chat/doctor_chat_detail_screen.dart
import 'package:flutter/material.dart';

class DoctorChatDetailScreen extends StatefulWidget {
  final String patientName;
  const DoctorChatDetailScreen({super.key, required this.patientName});

  @override
  State<DoctorChatDetailScreen> createState() => _DoctorChatDetailScreenState();
}

class _DoctorChatDetailScreenState extends State<DoctorChatDetailScreen> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _controller = TextEditingController();

  // keep the messages list as the source of truth (we insert them into the AnimatedList)
  final List<_Msg> _messages = [
    _Msg(text: 'Hello Doctor, I have a doubt about my diet.', fromDoctor: false),
    _Msg(text: 'Sure, tell me what happened.', fromDoctor: true),
    _Msg(text: 'I feel dizzy after lunch.', fromDoctor: false),
  ];

  @override
  void initState() {
    super.initState();

    // Start AnimatedList empty, then insert existing messages one-by-one for animation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final listState = _listKey.currentState;
      if (listState != null) {
        for (int i = 0; i < _messages.length; i++) {
          // insert at end (index == current length), but using i works because we are inserting sequentially
          listState.insertItem(i, duration: Duration(milliseconds: 200 + (i * 50)));
        }
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMsg = _Msg(text: text, fromDoctor: true);
    final insertIndex = _messages.length; // append
    _messages.add(newMsg);

    // If AnimatedList state available, animate insertion; otherwise list will still display (fallback)
    _listKey.currentState?.insertItem(insertIndex, duration: const Duration(milliseconds: 300));
    _controller.clear();

    // demo auto-reply
    Future.delayed(const Duration(milliseconds: 700), () {
      final reply = _Msg(text: 'Thanks, I will follow up tomorrow.', fromDoctor: false);
      final replyIndex = _messages.length;
      _messages.add(reply);
      _listKey.currentState?.insertItem(replyIndex, duration: const Duration(milliseconds: 300));
    });
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    // guard: if index ever out of range, return empty sized box
    if (index < 0 || index >= _messages.length) return const SizedBox.shrink();

    final msg = _messages[index];
    final alignment = msg.fromDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = msg.fromDoctor ? Colors.green.shade600 : Colors.grey.shade200;
    final textColor = msg.fromDoctor ? Colors.white : Colors.black87;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(14),
      topRight: const Radius.circular(14),
      bottomLeft: msg.fromDoctor ? const Radius.circular(14) : const Radius.circular(2),
      bottomRight: msg.fromDoctor ? const Radius.circular(2) : const Radius.circular(14),
    );

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          mainAxisAlignment: msg.fromDoctor ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!msg.fromDoctor) ...[
              CircleAvatar(radius: 14, backgroundColor: Colors.blue.shade50, child: Icon(Icons.person, color: Colors.blue.shade700, size: 14)),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: alignment,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: radius,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0,2))],
                    ),
                    child: Text(msg.text, style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ),
            if (msg.fromDoctor) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.blue.shade50, child: Icon(Icons.person, color: Colors.blue.shade700)),
          const SizedBox(width: 12),
          Text(widget.patientName, style: const TextStyle(fontSize: 18, color: Colors.black87)),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.grey.shade700)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF5F6F8);
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: bg,
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              // START EMPTY — we insert items in initState for the animated entrance.
              initialItemCount: 0,
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemBuilder: (context, index, animation) => _buildItem(context, index, animation),
            ),
          ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: bg,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey.shade700),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0,2))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                hintText: 'Type a message',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black45),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey.shade700),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.green.shade100.withOpacity(0.4), blurRadius: 8, offset: const Offset(0,3))],
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool fromDoctor;
  const _Msg({required this.text, required this.fromDoctor});
}
