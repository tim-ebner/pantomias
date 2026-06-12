import 'package:flutter/material.dart';
import 'package:pantomias/ui/shared/commons.dart';

const pointModeFieldBorderColor = Color(0xFFB9CBC5);
const _pointModeFieldFillColor = Color(0xFFFFFFFF);
const _pointModeFieldLabelColor = Color(0xFF304841);
const _pointModeFieldTextColor = Color(0xFF111917);
const _pointModeFieldErrorColor = Color(0xFFB85B5B);

InputDecoration buildPointModeInputDecoration(
  BuildContext context, {
  required String labelText,
  String? errorText,
}) {
  final labelStyle =
      Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: _pointModeFieldLabelColor,
        letterSpacing: 0.0,
      ) ??
      const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: _pointModeFieldLabelColor,
        letterSpacing: 0.0,
      );

  return InputDecoration(
    labelText: labelText,
    errorText: errorText,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: labelStyle,
    floatingLabelStyle: labelStyle,
    filled: true,
    fillColor: _pointModeFieldFillColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 28.0,
      vertical: 26.0,
    ),
    border: _pointModeFieldBorder(),
    enabledBorder: _pointModeFieldBorder(),
    focusedBorder: _pointModeFieldBorder(color: brandColor, width: 3.0),
    errorBorder: _pointModeFieldBorder(color: _pointModeFieldErrorColor),
    focusedErrorBorder: _pointModeFieldBorder(
      color: _pointModeFieldErrorColor,
      width: 3.0,
    ),
    errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: _pointModeFieldErrorColor,
      fontWeight: FontWeight.w600,
    ),
  );
}

TextStyle pointModeInputTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w500,
        color: _pointModeFieldTextColor,
        height: 1.0,
        letterSpacing: 0.0,
      ) ??
      const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w500,
        color: _pointModeFieldTextColor,
        height: 1.0,
        letterSpacing: 0.0,
      );
}

OutlineInputBorder _pointModeFieldBorder({
  Color color = pointModeFieldBorderColor,
  double width = 2.5,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(40.0),
    borderSide: BorderSide(color: color, width: width),
    gapPadding: 10.0,
  );
}
