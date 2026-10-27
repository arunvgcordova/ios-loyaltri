import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Profile_Page/image_crop_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/Login/Login_Screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/Work_Entry/work_entry_widgets/alert_dialogue.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/services/connectivity_service.dart';
import 'package:loyaltri_minimal/sqflite_db/punch_db.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../models/checkIn_model.dart';
import '../../models/user_profile_api_model.dart';
import '../../services/attachment_service.dart';
import '../../services/controller_handling.dart';
import '../../services/flutter_secure_storage.dart';
import '../../services/ui_model_services/profile_menu_model.dart';
import '../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../Leave_Page/leave_widgets/leave_type_card.dart';
import 'package:open_file/open_file.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0).h,
          child: RefreshIndicator(
            onRefresh: () async {
              String employeeId =
                  Get.find<UserAuthController>()
                      .userData
                      .value
                      .userData
                      ?.employeeId ??
                  '';

              await Get.find<UserProfileController>().fetchUserData(
                empId: employeeId,
              );
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GetX<UserProfileController>(
                      builder: (UserProfileController controller) {
                        UserProfile user = controller.userData.value.result;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30,
                                bottom: 10,
                              ).h,
                              child: SizedBox(
                                height: 110.h,
                                width: 110.h,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        500,
                                      ).h,
                                      child:
                                          controller
                                                  .profileImageLocation
                                                  .value
                                                  .path !=
                                              ""
                                          ? Image.file(
                                              controller
                                                  .profileImageLocation
                                                  .value,
                                              width: 100.h,
                                              height: 100.h,
                                              fit: BoxFit.fitWidth,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  user.profilePicture
                                                      ?.toString() ??
                                                  '',
                                              width: 100.h,
                                              height: 100.h,
                                              fit: BoxFit.fitWidth,
                                              placeholder: (context, url) => Image.asset(
                                                user.gender
                                                            ?.trim()
                                                            .toLowerCase() ==
                                                        "female"
                                                    ? "assets/images/profile_pic_girl.jpg"
                                                    : "assets/images/profile_pic.png",
                                              ),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Image.asset(
                                                    user.gender
                                                                ?.trim()
                                                                .toLowerCase() ==
                                                            "female"
                                                        ? "assets/images/profile_pic_girl.jpg"
                                                        : "assets/images/profile_pic.png",
                                                  ),
                                            ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          attachBottomSheetShow(context);
                                          // if(selectedImage != null) {
                                          //   String employeeId = Get.find<UserAuthController>().userData.value.userData.employeeId;
                                          //   await ApiServices().updateProfilePic(selectedFile: selectedImage!, empId: employeeId);
                                          // }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorUtils.workEntryHead
                                                .withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(
                                              80,
                                            ).h,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              "assets/images/camera-icon3d.webp",
                                              width: 20.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onDoubleTap: () async {
                                await saveSyncDataPdf(user);
                              },
                              onLongPress: () async {
                                await saveFullSyncDataPdf(user);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ).h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (user.firstName != null &&
                                        user.firstName != "")
                                      Flexible(
                                        child: Text(
                                          "${(user.firstName?.trim().isNotEmpty ?? false) ? '${user.firstName} ' : ''}"
                                          "${(user.middleName?.trim().isNotEmpty ?? false) ? '${user.middleName} ' : ''}"
                                          "${(user.lastName?.trim().isNotEmpty ?? false) ? user.lastName : ''}",
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19.h,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ).h,
                              child: Text(
                                user.designation ?? "--",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.h,
                                  color: ColorUtils.textWhite.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0).h,
                    child: Container(
                      // height: 250.w,
                      width: ScreenUtil().screenWidth,
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        right: 10,
                        left: 10,
                      ).h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF101012),
                        borderRadius: BorderRadius.circular(14).h,
                      ),
                      child: ListView.separated(
                        itemCount: profileMenu.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                newSlideNavigation(profileMenu[index].page)
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 7,
                                bottom: 7,
                              ).h,
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          profileMenu[index].icon,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          profileMenu[index].title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.h,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(flex: 40),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: const Color(0xFF666666),
                                      size: 20.h,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.05),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0).h,
                    child: GestureDetector(
                      onTap: () async {
                        await logOutWarn();
                      },
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        height: 65.h,
                        padding: const EdgeInsets.symmetric(horizontal: 10).h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF101012),
                          borderRadius: BorderRadius.circular(14).h,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/SignOut.svg"),
                            SizedBox(width: 10.h),
                            Text(
                              "Log Out",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      int count = await AttachmentService.getFaceImageCount();
                      AttendanceCommonWidgets().showSnackBar(
                        context: context,
                        backgroundColor: count == 0 ? Colors.green : Colors.red,
                        message: "$count image files find in app directory.",
                      );
                    },
                    onLongPress: () async {
                      String? error = await SecureStorageUtils().getErrorOccurs();
                      if (error != null) {
                        AttendanceCommonWidgets().showSnackBar(
                          context: context,
                          backgroundColor: Colors.red,
                          message: error,
                        );
                      }
                    },
                    child: Text(
                      ApiConstants.apiLink == ""
                          ? "Version : ${ApiConstants.appVersion}"
                          : "Version : ${ApiConstants.apiLink} - ${ApiConstants.appVersion}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.h,
                        color: ColorUtils.textWhite.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> logOutWarn() async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: ColorUtils.backgroundBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(color: const Color(0xFF666666), width: 1.w),
              ),
              title: Image.asset(
                "assets/images/alert.webp",
                // width: 10.w,
                height: 60.w,
              ),
              content: Text(
                "Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      // width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF6A4BFC),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          await Get.find<UserAuthController>().logOut(context);
                        },
                        child: GetX<UserAuthController>(
                          builder: (UserAuthController controller) {
                            if (controller.logOutLoading.value) {
                              return SizedBox(
                                width: 15.h,
                                height: 15.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              return Text(
                                "Confirm",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  color: ColorUtils.textWhite,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      // width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: ColorUtils.foregroundBlack,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              color: ColorUtils.textWhite,
                              size: 15.w,
                            ),
                            Text(
                              "Close",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> saveSyncDataPdf(UserProfile user) async {
    List<AttendanceCheckModel> punchData = await PunchDatabase.instance
        .readAllPunchData();
    for (var punch in punchData) {
      AttendanceCommonWidgets().printF(
        "------time------${punch.punchDate} ${punch.punchTime}",
      );
    }
    if (punchData.isNotEmpty) {
      final PdfDocument document = PdfDocument();
      final PdfPageTemplateElement headerTemplate = PdfPageTemplateElement(
        const Rect.fromLTWH(0, 0, 515, 50),
      );
      headerTemplate.graphics.drawString(
        'Loyaltri Punch Log\n${user.firstName ?? ''} ${user.middleName ?? ''} ${user.lastName ?? ''} - ${user.employeeId ?? ''} - ${user.companyId ?? ''} - ${user.designation ?? ''}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 15, 500, 30),
      );

      document.template.top = headerTemplate;

      final PdfPageTemplateElement footerTemplate = PdfPageTemplateElement(
        const Rect.fromLTWH(0, 0, 515, 50),
      );

      footerTemplate.graphics.drawString(
        'Created on ${DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now())}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 15, 500, 20),
      );
      document.template.bottom = footerTemplate;

      final PdfPage page = document.pages.add();

      final PdfGrid grid = PdfGrid();

      grid.columns.add(count: 4);

      final PdfGridRow headerRow = grid.headers.add(1)[0];
      headerRow.cells[0].value = 'Date';
      headerRow.cells[1].value = 'Punch Type';
      headerRow.cells[2].value = 'Time';
      headerRow.cells[3].value = 'Sync Status';

      headerRow.style.font = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );

      for (var logFinal in punchData) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].value = logFinal.punchDate;
        row.cells[1].value = logFinal.punchState;
        row.cells[2].value = logFinal.punchTime;
        row.cells[3].value = logFinal.isSynced == 1 ? "YES" : "NO";
      }

      grid.style.cellPadding = PdfPaddings(left: 5, top: 5);

      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
          0,
          0,
          page.getClientSize().width,
          page.getClientSize().height,
        ),
      );

      final direX = await getApplicationDocumentsDirectory();

      final path = direX.path;
      AttendanceCommonWidgets().printF(path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = await File(
        '$path/ActivityLog_createdOn_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}_$timestamp.pdf',
      ).writeAsBytes(await document.save());

      AttendanceCommonWidgets().printF('file path ------${file.path}');

      document.dispose();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: const Text(
            'Activity log generated successfully.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'Open',
            textColor: const Color(0xFF4003AB),
            onPressed: () async {
              await OpenFile.open(
                '$path/ActivityLog_createdOn_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}_$timestamp.pdf',
              );
              // incre++;
              // AttendanceCommonWidgets().printF('opened......$incre');
            },
          ),
        ),
      );
    }
  }

  Future<void> saveFullSyncDataPdf(UserProfile user) async {
    List<AttendanceCheckModel> punchData = await PunchDatabase.instance
        .readAllPunchData();
    for (var punch in punchData) {
      AttendanceCommonWidgets().printF(
        "------time------${punch.punchDate} ${punch.punchTime}",
      );
    }
    if (punchData.isNotEmpty) {
      final PdfDocument document = PdfDocument();
      final PdfPageTemplateElement headerTemplate = PdfPageTemplateElement(
        const Rect.fromLTWH(0, 0, 515, 50),
      );
      headerTemplate.graphics.drawString(
        'Loyaltri Punch Log\n${user.firstName ?? ''} ${user.middleName ?? ''} ${user.lastName ?? ''} - ${user.employeeId ?? ''} - ${user.designation ?? ''}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 15, 500, 30),
      );

      document.template.top = headerTemplate;

      final PdfPageTemplateElement footerTemplate = PdfPageTemplateElement(
        const Rect.fromLTWH(0, 0, 515, 50),
      );

      footerTemplate.graphics.drawString(
        'Created on ${DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now())}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 15, 500, 20),
      );
      document.template.bottom = footerTemplate;

      final PdfPage page = document.pages.add();

      final PdfGrid grid = PdfGrid();

      grid.columns.add(count: 13);

      final PdfGridRow headerRow = grid.headers.add(1)[0];
      headerRow.cells[0].value = 'id';
      headerRow.cells[1].value = 'employeeId';
      headerRow.cells[2].value = 'companyId';
      headerRow.cells[3].value = 'punchDate';
      headerRow.cells[4].value = 'punchTime';
      headerRow.cells[5].value = 'punchType';
      headerRow.cells[6].value = 'punchRemarks';
      headerRow.cells[7].value = 'punchImage';
      headerRow.cells[8].value = 'locationName';
      headerRow.cells[9].value = 'latitude';
      headerRow.cells[10].value = 'longitude';
      headerRow.cells[11].value = 'punchState';
      headerRow.cells[12].value = 'isSynced';

      headerRow.style.font = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );

      for (var logFinal in punchData) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].value = logFinal.id.toString();
        row.cells[1].value = logFinal.employeeId.toString();
        row.cells[2].value = logFinal.companyId.toString();
        row.cells[3].value = logFinal.punchDate.toString();
        row.cells[4].value = logFinal.punchTime.toString();
        row.cells[5].value = logFinal.punchType.toString();
        row.cells[6].value = logFinal.punchRemarks.toString();
        row.cells[7].value = logFinal.punchImage.toString();
        row.cells[8].value = logFinal.locationName.toString();
        row.cells[9].value = logFinal.latitude.toString();
        row.cells[10].value = logFinal.longitude.toString();
        row.cells[11].value = logFinal.punchState.toString();
        row.cells[12].value = logFinal.isSynced.toString();
      }

      grid.style.cellPadding = PdfPaddings(left: 5, top: 5);

      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
          0,
          0,
          page.getClientSize().width,
          page.getClientSize().height,
        ),
      );

      final direX = await getApplicationDocumentsDirectory();

      final path = direX.path;
      AttendanceCommonWidgets().printF(path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = await File(
        '$path/ActivityLog_createdOn_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}_$timestamp.pdf',
      ).writeAsBytes(await document.save());

      AttendanceCommonWidgets().printF('file path ------${file.path}');

      document.dispose();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: const Text(
            'Activity log generated successfully.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'Open',
            textColor: const Color(0xFF4003AB),
            onPressed: () async {
              await OpenFile.open(
                '$path/ActivityLog_createdOn_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}_$timestamp.pdf',
              );
              // incre++;
              // AttendanceCommonWidgets().printF('opened......$incre');
            },
          ),
        ),
      );
    }
  }

  Future<String?> _cropImage(String sourcePath) async {
    final croppedPath = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ImageCropScreen(imagePath: sourcePath),
      ),
    );
    return croppedPath;
  }

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
                padding: const EdgeInsets.only(
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
                        Navigator.of(context).push(
                          newSlideNavigation(const CameraViewLeave()),
                        ).then((value) async {
                          if (value != null) {
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

                            String? croppedPath = await _cropImage(value);
                            if (croppedPath != null) {
                              selectedImage = croppedPath;
                              showImagePopUp(mainContext: mainContext);
                            }
                          }
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
                            allowedExtensions: [
                              'png',
                              'jpg',
                              'jpeg',
                              'gif',
                              'bmp',
                              'tiff',
                              'webp'
                            ],
                          );

                          if (result == null || result.files.single.path == null) {
                            return; // User cancelled
                          }

                          String originalPath = result.files.single.path!;

                          final file = File(originalPath);
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

                          // Crop the selected image
                          String? croppedPath = await _cropImage(originalPath);

                          if (croppedPath != null) {
                            setState(() {
                              selectedImage = croppedPath;
                            });

                            showImagePopUp(mainContext: mainContext);
                          }

                          AttendanceCommonWidgets().printF(
                            "------path------$originalPath",
                          );

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
                              type: FileType.custom,
                              allowedExtensions: [
                                'png',
                                'jpg',
                                'jpeg',
                                'gif',
                                'bmp',
                                'tiff',
                                'webp',
                              ],
                            );
          
                        if (result != null) {
                          List<File> files = result.paths
                              .map((path) => File(path!))
                              .toList();

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

                          String? croppedPath = await _cropImage(files.first.path);
                          if (croppedPath != null) {
                            setState(() {
                              selectedImage = croppedPath;
                            });
                            showImagePopUp(mainContext: mainContext);
                          }
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

  Future<void> getLostData(mainContext) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final LostDataResponse response = await picker.retrieveLostData();
    // AttendanceCommonWidgets().printF("------path------${image.path}");
    if (image != null) {
      String? croppedPath = await _cropImage(image.path);
      if (croppedPath != null) {
        setState(() {
          selectedImage = croppedPath;
        });
        showImagePopUp(mainContext: mainContext);
      }
      return;
    }
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;

    if (files != null && files.isNotEmpty) {
      String? croppedPath = await _cropImage(files.first.path);
      if (croppedPath != null) {
        setState(() {
          selectedImage = croppedPath;
        });
        showImagePopUp(mainContext: mainContext);
      }
    }
  }

  Future<bool?> showImagePopUp({required BuildContext mainContext}) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: ColorUtils.backgroundBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(color: const Color(0xFF666666), width: 1.w),
              ),
              title: Text(
                "Image Preview",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              content: selectedImage != null
                  ? Image.file(
                      File(selectedImage!),
                      // width: 10.w,
                      height: 100.w,
                    )
                  : Container(height: 100.w),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF6A4BFC),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          context.loaderOverlay.show();
                          String employeeId =
                              Get.find<UserAuthController>()
                                  .userData
                                  .value
                                  .userData
                                  ?.employeeId ??
                              '--';
                          bool connection = await ConnectivityService().check();
                          try {
                            if (connection) {
                              Map<String, dynamic> resp =
                                  await ApiServices.updateProfilePic(
                                    selectedFile: selectedImage!,
                                    empId: employeeId,
                                  );
                              AttendanceCommonWidgets().printF(
                                "--------profile pic save resp------------$resp",
                              );
                              if (resp['status'] == 200) {
                                await Get.find<UserProfileController>()
                                    .fetchUserData(empId: employeeId);
                                Navigator.pop(ctx);
                                HapticFeedback.lightImpact();
                                UploadSuccessDialog().showWarn(
                                  context: mainContext,
                                  message:
                                      "Profile picture updated Successfully",
                                );
                              } else {
                                Navigator.pop(ctx);
                                HapticFeedback.lightImpact();
                                ErrorDialog().showWarn(
                                  context: mainContext,
                                  title: "Failed to save profile picture",
                                );
                              }
                            } else {
                              Navigator.pop(ctx);
                              HapticFeedback.lightImpact();
                              ErrorDialog().showWarn(
                                context: mainContext,
                                title: "Failed",
                                subTitle: "No internet connection.",
                              );
                            }
                          } catch (e) {
                            Navigator.pop(ctx);
                            HapticFeedback.lightImpact();
                            ErrorDialog().showWarn(
                              context: mainContext,
                              title: "Failed",
                              subTitle: "Something went wrong.",
                            );
                          } finally {
                            selectedImage = null;
                          }
                          context.loaderOverlay.hide();
                        },
                        child: Text(
                          "Save",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: ColorUtils.foregroundBlack,
                          elevation: 0,
                        ),
                        onPressed: () {
                          selectedImage = null;
                          Navigator.pop(ctx);
                        },
                        child: FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close,
                                color: ColorUtils.textWhite,
                                size: 15.w,
                              ),
                              Text(
                                "Cancel",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
