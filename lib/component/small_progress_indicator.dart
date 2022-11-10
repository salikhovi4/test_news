
import 'package:flutter/material.dart';

class SmallProgressIndicator extends StatelessWidget {
  final double size;
  final Color? indicatorColor;
  final double? indicatorWidth;

  const SmallProgressIndicator({
    Key? key,
    required this.size,
    this.indicatorColor,
    this.indicatorWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: indicatorColor ?? Colors.white,
        strokeWidth: indicatorWidth ?? 2.0,
      ),
    );
  }
}
