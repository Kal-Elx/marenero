import 'package:flutter/material.dart';

class RoundedDivider extends StatelessWidget {
  final double thickness;
  final double height;
  final double indent;
  final Color color;

  const RoundedDivider({
    this.height = 60.0,
    this.thickness = 4.0,
    this.indent = 0.0,
    this.color = Colors.white54,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: indent,
        vertical: (height - thickness) / 2,
      ),
      child: Container(
        height: thickness,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(thickness / 2)),
        ),
      ),
    );
  }
}
