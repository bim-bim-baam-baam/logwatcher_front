import 'package:flutter/material.dart';

class ErrorChatPage extends StatefulWidget {
  final String packageName;
  final String errorDescription;

  const ErrorChatPage({
    required this.packageName,
    required this.errorDescription,
  });

  @override
  State<ErrorChatPage> createState() => _ErrorChatPageState();
}

class _ErrorChatPageState extends State<ErrorChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        messages.add("👤 $input");
        messages.add("🤖 Обработка ошибки в пакете ${widget.packageName}...");
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("💬 ${widget.packageName}"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              widget.errorDescription,
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
          Divider(color: Colors.grey[700]),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                alignment: messages[index].startsWith("👤")
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: messages[index].startsWith("👤")
                        ? Colors.green[800]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(messages[index],
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Спроси что-то по этой ошибке...",
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
    );
  }
}
