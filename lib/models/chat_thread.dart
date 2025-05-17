class ChatThread {
  final String id;
  final String title;
  final List<dynamic> messages;
  final List<ChatThread> children;

  ChatThread({
    required this.id,
    required this.title,
    List<dynamic>? messages,
    List<ChatThread>? children,
  })  : messages = messages ?? [],
        children = children ?? [];
}
