import 'package:flutter_youssefkleeno/core/network/api_client.dart';
import 'package:flutter_youssefkleeno/core/network/constants/api_constants.dart';

class HomeRepository {
  final ApiClient api;
  HomeRepository({required this.api});

  Future<dynamic> fetchMonthlyServices() async {
    final endpoint = '${ApiConstants.baseUrl}/service';
    final result = await api.get(
      endpoint,
      queryParameters: {'washType': 'Monthly Subscription', 'limit': '30'},
      fromJsonT: (j) => j,
    );
    return result;
  }
}
