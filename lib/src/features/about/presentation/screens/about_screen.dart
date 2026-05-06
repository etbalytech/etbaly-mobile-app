import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return EtbalyPage(
      children: [
        const EtbalyHero(
          badge: 'عن اطبعلي',
          title: 'شريك نمو حقيقي، وليس مجرد مزود خدمة',
          description:
              'اطبعلي تحول أفكار الأعمال إلى نمو رقمي واضح من خلال الاستراتيجية والتصميم والمحتوى والإعلانات وتطوير الويب.',
          icon: Icons.people,
          stats: [
            EtbalyStat(value: '12+', label: 'سنة خبرة'),
            EtbalyStat(value: '+400K', label: 'أثر الأعمال'),
            EtbalyStat(value: '24/7', label: 'دعم أونلاين'),
          ],
        ),
        const EtbalyPageSectionHeader(
          badge: 'قصتنا',
          title: 'من فكرة إلى وكالة رائدة',
          description:
              'صفحة من نحن في الموقع تضم القصة، البورتفوليو، رسالة المدير التنفيذي، شفافية التعاقد، القيم، لماذا نحن، والفريق. نفس الرواية موجودة هنا بالعربية.',
        ),
        EtbalyInfoCard(
          title: 'مهمتنا',
          description:
              'مساعدة العلامات على التواصل بوضوح، والظهور بصورة احترافية، والنمو من خلال أنظمة تسويق عملية.',
          icon: Icons.flag,
          accent: colors.gold,
        ),
        EtbalyInfoCard(
          title: 'قيمنا',
          description:
              'الشفافية، الإبداع، التنفيذ القابل للقياس، حماية العميل، وبناء شراكات طويلة المدى.',
          icon: Icons.verified,
          accent: colors.success,
        ),
        EtbalyInfoCard(
          title: 'عقد احترافي واضح',
          description:
              'نطاق عمل واضح، مواعيد محددة، آلية دفع منظمة، حماية بيانات العميل، وحقوق ملكية فكرية محفوظة.',
          icon: Icons.description,
          accent: colors.info,
        ),
        const EtbalyPageSectionHeader(
          badge: 'الفريق',
          title: 'الأشخاص خلف العمل',
          description:
              'استراتيجيون، مصممون، متخصصو إعلانات، مطورون، صناع محتوى، وفريق دعم يعملون كوحدة واحدة.',
        ),
        EtbalyInfoCard(
          title: 'جاهز تبني معنا؟',
          description:
              'احك لنا ما الذي تريد نموه وسنحدد لك المسار الأنسب من الخدمات.',
          icon: Icons.rocket_launch,
          accent: colors.primaryLight,
          trailing: Icon(Icons.arrow_forward_ios, color: colors.gold, size: 16),
          onTap: () => context.go(AppRoutes.contact),
        ),
      ],
    );
  }
}
