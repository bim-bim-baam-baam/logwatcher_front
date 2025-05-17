import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← добавлено
import '../controllers/sidebar_mascot_controller.dart'; // ← добавлено
import '../models/error_cluster.dart';

class ExpandableClusterCard extends StatefulWidget {
  final ErrorCluster cluster;
  final VoidCallback? onOpenSubChat;
  final void Function(String packageName)? onOpenPackageChat;

  const ExpandableClusterCard({
    required this.cluster,
    this.onOpenSubChat,
    this.onOpenPackageChat,
  });

  @override
  State<ExpandableClusterCard> createState() => _ExpandableClusterCardState();
}

class _ExpandableClusterCardState extends State<ExpandableClusterCard> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });

    if (isExpanded) {
      context.read<SidebarMascotController>().set('reading_bro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.cluster.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${widget.cluster.count} пакетов"),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.greenAccent,
            ),
            onTap: toggleExpanded,
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cluster.description,
                      style: TextStyle(color: Colors.grey[300])),
                  SizedBox(height: 12),
                  Text("📦 Пакеты:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...widget.cluster.packages.map((pkg) {
                    return ListTile(
                      title: Text(pkg, style: TextStyle(color: Colors.white)),
                      leading: Icon(Icons.bug_report_outlined, color: Colors.greenAccent),
                      trailing: IconButton(
                        icon: Icon(Icons.chat_bubble_outline, color: Colors.greenAccent),
                        tooltip: "Обсудить пакет",
                        onPressed: () {
                          if (widget.onOpenPackageChat != null) {
                            widget.onOpenPackageChat!(pkg);
                          }
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: Text("📦 $pkg"),
                            content: Text("Детали ошибки в пакете $pkg\n(тут потом будет GPT-чат или логика анализа)"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Закрыть", style: TextStyle(color: Colors.greenAccent)),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),

                  SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: widget.onOpenSubChat,
                      icon: Icon(Icons.open_in_new, color: Colors.greenAccent),
                      label: Text(
                        "Обсудить кластер",
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
