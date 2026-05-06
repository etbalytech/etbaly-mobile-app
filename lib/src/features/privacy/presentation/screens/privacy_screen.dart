import 'package:etbaly/src/imports/core_imports.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Scaffold(
      backgroundColor: colors.bgMain,
      appBar: AppBar(
        backgroundColor: colors.bgCard,
        foregroundColor: colors.textMain,
        title: const Text('سياسة الخصوصية'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: const [
          EtbalyHero(
            badge: 'الخصوصية',
            title: 'بياناتك محمية معنا',
            description:
                'نتعامل مع بيانات العملاء باحترام ووضوح، ونستخدمها فقط للتواصل وتنفيذ الخدمات وتحسين تجربة العمل.',
            icon: Icons.privacy_tip,
          ),
          SizedBox(height: 18),
          EtbalyPageSectionHeader(
            badge: 'ما الذي نجمعه؟',
            title: 'بيانات التواصل وطلب الخدمة',
            description:
                'قد نحتاج إلى الاسم، رقم الهاتف أو الواتساب، البريد الإلكتروني، تفاصيل المشروع، والملفات التي يرسلها العميل لتنفيذ الخدمة.',
          ),
          SizedBox(height: 18),
          EtbalyInfoCard(
            title: 'الاستخدام',
            description:
                'تستخدم البيانات للتواصل، إعداد العروض، تنفيذ الخدمات، إرسال التقارير، وتحسين جودة الدعم.',
            icon: Icons.verified_user,
          ),
          SizedBox(height: 12),
          EtbalyInfoCard(
            title: 'الحماية',
            description:
                'لا نشارك بياناتك مع أطراف غير مرتبطة بالخدمة إلا عند الحاجة للتنفيذ أو الالتزام القانوني.',
            icon: Icons.lock,
          ),
        ],
      ),
    );
  }
}
