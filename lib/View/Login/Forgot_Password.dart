import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/error_dialog.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocus = FocusNode();
  RxBool _showValidation = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _emailFocus.unfocus(),
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 20).w,
                  child: SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: 86.w,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Text(
                  'Forgot Password!',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.h,
                    color: ColorUtils.textWhite,
                  ),
                ),
                SizedBox(height: 5.w),
                Text(
                  "Provide your email and we'll promptly send a link for resetting your password",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.h,
                    color: ColorUtils.textWhite.withOpacity(0.8),
                  ),
                ),
                Obx(() => Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: _showValidation.value && _emailController.text.trim().isEmpty ? 5.w : 20.w),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12).w,
                    onTap: () {
                      _emailFocus.requestFocus();
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      height: 65.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF101010),
                        borderRadius: BorderRadius.circular(12).w,
                        border: Border.all(
                          width: _showValidation.value && _emailController.text.trim().isEmpty ? 1.w : 2.w,
                          color: _showValidation.value && _emailController.text.trim().isEmpty ? ColorUtils.errorRedBorder : const Color(0xFF151515),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10).w,
                            child: SvgPicture.asset(
                              "assets/images/EnvelopeSimple.svg",
                              width: 24.w,
                              fit: BoxFit.fitWidth,
                              colorFilter: _showValidation.value && _emailController.text.trim().isEmpty ? const ColorFilter.mode(ColorUtils.errorRedText, BlendMode.srcIn) : null,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().screenWidth * 0.7,
                            height: 65.w,
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.haceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      bottom: 2,
                                    ).w,
                                    child: Text(
                                      "Email",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.h,
                                        color: _showValidation.value && _emailController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    // focusNode: _reasonFocus,
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    cursorColor: Colors.grey,
                                    onTap: () {},
                                    onChanged: (value) {
                                      if (_showValidation.value) {
                                        _showValidation.refresh();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter your email",
                                      hintStyle: GoogleFonts.inter(
                                        color: _showValidation.value && _emailController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(
                                          0.2,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.h,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.only(
                                        left: 10,
                                        bottom: 0,
                                        top: 0,
                                      ).w,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.h,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                Obx(() => _showValidation.value && _emailController.text.trim().isEmpty ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, bottom: 15.w),
                      child: Text(
                        "Email is required",
                        style: GoogleFonts.inter(
                          color: ColorUtils.errorRedText,
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ) : const SizedBox()),
                GestureDetector(
                  onTap: () async {
                    if (_emailController.text.trim().isNotEmpty) {
                      bool? result = await Get.find<UserAuthController>()
                          .sendMail(
                            emailId: _emailController.text,
                            context: context,
                          );
                      if (result == true) {
                        _emailController.clear();
                        Navigator.of(context).pop();
                      }
                    } else {
                      _showValidation.value = true;
                    }
                  },
                  child: GetX<UserAuthController>(
                    builder: (UserAuthController userController) {
                      return LoyaltriBlueTextButton(
                        text: "Reset Password",
                        showLoading: userController.forgetLoading.value,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Back to login?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.h,
                      color: ColorUtils.textWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
