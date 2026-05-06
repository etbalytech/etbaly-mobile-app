import 'package:etbaly/src/imports/core_imports.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return EtbalyPage(
      children: [
        const EtbalyHero(
          badge: 'تواصل معنا',
          title: 'احك لنا عن مشروعك',
          description:
              'رد سريع، بيانات محمية، ودعم أونلاين طوال الوقت. اختر قناة التواصل المناسبة أو أرسل لنا نبذة سريعة من التطبيق.',
          icon: Icons.send,
          stats: [
            EtbalyStat(value: 'سريع', label: 'الرد'),
            EtbalyStat(value: '24/7', label: 'واتساب'),
            EtbalyStat(value: 'آمن', label: 'البيانات'),
          ],
        ),
        const EtbalyPageSectionHeader(
          badge: 'قنوات التواصل',
          title: 'تواصل مع اطبعلي مباشرة',
          description:
              'صفحة التواصل في الموقع تضم قنوات السوشيال، الفورم، مواعيد العمل، والخريطة. نفس الأقسام موجودة هنا بالعربية.',
        ),
        EtbalyInfoCard(
          title: 'واتساب',
          description:
              '+201010285020 - ابدأ محادثة مباشرة لمعرفة الأسعار والباقات وتفاصيل المشروع.',
          icon: Icons.chat,
          accent: const Color(0xFF25D366),
          trailing: Icon(Icons.open_in_new, color: colors.gold, size: 18),
          onTap: () => _open('https://wa.me/01010285020'),
        ),
        EtbalyInfoCard(
          title: 'البريد الإلكتروني',
          description:
              'etba3ly2022@gmail.com - أرسل نبذة مكتوبة أو ملفات أو طلبات رسمية.',
          icon: Icons.mail,
          accent: colors.info,
          trailing: Icon(Icons.open_in_new, color: colors.gold, size: 18),
          onTap: () => _open('mailto:etba3ly2022@gmail.com'),
        ),
        EtbalyInfoCard(
          title: 'قنوات السوشيال',
          description:
              'فيسبوك، إنستجرام، يوتيوب، تيك توك، وباقي القنوات العامة الموجودة في نسخة الويب.',
          icon: Icons.public,
          accent: colors.primaryLight,
        ),
        const EtbalyPageSectionHeader(
          badge: 'نبذة سريعة',
          title: 'ما الذي نحتاج معرفته؟',
          description:
              'الاسم، الواتساب، الدول المستهدفة، الباقة المختارة، حالة الهوية، التسويق الرقمي، الإعلانات، صور المنتجات، الموقع، ورسالتك.',
        ),
        EtbalyInfoCard(
          title: 'المكتب والزيارات',
          description:
              'المقر الرئيسي: الإسكندرية، مصر. مواعيد المكتب: من السبت إلى الخميس، من 12 ظهرا إلى 9 مساء. الدعم الأونلاين متاح دائما.',
          icon: Icons.location_on,
          accent: colors.gold,
          trailing: Icon(Icons.map, color: colors.gold, size: 20),
          onTap: () => _open('https://maps.google.com/?q=31.094632,29.753261'),
        ),
      ],
    );
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
