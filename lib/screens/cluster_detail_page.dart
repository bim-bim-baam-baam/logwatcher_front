import 'package:flutter/material.dart';
import 'package:logwatcher/screens/error_chat_page.dart';
import '../models/error_cluster.dart';

class ClusterDetailPage extends StatelessWidget {
  final ErrorCluster cluster;

  const ClusterDetailPage({required this.cluster});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📄 ${cluster.title}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Описание", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(cluster.description),
            SizedBox(height: 20),
            Text("Пакеты", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...cluster.packages.map((p) => ListTile(
              title: Text(p),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ErrorChatPage(
                      packageName: p,
                      errorDescription: cluster.description,
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
