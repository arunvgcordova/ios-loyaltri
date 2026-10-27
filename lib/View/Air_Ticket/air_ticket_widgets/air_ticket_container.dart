import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_controller/air_ticket_controller.dart';
import '../../../utils/color_utils.dart';

class AirTicketContainerWidget extends GetView<AirTicketController> {
  final String? text;
  final String label;
  final Widget? icon;
  final int number;
  const AirTicketContainerWidget({
    super.key,
    this.text,
    required this.number,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        decoration: BoxDecoration(
          color: ColorUtils.foregroundBlack,
          borderRadius: BorderRadius.circular(12).r,
          border: Border.all(
            color:
                controller.selectedFieldNumber.value == number
                    ? ColorUtils.darkGrey
                    : ColorUtils.foregroundBlack,
            width: 0.5.h,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text ?? label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13.h,
                color: text == null ? ColorUtils.lightGrey : ColorUtils.textWhite,
              ),
            ),
            if (icon != null) icon!,
          ],
        ),
      );
    });
  }
}
