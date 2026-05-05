import 'package:flutter/material.dart';
import 'package:etbaly/src/extensions/context_extension.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;

    return Scaffold(
      backgroundColor: etbalyColors.bgMain,
      appBar: AppBar(
        backgroundColor: etbalyColors.bgCard,
        title: Text(
          'Privacy Policy',
          style: context.textTheme.titleLarge?.copyWith(
            color: etbalyColors.textMain,
          ),
        ),
        iconTheme: IconThemeData(color: etbalyColors.textMain),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.privacy_tip,
              size: 64,
              color: etbalyColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Privacy Screen',
              style: context.textTheme.headlineMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon - Privacy policy page',
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
