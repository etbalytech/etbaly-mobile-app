/// The "Our Expertise" sample catalogues published by the website under
/// `https://etba3ly-dm.com/data/expertises-*.json`. Parsing is forgiving: a
/// record that does not match the expected shape is skipped, never fatal.
library;

/// `{ "ar": …, "en": … }` text.
class ExpertiseCopy {
  const ExpertiseCopy(this.ar, this.en);

  factory ExpertiseCopy.fromJson(Object? json) {
    if (json is Map) return ExpertiseCopy(_str(json['ar']), _str(json['en']));
    return const ExpertiseCopy('', '');
  }

  final String ar;
  final String en;

  String of(bool arabic) => arabic ? (ar.isNotEmpty ? ar : en) : (en.isNotEmpty ? en : ar);
}

class ExpertiseCategory {
  const ExpertiseCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.subcategories = const [],
    this.tagsAr = const [],
    this.tagsEn = const [],
  });

  factory ExpertiseCategory.fromJson(Map<String, dynamic> json) {
    final tags = json['tags'];
    return ExpertiseCategory(
      id: _str(json['id']),
      name: ExpertiseCopy.fromJson(json['name']),
      icon: _str(json['icon']),
      subcategories: [
        for (final item in _list(json['subcategories']))
          if (item is Map<String, dynamic>)
            ExpertiseSubcategory(_str(item['id']), ExpertiseCopy.fromJson(item['name'])),
      ],
      tagsAr: tags is Map ? [for (final t in _list(tags['ar'])) _str(t)] : const [],
      tagsEn: tags is Map ? [for (final t in _list(tags['en'])) _str(t)] : const [],
    );
  }

  final String id;
  final ExpertiseCopy name;

  /// Font Awesome class name from the website, e.g. `fa-stethoscope`.
  final String icon;
  final List<ExpertiseSubcategory> subcategories;
  final List<String> tagsAr;
  final List<String> tagsEn;
}

class ExpertiseSubcategory {
  const ExpertiseSubcategory(this.id, this.name);
  final String id;
  final ExpertiseCopy name;
}

// ─── Websites ────────────────────────────────────────────────────────────────

class WebSample {
  const WebSample({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.url,
    required this.domain,
    required this.previewUrl,
    required this.previewSources,
    required this.available,
  });

  factory WebSample.fromJson(Map<String, dynamic> json) {
    final availability = json['availability'];
    return WebSample(
      id: _str(json['id']),
      categoryId: _str(json['category_id']),
      name: _str(json['name']),
      url: _str(json['url']),
      domain: _str(json['domain']),
      previewUrl: _str(json['preview_url']),
      previewSources: [
        for (final source in _list(json['preview_sources']))
          if (source is Map) (url: _str(source['url']), width: _int(source['width'])),
      ],
      available: availability is Map && availability['status'] == 'available',
    );
  }

  final String id;
  final String categoryId;
  final String name;
  final String url;
  final String domain;
  final String previewUrl;
  final List<({String url, int width})> previewSources;
  final bool available;

  /// The website only lists reachable sites with an http(s) address.
  bool get listed => available && RegExp(r'^https?://', caseSensitive: false).hasMatch(url);

  /// The smallest preview that is still sharp at [pixelWidth].
  String previewFor(double pixelWidth) {
    final sources = [...previewSources]..sort((a, b) => a.width.compareTo(b.width));
    for (final source in sources) {
      if (source.width >= pixelWidth && source.url.isNotEmpty) return source.url;
    }
    return sources.isNotEmpty && sources.last.url.isNotEmpty ? sources.last.url : previewUrl;
  }
}

class WebCatalogue {
  const WebCatalogue({required this.categories, required this.sites});

  factory WebCatalogue.fromJson(Map<String, dynamic> json) => WebCatalogue(
        categories: _categories(json),
        sites: [
          for (final item in _list(json['sites']))
            if (item is Map<String, dynamic>) WebSample.fromJson(item),
        ],
      );

  final List<ExpertiseCategory> categories;
  final List<WebSample> sites;
}

// ─── Mobile apps ─────────────────────────────────────────────────────────────

class MobileSample {
  const MobileSample({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.storeName,
    required this.developer,
    required this.store,
    required this.storeId,
    required this.url,
    required this.iconUrl,
    required this.status,
  });

