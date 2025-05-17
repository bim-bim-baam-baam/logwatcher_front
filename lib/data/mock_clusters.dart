import '../models/error_cluster.dart';

final mockClusters = [
  ErrorCluster(
    id: '1',
    title: 'NullPointerException',
    description: 'Null reference detected in OrderService. Possibly missing null check.',
    count: 3,
    packages: ['pkg-order', 'pkg-catalog', 'pkg-user'],
  ),
  ErrorCluster(
    id: '2',
    title: 'SSL Handshake Failed',
    description: 'Expired certificate detected. Update or regenerate certs.',
    count: 2,
    packages: ['pkg-auth', 'pkg-api'],
  ),
];
