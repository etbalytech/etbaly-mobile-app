import 'package:flutter/material.dart';
import 'package:etbaly/src/extensions/context_extension.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;

    return Scaffold(
      backgroundColor: etbalyColors.bgMain,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: etbalyColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'About Screen',
              style: context.textTheme.headlineMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon - About us page',
              style: context.textTheme.bodyMedium?.copyWith(
                color: etbalyColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
