class ErrorCluster {
  final String id;
  final String title;
  final String description;
  final int count;
  final List<String> packages;

  ErrorCluster({
    required this.id,
    required this.title,
    required this.description,
    required this.count,
    required this.packages,
  });

  factory ErrorCluster.fromJson(Map<String, dynamic> json) {
    return ErrorCluster(
      id: json['id'],
      title: json['error_type'],
      description: json['description'],
      count: json['packages']?.length ?? 0,
      packages: List<String>.from(json['packages'] ?? []),
    );
  }
}
