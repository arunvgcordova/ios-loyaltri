import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StripGraph extends StatelessWidget {
  final int width;
  final int height;
  final BorderRadius? radius;
  final List<Color> colors;
  const StripGraph({super.key, required this.width, required this.colors, this.radius, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
    );
  }
}

class StripGraphManager extends StatelessWidget {
  final int width;
  final int height;
  final BorderRadius? radius;
  final List<Color> colors;
  const StripGraphManager({super.key, required this.width, required this.colors, this.radius, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
    );
  }
}
