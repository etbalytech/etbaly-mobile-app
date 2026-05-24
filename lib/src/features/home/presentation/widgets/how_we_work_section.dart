part of '../screens/home_page.dart';

class _HowWeWorkSection extends StatelessWidget {
  const _HowWeWorkSection();

  static const _waves = [
    _WorkWaveData(
      number: '01',
      title: 'استشارة مع خبير',
      subtitle: 'نبدأ معك من الصفر حتى الفكرة الأقوى',
      accent: EtbalyWebColors.gold,
      cards: [
        _WorkStepData(
          number: '01',
          title: 'تحليل الاحتياجات',
          description:
              'نجلس معك ونستمع بعمق لفهم أهدافك، تحدياتك، وجمهورك المستهدف. هذه الجلسة هي نقطة الانطلاق نحو نجاح حقيقي وملموس.',
          icon: Icons.forum,
        ),
        _WorkStepData(
          number: '02',
          title: 'دراسة السوق',
          description:
              'نحلل المنافسين ونرصد توجهات السوق بدقة علمية دقيقة لنبني عليها استراتيجية لا يمكن للمنافسين تجاهلها.',
          icon: Icons.saved_search,
        ),
        _WorkStepData(
          number: '03',
          title: 'تحديد الهوية',
          description:
              'نرسم هوية علامتك التجارية بوضوح: رسالتك، قيمتك الفريدة، وكيف تتميز في سوق مزدحم بالمنافسين.',
          icon: Icons.track_changes,
        ),
      ],
    ),
    _WorkWaveData(
      number: '02',
      title: 'استراتيجية مضبوطة',
      subtitle: 'خطة محكمة لكل خطوة نحو الهدف',
      accent: EtbalyWebColors.purple,
      alternate: true,
      cards: [
        _WorkStepData(
          number: '04',
          title: 'رسم خريطة المحتوى',
          description:
              'نبني خارطة طريق محتوى شاملة تغطي كل قناة رقمية وتتناسب مع كل مرحلة في رحلة عميلك من أول لحظة حتى اتخاذ القرار.',
          icon: Icons.map,
        ),
        _WorkStepData(
          number: '05',
          title: 'بناء مسار التحويل',
          description:
              'نصمم مسارات تحويل ذكية تحول الزوار العاديين إلى عملاء مخلصين، مع تحسين مستمر في كل مرحلة للحصول على أقصى عائد استثمار.',
          icon: Icons.filter_alt,
        ),
        _WorkStepData(
          number: '06',
          title: 'الجدول الزمني المحكم',
          description:
              'نضع جدولًا زمنيًا دقيقًا لكل مهمة ومخرج وموعد تسليم، مع مرونة كافية لاستيعاب أي تغييرات دون التأثير على جودة العمل.',
          icon: Icons.calendar_month,
        ),
      ],
    ),
    _WorkWaveData(
      number: '03',
      title: 'تنفيذ باحترافية',
      subtitle: 'ننفذ كل تفصيلة بدقة وإبداع لا يُضاهيان',
      accent: EtbalyWebColors.teal,
      cards: [
        _WorkStepData(
          number: '07',
          title: 'الإنتاج الإبداعي',
          description:
              'نصمم محتوى بصريًا مذهلًا وكتابيًا مقنعًا يجذب انتباه جمهورك في ثوانٍ ويحثه على التفاعل والمشاركة والتحويل الفوري.',
          icon: Icons.brush,
        ),
        _WorkStepData(
          number: '08',
          title: 'إطلاق الحملات',
          description:
              'نطلق حملاتك الإعلانية بدقة جراحية على منصات Meta وGoogle وTikTok واليوتيوب لنضمن أن رسالتك تصل لمن يهمك في اللحظة المثالية.',
          icon: Icons.campaign,
        ),
        _WorkStepData(
          number: '09',
          title: 'التحسين المستمر',
          description:
              'نراقب الأداء لحظة بلحظة ونُحسّن الحملات بشكل مستمر بناءً على البيانات الحقيقية لنضمن تحسنًا مستمرًا في النتائج والعائد.',
          icon: Icons.sync,
        ),
      ],
    ),
    _WorkWaveData(
      number: '04',
      title: 'نتائج مرضية',
      subtitle: 'أرقام حقيقية تتحدث بدلًا عنّا',
      accent: EtbalyWebColors.gold,
      alternate: true,
      cards: [
        _WorkStepData(
          number: '10',
          title: 'قياس الأداء',
          description:
              'نقدم تقارير مفصلة وشفافة تمامًا عن كل مقياس أداء رئيسي، حتى تعرف بالضبط أين ذهب كل جنيه وما العائد الفعلي الذي حققه.',
          icon: Icons.query_stats,
        ),
        _WorkStepData(
          number: '11',
          title: 'تحقيق الأهداف',
          description:
              'نتتبع كل هدف وضعناه في البداية ونحرص على تجاوزه لا مجرد الوصول إليه. نجاحك هو معيارنا الوحيد والمقياس الأهم لجودة عملنا.',
          icon: Icons.emoji_events,
        ),
        _WorkStepData(
          number: '12',
          title: 'شراكة مستدامة',
          description:
              'لسنا مجرد مزود خدمة، نحن شريك نمو استراتيجي طويل الأمد. ندعمك بعد التسليم ونستمر في التحسين والتطوير معك في كل مرحلة جديدة.',
          icon: Icons.handshake,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;

    return EtbalyWebSectionShell(
      backgroundColor: EtbalyWebColors.sectionDeep,
      backgroundPainter: const _HowWeWorkPainter(),
      child: Column(
        children: [
          const EtbalyWebBadge(
            label: 'كيف نعمل',
            glowDot: EtbalyWebColors.green,
            trailingDot: Color(0xBBD4AF37),
            websiteStyle: true,
          ),
          SizedBox(height: isMobile ? 18 : 24),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'رحلتك معنا '),
                TextSpan(
                  text: 'إبداعية',
                  style: context.textTheme.displaySmall?.copyWith(
                    color: EtbalyWebColors.gold,
                    fontSize: context.width < 390 ? 34 : 42,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: context.textTheme.displaySmall?.copyWith(
              color: EtbalyWebColors.heading,
              fontSize: context.width < 390 ? 34 : 42,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 16),
          const EtbalyWebGoldDivider(),
          const SizedBox(height: 24),
          Text(
            'عملية واضحة وشفافة من الفكرة إلى النتيجة',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              color: EtbalyWebColors.body,
              fontSize: context.width < 390 ? 14 : 16,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 34 : 46),
          for (var i = 0; i < _waves.length; i++) ...[
            _ProcessWave(wave: _waves[i]),
            if (i != _waves.length - 1) SizedBox(height: isMobile ? 30 : 42),
          ],
        ],
      ),
    );
  }
}