  factory MobileSample.fromJson(Map<String, dynamic> json) {
    final availability = json['availability'];
    return MobileSample(
      id: _str(json['id']),
      categoryId: _str(json['category_id']),
      name: _str(json['name']),
      storeName: _str(json['store_name']),
      developer: _str(json['developer']),
      store: _str(json['store']),
      storeId: _str(json['store_id']),
      url: _str(json['url']),
      iconUrl: _str(json['icon_url']),
      status: availability is Map ? _str(availability['status']) : '',
    );
  }

  final String id;
  final String categoryId;
  final String name;
  final String storeName;
  final String developer;

  /// `google-play` or `app-store`.
  final String store;
  final String storeId;
  final String url;
  final String iconUrl;
  final String status;

  bool get isIos => store == 'app-store';

  /// Same rule as the website's `isPublishedApp`: only direct HTTPS store
  /// listings from the two supported stores, checked as available.
  bool get published {
    if (status != 'available') return false;
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.userInfo.isNotEmpty || uri.hasPort) {
      return false;
    }
    if (store == 'google-play') {
      return uri.host == 'play.google.com' &&
          uri.path == '/store/apps/details' &&
          uri.queryParameters['id'] == storeId;
    }
    return store == 'app-store' &&
        uri.host == 'apps.apple.com' &&
        uri.path.endsWith('/id$storeId') &&
        RegExp(r'^\d+$').hasMatch(storeId);
  }
}

class MobileCatalogue {
  const MobileCatalogue({required this.categories, required this.apps});

  factory MobileCatalogue.fromJson(Map<String, dynamic> json) => MobileCatalogue(
        categories: _categories(json),
        apps: [
          for (final item in _list(json['apps']))
            if (item is Map<String, dynamic>) MobileSample.fromJson(item),
        ],
      );

  final List<ExpertiseCategory> categories;
  final List<MobileSample> apps;
}

// ─── Facebook / Instagram ────────────────────────────────────────────────────

enum SocialPlatform { facebook, instagram }

class SocialAccount {
  const SocialAccount({
    required this.id,
    required this.platform,
    required this.categoryId,
    required this.subcategoryId,
    required this.displayName,
    required this.name,
    required this.username,
    required this.profileUrl,
    required this.logoUrl,
    required this.verificationStatus,
    required this.verificationSource,
    required this.verificationCheckedAt,
  });

  factory SocialAccount.fromJson(Map<String, dynamic> json) {
    final verification = json['verification'];
    return SocialAccount(
      id: _str(json['id']),
      platform: _str(json['platform']),
      categoryId: _str(json['category_id']),
      subcategoryId: json['subcategory_id'] == null ? null : _str(json['subcategory_id']),
      displayName: ExpertiseCopy.fromJson(json['display_name']),
      name: _str(json['name']),
      username: _str(json['username']),
      profileUrl: _str(json['profile_url']),
      logoUrl: json['logo_url'] == null ? null : _str(json['logo_url']),
      verificationStatus: verification is Map ? _str(verification['status']) : '',
      verificationSource: verification is Map ? _str(verification['source_url']) : '',
      verificationCheckedAt: verification is Map ? _str(verification['checked_at']) : '',
    );
  }

  final String id;
  final String platform;
  final String categoryId;
  final String? subcategoryId;
  final ExpertiseCopy displayName;
  final String name;
  final String username;
  final String profileUrl;
  final String? logoUrl;
  final String verificationStatus;
  final String verificationSource;
  final String verificationCheckedAt;

  String nameFor(bool arabic) => name.isNotEmpty ? name : displayName.of(arabic);

  String initialsFor(bool arabic) => nameFor(arabic)
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => String.fromCharCode(part.runes.first))
      .join();

  /// Same rule as the website: the evidence must point at this very profile.
  bool get verified {
    if (verificationStatus != 'verified' ||
        verificationSource.isEmpty ||
        verificationCheckedAt.isEmpty ||
        DateTime.tryParse(verificationCheckedAt) == null) {
      return false;
    }
    final source = Uri.tryParse(verificationSource);
    final profile = Uri.tryParse(profileUrl);
    if (source == null || profile == null) return false;
    return source.scheme == 'https' &&
        source.host == profile.host &&
        source.path == profile.path &&
        source.queryParameters['id'] == profile.queryParameters['id'];
  }
}

