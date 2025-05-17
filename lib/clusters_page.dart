import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ClustersPage extends StatefulWidget {
  @override
  _ClustersPageState createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  List<dynamic> clusters = [];

  @override
  void initState() {
    super.initState();
    fetchClusters();
  }

  Future<void> fetchClusters() async {
    try {
      final response = await Dio().get('http://localhost:8080/clusters/test');
      setState(() {
        clusters = response.data['clusters'];
      });
    } catch (e) {
      print("Ошибка загрузки кластеров: $e");
    }
  }

  Future<void> createChat(String title, String context) async {
    try {
      await Dio().post('http://localhost:8080/chat/create', queryParameters: {
        'title': title,
        'context': context,
      });
      print("Чат успешно создан");
    } catch (e) {
      print("Ошибка создания чата: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список Кластеров'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: clusters.length,
        itemBuilder: (context, index) {
          final cluster = clusters[index];
          return ExpansionTile(
            title: Text(cluster['name']),
            children: [
              Text(cluster['description']),
              for (var package in cluster['packages'])
                ListTile(
                  title: Text(package['name']),
                  trailing: IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                      createChat(cluster['name'], cluster['description']);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
