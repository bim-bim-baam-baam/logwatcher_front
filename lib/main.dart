import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'clusters_page.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: ChatMainPage(),
    );
  }
}

class ChatMainPage extends StatefulWidget {
  @override
  _ChatMainPageState createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> {
  List<dynamic> chats = [];
  List<dynamic> chatHistory = [];
  int? selectedChatId;
  String selectedChatTitle = "";
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    try {
      final response = await Dio().get('http://localhost:8080/chat/allChats');
      setState(() {
        chats = response.data;
      });
    } catch (e) {
      print("Ошибка загрузки чатов: $e");
    }
  }

  Future<void> fetchChatHistory(int chatId, String chatTitle) async {
    try {
      final response = await Dio().get('http://localhost:8080/chat/history', queryParameters: {
        'chatId': chatId,
      });
      setState(() {
        chatHistory = response.data;
        selectedChatId = chatId;
        selectedChatTitle = chatTitle;
      });
    } catch (e) {
      print("Ошибка загрузки истории: $e");
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty || selectedChatId == null) return;
    try {
      await Dio().post('http://localhost:8080/chat/message', queryParameters: {
        'chatId': selectedChatId,
        'sender': 'user',
        'message': messageController.text
      });
      messageController.clear();
      await fetchChatHistory(selectedChatId!, selectedChatTitle);
    } catch (e) {
      print("Ошибка отправки сообщения: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Чатов'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.account_tree_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClustersPage()));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - список чатов
          Container(
            width: 300,
            color: Colors.grey[800],
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  title: Text(chat['title'], style: TextStyle(color: Colors.white)),
                  tileColor: selectedChatId == chat['id'] ? Colors.orange[400] : Colors.grey[700],
                  onTap: () => fetchChatHistory(chat['id'], chat['title']),
                );
              },
            ),
          ),
          // Правая панель - история чата и отправка сообщений
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.yellow[100],
              child: Column(
                children: [
                  Text(
                    selectedChatTitle.isNotEmpty ? selectedChatTitle : 'Выберите чат',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        final message = chatHistory[index];
                        bool isUser = message['sender'] == 'user';
                        return Align(
                          alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.orange[200] : Colors.grey[500],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              message['message'],
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(hintText: 'Введите сообщение'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.orange),
                        onPressed: sendMessage,
                      ),
                    ],
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
