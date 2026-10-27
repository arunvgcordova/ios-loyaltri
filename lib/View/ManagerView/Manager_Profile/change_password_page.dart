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
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../Leave_Page/leave_widgets/leave_type_card.dart';
import '../../Leave_Page/leave_widgets/success_dialogue.dart';
import '../../Login/Login_Screen.dart';
import '../../Work_Entry/work_entry_widgets/alert_dialogue.dart';
import '../Manager_Request/request_wigets_manager/letter_request_bottomSheet.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPswController = TextEditingController();
  final TextEditingController _newPswController = TextEditingController();

  final ValueNotifier<String?> _oldPswErrorMsg = ValueNotifier(null);
  final ValueNotifier<String?> _newPswErrorMsg = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Scaffold(
          body: Container(
            height: ScreenUtil().screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorUtils.lavenderPurple,
                  ColorUtils.lavenderMist,
                  ColorUtils.textWhite,
                  ColorUtils.textWhite,
                  ColorUtils.textWhite,
                  ColorUtils.textWhite,
                  ColorUtils.textWhite,
                  ColorUtils.textWhite,
                  ColorUtils.whiteSmoke,
                  ColorUtils.whiteSmoke,
                  ColorUtils.whiteSmoke,
                  ColorUtils.whiteSmoke,
                  ColorUtils.whiteSmoke,
                  ColorUtils.whiteSmoke,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20).h,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 200.h),
                    Container(
                      width: 100.h,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.secondaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/manager_view/loyaltri-blue-logo.svg',
                          height: 50.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Change Password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.h,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    ValueListenableBuilder(
                      valueListenable: _oldPswErrorMsg,
                      builder: (context, value, child) {
                        return Container(
                          width: ScreenUtil().screenWidth,
                          height: 65.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: Border.all(
                              width: 2.h,
                              color: value == null
                                  ? ColorUtils.workEntryHead.withValues(
                                alpha: 0.1,
                              )
                                  : ColorUtils.errorRedText,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.h),
                                child: SvgPicture.asset(
                                  "assets/images/Lock.svg",
                                  width: 24.h,
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(
                                    value == null
                                        ? ColorUtils.workEntryHead
                                        : ColorUtils.errorRedText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().screenWidth * 0.7,
                                height: 65.h,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 4.h,
                                          bottom: 2.h,
                                        ),
                                        child: Text(
                                          "Old Password",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.h,
                                            color: value == null
                                                ? ColorUtils.workEntryHead
                                                .withValues(alpha: 0.5)
                                                : ColorUtils.errorRedText,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        cursorColor: Colors.grey,
                                        onTap: () {},
                                        controller: _oldPswController,
                                        onChanged: (value) {
                                          validatePassword(
                                            validateOld: true,
                                            validateNew: false,
                                          );
                                        },
                                        // maxLength: 15,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: GoogleFonts.inter(
                                            color: value == null
                                                ? ColorUtils.workEntryHead
                                                .withValues(alpha: 0.2)
                                                : ColorUtils.errorRedText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.h,
                                          ),
                                          filled: true,
                                          fillColor:
                                          ColorUtils.paleLavenderMist,
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          counterText: '',
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.h,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 2.h),
                    ValueListenableBuilder(
                      valueListenable: _oldPswErrorMsg,
                      builder: (context, value, child) {
                        if (value == null) return SizedBox.shrink();
                        return Row(
                          children: [
                            SizedBox(width: 4.h),
                            Text(
                              value,
                              style: GoogleFonts.poppins(
                                color: ColorUtils.errorRedText,
                                fontSize: 12.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    ValueListenableBuilder(
                      valueListenable: _newPswErrorMsg,
                      builder: (context, value, child) {
                        return Container(
                          width: ScreenUtil().screenWidth,
                          height: 65.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: Border.all(
                              width: 2.h,
                              color: value == null
                                  ? ColorUtils.workEntryHead.withValues(
                                alpha: 0.1,
                              )
                                  : ColorUtils.errorRedText,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.h),
                                child: SvgPicture.asset(
                                  "assets/images/Lock.svg",
                                  width: 24.h,
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(
                                    value == null
                                        ? ColorUtils.workEntryHead
                                        : ColorUtils.errorRedText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().screenWidth * 0.65,
                                height: 65.h,
                                child: Center(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 4.h,
                                          bottom: 2.h,
                                        ),
                                        child: Text(
                                          "New Password",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.h,
                                            color: value == null
                                                ? ColorUtils.workEntryHead
                                                .withValues(alpha: 0.5)
                                                : ColorUtils.errorRedText,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        cursorColor: Colors.grey,
                                        onTap: () {},
                                        controller: _newPswController,
                                        onChanged: (value) {
                                          validatePassword(
                                            validateNew: true,
                                            validateOld: false,
                                          );
                                        },
                                        maxLength: 15,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          counterText: '',
                                          hintStyle: GoogleFonts.inter(
                                            color: value == null
                                                ? ColorUtils.workEntryHead
                                                .withValues(alpha: 0.2)
                                                : ColorUtils.errorRedText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.h,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(
                                            left: 4.h,
                                            bottom: 0,
                                            top: 0,
                                          ),
                                        ),
                                        obscuringCharacter: "*",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.h,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.h,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/images/Eye.svg",
                                    width: 20.h,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 2.h),
                    ValueListenableBuilder(
                      valueListenable: _newPswErrorMsg,
                      builder: (context, value, child) {
                        if (value == null) return SizedBox.shrink();
                        return Row(
                          children: [
                            SizedBox(width: 4.h),
                            Flexible(
                              child: Text(
                                value,
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.errorRedText,
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                    GetX<UserAuthController>(
                      builder: (UserAuthController controller) {
                        return InkWell(
                          onTap: () async {
                            validatePassword();
                            if (_oldPswErrorMsg.value == null &&
                                _newPswErrorMsg.value == null &&
                                !controller.changePswLoader.value) {
                              final result = await controller.changePassword(
                                oldP: _oldPswController.text,
                                newP: _newPswController.text,
                              );
                              if (result?.status == 200) {
                                await ShowSuccessDialog().showSuccessManager(
                                  context: context,
                                  title: 'Message',
                                  subTitle: result?.message ?? 'Password Changed',
                                );
                                _oldPswController.clear();
                                _newPswController.clear();
                                Navigator.of(context).pop();
                              } else {
                                ErrorDialog().showWarnManager(
                                  context: context,
                                  title: 'Message',
                                  subTitle: result?.message ?? 'Something went wrong',
                                );
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(37).r,
                          child: LoyaltriBlueTextButton(
                            text: "Change Password",
                            showLoading: controller.changePswLoader.value,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            ColorUtils.paleLavenderMist,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Back",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.h,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validatePassword({bool? validateOld, bool? validateNew}) {
    if (validateOld ?? true) {
      if (_oldPswController.text.trim().isEmpty) {
        _oldPswErrorMsg.value = 'Old Password is required';
      } else {
        _oldPswErrorMsg.value = null;
      }
    }
    if (validateNew ?? true) {
      if (_newPswController.text.trim().isEmpty) {
        _newPswErrorMsg.value = 'New Password is required';
      } if(_oldPswController.text.trim() == _newPswController.text.trim()) {
        _newPswErrorMsg.value = 'New password should not be the same as the old password';
      } else {
        final passwordRegex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
        );

        if (!passwordRegex.hasMatch(_newPswController.text)) {
          _newPswErrorMsg.value =
          "Password must be 8–15 characters, include an uppercase letter, a lowercase letter, a number, and a special character.";
        } else {
          _newPswErrorMsg.value = null;
        }
      }
    }
  }
}
