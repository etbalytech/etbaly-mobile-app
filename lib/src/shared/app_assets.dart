class AppAssets {
  AppAssets._();

  static const String _basePath = 'assets';
  static const String _iconsPath = '$_basePath/icons';
  static const String _imagesPath = '$_basePath/images';

  // SVGs
  static const String googleIcon = '$_iconsPath/google.svg';
  static const String facebookIcon = '$_iconsPath/facebook.svg';
  static const String appleIcon = '$_iconsPath/apple.svg';

  // Images
  static const String logo = '$_imagesPath/logo.png';
  static const String logo3d = '$_imagesPath/logo_3d.png';
  static const String airplaneLeft = '$_imagesPath/airplane-left.svg';
  static const String airplaneRight = '$_imagesPath/airplane-right.svg';
  static const String aboutCeo = '$_imagesPath/about/team/ceo.webp';
  static const String aboutVideoPoster = '$_imagesPath/about/about_img.webp';
  static const String contractPage1 = '$_imagesPath/about/contract/1.webp';
  static const String contractPage2 = '$_imagesPath/about/contract/2.webp';
  static const String aboutVideo = 'assets/videos/about/about_video.mp4';

  static String partnerLogo(int index) => '$_imagesPath/partners/$index.webp';
  static String stripImage(int index) => '$_imagesPath/strip/tab_$index.webp';
  static String teamMember(String fileName) =>
      '$_imagesPath/about/team/$fileName.webp';
}
