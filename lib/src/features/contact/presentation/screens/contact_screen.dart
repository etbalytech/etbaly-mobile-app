import 'package:flutter/material.dart';
import 'package:etbaly/src/extensions/context_extension.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
              Icons.mail,
              size: 64,
              color: etbalyColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Contact Screen',
              style: context.textTheme.headlineMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon - Contact form',
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
