import 'package:flutter/material.dart';

Widget buttonWidget(
  Widget title,
  VoidCallback onPressed, {
  Color? color,
  double? width,
  double? height,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  OutlinedBorder? shape,
}) {
  return Container(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: shape,
        padding: padding,
      ),
      child: title,
    ),
  );
}
