import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_thread.dart';
import '../controllers/sidebar_mascot_controller.dart';

class ChatSidebar extends StatelessWidget {
  final List<ChatThread> threads;
  final ChatThread active;
  final Function(ChatThread) onSelect;

  const ChatSidebar({
    required this.threads,
    required this.active,
    required this.onSelect,
  });

  Widget buildThread(ChatThread thread, {int indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: indent * 16.0),
      child: ListTile(
        title: Text(
          thread.title,
          style: TextStyle(
            color: thread == active ? Colors.greenAccent : Colors.white,
            fontWeight: thread == active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => onSelect(thread),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> flatList = [];

    void addRecursively(ChatThread t, int depth) {
      flatList.add(buildThread(t, indent: depth));
      for (var child in t.children) {
        addRecursively(child, depth + 1);
      }
    }

    for (var thread in threads) {
      addRecursively(thread, 0);
    }

    final mascotState = context.watch<SidebarMascotController>().current;
    final isStatic = mascotState == 'bro';
    final extension = isStatic ? '.png' : '.gif';
    final path = 'assets/mascot/$mascotState$extension';

    return Stack(
      children: [
        // Основной сайдбар
        Container(
          width: 240,
          color: Colors.grey[900],
          child: ListView(children: flatList),
        ),

        // Наложенная гифка в нижнем левом углу
        Positioned(
          left: 8,
          bottom: 8,
          child: IgnorePointer( // чтобы не перехватывала клики по чатам
            child: SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                path,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
