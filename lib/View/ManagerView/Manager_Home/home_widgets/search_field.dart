import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';

import '../../../../controller/userAuthentication.dart';
import '../../../../utils/color_utils.dart';
import '../../Manager_Employee/employee_page_controller/employee_page_controller.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: ColorUtils.snowGrey,
          borderRadius: BorderRadius.circular(50).r,
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Animated Text
            GetX<ManagerHomeController>(
              builder: (ManagerHomeController controller) {
                if(controller.textController.value.isEmpty) {
                  return Positioned(
                    left: 45.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 1.h,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Search for People",
                            style: GoogleFonts.poppins(
                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                              fontSize: 12.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // AnimatedTextKit(
                          //   isRepeatingAnimation: true,
                          //   repeatForever: true,
                          //   pause: Duration(milliseconds: 500),
                          //   animatedTexts: [
                          //     RotateAnimatedText(
                          //       "People",
                          //       textStyle: GoogleFonts.poppins(
                          //         color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          //         fontSize: 12.h,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //     RotateAnimatedText(
                          //       "Settings",
                          //       textStyle: GoogleFonts.poppins(
                          //         color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          //         fontSize: 12.h,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //     RotateAnimatedText(
                          //       "Pages",
                          //       textStyle: GoogleFonts.poppins(
                          //         color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          //         fontSize: 12.h,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }
            ),

            // Search Field
            TextField(
              onTap: () async {
                Get.find<UserPageController>().currentIndex.value = 3;
                context.loaderOverlay.show();
                await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
                context.loaderOverlay.hide();
              },
              style: GoogleFonts.poppins(
                color: ColorUtils.workEntryHead,
                fontSize: 13.h,
                fontWeight: FontWeight.w400,
              ),
              readOnly: true,
              onChanged: (value) {
                Get.find<ManagerHomeController>().textController.value = value;
              },
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 45.h,
                  top: 13.h,
                  bottom: 13.h,
                  right: 10.h,
                ),
                // prefixIcon: Padding(
                //   padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                //   child: SvgPicture.asset(
                //     "assets/images/manager_view/search_icon_req.svg",
                //     fit: BoxFit.contain,
                //   ),
                // ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 12.h, left: 15.h),
              child: SvgPicture.asset(
                "assets/images/manager_view/search_icon_req.svg",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RotateAnimatedText extends AnimatedText {
  /// Transition height.
  ///
  /// By default it is set to [TextStyle.fontSize] * 10 / 3.
  final double? transitionHeight;

  /// Adds [AlignmentGeometry] property to the text in the widget.
  ///
  /// By default it is set to [Alignment.center]
  final AlignmentGeometry alignment;

  /// Specifies the [TextDirection] for resolving alignment.
  ///
  /// By default it is set to [TextDirection.ltr]
  final TextDirection textDirection;

  /// Controls whether the text:
  /// * rotates in _and_ out (true), or
  /// * just rotates _in_ (false).
  ///
  /// Note that you may want to adjust the [duration] when mixing
  /// [RotateAnimatedText] instances with mixed [rotateOut] values.
  ///
  /// By default, it is set to true.
  final bool rotateOut;

  RotateAnimatedText(
      String text, {
        super.textAlign,
        super.textStyle,
        super.duration = const Duration(seconds: 3),
        this.transitionHeight,
        this.alignment = Alignment.center,
        this.textDirection = TextDirection.ltr,
        this.rotateOut = true,
      }) : super(
    text: text,
  );

  late Animation<double> _fadeIn, _fadeOut;
  late Animation<Alignment> _slideIn, _slideOut;

  @override
  void initAnimation(AnimationController controller) {
    final direction = textDirection;

    final inIntervalEnd = rotateOut ? 0.1 : 1.0;

    _slideIn = AlignmentTween(
      begin: Alignment.bottomCenter.add(alignment).resolve(direction),
      end: Alignment.center.add(alignment).resolve(direction),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, inIntervalEnd, curve: Curves.linear),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, inIntervalEnd, curve: Curves.easeOut),
      ),
    );

    if (rotateOut) {
      _slideOut = AlignmentTween(
        begin: Alignment.center.add(alignment).resolve(direction),
        end: Alignment.topCenter.add(alignment).resolve(direction),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.9, 1.0, curve: Curves.linear),
        ),
      );

      _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
        ),
      );
    }
  }

  @override
  Widget completeText(BuildContext context) =>
      rotateOut ? SizedBox.shrink() : super.completeText(context);

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final fontSize =
        textStyle?.fontSize ?? DefaultTextStyle.of(context).style.fontSize;

    return SizedBox(
      height: transitionHeight ?? (fontSize! * 10 / 3),
      child: AlignTransition(
        alignment: _slideIn.value.y != 0.0 || !rotateOut ? _slideIn : _slideOut,
        child: Opacity(
          opacity: _fadeIn.value != 1.0 || !rotateOut
              ? _fadeIn.value
              : _fadeOut.value,
          child: textWidget(text),
        ),
      ),
    );
  }
}
