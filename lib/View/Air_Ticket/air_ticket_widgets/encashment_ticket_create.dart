import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/attachment_service.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/date_picker.dart';
import '../../CWidgets/file_selection_sheet.dart';
import '../air_ticket_controller/air_ticket_controller.dart';
import 'air_ticket_container.dart';
import 'air_ticket_textField.dart';

class EncashmentTicketCreate extends GetView<AirTicketController> {
  const EncashmentTicketCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextFieldWidget(
        //   label: 'Amount',
        //   hintText: 'Type here...',
        //   number: 20,
        // ),
        // SizedBox(height: 15.h),
        TextFieldWidget(
          label: 'Request Message',
          hintText: 'Type here...',
          number: 21,
          maxLines: 5,
        ),
      ],
    );
  }
}
