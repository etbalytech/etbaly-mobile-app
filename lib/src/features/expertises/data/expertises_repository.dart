import 'dart:convert';

import 'package:dio/dio.dart';

import 'expertise_catalogue.dart';

/// Loads the "Our Expertise" sample catalogues and the public Google reviews
/// from the website. A catalogue is kept for the rest of the app session once
/// it loads (a failed load is tried again next time); reviews are always
/// fetched fresh, like the website does.
abstract final class ExpertisesRepository {
  static const _site = 'https://etba3ly-dm.com';

  /// Where customers leave a review for the business on Google.
  static const googleWriteReviewUrl =
      'https://search.google.com/local/writereview?placeid=ChIJF0b9YcPD9RQRgKm43zCNm8I';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  static final Map<String, Future<Map<String, dynamic>>> _cache = {};

  static Future<WebCatalogue> web({bool refresh = false}) async =>
      WebCatalogue.fromJson(await _catalogue('web', refresh));

  static Future<MobileCatalogue> mobile({bool refresh = false}) async =>
      MobileCatalogue.fromJson(await _catalogue('mobile', refresh));

  static Future<SocialCatalogue> social(
    SocialPlatform platform, {
    bool refresh = false,
  }) async =>
      SocialCatalogue.fromJson(await _catalogue(platform.name, refresh));

  static Future<CampaignCatalogue> campaigns({bool refresh = false}) async =>
      CampaignCatalogue.fromJson(await _catalogue('campaigns', refresh));

  /// The overall Google rating plus up to three five-star reviews, or null
  /// when the website has no reviews to share.
  static Future<GoogleReviewFeed?> googleReviews() async {
    final response = await _dio.get<Object>(
      '$_site/api-dashboard/public-google-reviews.php',
    );
    final body = _decode(response.data);
    final data = body['data'];
    if (body['status'] != 'ok' || data is! Map<String, dynamic>) return null;
    final average = data['average'];
    final total = data['total'];
    final reviews = data['reviews'];
    return GoogleReviewFeed(
      average: average is num ? average.toDouble() : 0,
      total: total is num ? total.toInt() : 0,
      reviews: [
        if (reviews is List)
          for (final item in reviews)
            if (item is Map<String, dynamic>) GoogleReview.fromJson(item),
      ].where((review) => review.stars == 5).take(3).toList(),
    );
  }

  static Future<Map<String, dynamic>> _catalogue(
    String name,
    bool refresh,
  ) async {
    if (refresh) _cache.remove(name);
    final request = _cache[name] ??= _fetch('$_site/data/expertises-$name.json');
    try {
      return await request;
    } catch (_) {
      if (identical(_cache[name], request)) _cache.remove(name);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _fetch(String url) async {
    final response = await _dio.get<Object>(url);
    return _decode(response.data);
  }

  static Map<String, dynamic> _decode(Object? data) {
    final value = data is String ? jsonDecode(data) : data;
    if (value is Map<String, dynamic>) return value;
    throw const FormatException('Unexpected response from the website');
  }
}
