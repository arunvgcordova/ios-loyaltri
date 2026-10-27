
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/Login/Forgot_Password.dart';
import 'package:loyaltri_minimal/View/Login/Mobile_SignIn.dart';
import 'package:loyaltri_minimal/View/Login/login_widgets/custom_check_box.dart';
import 'package:loyaltri_minimal/View/Login/login_widgets/signInWith_button.dart';
import 'package:loyaltri_minimal/View/Login/login_widgets/versionUpdateDialogue.dart';
import 'package:loyaltri_minimal/controller/versionCheckController.dart';
import 'package:loyaltri_minimal/models/user_api_model.dart';
import '../../controller/network_controller.dart';
import '../../controller/ui_controller/home_controller.dart';
import '../../controller/ui_controller/page_controller.dart';
import '../../controller/userAuthentication.dart';
import '../../services/flutter_secure_storage.dart';
import '../../utils/api_constants.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/cwidgets.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import '../menu_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  FocusNode _usernameFocus = FocusNode();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocus = FocusNode();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isCheckedw = false;
  bool _hidePsw = true;
  RxBool _showValidation = false.obs;
  @override
  void initState() {
    initialize();
    SystemChrome.setSystemUIOverlayStyle(
      systemUiOverlayStyleDark,
    );
    super.initState();
  }

  Future<void> initialize() async {
    LoginCredentials? loginData = await SecureStorageUtils().getRememberMe();
    if (loginData != null) {
      setState(() {
        _usernameController = TextEditingController(text: loginData.username);
        _passwordController = TextEditingController(text: loginData.password);
        _isCheckedw = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).w,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: GetX<UserAuthController>(
                  builder: (UserAuthController controller) {
                    if (userAuthController.isLoading.value) {
                      context.loaderOverlay.show();
                    } else {
                      context.loaderOverlay.hide();
                    }
                    return Column(
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
                          'Please enter your details to log in',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite.withOpacity(0.8),
                          ),
                        ),
                        Obx(() => Padding(
                          padding: EdgeInsets.only(top: 20.w, bottom: _showValidation.value && _usernameController.text.trim().isEmpty ? 5.w : 20.w),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12).w,
                            onTap: () {
                              _usernameFocus.requestFocus();
                            },
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              height: 65.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF101010),
                                borderRadius: BorderRadius.circular(12).w,
                                border: Border.all(
                                  width: _showValidation.value && _usernameController.text.trim().isEmpty ? 1.w : 2.w,
                                  color: _showValidation.value && _usernameController.text.trim().isEmpty ? ColorUtils.errorRedBorder : const Color(0xFF151515),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10).w,
                                    child: SvgPicture.asset(
                                      "assets/images/EnvelopeSimple.svg",
                                      width: 24.w,
                                      fit: BoxFit.fitWidth,
                                      colorFilter: _showValidation.value && _usernameController.text.trim().isEmpty ? const ColorFilter.mode(ColorUtils.errorRedText, BlendMode.srcIn) : null,
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil().screenWidth * 0.7,
                                    height: 65.w,
                                    child: Center(
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, bottom: 2).w,
                                            child: Text(
                                              "Email or Phone Number",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: _showValidation.value && _usernameController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            // focusNode: _reasonFocus,
                                            controller: _usernameController,
                                            focusNode: _usernameFocus,
                                            cursorColor: Colors.grey,
                                            onTap: () {},
                                            onChanged: (value) {
                                              if (_showValidation.value) {
                                                _showValidation.refresh();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Enter your email or phone number",
                                              hintStyle: GoogleFonts.inter(
                                                // color: _showValidation.value && _usernameController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                color: ColorUtils.textWhite.withOpacity(0.2),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                              ),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: const EdgeInsets.only(
                                                  left: 10, bottom: 0, top: 0)
                                                  .w,
                                            ),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
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
                        Obx(() => _showValidation.value && _usernameController.text.trim().isEmpty ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, bottom: 15.w),
                              child: Text(
                                "Email or Phone Number is required",
                                style: GoogleFonts.inter(
                                  color: ColorUtils.errorRedText,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ) : const SizedBox()),
                        Obx(() => InkWell(
                          borderRadius: BorderRadius.circular(12).w,
                          onTap: () {
                            _passwordFocus.requestFocus();
                          },
                          child: Container(
                            width: ScreenUtil().screenWidth,
                            height: 65.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF101010),
                              borderRadius: BorderRadius.circular(12).w,
                              border: Border.all(
                                width: _showValidation.value && _passwordController.text.trim().isEmpty ? 1.w : 2.w,
                                color: _showValidation.value && _passwordController.text.trim().isEmpty ? ColorUtils.errorRedBorder : const Color(0xFF151515),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10).w,
                                  child: SvgPicture.asset(
                                    "assets/images/Lock.svg",
                                    width: 24.w,
                                    fit: BoxFit.fitWidth,
                                    colorFilter: _showValidation.value && _passwordController.text.trim().isEmpty ? const ColorFilter.mode(ColorUtils.errorRedText, BlendMode.srcIn) : null,
                                  ),
                                ),
                                Container(
                                  width: ScreenUtil().screenWidth * 0.65,
                                  height: 65.w,
                                  child: Center(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 2).w,
                                          child: Text(
                                            "Password",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: _showValidation.value && _passwordController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          // focusNode: _reasonFocus,
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          cursorColor: Colors.grey,
                                          onTap: () {},
                                          onChanged: (value) {
                                            if (_showValidation.value) {
                                              _showValidation.refresh();
                                            }
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                          ],
                                          // maxLength: 15,
                                          decoration: InputDecoration(
                                            hintText: "Enter your password",
                                            hintStyle: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withOpacity(0.2),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: const EdgeInsets.only(
                                                left: 10, bottom: 0, top: 0)
                                                .w,
                                            counterText: '',
                                          ),
                                          obscureText: _hidePsw,
                                          obscuringCharacter: "*",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() => _hidePsw = !_hidePsw);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10).w,
                                    child: SvgPicture.asset(
                                      _hidePsw ? "assets/images/eye_close.svg" : "assets/images/Eye.svg",
                                      width: _hidePsw ? 17.w : 20.w,
                                      fit: BoxFit.fitWidth,
                                      colorFilter: _showValidation.value && _passwordController.text.trim().isEmpty ? const ColorFilter.mode(ColorUtils.errorRedText, BlendMode.srcIn) : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Obx(() => _showValidation.value && _passwordController.text.trim().isEmpty ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, top: 5.w),
                              child: Text(
                                "Password is required",
                                style: GoogleFonts.inter(
                                  color: ColorUtils.errorRedText,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ) : const SizedBox()),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     width: ScreenUtil().screenWidth,
                        //     height: 65.w,
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFF101010),
                        //       borderRadius: BorderRadius.circular(12).w,
                        //       border: Border.all(
                        //         width: 2.w,
                        //         color: const Color(0xFF151515),
                        //       ),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(horizontal: 10).w,
                        //           child: SvgPicture.asset(
                        //             "assets/images/Lock.svg",
                        //             width: 24.w,
                        //             fit: BoxFit.fitWidth,
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(vertical: 10).w,
                        //           child: Container(
                        //             width: ScreenUtil().screenWidth * 0.65,
                        //             height: 65.w,
                        //             child: Column(
                        //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(left: 10).w,
                        //                   child: Text(
                        //                     "Password",
                        //                     style: LoyaltriFonts
                        //                         .poppinsW400_12sp_textWhiteOp50,
                        //                   ),
                        //                 ),
                        //                 TextFormField(
                        //                   // focusNode: _reasonFocus,
                        //                   controller: _passwordController,
                        //                   cursorColor: Colors.grey,
                        //                   onTap: () {},
                        //                   decoration: InputDecoration(
                        //                     hintText: "Password",
                        //                     hintStyle: LoyaltriFonts
                        //                         .interW500_12sp_textWhiteOp20,
                        //                     border: InputBorder.none,
                        //                     contentPadding: const EdgeInsets.only(
                        //                         left: 10, bottom: 0, top: 0)
                        //                         .w,
                        //                   ),
                        //                   obscureText: _hidePsw,
                        //                   obscuringCharacter: "*",
                        //                   style: LoyaltriFonts.poppinsW500_12sp_textWhite,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         GestureDetector(
                        //           onTap: () {
                        //             setState(() => _hidePsw = !_hidePsw);
                        //           },
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(horizontal: 10).w,
                        //             child: SvgPicture.asset(
                        //               "assets/images/Eye.svg",
                        //               width: 20.w,
                        //               fit: BoxFit.fitWidth,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() => _isCheckedw = !_isCheckedw);
                                },
                                splashColor: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomCheckbox(
                                      size: 13.0,
                                      iconSize: 8.0,
                                      borderRadius: BorderRadius.circular(3).w,
                                      checkIcon: const Icon(Icons.done_rounded),
                                      borderColor: ColorUtils.textWhite.withOpacity(0.5),
                                      selectedColor: ColorUtils.textWhite.withOpacity(0.5),
                                      isChecked: _isCheckedw,
                                      onChange: (bool? value) {
                                        setState(() => _isCheckedw = value!);
                                      },
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Remember me",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    newSlideNavigation(const ForgotPassword()),
                                  );
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.h,
                                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                    decoration: TextDecoration.underline,
                                    decorationColor: ColorUtils.textWhite.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () async {
                            if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                              _showValidation.value = true;
                              return;
                            } else {
                              await userAuthController.fetchUserData(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                              if (controller.dataLoaded.value) {
                                if(controller.userData.value.userData?.loginType == 1 || controller.userData.value.userData?.loginType == 3) {
                                  Get.find<UserPageController>().setPages(AppView.employee);
                                }
                                if(controller.userData.value.userData?.loginType == 2) {
                                  Get.find<UserPageController>().setPages(AppView.manager);
                                }
                                if (_isCheckedw) {
                                  await SecureStorageUtils().setRememberMe(
                                    LoginCredentials(
                                        username: _usernameController.text,
                                        password: _passwordController.text
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pushAndRemoveUntil(newSlideNavigation(const MenuPage()), (route) => false);
                                  });
                                } else {
                                  await SecureStorageUtils().deleteRememberMe().then((value) {
                                    Navigator.of(context).pushAndRemoveUntil(newSlideNavigation(const MenuPage()), (route) => false);
                                  });
                                }
                              } else {
                                ErrorDialog().showWarn(context: context, title: "Login Failed!", subTitle: controller.errorMessage.value ?? "Something went wrong");
                              }
                            }
                          },
                          child: const LoyaltriBlueTextButton(text: "Sign in"),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 20).w,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.of(context).push(MaterialPageRoute(
                        //           builder: (context) => const SignInWithMobile()));
                        //     },
                        //     child: const SignInWithButton(
                        //       icon: "assets/images/smartphone-line-blue.svg",
                        //       text: "Log in with Mobile Number",
                        //       iconWidth: 20,
                        //     ),
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         thickness: 0.9.w,
                        //         color: ColorUtils.textWhite.withOpacity(0.2),
                        //         height: 0,
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 15).w,
                        //       child: Text(
                        //         "or",
                        //         style: LoyaltriFonts.poppinsW400_12sp_textWhite,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Divider(
                        //         thickness: 0.9.w,
                        //         color: ColorUtils.textWhite.withOpacity(0.2),
                        //         height: 0,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 20).w,
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //       try {
                        //         var account = await _googleSignIn.signIn();
                        //         // GoogleSignInAccount? user = _googleSignIn.currentUser;
                        //         print('User Email: ${account!.email}');
                        //       } catch (error) {
                        //         print('Error signing in: $error');
                        //       }
                        //     },
                        //     child: const SignInWithButton(
                        //       icon: "assets/images/Google.svg",
                        //       text: "Sign in with Google",
                        //       iconWidth: 15.48,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 100.h),
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  top: false,
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: 40.h,
                    color: ColorUtils.workEntryHead,
                    child: Center(
                      child: AnimatedPadding(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.only(bottom: 10).h,
                        child: Text(
                          ApiConstants.apiLink == ""
                              ? "Version : ${ApiConstants.appVersion}"
                              : "Version : ${ApiConstants.apiLink} - ${ApiConstants.appVersion}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: ColorUtils.textWhite.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
