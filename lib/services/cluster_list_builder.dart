import 'package:flutter/material.dart';
import 'package:logwatcher/models/chat_thread.dart';
import 'package:logwatcher/data/mock_clusters.dart';
import 'package:logwatcher/widgets/expandable_cluster_card.dart';
import 'package:uuid/uuid.dart';

Widget buildClusterList({
  required ChatThread currentThread,
  required void Function(ChatThread) onThreadCreated,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: mockClusters.map((cluster) {
      return ExpandableClusterCard(
        cluster: cluster,
        onOpenSubChat: () {
          final thread = ChatThread(
            id: const Uuid().v4(),
            title: "Обсуждение: ${cluster.title}",
            messages: ["🤖 Чат по кластеру: ${cluster.title}"],
          );
          currentThread.children.add(thread);
          onThreadCreated(thread);
        },
        onOpenPackageChat: (package) {
          final thread = ChatThread(
            id: const Uuid().v4(),
            title: "Пакет: $package",
            messages: ["🤖 Обсуждение пакета: $package"],
          );
          currentThread.children.add(thread);
          onThreadCreated(thread);
        },
      );
    }).toList(),
  );
}
