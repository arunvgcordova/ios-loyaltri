import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/form/controller/work_form_controller.dart';
import 'package:loyaltri_minimal/View/field/features/form/model/otp_override_response.dart';
import 'package:loyaltri_minimal/View/field/features/form/widget/otp_override_request_dialog.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/filled_button.dart';

class OtpWidget extends GetView<WorkFormController> {
  OtpWidget({
    super.key,
    required this.otpData,
    required this.workInstanceId,
    required this.workId,
    required this.workTypeId,
  });
  final OtpOverride? otpData;
  final int workInstanceId;
  final int workId;
  final String workTypeId;

  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  String _generatedOtp = '';
  bool _isOtpVerified = false;
  bool _hasOtpError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour2,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Row(
              children: [
                Text(
                  'OTP Verification',
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    if (otpData?.status == "pending" ||
                        otpData?.status == "approved") {
                      return;
                    }
                    bool result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return OtpOverrideRequestDialog(
                          workid: workId,
                          workInstanceId: workInstanceId,
                        );
                      },
                    );
                    // print("sdhashoiudsiu = $result");
                    if (result == true) {
                      controller.fetchWorkFormDetail(
                        id: workTypeId,
                        workInstanceId: workInstanceId.toString(),
                      );
                    }
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: ColourUtils.transparant,
                      border: Border.all(
                        color: ColourUtils.fontColour1,
                        width: 1.h,
                      ),
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: svgWidget(
                            height: 20.h,
                            width: 20.h,
                            icon: 'shield_3',
                          ),
                        ),

