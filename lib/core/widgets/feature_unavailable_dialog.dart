import 'package:flutter/material.dart';

/// Consistent user-visible fallback for artwork controls whose authoritative
/// product owner or destination is not available yet.
///
/// A visible control must never fail silently. Real routes should be preferred;
/// this dialog is only the fail-closed response for unfinished/external work.
class FeatureUnavailableDialog extends StatelessWidget {
  const FeatureUnavailableDialog({
    super.key,
    required this.feature,
    this.message,
  });

  final String feature;
  final String? message;

  static Future<void> show(
    BuildContext context, {
    required String feature,
    String? message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) =>
          FeatureUnavailableDialog(feature: feature, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const ValueKey('feature-unavailable-dialog'),
      backgroundColor: const Color(0xFF071827),
      title: Text(
        feature,
        style: const TextStyle(
          color: Color(0xFFE7C47A),
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        message ?? 'Bu özellik henüz kullanıma açılmadı.',
        style: const TextStyle(color: Color(0xFFD8E5F8)),
      ),
      actions: [
        TextButton(
          key: const ValueKey('feature-unavailable-close'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}
