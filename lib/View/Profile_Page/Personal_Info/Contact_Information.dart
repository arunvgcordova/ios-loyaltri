import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/sqflite_db/punch_db.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../controller/userAuthentication.dart';
import '../../../models/checkIn_model.dart';
import '../../../models/user_api_model.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';
class ContactInformation extends StatelessWidget {
  ContactInformation({super.key});
  final ValueNotifier<bool> expandContactInfo = ValueNotifier(false);
  final user = Get.find<UserProfileController>().userData.value.result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => expandContactInfo.value = !expandContactInfo.value,
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
            color: Color(0xff101012),
            borderRadius: BorderRadius.circular(14).r),
        child: ValueListenableBuilder(
            valueListenable: expandContactInfo,
            builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mail",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.email ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          // await pickPdfAndSaveToDb();
                        },
                        child: Text(
                          user.phone ?? '--',
                          overflow: !value ? TextOverflow.ellipsis : null,
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Future<void> pickPdfAndSaveToDb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      await extractAndSavePunchData(result.files.single.path!);
    }
  }

  Future<void> extractAndSavePunchData(String filePath) async {
    final fileBytes = await File(filePath).readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: fileBytes);
    final String rawText = PdfTextExtractor(document).extractText();
    document.dispose();

    final lines = rawText
        .split('\n')
        .map((e) => e.trim())
        .where((e) =>
    e.isNotEmpty &&
        !e.startsWith('Date Punch') &&
        !e.startsWith('Loyaltri Punch Log') &&
        !e.startsWith('MUHAMMED') &&
        !e.startsWith('Created on'))
        .toList();

    final punches = <AttendanceCheckModel>[];

    for (int i = 0; i + 3 < lines.length; i += 4) {
      final date = lines[i];
      final state = lines[i + 1];
      final time = lines[i + 2];
      final sync = lines[i + 3];

      punches.add(AttendanceCheckModel(
        employeeId: '9796',
        companyId: '28',
        punchDate: date,
        punchTime: time,
        punchType: 'Mobile',
        punchState: state,
        punchRemarks: '',
        punchImage: null,
        locationName: null,
        latitude: '',
        longitude: '',
        isSynced: sync.toUpperCase() == 'YES' ? 1 : 0,
      ));
    }

    punches.removeAt(0);

    await _saveToDatabase(punches);
  }

  Future<void> _saveToDatabase(List<AttendanceCheckModel> punches) async {
    for (var punch in punches) {
      // AttendanceCommonWidgets().printF("---------toJson---------${punch.toJson()}");
      await PunchDatabase.instance.create(punch);
    }

    List<AttendanceCheckModel> allData = await PunchDatabase.instance.readAllPunchData();

    AttendanceCommonWidgets().printF("✅ ${punches.length} records saved to DB.");
    for (var element in allData) {
      AttendanceCommonWidgets().printF("✅ ${element.punchDate}");
    }
  }
}
