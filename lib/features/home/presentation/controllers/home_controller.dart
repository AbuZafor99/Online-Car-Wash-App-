import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/home/data/models/home_service_model.dart';
import 'package:flutter_youssefkleeno/features/home/data/repo/home_repository.dart';
import 'package:flutter_youssefkleeno/core/network/api_client.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository repo;
  bool isLoading = false;
  List<HomeServiceModel> services = [];

  HomeController({HomeRepository? repository})
    : repo = repository ?? HomeRepository(api: ApiClient());

  Future<void> loadMonthlyServices() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await repo.fetchMonthlyServices();
      result.fold(
        (failure) {
          // keep services empty on failure
          services = [];
        },
        (success) {
          final data = success.data;
          List<dynamic> raw = [];
          if (data is List)
            raw = data;
          else if (data is Map && data['services'] is List)
            raw = data['services'];
          services = raw
              .map(
                (e) => HomeServiceModel.fromMap(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        },
      );
    } catch (_) {
      services = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
