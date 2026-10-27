import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../services/attachment_service.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/date_picker.dart';
import '../../CWidgets/file_selection_sheet.dart';
import '../air_ticket_controller/air_ticket_controller.dart';
import 'air_ticket_container.dart';
import 'air_ticket_textField.dart';

class ReimbursmentTicketCreate extends StatelessWidget {
  const ReimbursmentTicketCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextFieldWidget(
                label: 'Amount',
                hintText: 'Type here...',
                number: 2,
              ),
            ),
            SizedBox(width: 13.h),
            Flexible(
              child: TextFieldWidget(
                label: 'VAT Amount',
                hintText: 'Type here...',
                number: 3,
              ),
            ),
          ],
        ),
        // SizedBox(height: 15.h),
        // TextFieldWidget(
        //   label: 'Employee Name',
        //   hintText: 'Type here...',
        //   number: 4,
        // ),
        SizedBox(height: 15.h),
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12).r),
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.find<AirTicketController>().selectedFieldNumber.value = 6;
            DateTime? picked = await pickDate(
              context,
              ThemeMode.dark,
              firstDate: DateTime(DateTime.now().year),
              lastDate: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ),
            );
            if(picked != null) {
              Get.find<AirTicketController>().airTicketCreateData.value.reqDate = DateFormat("yyyy-MM-dd").format(picked);
              Get.find<AirTicketController>().airTicketCreateData.refresh();
            }
          },
          child: GetX<AirTicketController>(
            builder: (AirTicketController controller) {
              return AirTicketContainerWidget(
                label: "Date of spend",
                text: controller.airTicketCreateData.value.reqDate,
                number: 6,
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                  size: 20.h,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 15.h),
        TextFieldWidget(
          label: 'Description',
          hintText: 'Description (Optional)',
          number: 5,
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 3.h),
                Image.asset(
                  'assets/images/air_ticket/air_ticket.png',
                  height: 38.h,
                  fit: BoxFit.fitHeight,
                ),
                Text(
                  " Attachment Ticket ",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.h,
                    color: ColorUtils.lightGrey,
                  ),
                ),
                Text(
                  "*",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.h,
                    color: ColorUtils.pureRed,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                attachBottomSheetShow(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28).h,
                height: 40.h,
                decoration: BoxDecoration(
                  color: ColorUtils.foregroundBlack,
                  borderRadius: BorderRadius.circular(23).r,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/attach_icon.svg",
                      height: 17.h,
                    ),
                    SizedBox(width: 12.h),
                    Text(
                      "Add",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.h,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: AttachmentService().selectedFiles,
          builder: (context, value, child) {
            return Column(
              children: List.generate(value.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15).h,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ).h,
                    decoration: BoxDecoration(
                      color: ColorUtils.foregroundBlack,
                      borderRadius: BorderRadius.circular(12).r,
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                AttachmentService().removeFile(value[index]);
                              },
                              child: const Icon(
                                Icons.close,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            SizedBox(width: 10.h),
                            if(value[index].split('.').last == 'pdf')
                              Image.asset(
                                "assets/images/manager_view/pdf_icon.png",
                                height: 35.h,
                              )
                            else
                              Image.file(
                                File(value[index]),
                                height: 60.h,
                                width: 80.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Transform.rotate(
                                    angle: 180,
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 28.h,
                                      color: Colors.blueGrey,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        SizedBox(width: 10.h),
                        Flexible(
                          child: Text(
                            value[index].split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.h,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.h),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
