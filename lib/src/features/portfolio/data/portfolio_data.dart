// ignore_for_file: unnecessary_const

class PortfolioIndustry {
  const PortfolioIndustry(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.icon,
      required this.accentColor,
      required this.specialties,
      required this.photos,
      required this.reels});
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String accentColor;
  final List<PortfolioSpecialty> specialties;
  final List<PortfolioMedia> photos;
  final List<PortfolioMedia> reels;
}

class PortfolioSpecialty {
  const PortfolioSpecialty(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.icon,
      required this.accentColor,
      required this.photos,
      required this.reels});
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String accentColor;
  final List<PortfolioMedia> photos;
  final List<PortfolioMedia> reels;
}

class PortfolioMedia {
  const PortfolioMedia(
      {required this.id,
      required this.titleAr,
      required this.titleEn,
      required this.descAr,
      required this.descEn,
      required this.thumbnail,
      required this.galleryImages,
      required this.videoUrl,
      required this.tagAr,
      required this.tagEn,
      required this.accentColor});
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
}

const portfolioIndustries = <PortfolioIndustry>[
  PortfolioIndustry(
      id: 'legal',
      nameAr: 'المحامون',
      nameEn: 'lawyers',
      icon: 'fa-balance-scale',
      accentColor: '#C9A84C',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/1.jpg',
            galleryImages: const ['projects/photos/lawyers/1.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 2,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/2.jpg',
            galleryImages: const ['projects/photos/lawyers/2.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 3,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/3.jpg',
            galleryImages: const ['projects/photos/lawyers/3.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 4,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/4.jpg',
            galleryImages: const ['projects/photos/lawyers/4.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 5,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/5.jpg',
            galleryImages: const ['projects/photos/lawyers/5.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 6,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/6.jpg',
            galleryImages: const ['projects/photos/lawyers/6.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 7,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/7.jpg',
            galleryImages: const ['projects/photos/lawyers/7.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 8,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/8.jpg',
            galleryImages: const ['projects/photos/lawyers/8.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 9,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/9.jpg',
            galleryImages: const ['projects/photos/lawyers/9.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 10,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/10.jpg',
            galleryImages: const ['projects/photos/lawyers/10.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 11,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/11.jpg',
            galleryImages: const ['projects/photos/lawyers/11.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
        PortfolioMedia(
            id: 12,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم سوشيال ميديا لمكتب محاماة',
            descEn: 'Social media design for law firm',
            thumbnail: 'projects/photos/lawyers/12.jpg',
            galleryImages: const ['projects/photos/lawyers/12.jpg'],
            videoUrl: '',
            tagAr: 'سوشيال ميديا',
            tagEn: 'Social Media',
            accentColor: '#C9A84C'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز عيادة الأسنان',
            titleEn: 'Dental Clinic Reel',
            descAr: 'فيديو ترويجي لعيادة أسنان',
            descEn: 'Promotional video for dental clinic',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/2.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#4ECDC4'),
      ]),
  PortfolioIndustry(
      id: 'medical',
      nameAr: 'المجال الطبي',
      nameEn: 'Medical Field',
      icon: 'fa-heartbeat',
      accentColor: '#4ECDC4',
      specialties: const [
        PortfolioSpecialty(
            id: 'dentistry',
            nameAr: 'طب الأسنان',
            nameEn: 'Dentistry',
            icon: 'fa-tooth',
            accentColor: '#4ECDC4',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/medical/Dentistry/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dentistry/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/1.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'dermatology',
            nameAr: 'الأمراض الجلدية والتجميل',
            nameEn: 'Dermatology & Aesthetics',
            icon: 'fa-spa',
            accentColor: '#F7B2BD',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Dermatology & Aesthetics/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Dermatology & Aesthetics/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/7.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'surgery',
            nameAr: 'الجراحة',
            nameEn: 'Surgery',
            icon: 'fa-user-md',
            accentColor: '#60A5FA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Surgery/11.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Surgery/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/3.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'veterinary',
            nameAr: 'الطب البيطري',
            nameEn: 'Veterinary',
            icon: 'fa-paw',
            accentColor: '#6EE7B7',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Veterinary/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Veterinary/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/8.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'psychiatry',
            nameAr: 'الطب النفسي',
            nameEn: 'Psychiatry',
            icon: 'fa-brain',
            accentColor: '#C084FC',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Psychiatry/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Psychiatry/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/9.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'physiotherapy',
            nameAr: 'العلاج الطبيعي',
            nameEn: 'Physiotherapy',
            icon: 'fa-hands',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Physiotherapy/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Physiotherapy/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/10.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'cardiology',
            nameAr: 'أمراض القلب',
            nameEn: 'Cardiology',
            icon: 'fa-heart',
            accentColor: '#F87171',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Cardiology/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Cardiology/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/11.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'obstetrics',
            nameAr: 'أمراض النساء والتوليد',
            nameEn: 'Obstetrics & Gynecology',
            icon: 'fa-baby',
            accentColor: '#F9A8D4',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/11.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Obstetrics & Gynecology/12.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Obstetrics & Gynecology/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/12.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'orthopedics',
            nameAr: 'جراحة العظام',
            nameEn: 'Orthopedic Surgery',
            icon: 'fa-bone',
            accentColor: '#FCD34D',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Orthopedic Surgery/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Orthopedic Surgery/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Orthopedic Surgery/11.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Orthopedic Surgery/12.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Orthopedic Surgery/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/13.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'pediatrics',
            nameAr: 'طب الأطفال',
            nameEn: 'Pediatrics',
            icon: 'fa-child',
            accentColor: '#86EFAC',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Pediatrics/11.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Pediatrics/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/14.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'nutrition',
            nameAr: 'التغذية العلاجية',
            nameEn: 'Clinical Nutrition',
            icon: 'fa-apple-alt',
            accentColor: '#A3E635',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/1.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/2.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/3.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/4.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/5.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/6.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/7.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/8.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail: 'projects/photos/medical/Clinical Nutrition/9.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'كلينيك غلو',
                  titleEn: 'Glow Clinic',
                  descAr: 'محتوى احترافي لعيادة تجميل',
                  descEn: 'Professional content for aesthetics clinic',
                  thumbnail:
                      'projects/photos/medical/Clinical Nutrition/10.jpg',
                  galleryImages: const [
                    'projects/photos/medical/Clinical Nutrition/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال ميديا',
                  tagEn: 'Social Media',
                  accentColor: '#F7B2BD'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/15.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'furniture-home',
      nameAr: 'الأثاث والموبليا',
      nameEn: 'Furniture & Home',
      icon: 'fa-couch',
      accentColor: '#D4AF37',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/1.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/1.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 2,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/2.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/2.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 3,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/3.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/3.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 4,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/4.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/4.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 5,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/5.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/5.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 6,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/6.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/6.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 7,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/7.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/7.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 8,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/8.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/8.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 9,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/9.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/9.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 10,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Furniture & Home/10.jpg',
            galleryImages: const ['projects/photos/Furniture & Home/10.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز عيادة الأسنان',
            titleEn: 'Dental Clinic Reel',
            descAr: 'فيديو ترويجي لعيادة أسنان',
            descEn: 'Promotional video for dental clinic',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/4.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#4ECDC4'),
      ]),
  PortfolioIndustry(
      id: 'commercial',
      nameAr: 'الأنشطة التجارية',
      nameEn: 'Commercial Activities',
      icon: 'fa-shopping-bag',
      accentColor: '#A78BFA',
      specialties: const [
        PortfolioSpecialty(
            id: 'furniture-retail',
            nameAr: 'الأثاث',
            nameEn: 'Furniture',
            icon: 'fa-couch',
            accentColor: '#D4AF37',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/1.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/2.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/3.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/4.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/5.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/6.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/7.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/8.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/9.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/10.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Furniture/11.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Furniture/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/17.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'electronics',
            nameAr: 'الإلكترونيات',
            nameEn: 'Electronics',
            icon: 'fa-laptop',
            accentColor: '#93C5FD',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/1.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/2.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/3.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/4.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/5.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/6.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/7.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/8.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/9.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Electronics/10.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Electronics/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/16.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'perfumes',
            nameAr: 'العطور',
            nameEn: 'Perfumes',
            icon: 'fa-flask',
            accentColor: '#FDE68A',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/1.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/2.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/3.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/4.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/5.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/6.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/7.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/8.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/9.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Perfumes/10.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Perfumes/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/18.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'fashion',
            nameAr: 'الأزياء',
            nameEn: 'Fashion',
            icon: 'fa-tshirt',
            accentColor: '#A78BFA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/1.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/2.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/3.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/4.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/5.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/6.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/7.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/8.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/9.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Fashion/10.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Fashion/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'Deva Hair Extension',
                  titleEn: 'Deva Hair Extension',
                  descAr: 'فيلم إعلاني يعكس هوية ماركة عناية بالشعر',
                  descEn:
                      'Brand film reflecting luxury hair extension identity',
                  thumbnail: 'projects/photos/2/part_2.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/19.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#A78BFA'),
            ]),
        PortfolioSpecialty(
            id: 'handmade',
            nameAr: 'الأشغال اليدوية',
            nameEn: 'Handmade Products',
            icon: 'fa-paint-brush',
            accentColor: '#6EE7B7',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/1.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/2.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/3.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/4.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/5.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/6.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/7.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/8.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/9.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Handmade Products/10.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Handmade Products/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'Deva Hair Extension',
                  titleEn: 'Deva Hair Extension',
                  descAr: 'فيلم إعلاني يعكس هوية ماركة عناية بالشعر',
                  descEn:
                      'Brand film reflecting luxury hair extension identity',
                  thumbnail: 'projects/photos/2/part_2.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/20.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#A78BFA'),
            ]),
        PortfolioSpecialty(
            id: 'skincare-products',
            nameAr: 'العناية بالبشرة ومستحضرات التجميل',
            nameEn: 'Skincare & Cosmetics',
            icon: 'fa-magic',
            accentColor: '#FBCFE8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/1.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/2.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/3.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/4.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/5.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/6.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/7.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/8.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/9.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Commercial Activities/Skincare & Cosmetics/10.jpg',
                  galleryImages: const [
                    'projects/photos/Commercial Activities/Skincare & Cosmetics/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'Deva Hair Extension',
                  titleEn: 'Deva Hair Extension',
                  descAr: 'فيلم إعلاني يعكس هوية ماركة عناية بالشعر',
                  descEn:
                      'Brand film reflecting luxury hair extension identity',
                  thumbnail: 'projects/photos/2/part_2.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/21.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#A78BFA'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'education',
      nameAr: 'التعليم والتدريب',
      nameEn: 'Education & Training',
      icon: 'fa-graduation-cap',
      accentColor: '#38BDF8',
      specialties: const [
        PortfolioSpecialty(
            id: 'teaching',
            nameAr: 'التعليم والتدريس',
            nameEn: 'Teaching & Education',
            icon: 'fa-chalkboard-teacher',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/1.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/2.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/3.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/4.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/5.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/6.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/7.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/8.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/9.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/10.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/11.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Teaching & Education/12.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Teaching & Education/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/6.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'online-courses',
            nameAr: 'كورسات أونلاين',
            nameEn: 'Online Courses',
            icon: 'fa-laptop-code',
            accentColor: '#A78BFA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/1.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/2.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/3.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/4.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/5.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/6.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/7.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/8.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/9.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Education & Training/Online Courses/10.jpg',
                  galleryImages: const [
                    'projects/photos/Education & Training/Online Courses/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'Deva Hair Extension',
                  titleEn: 'Deva Hair Extension',
                  descAr: 'فيلم إعلاني يعكس هوية ماركة عناية بالشعر',
                  descEn:
                      'Brand film reflecting luxury hair extension identity',
                  thumbnail: 'projects/photos/2/part_2.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/22.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#A78BFA'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'swimming',
      nameAr: 'الأنشطة الرياضية (السباحة)',
      nameEn: 'Sports Activities (Swimming)',
      icon: 'fa-swimming-pool',
      accentColor: '#06B6D4',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/2.jpg',
            galleryImages: const ['projects/photos/Sports Activities/2.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 2,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/3.jpg',
            galleryImages: const ['projects/photos/Sports Activities/3.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 3,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/4.jpg',
            galleryImages: const ['projects/photos/Sports Activities/4.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 4,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/5.jpg',
            galleryImages: const ['projects/photos/Sports Activities/5.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 5,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/6.jpg',
            galleryImages: const ['projects/photos/Sports Activities/6.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 6,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/7.jpg',
            galleryImages: const ['projects/photos/Sports Activities/7.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 7,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/8.jpg',
            galleryImages: const ['projects/photos/Sports Activities/8.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 8,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/9.jpg',
            galleryImages: const ['projects/photos/Sports Activities/9.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
        PortfolioMedia(
            id: 9,
            titleAr: 'عيادة سمايل كير',
            titleEn: 'Smile Care Clinic',
            descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
            descEn:
                'Full brand identity & social media management for dental clinic',
            thumbnail: 'projects/photos/Sports Activities/10.jpg',
            galleryImages: const ['projects/photos/Sports Activities/10.jpg'],
            videoUrl: '',
            tagAr: 'هوية بصرية',
            tagEn: 'Branding',
            accentColor: '#4ECDC4'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز عيادة الأسنان',
            titleEn: 'Dental Clinic Reel',
            descAr: 'فيديو ترويجي لعيادة أسنان',
            descEn: 'Promotional video for dental clinic',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/23.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#4ECDC4'),
      ]),
  PortfolioIndustry(
      id: 'realestate',
      nameAr: 'العقارات',
      nameEn: 'Real Estate',
      icon: 'fa-building',
      accentColor: '#D4AF37',
      specialties: const [
        PortfolioSpecialty(
            id: 'finishing',
            nameAr: 'التشطيبات',
            nameEn: 'Finishing & Renovation',
            icon: 'fa-paint-roller',
            accentColor: '#FB923C',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/1.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/2.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/3.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/4.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/5.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/6.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/7.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/8.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/9.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/10.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/11.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Finishing & Renovation/12.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Finishing & Renovation/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/24.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'apartments',
            nameAr: 'الشقق السكنية',
            nameEn: 'Apartments',
            icon: 'fa-home',
            accentColor: '#D4AF37',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/1.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/2.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/3.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/4.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/5.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/6.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/7.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/8.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/9.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Apartments/10.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Apartments/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/25.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'villas',
            nameAr: 'الفيلات',
            nameEn: 'Villas',
            icon: 'fa-house-user',
            accentColor: '#FCD34D',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/1.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/2.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/3.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/4.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/5.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/6.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/7.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/8.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/9.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Real Estate/Villas/10.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Villas/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/26.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'compounds',
            nameAr: 'المشروعات السكنية',
            nameEn: 'Residential Projects',
            icon: 'fa-city',
            accentColor: '#60A5FA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/1.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/2.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/3.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/4.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/5.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/6.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/7.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/8.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/9.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/10.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/11.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Real Estate/Residential Projects/12.jpg',
                  galleryImages: const [
                    'projects/photos/Real Estate/Residential Projects/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/27.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'fitness',
      nameAr: 'اللياقة البدنية والرياضة',
      nameEn: 'Fitness & Sports',
      icon: 'fa-dumbbell',
      accentColor: '#4ADE80',
      specialties: const [
        PortfolioSpecialty(
            id: 'academies',
            nameAr: 'أكاديميات رياضية',
            nameEn: 'Sports Academies',
            icon: 'fa-trophy',
            accentColor: '#D4AF37',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/1.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/2.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/3.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/4.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/5.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/6.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/7.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/8.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/9.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Sports Academies/10.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Sports Academies/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/28.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'gyms',
            nameAr: 'الجيم (صالات رياضية)',
            nameEn: 'Gyms & Fitness Centers',
            icon: 'fa-dumbbell',
            accentColor: '#4ADE80',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/1.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/2.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/3.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/4.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/5.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/6.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/7.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/8.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/9.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/10.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Gyms & Fitness Centers/11.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Gyms & Fitness Centers/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/29.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'supplements',
            nameAr: 'المكملات الغذائية',
            nameEn: 'Supplements',
            icon: 'fa-pills',
            accentColor: '#A78BFA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/1.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/2.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/3.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/4.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/5.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/6.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/7.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/8.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/9.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Supplements/10.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Supplements/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/30.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'yoga',
            nameAr: 'اليوغا',
            nameEn: 'Yoga',
            icon: 'fa-yin-yang',
            accentColor: '#F9A8D4',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/1.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/2.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/3.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/4.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/5.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/6.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/7.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/8.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/9.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Fitness & Sports/Yoga/10.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Yoga/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/31.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'online-trainers',
            nameAr: 'مدربين أونلاين',
            nameEn: 'Online Trainers',
            icon: 'fa-user-tie',
            accentColor: '#FCD34D',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/1.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/2.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/3.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/4.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/5.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/6.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/7.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/8.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/9.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Fitness & Sports/Online Trainers/10.jpg',
                  galleryImages: const [
                    'projects/photos/Fitness & Sports/Online Trainers/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/32.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'fnb',
      nameAr: 'المطاعم والكافيهات',
      nameEn: 'Restaurants & Cafés',
      icon: 'fa-utensils',
      accentColor: '#FB923C',
      specialties: const [
        PortfolioSpecialty(
            id: 'home-food',
            nameAr: 'الأكل البيتي',
            nameEn: 'Home-cooked Food',
            icon: 'fa-home',
            accentColor: '#FCD34D',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/1.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/2.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/3.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/4.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/5.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/6.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/7.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/8.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/9.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/10.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Home-cooked Food/11.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Home-cooked Food/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/41.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'healthy-food',
            nameAr: 'الأكل الصحي',
            nameEn: 'Healthy Food',
            icon: 'fa-seedling',
            accentColor: '#86EFAC',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/1.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/2.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/3.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/4.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/5.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/6.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/7.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/8.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/9.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Healthy Food/10.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Healthy Food/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/42.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'desserts',
            nameAr: 'الحلويات والمخبوزات',
            nameEn: 'Desserts & Bakeries',
            icon: 'fa-birthday-cake',
            accentColor: '#F9A8D4',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/1.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/2.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/3.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/4.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/5.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/6.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/7.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/8.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/9.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/10.png',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/10.png'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/11.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Desserts & Bakeries/12.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Desserts & Bakeries/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/43.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'restaurants',
            nameAr: 'المطاعم',
            nameEn: 'Restaurants',
            icon: 'fa-hamburger',
            accentColor: '#FB923C',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/1.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/2.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/3.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/4.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/5.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/6.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/7.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/8.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/9.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/10.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/11.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Restaurants & Cafés/Restaurants/12.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Restaurants/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'Float Corner',
                  titleEn: 'Float Corner',
                  descAr: 'ريلز إبداعي لماركة فلوت كورنر',
                  descEn: 'Creative reel for Float Corner brand',
                  thumbnail: 'projects/photos/3/part_3.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/49.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#FB923C'),
            ]),
        PortfolioSpecialty(
            id: 'cafes',
            nameAr: 'الكافيهات',
            nameEn: 'Cafés',
            icon: 'fa-coffee',
            accentColor: '#D4AF37',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/1.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/2.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/3.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/4.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/5.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/6.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/7.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/8.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/9.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/10.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/11.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/Restaurants & Cafés/Cafés/12.jpg',
                  galleryImages: const [
                    'projects/photos/Restaurants & Cafés/Cafés/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'Float Corner',
                  titleEn: 'Float Corner',
                  descAr: 'ريلز إبداعي لماركة فلوت كورنر',
                  descEn: 'Creative reel for Float Corner brand',
                  thumbnail: 'projects/photos/3/part_3.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/50.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#FB923C'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'logistics',
      nameAr: 'الخدمات اللوجستية والتوصيل',
      nameEn: 'Logistics & Delivery Services',
      icon: 'fa-truck',
      accentColor: '#FACC15',
      specialties: const [
        PortfolioSpecialty(
            id: 'courier',
            nameAr: 'خدمات الشحن',
            nameEn: 'Courier Services',
            icon: 'fa-box',
            accentColor: '#FACC15',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/1.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/2.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/3.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/4.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/5.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/6.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/7.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/8.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/9.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Courier Services/10.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Courier Services/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/33.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'last-mile',
            nameAr: 'التوصيل للميل الأخير',
            nameEn: 'Last-Mile Delivery',
            icon: 'fa-shipping-fast',
            accentColor: '#FB923C',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/1.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/2.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/3.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/4.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/5.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/6.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/7.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Last-Mile Delivery/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/34.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'shipping',
            nameAr: 'شركات الشحن',
            nameEn: 'Shipping Companies',
            icon: 'fa-truck-loading',
            accentColor: '#60A5FA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/1.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/2.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/3.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/4.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/5.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/6.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/7.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/8.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/9.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Logistics & Delivery Services/Shipping Companies/10.jpg',
                  galleryImages: const [
                    'projects/photos/Logistics & Delivery Services/Shipping Companies/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/35.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'automotive',
      nameAr: 'السيارات',
      nameEn: 'Automotive',
      icon: 'fa-car',
      accentColor: '#94A3B8',
      specialties: const [
        PortfolioSpecialty(
            id: 'car-care',
            nameAr: 'العناية بالسيارات (تلميع – نانو سيراميك)',
            nameEn: 'Car Care (Detailing & Nano Ceramic)',
            icon: 'fa-tint',
            accentColor: '#4ADE80',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/1.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/2.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/3.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/4.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/5.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/9.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/10.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/11.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/13.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Care (Detailing  Nano Ceramic)/13.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/51.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'dealerships',
            nameAr: 'معارض سيارات',
            nameEn: 'Car Dealerships',
            icon: 'fa-car-alt',
            accentColor: '#94A3B8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/1.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/2.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/3.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/4.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/5.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/6.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/7.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/8.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/9.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Car Dealerships/10.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Car Dealerships/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/53.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'service-centers',
            nameAr: 'مراكز صيانة',
            nameEn: 'Service Centers',
            icon: 'fa-wrench',
            accentColor: '#FB923C',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/1.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/2.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/3.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/4.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/5.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/6.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/7.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/8.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail: 'projects/photos/cars/Service Centers/9.jpg',
                  galleryImages: const [
                    'projects/photos/cars/Service Centers/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/52.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'beauty',
      nameAr: 'الجمال والعناية الشخصية',
      nameEn: 'Beauty & Personal Care',
      icon: 'fa-magic',
      accentColor: '#F472B6',
      specialties: const [
        PortfolioSpecialty(
            id: 'beauty-products',
            nameAr: 'منتجات التجميل',
            nameEn: 'Beauty Products',
            icon: 'fa-gift',
            accentColor: '#86EFAC',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/1.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/2.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/3.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/4.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/5.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/6.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/7.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/8.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/9.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/10.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/beauty products/11.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/beauty products/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/36.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'salons',
            nameAr: 'صالونات التجميل',
            nameEn: 'Beauty Salons',
            icon: 'fa-cut',
            accentColor: '#F472B6',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/1.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/2.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/3.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/4.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/5.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/6.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/7.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/8.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/9.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Beauty Salons/10.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Beauty Salons/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/37.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'laser',
            nameAr: 'عيادات الليزر',
            nameEn: 'Laser Clinics',
            icon: 'fa-star',
            accentColor: '#C084FC',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/1.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/2.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/3.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/4.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/5.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/6.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/7.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/8.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/9.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/10.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Laser Clinics/11.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Laser Clinics/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/38.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'makeup',
            nameAr: 'ميك أب أرتيست',
            nameEn: 'Makeup Artists',
            icon: 'fa-paint-brush',
            accentColor: '#FBCFE8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/1.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/2.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/3.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/4.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/5.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/6.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/7.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/8.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/9.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/10.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/11.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/12.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 13,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Makeup Artists/13.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Makeup Artists/13.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/40.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'skincare-clinics',
            nameAr: 'عيادات العناية بالبشرة',
            nameEn: 'Skincare Clinics',
            icon: 'fa-spa',
            accentColor: '#D4AF37',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/1.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/2.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/3.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/4.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/5.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/6.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/7.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/8.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/9.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/10.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Beauty & Personal Care/Skincare Clinics/11.jpg',
                  galleryImages: const [
                    'projects/photos/Beauty & Personal Care/Skincare Clinics/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/39.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'travel',
      nameAr: 'السفر والسياحة',
      nameEn: 'Travel & Tourism',
      icon: 'fa-plane',
      accentColor: '#06B6D4',
      specialties: const [
        PortfolioSpecialty(
            id: 'domestic',
            nameAr: 'السفر المحلي',
            nameEn: 'Domestic Travel',
            icon: 'fa-map-marked-alt',
            accentColor: '#06B6D4',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/1.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/2.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/3.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/4.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/5.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/6.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/7.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/8.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/9.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Domestic Travel/10.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Domestic Travel/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/44.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'hajj',
            nameAr: 'الحج والعمرة',
            nameEn: 'Hajj & Umrah',
            icon: 'fa-kaaba',
            accentColor: '#D4AF37',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/1.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/2.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/3.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/4.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/5.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/6.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/7.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/8.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/9.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Hajj & Umrah/10.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Hajj & Umrah/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/47.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'tour-operators',
            nameAr: 'شركات السياحة',
            nameEn: 'Tour Operators',
            icon: 'fa-route',
            accentColor: '#4ADE80',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/1.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/2.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/3.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/4.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/5.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/6.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/7.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/8.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/9.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/10.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/11.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 12,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Tour Operators/12.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Tour Operators/12.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/46.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'agencies',
            nameAr: 'مكاتب السفر',
            nameEn: 'Travel Agencies',
            icon: 'fa-suitcase',
            accentColor: '#A78BFA',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/1.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/2.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/3.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/4.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/5.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/6.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/7.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/8.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/9.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/10.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/Travel Agencies/11.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/Travel Agencies/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/45.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
        PortfolioSpecialty(
            id: 'international',
            nameAr: 'السفر الدولي',
            nameEn: 'International Travel',
            icon: 'fa-globe',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/1.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/2.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/3.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/4.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/5.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/6.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/7.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/8.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/9.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/10.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'عيادة سمايل كير',
                  titleEn: 'Smile Care Clinic',
                  descAr: 'هوية بصرية متكاملة وإدارة سوشيال ميديا لعيادة أسنان',
                  descEn:
                      'Full brand identity & social media management for dental clinic',
                  thumbnail:
                      'projects/photos/Travel & Tourism/International Travel/11.jpg',
                  galleryImages: const [
                    'projects/photos/Travel & Tourism/International Travel/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'هوية بصرية',
                  tagEn: 'Branding',
                  accentColor: '#4ECDC4'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز عيادة الأسنان',
                  titleEn: 'Dental Clinic Reel',
                  descAr: 'فيديو ترويجي لعيادة أسنان',
                  descEn: 'Promotional video for dental clinic',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/48.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#4ECDC4'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'media-production',
      nameAr: 'الإعلام والإنتاج',
      nameEn: 'Media & Production',
      icon: 'fa-video',
      accentColor: '#E040FB',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/1.jpeg',
            galleryImages: const ['projects/photos/Media & Production/1.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 2,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/2.jpeg',
            galleryImages: const ['projects/photos/Media & Production/2.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 3,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/3.jpeg',
            galleryImages: const ['projects/photos/Media & Production/3.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 4,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/4.jpeg',
            galleryImages: const ['projects/photos/Media & Production/4.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 5,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/5.jpeg',
            galleryImages: const ['projects/photos/Media & Production/5.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 6,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/6.jpeg',
            galleryImages: const ['projects/photos/Media & Production/6.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 7,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/7.jpeg',
            galleryImages: const ['projects/photos/Media & Production/7.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 8,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/8.jpeg',
            galleryImages: const ['projects/photos/Media & Production/8.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 9,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/9.jpeg',
            galleryImages: const ['projects/photos/Media & Production/9.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 10,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/10.jpeg',
            galleryImages: const ['projects/photos/Media & Production/10.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
        PortfolioMedia(
            id: 11,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تطوير موقع إلكتروني',
            descEn: 'Website development',
            thumbnail: 'projects/photos/Media & Production/11.jpeg',
            galleryImages: const ['projects/photos/Media & Production/11.jpeg'],
            videoUrl: '',
            tagAr: 'مواقع',
            tagEn: 'Web',
            accentColor: '#00E676'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/55.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
      ]),
  PortfolioIndustry(
      id: 'tech-programming',
      nameAr: 'التكنولوجيا والبرمجة',
      nameEn: 'Technology & Programming',
      icon: 'fa-code',
      accentColor: '#00E676',
      specialties: const [
        PortfolioSpecialty(
            id: 'web-dev',
            nameAr: 'تطوير المواقع',
            nameEn: 'Web Development',
            icon: 'fa-globe',
            accentColor: '#00E676',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/Web Development/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Web Development/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/58.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'app-dev',
            nameAr: 'تطوير التطبيقات',
            nameEn: 'App Development',
            icon: 'fa-mobile-alt',
            accentColor: '#00E676',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تطوير موقع إلكتروني',
                  descEn: 'Website development',
                  thumbnail:
                      'projects/photos/Technology & Programming/App Development/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/App Development/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'مواقع',
                  tagEn: 'Web',
                  accentColor: '#00E676'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/57.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'cybersecurity',
            nameAr: 'الأمن السيبراني',
            nameEn: 'Cybersecurity',
            icon: 'fa-shield-alt',
            accentColor: '#00E676',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حلول أمن سيبراني',
                  descEn: 'Cybersecurity solutions',
                  thumbnail:
                      'projects/photos/Technology & Programming/Cybersecurity/11.jpeg',
                  galleryImages: const [
                    'projects/photos/Technology & Programming/Cybersecurity/11.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'أمن',
                  tagEn: 'Security',
                  accentColor: '#00E676'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/59.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'design-creative',
      nameAr: 'التصميم والإبداع',
      nameEn: 'Design & Creative',
      icon: 'fa-paint-brush',
      accentColor: '#FF6D00',
      specialties: const [
        PortfolioSpecialty(
            id: 'graphic-design',
            nameAr: 'الجرافيك ديزاين',
            nameEn: 'Graphic Design',
            icon: 'fa-bezier-curve',
            accentColor: '#FF6D00',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم جرافيك احترافي',
                  descEn: 'Professional graphic design',
                  thumbnail:
                      'projects/photos/Design & Creative/Graphic Design/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Graphic Design/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'جرافيك',
                  tagEn: 'Graphic',
                  accentColor: '#FF6D00'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/60.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'ui-ux',
            nameAr: 'تصميم UI/UX',
            nameEn: 'UI/UX Design',
            icon: 'fa-layer-group',
            accentColor: '#FF6D00',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم واجهات مستخدم',
                  descEn: 'User interface design',
                  thumbnail:
                      'projects/photos/Design & Creative/UIUX Design/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/UIUX Design/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'UI/UX',
                  tagEn: 'UI/UX',
                  accentColor: '#FF6D00'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/61.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'motion-graphics',
            nameAr: 'الموشن جرافيك',
            nameEn: 'Motion Graphics',
            icon: 'fa-magic',
            accentColor: '#FF6D00',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'موشن جرافيك احترافي',
                  descEn: 'Professional motion graphics',
                  thumbnail:
                      'projects/photos/Design & Creative/Motion Graphics/11.jpeg',
                  galleryImages: const [
                    'projects/photos/Design & Creative/Motion Graphics/11.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'موشن',
                  tagEn: 'Motion',
                  accentColor: '#FF6D00'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/62.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'marketing-advertising',
      nameAr: 'التسويق والإعلان',
      nameEn: 'Marketing & Advertising',
      icon: 'fa-bullhorn',
      accentColor: '#FF4081',
      specialties: const [
        PortfolioSpecialty(
            id: 'digital-marketing',
            nameAr: 'التسويق الرقمي',
            nameEn: 'Digital Marketing',
            icon: 'fa-chart-line',
            accentColor: '#FF4081',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'حملة تسويق رقمي',
                  descEn: 'Digital marketing campaign',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Digital Marketing/11.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Digital Marketing/11.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تسويق',
                  tagEn: 'Marketing',
                  accentColor: '#FF4081'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/65.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'social-media-management',
            nameAr: 'إدارة السوشيال ميديا',
            nameEn: 'Social Media Management',
            icon: 'fa-share-alt',
            accentColor: '#FF4081',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'إدارة حسابات سوشيال ميديا',
                  descEn: 'Social media accounts management',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Social Media Management/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Social Media Management/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'سوشيال',
                  tagEn: 'Social',
                  accentColor: '#FF4081'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/64.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'copywriting',
            nameAr: 'كتابة المحتوى',
            nameEn: 'Copywriting',
            icon: 'fa-pencil-alt',
            accentColor: '#FF4081',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'كتابة محتوى تسويقي',
                  descEn: 'Marketing copywriting',
                  thumbnail:
                      'projects/photos/Marketing & Advertising/Copywriting/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Marketing & Advertising/Copywriting/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'كتابة',
                  tagEn: 'Copy',
                  accentColor: '#FF4081'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/63.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'industry-production',
      nameAr: 'الصناعة والإنتاج',
      nameEn: 'Industry & Production',
      icon: 'fa-industry',
      accentColor: '#FFD600',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/1.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/1.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 2,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/2.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/2.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 3,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/3.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/3.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 4,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/4.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/4.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 5,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/5.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/5.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 6,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/6.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/6.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 7,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/7.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/7.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 8,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/8.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/8.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 9,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/9.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/9.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
        PortfolioMedia(
            id: 10,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'حملة تسويق رقمي',
            descEn: 'Digital marketing campaign',
            thumbnail: 'projects/photos/Industry & Production/10.jpeg',
            galleryImages: const [
              'projects/photos/Industry & Production/10.jpeg'
            ],
            videoUrl: '',
            tagAr: 'تسويق',
            tagEn: 'Marketing',
            accentColor: '#FF4081'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/66.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
        PortfolioMedia(
            id: 2,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/67.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
        PortfolioMedia(
            id: 3,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/68.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
      ]),
  PortfolioIndustry(
      id: 'hotels-hospitality',
      nameAr: 'الفنادق',
      nameEn: 'Hotels & Hospitality',
      icon: 'fa-hotel',
      accentColor: '#00BFFF',
      specialties: const [
        PortfolioSpecialty(
            id: 'hotel-management',
            nameAr: 'إدارة الفنادق',
            nameEn: 'Hotel Management',
            icon: 'fa-concierge-bell',
            accentColor: '#00BFFF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق خدمات إدارة الفنادق',
                  descEn: 'Hotel management marketing',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Hotel management marketing/11.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Hotel management marketing/11.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'فنادق',
                  tagEn: 'Hotels',
                  accentColor: '#00BFFF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز فندقي',
                  titleEn: 'Hotel Reel',
                  descAr: 'فيديو ترويجي لخدمات الفنادق',
                  descEn: 'Promotional hotel reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/92.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'front-office',
            nameAr: 'الاستقبال وخدمة العملاء',
            nameEn: 'Front Office & Guest Relations',
            icon: 'fa-user-tie',
            accentColor: '#00BFFF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تحسين تجربة النزلاء وخدمة العملاء',
                  descEn: 'Guest experience and service',
                  thumbnail:
                      'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Hotels & Hospitality/Front Office & Guest Relations/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'خدمة',
                  tagEn: 'Service',
                  accentColor: '#00BFFF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز استقبال',
                  titleEn: 'Reception Reel',
                  descAr: 'فيديو ترويجي لخدمة الاستقبال',
                  descEn: 'Front office promotional reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/91.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'carpentry',
      nameAr: 'النجارة',
      nameEn: 'Carpentry',
      icon: 'fa-hammer',
      accentColor: '#A0522D',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/1.jpeg',
            galleryImages: const ['projects/photos/Carpentry/1.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 2,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/2.jpeg',
            galleryImages: const ['projects/photos/Carpentry/2.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 3,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/3.jpeg',
            galleryImages: const ['projects/photos/Carpentry/3.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 4,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/4.jpeg',
            galleryImages: const ['projects/photos/Carpentry/4.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 5,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/5.jpeg',
            galleryImages: const ['projects/photos/Carpentry/5.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 6,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/6.jpeg',
            galleryImages: const ['projects/photos/Carpentry/6.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 7,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/7.jpeg',
            galleryImages: const ['projects/photos/Carpentry/7.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 8,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/8.jpeg',
            galleryImages: const ['projects/photos/Carpentry/8.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 9,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/9.jpeg',
            galleryImages: const ['projects/photos/Carpentry/9.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 10,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/10.jpeg',
            galleryImages: const ['projects/photos/Carpentry/10.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
        PortfolioMedia(
            id: 11,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تصميم وتنفيذ أثاث مخصص',
            descEn: 'Custom furniture design & execution',
            thumbnail: 'projects/photos/Carpentry/11.jpeg',
            galleryImages: const ['projects/photos/Carpentry/11.jpeg'],
            videoUrl: '',
            tagAr: 'أثاث',
            tagEn: 'Furniture',
            accentColor: '#A0522D'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز نجارة',
            titleEn: 'Carpentry Reel',
            descAr: 'فيديو لأعمال الصيانة',
            descEn: 'Repair work reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/93.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
      ]),
  PortfolioIndustry(
      id: 'security-protection',
      nameAr: 'الأمن والحماية',
      nameEn: 'Security & Protection',
      icon: 'fa-shield-alt',
      accentColor: '#FF1744',
      specialties: const [
        PortfolioSpecialty(
            id: 'surveillance-systems',
            nameAr: 'أنظمة المراقبة',
            nameEn: 'Surveillance Systems',
            icon: 'fa-video',
            accentColor: '#FF1744',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/1.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/2.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/3.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/4.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/5.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/6.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/7.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/8.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/9.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/10.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لأنظمة المراقبة',
                  descEn: 'Surveillance systems marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Surveillance Systems/11.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Surveillance Systems/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مراقبة',
                  tagEn: 'Surveillance',
                  accentColor: '#FF1744'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/76.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'occupational-safety',
            nameAr: 'السلامة المهنية',
            nameEn: 'Occupational Safety',
            icon: 'fa-user-shield',
            accentColor: '#FF1744',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/1.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/2.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/3.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/4.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/5.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/6.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/7.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/8.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/9.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق للسلامة المهنية',
                  descEn: 'Occupational safety marketing',
                  thumbnail:
                      'projects/photos/Security & Protection/Occupational Safety/10.jpg',
                  galleryImages: const [
                    'projects/photos/Security & Protection/Occupational Safety/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'سلامة',
                  tagEn: 'Safety',
                  accentColor: '#FF1744'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/75.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'home-services',
      nameAr: 'الخدمات المنزلية',
      nameEn: 'Home Services',
      icon: 'fa-home',
      accentColor: '#40C4FF',
      specialties: const [
        PortfolioSpecialty(
            id: 'home-cleaning',
            nameAr: 'التنظيف المنزلي',
            nameEn: 'Home Cleaning',
            icon: 'fa-broom',
            accentColor: '#40C4FF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات التنظيف',
                  descEn: 'Cleaning services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Cleaning/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Cleaning/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'تنظيف',
                  tagEn: 'Cleaning',
                  accentColor: '#40C4FF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/79.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'home-maintenance',
            nameAr: 'الصيانة المنزلية',
            nameEn: 'Home Maintenance',
            icon: 'fa-wrench',
            accentColor: '#40C4FF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/1.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/1.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/2.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/2.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/3.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/3.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/4.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/4.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/5.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/5.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/6.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/6.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/7.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/7.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/8.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/8.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/9.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/9.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الصيانة',
                  descEn: 'Maintenance services marketing',
                  thumbnail:
                      'projects/photos/Home Services/Home Maintenance/10.jpeg',
                  galleryImages: const [
                    'projects/photos/Home Services/Home Maintenance/10.jpeg'
                  ],
                  videoUrl: '',
                  tagAr: 'صيانة',
                  tagEn: 'Maintenance',
                  accentColor: '#40C4FF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/78.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'events-management',
      nameAr: 'تنظيم الفعاليات',
      nameEn: 'Events Management',
      icon: 'fa-calendar-alt',
      accentColor: '#B388FF',
      specialties: const [
        PortfolioSpecialty(
            id: 'parties',
            nameAr: 'تنظيم حفلات',
            nameEn: 'Party Planning',
            icon: 'fa-birthday-cake',
            accentColor: '#B388FF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/1.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/2.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/3.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/4.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/5.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/6.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/7.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/8.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/9.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتنظيم الحفلات',
                  descEn: 'Party planning marketing',
                  thumbnail:
                      'projects/photos/Events Management/Party Planning/10.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Party Planning/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'حفلات',
                  tagEn: 'Parties',
                  accentColor: '#B388FF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/81.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'conferences',
            nameAr: 'إدارة مؤتمرات',
            nameEn: 'Conference Management',
            icon: 'fa-microphone',
            accentColor: '#B388FF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/1.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/2.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/3.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/4.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/5.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/6.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/7.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/8.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لإدارة المؤتمرات',
                  descEn: 'Conference management marketing',
                  thumbnail:
                      'projects/photos/Events Management/Conference Management/9.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Conference Management/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مؤتمرات',
                  tagEn: 'Conferences',
                  accentColor: '#B388FF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/82.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'occasions-setup',
            nameAr: 'تجهيز المناسبات',
            nameEn: 'Occasions Setup',
            icon: 'fa-star',
            accentColor: '#B388FF',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/1.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/2.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/3.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/4.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/5.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/6.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/7.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/8.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/9.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لتجهيز المناسبات',
                  descEn: 'Occasions setup marketing',
                  thumbnail:
                      'projects/photos/Events Management/Occasions Setup/10.jpg',
                  galleryImages: const [
                    'projects/photos/Events Management/Occasions Setup/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مناسبات',
                  tagEn: 'Occasions',
                  accentColor: '#B388FF'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/83.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
  PortfolioIndustry(
      id: 'ecommerce',
      nameAr: 'التجارة الإلكترونية',
      nameEn: 'E-Commerce',
      icon: 'fa-shopping-cart',
      accentColor: '#1DE9B6',
      specialties: const [],
      photos: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/1.jpg',
            galleryImages: const ['projects/photos/E-Commerce/1.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 2,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/2.jpg',
            galleryImages: const ['projects/photos/E-Commerce/2.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 3,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/3.jpg',
            galleryImages: const ['projects/photos/E-Commerce/3.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 4,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/4.jpg',
            galleryImages: const ['projects/photos/E-Commerce/4.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 5,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/5.jpg',
            galleryImages: const ['projects/photos/E-Commerce/5.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 6,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/6.jpg',
            galleryImages: const ['projects/photos/E-Commerce/6.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 7,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/7.jpg',
            galleryImages: const ['projects/photos/E-Commerce/7.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 8,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/8.jpg',
            galleryImages: const ['projects/photos/E-Commerce/8.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 9,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/9.jpg',
            galleryImages: const ['projects/photos/E-Commerce/9.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
        PortfolioMedia(
            id: 10,
            titleAr: 'مشروع 1',
            titleEn: 'Project 1',
            descAr: 'تسويق للمتاجر الإلكترونية',
            descEn: 'Online store marketing',
            thumbnail: 'projects/photos/E-Commerce/10.jpg',
            galleryImages: const ['projects/photos/E-Commerce/10.jpg'],
            videoUrl: '',
            tagAr: 'متجر',
            tagEn: 'Store',
            accentColor: '#1DE9B6'),
      ],
      reels: const [
        PortfolioMedia(
            id: 1,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/84.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
        PortfolioMedia(
            id: 2,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/86.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
        PortfolioMedia(
            id: 3,
            titleAr: 'ريلز تصوير',
            titleEn: 'Photography Reel',
            descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
            descEn: 'Promotional photography reel',
            thumbnail: 'projects/photos/1/part_5.jpeg',
            galleryImages: const [],
            videoUrl: 'projects/reels/85.mp4',
            tagAr: 'ريلز',
            tagEn: 'Reel',
            accentColor: '#E040FB'),
      ]),
  PortfolioIndustry(
      id: 'engineering',
      nameAr: 'المهندسين',
      nameEn: 'Engineering',
      icon: 'fa-hard-hat',
      accentColor: '#38BDF8',
      specialties: const [
        PortfolioSpecialty(
            id: 'architecture',
            nameAr: 'الهندسة المعمارية',
            nameEn: 'Architecture',
            icon: 'fa-drafting-compass',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/1.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/2.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/3.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/4.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/5.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/6.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/7.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/8.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/9.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/10.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق لمشاريع معمارية',
                  descEn: 'Architecture project marketing',
                  thumbnail: 'projects/photos/Engineering/Architecture/11.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Architecture/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'معماري',
                  tagEn: 'Architecture',
                  accentColor: '#38BDF8'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/88.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'civil',
            nameAr: 'الهندسة المدنية',
            nameEn: 'Civil Engineering',
            icon: 'fa-building',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/1.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/2.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/3.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/4.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/5.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/6.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/7.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/8.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/9.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لمشاريع هندسية مدنية',
                  descEn: 'Civil engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Civil Engineering/10.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Civil Engineering/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'مدني',
                  tagEn: 'Civil',
                  accentColor: '#38BDF8'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/90.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'interior-design',
            nameAr: 'التصميم الداخلي',
            nameEn: 'Interior Design',
            icon: 'fa-couch',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/1.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/2.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/3.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/4.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/5.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/6.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/7.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/8.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/9.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/10.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 11,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تصميم وتسويق ديكورات داخلية',
                  descEn: 'Interior design marketing',
                  thumbnail:
                      'projects/photos/Engineering/Interior Design/11.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Interior Design/11.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'ديكور',
                  tagEn: 'Interior',
                  accentColor: '#38BDF8'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/87.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
        PortfolioSpecialty(
            id: 'electrical',
            nameAr: 'الهندسة الكهربائية',
            nameEn: 'Electrical Engineering',
            icon: 'fa-bolt',
            accentColor: '#38BDF8',
            photos: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/1.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/1.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 2,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/2.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/2.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 3,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/3.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/3.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 4,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/4.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/4.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 5,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/5.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/5.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 6,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/6.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/6.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 7,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/7.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/7.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 8,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/8.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/8.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 9,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/9.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/9.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
              PortfolioMedia(
                  id: 10,
                  titleAr: 'مشروع 1',
                  titleEn: 'Project 1',
                  descAr: 'تسويق لخدمات الهندسة الكهربائية',
                  descEn: 'Electrical engineering marketing',
                  thumbnail:
                      'projects/photos/Engineering/Electrical Engineering/10.jpg',
                  galleryImages: const [
                    'projects/photos/Engineering/Electrical Engineering/10.jpg'
                  ],
                  videoUrl: '',
                  tagAr: 'كهرباء',
                  tagEn: 'Electrical',
                  accentColor: '#38BDF8'),
            ],
            reels: const [
              PortfolioMedia(
                  id: 1,
                  titleAr: 'ريلز تصوير',
                  titleEn: 'Photography Reel',
                  descAr: 'فيديو ترويجي للتصوير الفوتوغرافي',
                  descEn: 'Promotional photography reel',
                  thumbnail: 'projects/photos/1/part_5.jpeg',
                  galleryImages: const [],
                  videoUrl: 'projects/reels/89.mp4',
                  tagAr: 'ريلز',
                  tagEn: 'Reel',
                  accentColor: '#E040FB'),
            ]),
      ],
      photos: const [],
      reels: const []),
];
