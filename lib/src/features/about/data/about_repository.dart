import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about_data.dart';

/// Loads the CEO profile and the team from the same dashboard-managed API the
/// website's About page uses, and keeps the last answer so the page still shows
/// real data when the phone is offline.
class AboutRepository {
  AboutRepository._();

  static const siteUrl = 'https://etba3ly-dm.com/';
  static const _apiBase = 'https://etba3ly-dm.com/api-services';
  static const _ceoCacheKey = 'about_ceo_profile_v1';
  static const _teamCacheKey = 'about_team_v1';

  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  /// Turns an avatar path stored in the dashboard (relative to the site root,
  /// e.g. `uploads/team/x.webp`) into a full URL. Absolute and `data:` URLs are kept.
  static String assetUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return '';
    if (RegExp(r'^(https?:)?//').hasMatch(trimmed) || trimmed.startsWith('data:')) {
      return trimmed.startsWith('//') ? 'https:$trimmed' : trimmed;
    }
    return Uri.parse(siteUrl).resolve(trimmed.replaceFirst(RegExp(r'^/+'), '')).toString();
  }

  static Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  static Future<void> _save(String key, Object value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(value));
    } catch (_) {
      // Caching is best-effort; the freshly loaded data is still returned.
    }
  }

  static Future<Object?> _read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      return raw == null ? null : jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  static List<TeamMember> _members(List<dynamic> rows) => [
        for (final row in rows)
          if (row is Map) TeamMember.fromJson(Map<String, dynamic>.from(row)),
      ];

  // ── CEO ────────────────────────────────────────────────────────────────────

  static Future<CeoProfile?> cachedCeoProfile() async {
    final cached = await _read(_ceoCacheKey);
    return cached is Map ? CeoProfile.fromJson(Map<String, dynamic>.from(cached)) : null;
  }

  /// Returns `null` when the dashboard has no profile yet (the defaults apply).
  static Future<CeoProfile?> fetchCeoProfile() async {
    final response = await _dio.get<dynamic>('$_apiBase/ceo.php');
    final profile = _asMap(response.data)?['profile'];
    if (profile is! Map) return null;
    final map = Map<String, dynamic>.from(profile);
    await _save(_ceoCacheKey, map);
    return CeoProfile.fromJson(map);
  }

  // ── Team ───────────────────────────────────────────────────────────────────

  static Future<List<TeamMember>?> cachedTeam() async {
    final cached = await _read(_teamCacheKey);
    return cached is List ? _members(cached) : null;
  }

  static Future<List<TeamMember>> fetchTeam() async {
    final response = await _dio.get<dynamic>('$_apiBase/team.php');
    final team = _asMap(response.data)?['team'];
    if (team is! List) throw Exception('Unexpected team response');
    await _save(_teamCacheKey, team);
    return _members(team);
  }
}
