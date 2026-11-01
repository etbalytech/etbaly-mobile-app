class PortfolioIndustry {
  PortfolioIndustry({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.accentColor,
    required this.gradient,
    required this.specialties,
    required this.photos,
    required this.reels,
  });

  factory PortfolioIndustry.fromJson(Map<String, dynamic> json) {
    return PortfolioIndustry(
      id: (json['id'] ?? '').toString(),
      nameAr: (json['nameAr'] ?? '').toString(),
      nameEn: (json['nameEn'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
      accentColor: (json['accentColor'] ?? '#6F3FF5').toString(),
      gradient: (json['gradient'] ?? '').toString(),
      specialties: (json['specialties'] as List<dynamic>? ?? [])
          .map((e) => PortfolioSpecialty.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => PortfolioMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      reels: (json['reels'] as List<dynamic>? ?? [])
          .map((e) => PortfolioMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String accentColor;
  final String gradient;
  final List<PortfolioSpecialty> specialties;
  final List<PortfolioMedia> photos;
  final List<PortfolioMedia> reels;
}

class PortfolioSpecialty {
  PortfolioSpecialty({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.accentColor,
    required this.photos,
    required this.reels,
  });

  factory PortfolioSpecialty.fromJson(Map<String, dynamic> json) {
    return PortfolioSpecialty(
      id: (json['id'] ?? '').toString(),
      nameAr: (json['nameAr'] ?? '').toString(),
      nameEn: (json['nameEn'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
      accentColor: (json['accentColor'] ?? '#6F3FF5').toString(),
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => PortfolioMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      reels: (json['reels'] as List<dynamic>? ?? [])
          .map((e) => PortfolioMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String accentColor;
  final List<PortfolioMedia> photos;
  final List<PortfolioMedia> reels;
}

class PortfolioMedia {
  PortfolioMedia({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.thumbnail,
    required this.galleryImages,
    required this.videoUrl,
    required this.tagAr,
    required this.tagEn,
    required this.accentColor,
    required this.gradient,
  });

  factory PortfolioMedia.fromJson(Map<String, dynamic> json) {
    return PortfolioMedia(
      id: (json['id'] as num? ?? 0).toInt(),
      titleAr: (json['titleAr'] ?? '').toString(),
      titleEn: (json['titleEn'] ?? '').toString(),
      descAr: (json['descAr'] ?? '').toString(),
      descEn: (json['descEn'] ?? '').toString(),
      thumbnail: (json['thumbnail'] ?? '').toString(),
      galleryImages: (json['galleryImages'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      videoUrl: (json['videoUrl'] ?? '').toString(),
      tagAr: (json['tagAr'] ?? '').toString(),
      tagEn: (json['tagEn'] ?? '').toString(),
      accentColor: (json['accentColor'] ?? '#6F3FF5').toString(),
      gradient: (json['gradient'] ?? '').toString(),
    );
  }

  final int id;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final String thumbnail;
  final List<String> galleryImages;
  final String videoUrl;
  final String tagAr;
  final String tagEn;
  final String accentColor;
  final String gradient;
}
