import 'package:flutter/material.dart';

/// A neutral cover for baked sample account/progression text in approved art.
class ArtworkSampleMask extends StatelessWidget {
  const ArtworkSampleMask({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xF0071A30),
      border: Border.all(color: const Color(0xFFD8B873)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE2AB),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
