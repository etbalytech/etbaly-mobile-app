import 'package:dio/dio.dart';

import 'portfolio_data.dart';

class PortfolioRepository {
  PortfolioRepository._();

  static const _dataUrl = 'https://etba3ly-dm.com/data/portfolio-data.json';

  // In-memory cache — lives as long as the app process (matches web shareReplay)
  static List<PortfolioIndustry>? _cache;

  static Future<List<PortfolioIndustry>> getIndustries() async {
    if (_cache != null) return _cache!;

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));

    final response = await dio.get<dynamic>(_dataUrl);
    final data = response.data;

    if (data is! List) {
      throw Exception('Unexpected portfolio-data format');
    }

    _cache = data
        .map((e) => PortfolioIndustry.fromJson(e as Map<String, dynamic>))
        .toList();

    return _cache!;
  }

  /// Clear cache — useful for pull-to-refresh.
  static void clearCache() => _cache = null;
}