                        Text(
                          otpData?.status == "pending" ||
                                  otpData?.status == "approved"
                              ? 'Request Override'
                              : 'Override',
                          style: GoogleFonts.inter(
                            color: ColourUtils.fontColour1,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Required for completion',
            style: GoogleFonts.inter(
              color: ColourUtils.textWhite.withValues(alpha: 0.6),
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          Builder(
            builder: (context) {
              if (otpData?.status == "pending") {
                return StatusWidget(
                  icon: "clock",
                  head1: "Pending owner approval",
                  head2:
                      "Override request sent. Waiting for owner approval before work can be submitted without OTP",
                  head3: "Approval request sent just now",
                  head4: "You will be noticed once the owner responds",
                  color: ColourUtils.fontColour2,
                );
              } else if (otpData?.status == "approved") {
                return StatusWidget(
                  icon: "round_check",
                  head1: "Override approved",
                  head2:
                      "Approved by owner. OTP verification has been bypassed for this submission",
                  head3: "You can continue and submit work",
                  head4: "This override is valid for this submission only",
                  color: ColourUtils.fontColour6,
                );
              } else {
                return Obx(() {
                  final isVerified = controller.isOtpVerified.value;
                  final hasError = controller.hasOtpError.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 75.w,
                        height: 80.h,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.jetBrainsMono(
                            color: isVerified
                                ? ColourUtils.completed
                                : hasError
                                    ? Colors.redAccent
                                    : ColourUtils.textMain,
                            fontSize: 24.h,
                            height: 3.5.h,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            isDense: true,
                            fillColor: ColourUtils.textWhite.withValues(
                              alpha: 0.05,
                            ),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide(
                                color: hasError
                                    ? Colors.redAccent
                                    : isVerified
                                        ? ColourUtils.completed
                                        : ColourUtils.textWhite.withValues(
                                            alpha: 0.1,
                                          ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide(
                                color: hasError
                                    ? Colors.redAccent
                                    : isVerified
                                        ? ColourUtils.completed
                                        : ColourUtils.primary,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < 3) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_otpFocusNodes[index + 1]);
                              } else {
                                _checkOtp();
                              }
                            } else {
                              if (index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_otpFocusNodes[index - 1]);
                              }
                              _checkOtp();
                            }
                          },
                        ),
                      );
                    }),
                  );
                });
                // return Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: List.generate(4, (index) {
                //     return SizedBox(
                //       width: 75.w,
                //       height: 80.h,
                //       child: TextFormField(
                //         controller: _otpControllers[index],
                //         focusNode: _otpFocusNodes[index],
                //         textAlign: TextAlign.center,
                //         textAlignVertical: TextAlignVertical.center,
                //         keyboardType: TextInputType.number,
                //         style: GoogleFonts.jetBrainsMono(
                //           color: _isOtpVerified
                //               ? ColourUtils.completed
                //               : ColourUtils.textMain,
                //           fontSize: 24.h,
                //           height: 3.5.h,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         maxLength: 1,
                //         decoration: InputDecoration(
                //           counterText: '',
                //           filled: true,
                //           isDense: true,
                //           fillColor: ColourUtils.textWhite.withValues(
                //             alpha: 0.05,
                //           ),
                //           contentPadding: EdgeInsets.zero,
                //           enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(12.h),
                //             borderSide: BorderSide(
                //               color: ColourUtils.textWhite.withValues(
                //                 alpha: 0.1,
                //               ),
                //             ),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(12.h),
                //             borderSide: BorderSide(
                //               color: _isOtpVerified
                //                   ? ColourUtils.completed
                //                   : ColourUtils.primary,
                //             ),
                //           ),
                //         ),
                //         onChanged: (value) {
                //           if (value.isNotEmpty) {
                //             if (index < 3) {
                //               FocusScope.of(
                //                 context,
                //               ).requestFocus(_otpFocusNodes[index + 1]);
                //             } else {
                //               // _checkOtp();
                //             }
                //           } else {
                //             if (index > 0) {
                //               FocusScope.of(
                //                 context,
                //               ).requestFocus(_otpFocusNodes[index - 1]);
                //             }
                //           }
                //         },
                //       ),
                //     );
                //   }),
                // );
              }
            },
          ),

          // SizedBox(height: 5.h),
          // SizedBox(height: 16.h),
          otpData?.status == null ||  otpData?.status == 'rejected'
              ? Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Row(
                    children: [
                      FillButtonWidget(
                        label: 'Generate OTP',
                        icon: 'lightning',
                        // function: _isOtpVerified ? null : _generateOtp,
                        function: () {},
                        isRound: false,
                      ),
                      Spacer(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
  void _checkOtp() {
    String enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length == 4) {
      if (enteredOtp == "2026") {
        controller.isOtpVerified.value = true;
        controller.hasOtpError.value = false;
      } else {
        controller.isOtpVerified.value = false;
        controller.hasOtpError.value = true;
      }
    } else {
      controller.isOtpVerified.value = false;
      controller.hasOtpError.value = false;
    }
  }
}



class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
    required this.head1,
    required this.head2,
    required this.head3,
    required this.head4,
    required this.icon,
    required this.color,
  });

  final String head1;
  final String head2;
  final String head3;
  final String head4;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.3), width: 1.w),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 10.h),
                        svgWidget(
                          icon: icon,
                          color: color,
                          height: 35.h,
                          width: 35.h,
                        ),
                      ],
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: color.withOpacity(0.3),
                                width: 1.w,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5.h,
                                horizontal: 10.h,
                              ),
                              child: Text(
                                head1,
                                style: GoogleFonts.inter(
                                  color: color,
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  head2,
                                  style: GoogleFonts.inter(
                                    color: ColourUtils.textWhite,
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: color.withValues(alpha: 0.3)),
                Row(
                  children: [
                    svgWidget(height: 15.h, width: 15.h, icon: 'calendar'),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        head3,
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          decoration: BoxDecoration(
            color: ColourUtils.textWhite.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Row(
              children: [
                svgWidget(height: 15.h, width: 15.h, icon: 'calendar'),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    head4,
                    style: GoogleFonts.inter(
                      color: ColourUtils.textWhite,
                      fontSize: 12.h,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
