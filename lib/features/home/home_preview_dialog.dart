import 'package:flutter/material.dart';

class HomePreviewDialog extends StatelessWidget {
  const HomePreviewDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => HomePreviewDialog(title: title, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
        decoration: BoxDecoration(
          color: const Color(0xFF07111F),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF285E74)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 30,
              color: Color(0x6600B8E6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF102B3A),
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'ÖNİZLEME',
                    style: TextStyle(
                      color: Color(0xFF87E9FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFFC1D1E2),
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const ValueKey('home-preview-dialog-close'),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('KAPAT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
