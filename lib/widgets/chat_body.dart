import 'package:flutter/material.dart';
import 'package:logwatcher/models/chat_thread.dart';

class ChatBody extends StatelessWidget {
  final ChatThread currentThread;

  const ChatBody({required this.currentThread});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentThread.messages.length,
      itemBuilder: (context, index) {
        final msg = currentThread.messages[index];
        if (msg is String) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            alignment: msg.startsWith("👤")
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(12),
              constraints: BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: msg.startsWith("👤")
                    ? Colors.green[800]
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(msg, style: TextStyle(fontSize: 16)),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: msg,
          );
        }
      },
    );
  }
}
