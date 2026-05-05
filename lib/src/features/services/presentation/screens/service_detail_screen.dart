import 'package:flutter/material.dart';
import 'package:etbaly/src/extensions/context_extension.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;

    return Scaffold(
      backgroundColor: etbalyColors.bgMain,
      appBar: AppBar(
        backgroundColor: etbalyColors.bgCard,
        title: Text(
          'Service: $slug',
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
              Icons.description,
              size: 64,
              color: etbalyColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Service Detail: $slug',
              style: context.textTheme.headlineMedium?.copyWith(
                color: etbalyColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon - Service details page',
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