class SocialCatalogue {
  const SocialCatalogue({required this.categories, required this.accounts});

  factory SocialCatalogue.fromJson(Map<String, dynamic> json) => SocialCatalogue(
        categories: _categories(json),
        accounts: [
          for (final item in _list(json['accounts']))
            if (item is Map<String, dynamic>) SocialAccount.fromJson(item),
        ],
      );

  final List<ExpertiseCategory> categories;
  final List<SocialAccount> accounts;
}

// ─── Advertising campaigns ───────────────────────────────────────────────────

class CampaignPhoto {
  const CampaignPhoto({
    required this.id,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
  });

  factory CampaignPhoto.fromJson(Map<String, dynamic> json) => CampaignPhoto(
        id: _str(json['id']),
        imageUrl: _str(json['image_url']),
        thumbnailUrl: _str(json['thumbnail_url']),
        width: _int(json['width']),
        height: _int(json['height']),
      );

  final String id;
  final String imageUrl;
  final String thumbnailUrl;
  final int width;
  final int height;

  /// Same rule as the website's `isCampaignPhoto`.
  bool get valid {
    if (!RegExp(r'^\d+$').hasMatch(id) || width <= 0 || height <= 0) return false;
    for (final value in [imageUrl, thumbnailUrl]) {
      final uri = Uri.tryParse(value);
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host != 'etba3ly-dm.com' ||
          !uri.path.startsWith('/expertises/campaign-media/') ||
          !uri.path.endsWith('.webp')) {
        return false;
      }
    }
    return true;
  }
}

class CampaignCategory {
  const CampaignCategory({required this.category, required this.photos});

  factory CampaignCategory.fromJson(Map<String, dynamic> json) => CampaignCategory(
        category: ExpertiseCategory.fromJson(json),
        photos: [
          for (final item in _list(json['images']))
            if (item is Map<String, dynamic>) CampaignPhoto.fromJson(item),
        ].where((photo) => photo.valid).toList(),
      );

  final ExpertiseCategory category;
  final List<CampaignPhoto> photos;
}

class CampaignCatalogue {
  const CampaignCatalogue({required this.categories});

  factory CampaignCatalogue.fromJson(Map<String, dynamic> json) => CampaignCatalogue(
        categories: [
          for (final item in _list(json['categories']))
            if (item is Map<String, dynamic>) CampaignCategory.fromJson(item),
        ],
      );

  final List<CampaignCategory> categories;
}

// ─── Google reviews ──────────────────────────────────────────────────────────

class GoogleReview {
  const GoogleReview({
    required this.name,
    required this.photo,
    required this.stars,
    required this.comment,
    required this.date,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) => GoogleReview(
        name: _str(json['name']),
        photo: _str(json['photo']),
        stars: _int(json['stars']),
        comment: _str(json['comment']),
        date: DateTime.tryParse(_str(json['date'])),
      );

  final String name;
  final String photo;
  final int stars;
  final String comment;
  final DateTime? date;

  /// Only Google-hosted avatars are shown, like the website.
  String get safePhoto {
    final uri = Uri.tryParse(photo);
    if (uri == null || uri.scheme != 'https') return '';
    return RegExp(r'(^|\.)(googleusercontent\.com|ggpht\.com)$', caseSensitive: false)
            .hasMatch(uri.host)
        ? photo
        : '';
  }
}

class GoogleReviewFeed {
  const GoogleReviewFeed({required this.average, required this.total, required this.reviews});

  final double average;
  final int total;
  final List<GoogleReview> reviews;
}

// ─── Search ──────────────────────────────────────────────────────────────────

/// Arabic-aware search folding used by every sample page (same as the
/// website): lowercase, no diacritics or tatweel, unified alef/yaa/taa marbuta.
String normalizeExpertiseSearch(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp('[̀-ًͯ-ٰٟـ]'), '')
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll('@', '')
      .trim();
}

// ─── helpers ─────────────────────────────────────────────────────────────────

String _str(Object? value) => value == null ? '' : value.toString();

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

List<Object?> _list(Object? value) => value is List ? value : const [];

List<ExpertiseCategory> _categories(Map<String, dynamic> json) => [
      for (final item in _list(json['categories']))
        if (item is Map<String, dynamic>) ExpertiseCategory.fromJson(item),
    ];
