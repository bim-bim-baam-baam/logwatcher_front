import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:logwatcher/data/mock_clusters.dart';
import 'package:logwatcher/widgets/expandable_cluster_card.dart';
import 'package:logwatcher/models/chat_thread.dart';
import 'package:logwatcher/widgets/chat_sidebar.dart';
import 'package:logwatcher/controllers/sidebar_mascot_controller.dart'; // ← добавлено

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatThread> rootThreads = [];
  late ChatThread currentThread;

  @override
  void initState() {
    super.initState();
    currentThread = ChatThread(
      id: const Uuid().v4(),
      title: "Главный чат",
      messages: [],
    );
    rootThreads.add(currentThread);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentThread.messages.add(_buildClusterList(context));
      });
    });
  }

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        currentThread.messages.add("👤 $input");
      });

      // 🟢 реагируем на сообщение
      context.read<SidebarMascotController>().set('basic_bro');

      _controller.clear();
    }
  }

  Widget _buildClusterList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mockClusters.map((cluster) {
        return ExpandableClusterCard(
          cluster: cluster,
          onOpenSubChat: () {
            final newThread = ChatThread(
              id: const Uuid().v4(),
              title: "Обсуждение: ${cluster.title}",
              messages: ["🤖 Чат по кластеру: ${cluster.title}"],
            );
            setState(() {
              currentThread.children.add(newThread);
              currentThread.messages.add(
                "🤖 Открыт чат по кластеру: ${cluster.title}",
              );
            });

            // 🟢 реагируем на создание чата
            context.read<SidebarMascotController>().set('basic_bro');
          },
          onOpenPackageChat: (String packageName) {
            final newThread = ChatThread(
              id: const Uuid().v4(),
              title: "Пакет: $packageName",
              messages: ["🤖 Обсуждение пакета: $packageName"],
            );
            setState(() {
              currentThread.children.add(newThread);
              currentThread.messages.add(
                "🤖 Открыт чат по пакету: $packageName",
              );
            });

            // 🟢 реагируем на создание чата
            context.read<SidebarMascotController>().set('basic_bro');
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("💬 LogWatcher Chat")),
      body: Row(
        children: [
          ChatSidebar(
            threads: rootThreads,
            active: currentThread,
            onSelect: (thread) {
              setState(() => currentThread = thread);
            },
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                  ),
                ),
                Divider(height: 1, color: Colors.grey[700]),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _sendMessage(),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[850],
                            hintText: "Вставь ссылку на лог или архив логов...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[700]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.greenAccent),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
