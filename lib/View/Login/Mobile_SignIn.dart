
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Login/OTP_Screen.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';

class SignInWithMobile extends StatefulWidget {
  const SignInWithMobile({super.key});

  @override
  State<SignInWithMobile> createState() => _SignInWithMobileState();
}

class _SignInWithMobileState extends State<SignInWithMobile> {
  TextEditingController mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                'Welcome back!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                'Please enter your mobile number',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: ColorUtils.textWhite.withOpacity(0.8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30).w,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: 65.w,
                    decoration: BoxDecoration(
                      color: ColorUtils.backgroundBlack1,
                      borderRadius: BorderRadius.circular(12).w,
                      border: Border.all(
                        width: 2.w,
                        color: ColorUtils.foregroundBlack1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10).w,
                          child: SvgPicture.asset(
                            "assets/images/smartphone-line.svg",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10).w,
                          child: Container(
                            width: ScreenUtil().screenWidth * 0.7,
                            height: 65.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10).w,
                                  child: Text(
                                    "Mobile Number",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.w,
                                  child: TextFormField(
                                    cursorColor: Colors.grey,
                                    onTap: () {},
                                    decoration: InputDecoration(
                                      hintText: "0 000 000 000",
                                      prefixIcon: Column(
                                        children: [
                                          const Spacer(flex: 2),
                                          Text(
                                            "+971",
                                            style: GoogleFonts.inter(
                                              color: ColorUtils.textWhite,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      hintStyle: GoogleFonts.inter(
                                        color: ColorUtils.textWhite.withOpacity(0.2),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                              left: 10, bottom: 10)
                                          .w,
                                    ),
                                    style: GoogleFonts.inter(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    )
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    newSlideNavigation(const OTPScreen()),
                  );
                },
                child: const LoyaltriBlueTextButton(text: "Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
