import 'package:flutter/material.dart';
import 'package:pantomias/ui/shared/commons.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    this.height = nextButtonHeight,
    this.backgroundColor = quickStartColor,
    this.foregroundColor = brandColor,
    this.shadowColor = buttonShadowColor,
    required this.icon,
    required this.label,
    this.labelMaxLines = 1,
    required this.onPressed,
  });

  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color shadowColor;
  final IconData icon;
  final String label;
  final int labelMaxLines;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0.0, 9.0),
            blurRadius: 0.0,
          ),
          if (backgroundColor == Colors.white)
            const BoxShadow(
              color: buttonShadowColor,
              offset: Offset(0.0, 18.0),
              blurRadius: 0.0,
              spreadRadius: -5.0,
            ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(36.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = (constraints.maxWidth * 0.06).clamp(
                  18.0,
                  28.0,
                );
                final sideSpacing = (constraints.maxWidth * 0.055).clamp(
                  16.0,
                  24.0,
                );
                final iconSize = (constraints.maxWidth * 0.11).clamp(
                  34.0,
                  42.0,
                );
                final chevronSize = (constraints.maxWidth * 0.095).clamp(
                  30.0,
                  36.0,
                );
                final labelFontSize = (constraints.maxWidth * 0.064).clamp(
                  20.0,
                  28.0,
                );
                final labelStyle = Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(
                      color: foregroundColor,
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.0,
                      height: 1.08,
                    );
                final labelText = Text(
                  label,
                  maxLines: labelMaxLines,
                  overflow: labelMaxLines == 1
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  softWrap: labelMaxLines > 1,
                  textAlign: TextAlign.center,
                  style: labelStyle,
                );

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    children: [
                      Icon(icon, color: foregroundColor, size: iconSize),
                      SizedBox(width: sideSpacing),
                      Expanded(
                        child: labelMaxLines == 1
                            ? FittedBox(fit: BoxFit.scaleDown, child: labelText)
                            : labelText,
                      ),
                      SizedBox(width: sideSpacing),
                      Icon(
                        Icons.chevron_right,
                        color: foregroundColor,
                        size: chevronSize,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
