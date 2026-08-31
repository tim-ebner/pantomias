import 'package:flutter/material.dart';
import 'package:pantomias/shared/commons.dart';

/// Bold rounded pill used as the header title on every route except home,
/// matching the redesign's top bar.
class TitlePill extends StatelessWidget {
  const TitlePill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: brandColor,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
