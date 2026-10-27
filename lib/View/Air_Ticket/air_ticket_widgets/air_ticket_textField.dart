import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/color_utils.dart';
import '../air_ticket_controller/air_ticket_controller.dart';

class TextFieldWidget extends GetView<AirTicketController> {
  final String? label;
  final String? hintText;
  final int number;
  final int? maxLines;
  const TextFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.maxLines,
    required this.number,
  });

  String? getInitialValue() {
    switch(number) {
      case 2: return controller.airTicketCreateData.value.reqAmount;
      case 3: return controller.airTicketCreateData.value.reqVatAmount;
      case 5 || 21: return controller.airTicketCreateData.value.reqDescription;
      case 9: return controller.airTicketCreateData.value.fromLocation;
      case 10: return controller.airTicketCreateData.value.toLocation;
      case 22: return controller.airTicketCreateData.value.employeePassport;
      default:
        int nameIndex = (number - 14) ~/ 50;
        if (number == 14 + (50 * nameIndex)) {
          return controller.airTicketCreateData.value.passengerData?[nameIndex].name;
        }
        int passIndex = (number - 19) ~/ 50;
        if (number == 19 + (50 * passIndex)) {
          return controller.airTicketCreateData.value.passengerData?[passIndex].name;
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: maxLines == null ? 70.h : null,
        decoration: BoxDecoration(
          color: ColorUtils.foregroundBlack,
          borderRadius: BorderRadius.all(Radius.circular(12).r),
          border: Border.all(
            color:
                controller.selectedFieldNumber.value == number
                    ? ColorUtils.darkGrey
                    : ColorUtils.foregroundBlack,
            width: 0.5.h,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 23.h),
          child: TextFormField(
            onTap: () {
              controller.selectedFieldNumber.value = number;
            },
            maxLines: maxLines ?? 1,
            minLines: 1,
            initialValue: getInitialValue(),
            onChanged: (value) {
              if(number == 2) {
                controller.airTicketCreateData.value.reqAmount = value;
              }
              if(number == 3) {
                controller.airTicketCreateData.value.reqVatAmount = value;
              }
              if(number == 5 || number == 21) {
                controller.airTicketCreateData.value.reqDescription = value;
              }
              if(number == 9) {
                controller.airTicketCreateData.value.fromLocation = value;
              }
              if(number == 10) {
                controller.airTicketCreateData.value.toLocation = value;
              }
              if(number == 22) {
                controller.airTicketCreateData.value.employeePassport = value;
              }
              int nameIndex = (number - 14) ~/ 50;
              if (number == 14 + (50 * nameIndex)) {
                controller.airTicketCreateData.value.passengerData?[nameIndex].name = value;
              }
              int passIndex = (number - 19) ~/ 50;
              if (number == 19 + (50 * passIndex)) {
                controller.airTicketCreateData.value.passengerData?[passIndex].passportNo = value;
              }
            },
            keyboardType: (label?.toLowerCase().contains('amount') ?? false) ? TextInputType.number : null,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12).r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12).r),
                borderSide: BorderSide.none,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              fillColor: ColorUtils.foregroundBlack,
              filled: true,
              isCollapsed: true,
              label:
                  label != null
                      ? Text(
                        label ?? '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 17.h,
                          color: ColorUtils.lightGrey,
                        ),
                      )
                      : null,
              hintText: hintText ?? '',
              hintStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 15.h,
                color: ColorUtils.textWhite.withValues(alpha: 0.2),
              ),
              contentPadding: EdgeInsets.only(
                top: 12.h,
                left: 15.h,
                right: 15.h,
                bottom: maxLines != null ? 13.h : 0.h,
              ),
            ),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 15.h,
              color: ColorUtils.textWhite,
            ),
          ),
        ),
      );
    });
  }
}
