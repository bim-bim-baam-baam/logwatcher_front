import 'package:flutter/material.dart';
import '../data/mock_clusters.dart';
import '../screens/cluster_detail_page.dart';

class ClustersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🧠 Кластеры ошибок")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: mockClusters.length,
        itemBuilder: (context, index) {
          final cluster = mockClusters[index];
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(cluster.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(
                "${cluster.description}\n${cluster.count} пакетов",
                style: TextStyle(color: Colors.grey[400]),
              ),
              isThreeLine: true,
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.greenAccent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClusterDetailPage(cluster: cluster),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
