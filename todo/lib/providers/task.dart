import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../services/api_service.dart';

// Provider to get object of ApiService
final apiProvider = Provider<ApiService>(
      (ref) => ApiService(),
);

// FutureProvider to fetch data from API using ApiService()
final taskDataProvider = FutureProvider<List<TaskModel>>(
        (ref) {
      return ref.read(apiProvider).getUser();
    }
);