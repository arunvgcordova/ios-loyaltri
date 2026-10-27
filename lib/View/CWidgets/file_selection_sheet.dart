import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../services/attachment_service.dart';
import '../../utils/color_utils.dart';
import '../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../Leave_Page/leave_widgets/leave_type_card.dart';
import 'error_dialog.dart';

AttachmentService attachmentService = AttachmentService();

attachBottomSheetShow(mainContext) {
  showModalBottomSheet(
    context: mainContext,
    backgroundColor: Colors.black,
    barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: ScreenUtil().screenWidth,
            height: 273.w,
            decoration: BoxDecoration(
              color: ColorUtils.backgroundBlack,
              borderRadius: BorderRadius.circular(20).w,
              border: Border.all(width: 1.w, color: const Color(0xFF404040)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 15.0,
                    right: 15.0,
                  ).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Source",
                    style: GoogleFonts.poppins(
                      color: ColorUtils.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(
                        newSlideNavigation(const CameraViewLeave()),
                          )
                          .then((value) async {
                        if (value == null) return;

                        final file = File(value);
                        final fileSizeInBytes = await file.length();
                        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                        if (fileSizeInMB > 5) {
                          ErrorDialog().showWarn(
                            context: mainContext,
                            title: "Error",
                            subTitle: "File size should be less than 5 MB",
                          );
                          return;
                        }
                            attachmentService.singleFileAdd(value);
                          });
                    },
                    child: const AttachMenuCard(
                      imageIcon: "assets/images/camera.webp",
                      title: "Camera",
                      subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      try {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp'],
                        );

                        if (result != null && result.files.single.path != null) {
                          final file = File(result.files.single.path!);
                          final fileSizeInBytes = await file.length();
                          final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                          if (fileSizeInMB > 5) {
                            ErrorDialog().showWarn(
                              context: mainContext,
                              title: "Error",
                              subTitle: "File size should be less than 5 MB",
                            );
                            return;
                          }
                          attachmentService.singleFileAdd(result.files.single.path!);
                        } else {
                          // User canceled the picker
                        }
                      } catch (e) {
                        AttendanceCommonWidgets().printF(
                          "------error-------${e.toString()}",
                        );
                      }
                    },
                    child: const AttachMenuCard(
                      imageIcon: "assets/images/image-3d.webp",
                      title: "Photos",
                      subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            allowMultiple: false,
                            // type: FileType.custom,
                            // allowedExtensions: [
                            //   'png',
                            //   'jpg',
                            //   'jpeg',
                            //   'gif',
                            //   'bmp',
                            //   'tiff',
                            //   'webp',
                            // ],
                          );

                      if (result != null) {
                        List<File> files =
                            result.paths.map((path) => File(path!)).toList();
                        final fileSizeInBytes = await files.first.length();
                        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                        if (fileSizeInMB > 5) {
                          ErrorDialog().showWarn(
                            context: mainContext,
                            title: "Error",
                            subTitle: "File size should be less than 5 MB",
                          );
                          return;
                        }
                        attachmentService.singleFileAdd(files.first.path);
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: const AttachMenuCard(
                      imageIcon: "assets/images/file-3d.webp",
                      title: "Browse",
                      subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


