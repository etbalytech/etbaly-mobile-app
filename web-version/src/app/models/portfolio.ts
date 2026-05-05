export interface Photo {
  id: number;
  image: string;
  accentColor: string;
  gradient: string;
  titleAr: string;
  titleEn: string;
  catLabel: string;
  tagAr: string;
  tagEn: string;
  descAr: string;
  descEn: string;
  galleryImages: string[];
}

export interface Reel {
  id: number;
  thumbnail: string;
  accentColor: string;
  gradient: string;
  titleAr: string;
  titleEn: string;
  tagAr: string;
  tagEn: string;
  descAr: string;
  descEn: string;
  videoUrl: string;
}

export interface Specialty {
  id: string;
  nameAr: string;
  nameEn: string;
  icon: string;
  accentColor: string;
  photos: SpecialtyMedia[];
  reels: SpecialtyMedia[];
}

export interface SpecialtyMedia {
  id: number;
  titleAr: string;
  titleEn: string;
  descAr: string;
  descEn: string;
  thumbnail: string;
  galleryImages?: string[];
  videoUrl?: string;
  tagAr: string;
  tagEn: string;
  accentColor: string;
  gradient: string;
}

export interface Industry {
  id: string;
  nameAr: string;
  nameEn: string;
  icon: string;
  gradient: string;
  accentColor: string;
  specialties: Specialty[];
  photos?: SpecialtyMedia[];
  reels?: SpecialtyMedia[];
}
