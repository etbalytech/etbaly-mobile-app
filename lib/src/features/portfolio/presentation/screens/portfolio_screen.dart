import 'package:flutter/material.dart';
import 'package:etbaly/src/extensions/context_extension.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

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
              Icons.photo_library,
              size: 64,
              color: etbalyColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Portfolio Screen',
              style: context.textTheme.headlineMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon - Portfolio gallery',
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
