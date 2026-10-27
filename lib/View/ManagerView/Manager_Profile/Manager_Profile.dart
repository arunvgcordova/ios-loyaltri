import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Profile/change_password_page.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/checkIn_model.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../services/api_services.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/controller_handling.dart';
import '../../../sqflite_db/punch_db.dart';
import '../../../utils/api_constants.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../Leave_Page/leave_widgets/leave_type_card.dart';
import '../../Login/Login_Screen.dart';
import '../../Profile_Page/image_crop_screen.dart';
import '../../Work_Entry/work_entry_widgets/alert_dialogue.dart';
import '../Manager_Request/request_wigets_manager/letter_request_bottomSheet.dart';

class ManagerProfile extends StatefulWidget {
  const ManagerProfile({super.key});

  @override
  State<ManagerProfile> createState() => _ManagerProfileState();
}

class _ManagerProfileState extends State<ManagerProfile> {
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: ScreenUtil().screenHeight,
            child: Stack(
              children: [
                gradientContainer2,
                Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0).w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14).w,
                              child: Material(
                                color: ColorUtils.foregroundBlack,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 48.h,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.textWhite,
                                      borderRadius: BorderRadius.circular(14).r,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5).h,
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: ColorUtils.workEntryHead,
                                          size: 15.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/userprofile.webp",
                                  height: 28.h,
                                ),
                                SizedBox(width: 4.h),
                                Text(
                                  "My Profile",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.workEntryHead,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.h,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 48.h,
                              height: 48.h,
                              color: Colors.transparent,
                            ),
                            // const Spacer(flex: 10),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GetX<UserProfileController>(
                        builder: (UserProfileController controller) {
                          UserProfile user = controller.userData.value.result;
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 10).w,
                                child: Container(
                                  height: 105.h,
                                  width: 105.w,
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500).w,
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
                                                    width: 100.w,
                                                    height: 100.w,
                                                    fit: BoxFit.fitWidth,
                                                  )
                                                  : CachedNetworkImage(
                                                    imageUrl:
                                                        user.profilePicture
                                                            .toString(),
                                                    width: 100.w,
                                                    height: 100.w,
                                                    fit: BoxFit.fitWidth,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => Image.asset(
                                                          user.gender?.trim().toLowerCase() == "female"
                                                              ? "assets/images/profile_pic_girl.jpg"
                                                              : "assets/images/profile_pic.png",
                                                        ),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Image.asset(
                                                          user.gender?.trim().toLowerCase() == "female"
                                                              ? "assets/images/profile_pic_girl.jpg"
                                                              : "assets/images/profile_pic.png",
                                                        ),
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
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(
                                                0xFFC7C7C7,
                                              ).withValues(alpha: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(80).w,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                "assets/images/camera-icon3d.webp",
                                                width: 20.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10).w,
                                child: Text(
                                  [
                                    if (user.firstName != null && user.firstName!.isNotEmpty) user.firstName,
                                    if (user.middleName != null && user.middleName!.isNotEmpty) user.middleName,
                                    if (user.lastName != null && user.lastName!.isNotEmpty) user.lastName,
                                  ].join(' '),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20).w,
                                child: Text(
                                  user.designation ?? "--",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.h,
                        vertical: 35.h,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            newSlideNavigation(const ChangePasswordPage()),
                          );
                        },
                          borderRadius: BorderRadius.circular(14).w,
                        child: Container(
                          width: ScreenUtil().screenWidth,
                          height: 56.w,
                          padding: const EdgeInsets.symmetric(horizontal: 10).w,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF6F2FF),
                              borderRadius: BorderRadius.circular(14).w
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/manager_view/reset_psw.svg",
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Change Password",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: ColorUtils.workEntryHead,
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined, size: 15.h, color: ColorUtils.workEntryHead),
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
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: ColorUtils.whiteSmoke,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.h,
                  vertical: 10.h,
                ),
                child: GestureDetector(
                  onTap: () async {
                    await logOutWarn();
                  },
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: 65.w,
                    padding: const EdgeInsets.symmetric(horizontal: 10).w,
                    decoration: BoxDecoration(
                        color: const Color(0xFFB61F1F),
                        borderRadius: BorderRadius.circular(14).w
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/SignOut.svg",
                          colorFilter: ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Log Out",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                ApiConstants.apiLink == ""
                    ? "Version : ${ApiConstants.appVersion}"
                    : "Version : ${ApiConstants.apiLink} - ${ApiConstants.appVersion}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  attachBottomSheetShow(mainContext) {
    showModalBottomSheet(
      context: mainContext,
      backgroundColor: Colors.white,
      barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: ScreenUtil().screenWidth,
              height: 273.w,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(20).w,
                // border: Border.all(
                //   width: 1.w,
                //   color: const Color(0xFF404040),
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Source",
                      style: GoogleFonts.poppins(
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
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

                          String? croppedPath = await _cropImage(value);
                          selectedImage = croppedPath;
                          if(selectedImage != null) {
                            showImagePopUp(mainContext: mainContext);
                          }
          
                          // if(selectedImages.length < 5) {
                          //   selectedImages.add(value),
                          //   setState(() {})
                          // } else {
                          //   ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected")
                          // }
                        });
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/camera.webp",
                        title: "Camera",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
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
                            String? croppedPath = await _cropImage(file.path);
                            setState(() {
                              selectedImage = croppedPath;
                            });
                          } else {
                            // User canceled the picker
                          }
                        } catch(e) {
                          AttendanceCommonWidgets().printF("------error-------${e.toString()}");
                        }
                        if(selectedImage != null) {
                          showImagePopUp(mainContext: mainContext);
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/image-3d.webp",
                        title: "Photos",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp'],
                        );
          
                        if (result != null) {
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
                          String? croppedPath = await _cropImage(file.path);
                          setState(() {
                            selectedImage = croppedPath;
                            // if(selectedImages.length < 5) {
                            //   if(files.length < (6 - selectedImages.length)) {
                            //     for (var file in files) {
                            //       selectedImages.add(file.path);
                            //     }
                            //   } else {
                            //     ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
                            //   }
                            // } else {
                            //   ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
                            // }
                          });
                        } else {
                          // User canceled the picker
                        }
                        if(selectedImage != null) {
                          showImagePopUp(mainContext: mainContext);
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/file-3d.webp",
                        title: "Browse",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
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

  Future<String?> _cropImage(String sourcePath) async {
    final croppedPath = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ImageCropScreen(imagePath: sourcePath),
      ),
    );
    return croppedPath;
  }

  Future<void> getLostData(mainContext) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final LostDataResponse response = await picker.retrieveLostData();
    // AttendanceCommonWidgets().printF("------path------${image.path}");
    if(image != null) {
      selectedImage = image.path;
      // if(selectedImages.length < 5) {
      //   if(image.length < (6 - selectedImages.length)) {
      //     for (var file in image) {
      //       selectedImages.add(file.path);
      //     }
      //     setState(() {});
      //   } else {
      //     ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
      //   }
      // } else {
      //   ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
      // }
    }
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;

    files?.forEach((element) {
      setState(() {
        selectedImage = files.first.path;
        // if(selectedImages.length < 5) {
        //   if(files.length < (6 - selectedImages.length)) {
        //     for (var file in files) {
        //       selectedImages.add(file.path);
        //     }
        //   } else {
        //     ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
        //   }
        // } else {
        //   ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
        // }
      });
      AttendanceCommonWidgets().printF("------path------${element.path}");
    });
    if (files != null) {
      // _handleLostFiles(files);
    } else {
      // _handleError(response.exception);
    }
  }

  Future<bool?> showImagePopUp(
      {required BuildContext mainContext,}) async {
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
              backgroundColor: ColorUtils.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(
                  color: const Color(0xFF666666),
                  width: 1.w,
                ),
              ),
              title: Text(
                "Image Preview",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: ColorUtils.workEntryHead,
                ),
              ),
              content: selectedImage != null ? Image.file(
                File(selectedImage!),
                // width: 10.w,
                height: 100.w,
              ) : Container(height: 100.w),
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
                            elevation: 0),
                        onPressed: () async {
                          context.loaderOverlay.show();
                          String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                          bool connection = await ConnectivityService().check();
                          try {
                            if(connection) {
                              Map<String, dynamic> resp = await ApiServices.updateProfilePic(selectedFile: selectedImage!, empId: employeeId);
                              AttendanceCommonWidgets().printF("--------profile pic save resp------------$resp");
                              if(resp['status'] == 200) {
                                await Get.find<UserProfileController>().fetchUserData(empId: employeeId);
                                Navigator.pop(ctx);
                                HapticFeedback.lightImpact();
                                UploadSuccessDialog().showWarnManager(context: mainContext, message: "Profile picture updated Successfully");
                              } else {
                                Navigator.pop(ctx);
                                HapticFeedback.lightImpact();
                                ErrorDialog().showWarnManager(context: mainContext, title: "Failed to save profile picture");
                              }
                            } else {
                              Navigator.pop(ctx);
                              HapticFeedback.lightImpact();
                              ErrorDialog().showWarnManager(context: mainContext, title: "Failed", subTitle: "No internet connection.");
                            }
                          } catch(e) {
                            Navigator.pop(ctx);
                            HapticFeedback.lightImpact();
                            ErrorDialog().showWarnManager(context: mainContext, title: "Failed", subTitle: "Something went wrong.");
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
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                            backgroundColor: ColorUtils.foregroundBlack.withValues(alpha: 0.6),
                            elevation: 0),
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
              backgroundColor: ColorUtils.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                // side: BorderSide(
                //   color: const Color(0xFF666666),
                //   width: 1.w,
                // ),
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
                  color: ColorUtils.workEntryHead,
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
                            elevation: 0),
                        onPressed: () async {
                          await Get.find<UserAuthController>().logOut(context);
                        },
                        child: GetX<UserAuthController>(
                          builder: (UserAuthController controller) {
                            if(controller.logOutLoading.value) {
                              return SizedBox(
                                width: 15.h,
                                height: 15.h,
                                child: CircularProgressIndicator(color: Colors.white),
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
                          }
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      // width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                            backgroundColor: ColorUtils.foregroundBlack.withValues(alpha: 0.6),
                            elevation: 0),
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
}
