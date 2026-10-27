
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';
import 'package:loyaltri_minimal/View/Login/login_widgets/custom_check_box.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_models/filter_model.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/Choose_Request_Dates.dart';
import '../controller/my_request_controller.dart';
import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/color_utils.dart';

class RequestFilterBottomSheet extends StatelessWidget {
  final int currentTabIndex;
  const RequestFilterBottomSheet({super.key, required this.currentTabIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Container(
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ).r),
          child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10).h,
                child: GetX<MyRequestControllerNew>(
                  builder: (MyRequestControllerNew controller) {
                    return Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5.h,
                          width: 100.h,
                          decoration: BoxDecoration(
                              color: ColorUtils.textWhite.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(50).r
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(14).r,
                                  border: Border.all(
                                    width: 1.h,
                                    color: const Color(0xFF3F4450),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: 18.h,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Filters",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Container(
                              height: 48.h,
                              width: 48.h,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          children: [
                            Text(
                              "Status",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Approved",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).r,
                              borderColor: controller.approved.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.approved.value,
                              onChange: (bool? value) {
                                controller.approved.value = value ?? false;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pending",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).r,
                              borderColor: controller.pending.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.pending.value,
                              onChange: (bool? value) {
                                controller.pending.value = value ?? false;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rejected",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).r,
                              borderColor: controller.rejected.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.rejected.value,
                              onChange: (bool? value) {
                                controller.rejected.value = value ?? false;
                              },
                            ),
                          ],
                        ),
                        // SizedBox(height: 30.w),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Date",
                        //       style: GoogleFonts.poppins(
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 11.h,
                        //         color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 15.w),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         // DateTime? picked = await pickDate(context);
                        //         // if(picked != null) {
                        //         //   fromDate.value = DateFormat('yyyy-MM-dd').format(picked);
                        //         // }
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(builder: (context) => const ChooseRequestDates(),
                        //           ),
                        //         ).then((value) {
                        //           if (value != null && value is LeaveDates) {
                        //             if(value.startDate != null && value.endDate != null) {
                        //               controller.dateFilter(
                        //                 from: DateFormat('yyyy-MM-dd').format(value.startDate!),
                        //                 to: DateFormat('yyyy-MM-dd').format(value.endDate!),
                        //                 fromDateTimeValue: value.startDate!,
                        //                 toDateTimeValue: value.endDate!,
                        //               );
                        //             }
                        //             // if(value.startDate != null) {
                        //             //   fromDateTime = value.startDate;
                        //             //   fromDate.value = DateFormat('yyyy-MM-dd').format(value.startDate!);
                        //             // }
                        //             // if(value.endDate != null) {
                        //             //   toDateTime = value.endDate;
                        //             //   toDate.value = DateFormat('yyyy-MM-dd').format(value.endDate!);
                        //             // }
                        //           }
                        //         });
                        //       },
                        //       child: Container(
                        //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).h,
                        //         decoration: BoxDecoration(
                        //           color: ColorUtils.foregroundBlack,
                        //           borderRadius: BorderRadius.circular(10).r,
                        //         ),
                        //         child: SizedBox(
                        //           width: 120.w,
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text(
                        //                 controller.fromDate.value,
                        //                 style: GoogleFonts.inter(
                        //                   color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        //                   fontWeight: FontWeight.w400,
                        //                   fontSize: 13.h,
                        //                 ),
                        //               ),
                        //               Icon(
                        //                 Icons.calendar_today_outlined,
                        //                 color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                        //                 size: 17.h,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 10.h),
                        //     InkWell(
                        //       onTap: () async {
                        //         // DateTime? picked = await pickDate(context);
                        //         // if(picked != null) {
                        //         //   toDate.value = DateFormat('yyyy-MM-dd').format(picked);
                        //         // }
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(builder: (context) => const ChooseRequestDates(),
                        //           ),
                        //         ).then((value) {
                        //           if (value != null && value is LeaveDates) {
                        //             if(value.startDate != null && value.endDate != null) {
                        //               controller.dateFilter(
                        //                 from: DateFormat('yyyy-MM-dd').format(value.startDate!),
                        //                 to: DateFormat('yyyy-MM-dd').format(value.endDate!),
                        //                 fromDateTimeValue: value.startDate!,
                        //                 toDateTimeValue: value.endDate!,
                        //               );
                        //             }
                        //             // if(value.startDate != null) {
                        //             //   fromDateTime = value.startDate;
                        //             //   fromDate.value = DateFormat('yyyy-MM-dd').format(value.startDate!);
                        //             // }
                        //             // if(value.endDate != null) {
                        //             //   toDateTime = value.endDate;
                        //             //   toDate.value = DateFormat('yyyy-MM-dd').format(value.endDate!);
                        //             // }
                        //           }
                        //         });
                        //       },
                        //       child: Container(
                        //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).h,
                        //         decoration: BoxDecoration(
                        //           color: ColorUtils.foregroundBlack,
                        //           borderRadius: BorderRadius.circular(10).r,
                        //         ),
                        //         child: SizedBox(
                        //           width: 120.h,
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text(
                        //                 controller.toDate.value,
                        //                 style: GoogleFonts.inter(
                        //                   color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        //                   fontWeight: FontWeight.w400,
                        //                   fontSize: 13.h,
                        //                 ),
                        //               ),
                        //               Icon(
                        //                 Icons.calendar_today_outlined,
                        //                 color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                        //                 size: 17.h,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 25.h),
                        GestureDetector(
                          onTap: () {
                            controller.filterRequests();
                            Navigator.of(context).pop();
                          },
                          child: const LoyaltriBlueTextButton(text: "Apply Filter"),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
