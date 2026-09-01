import 'package:flutter/material.dart';
import 'package:pantomias/shared/commons.dart';

import 'point_mode_input_style.dart';

/// One selectable radio-style card in the "Spielmodus" section.
class GameModeCard extends StatelessWidget {
  const GameModeCard({
    super.key,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  static const _radioSize = 22.0;
  static const _radioDotSize = 10.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? brandColor : pointModeCardBorderColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          children: [
            Container(
              width: _radioSize,
              height: _radioSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? brandColor : pointModeFieldBorderColor,
                  width: 2.5,
                ),
              ),
              child: isSelected
                  ? Container(
                      width: _radioDotSize,
                      height: _radioDotSize,
                      decoration: const BoxDecoration(
                        color: brandColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      color: pointModeTextColor,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: stageHelperTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
