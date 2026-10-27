
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final Function(bool)? onChange;
  final bool isChecked;
  final double? size;
  final double? iconSize;
  final double? borderWidth;
  final Color? selectedColor;
  final Color? selectedIconColor;
  final Color? borderColor;
  final Color? fillColor;
  final Icon? checkIcon;
  final BorderRadius? borderRadius;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChange,
    this.size,
    this.iconSize,
    this.borderWidth,
    this.selectedColor,
    this.selectedIconColor,
    this.borderColor,
    this.fillColor,
    this.checkIcon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: () async {
        await onChange?.call(!isChecked);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color: isChecked ? selectedColor ?? Colors.blue : fillColor ?? Colors.transparent,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor ?? selectedColor ?? Colors.black,
            width: borderWidth ?? 1.h,
          ),
        ),
        width: size ?? 18.h,
        height: size ?? 18.h,
        child: isChecked
            ? Icon(
          Icons.check,
          color: selectedIconColor ?? Colors.white,
          size: iconSize ?? 14.h,
        )
            : null,
      ),
    );
  }
}
