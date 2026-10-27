
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:pinput/pinput.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import '../menu_page.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      margin: const EdgeInsets.only(left: 8, right: 8).w,
      width: 60.85.w,
      height: 60.w,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: ColorUtils.textWhite,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 2.w, color: ColorUtils.foregroundBlack1),
        color: ColorUtils.backgroundBlack1,
        borderRadius: BorderRadius.circular(16).w,
      ),
    );

    return Scaffold(
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
                'Verify OTP',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                'Please enter the 4 digit code sent to',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: ColorUtils.textWhite.withOpacity(0.8),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+971 50 123 4567',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  Text(
                    ' through SMS',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20).w,
              //   child: Text(
              //     'Incorrect Code! Please try again',
              //     style: LoyaltriFonts.poppinsW500_14sp_incorrectOTP,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30).w,
                child: Pinput(
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: ColorUtils.foregroundBlack1),
                      )),
                  errorPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: ColorUtils.errorRedBorder),
                      )),
                  onCompleted: (String value) async {},
                  // forceErrorState: userAuthController.isLoading.value ||
                  //     userAuthController.isNetwrkError.value ||
                  //     userAuthController.isPinError.value,
                  closeKeyboardWhenCompleted: true,
                  keyboardType: TextInputType.number,
                  errorTextStyle: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w200,
                    color: ColorUtils.errorRedText,
                  ),
                  errorBuilder: (String? errorText, String? enteredValue) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12).w,
                        child: Text(
                          errorText!,
                          style: GoogleFonts.inter(
                            color: ColorUtils.errorRedText,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Didn’t receive a code?',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  Text(
                    ' Resend SMS',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: ColorUtils.resendSMS,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30).w,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MenuPage()), (route) => false);
                  },
                  child: LoyaltriBlueTextButton(text: "Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
