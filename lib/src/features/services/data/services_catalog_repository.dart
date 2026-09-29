import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services_catalog_data.dart';

/// Loads the public packages catalogue managed from the dashboard — the same
/// endpoint the website's services pages read — and keeps the last answer so
/// prices still show when the phone is offline.
class ServicesCatalogRepository {
  ServicesCatalogRepository._();

  static const _url = 'https://etba3ly-dm.com/api-dashboard/internal-packages.php';
  static const _cacheKey = 'services_catalog_v1';

  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
  ));

  // Shared by the services tab and the service pages during the app session.
  static List<InternalPackage>? _memory;

  static List<InternalPackage> _parse(Object? rows) => sortedActivePackages([
        if (rows is List)
          for (final row in rows)
            if (row is Map) InternalPackage.fromJson(Map<String, dynamic>.from(row)),
      ]);

  /// The last known catalogue (memory first, then disk), or `null` if none.
  static Future<List<InternalPackage>?> cached() async {
    if (_memory != null) return _memory;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return null;
      return _memory = _parse(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  /// Fetches the current catalogue. Throws when the server cannot be reached
  /// or answers with something else than `{status: ok, packages: [...]}`.
  static Future<List<InternalPackage>> fetch() async {
    final response = await _dio.get<dynamic>(_url, queryParameters: {'active': 1});
    var body = response.data;
    if (body is String) body = jsonDecode(body);
    if (body is! Map || body['status'] != 'ok' || body['packages'] is! List) {
      throw Exception('Unexpected catalogue response');
    }
    final rows = body['packages'] as List;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(rows));
    } catch (_) {
      // Caching is best-effort.
    }
    return _memory = _parse(rows);
  }
}
