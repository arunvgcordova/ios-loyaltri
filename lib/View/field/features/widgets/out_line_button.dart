import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class OutLineButtonWidget extends StatelessWidget {
  const OutLineButtonWidget({super.key, required this.label, this.icon,required this.function,});

  final String label;
  final String? icon;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: function,
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: ColourUtils.transparant,
            border: Border.all(color: ColourUtils.fontColour1, width: 0.5.h),
            borderRadius: BorderRadius.circular(10.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: svgWidget(
                        height: 20.h,
                        width: 20.h,
                        icon: icon ?? '',
                        color: ColourUtils.fontColour1,
                      ),
                    ),
        
              Text(
                label,
                style: GoogleFonts.inter(
                  color: ColourUtils.fontColour1,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
