part of '../screens/home_page.dart';

class _WorkWaveData {
  const _WorkWaveData({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.cards,
    this.alternate = false,
  });

  final String number;
  final String title;
  final String subtitle;
  final Color accent;
  final List<_WorkStepData> cards;
  final bool alternate;
}
