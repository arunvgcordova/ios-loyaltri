
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Login/login_widgets/custom_check_box.dart';
import '../controller/myRequestController.dart';
import '../my_request_models/filter_model.dart';
import 'Choose_Request_Dates.dart';

class RequestFilterBottomSheet extends StatelessWidget {
  final int currentTabIndex;
  const RequestFilterBottomSheet({super.key, required this.currentTabIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Container(
          width: ScreenUtil().screenWidth,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10).w,
                child: GetX<MyRequestFilterController>(
                  builder: (MyRequestFilterController controller) {
                    return Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5.w,
                          width: 100.w,
                          decoration: BoxDecoration(
                              color: ColorUtils.textWhite.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50).w
                          ),
                        ),
                        SizedBox(height: 15.w),
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
                                height: 48.w,
                                width: 48.w,
                                decoration: BoxDecoration(
                                  color: ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(14).w,
                                  border: Border.all(
                                    width: 1.w,
                                    color: const Color(0xFF3F4450),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: 18.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Filters",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Container(
                              height: 48.w,
                              width: 48.w,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.w),
                        Row(
                          children: [
                            Text(
                              "Status",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Approved",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).w,
                              borderColor: controller.approved.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.approved.value,
                              onChange: (bool? value) {
                                controller.approvedFilter(value!);
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
                                fontSize: 14.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).w,
                              borderColor: controller.pending.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.pending.value,
                              onChange: (bool? value) {
                                controller.pendingFilter(value!);
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
                                fontSize: 14.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).w,
                              borderColor: controller.rejected.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.rejected.value,
                              onChange: (bool? value) {
                                controller.rejectedFilter(value!);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 30.w),
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                // DateTime? picked = await pickDate(context);
                                // if(picked != null) {
                                //   fromDate.value = DateFormat('yyyy-MM-dd').format(picked);
                                // }
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const ChooseRequestDates(),
                                  ),
                                ).then((value) {
                                  if (value != null && value is LeaveDates) {
                                    if(value.startDate != null && value.endDate != null) {
                                      controller.dateFilter(
                                        from: DateFormat('yyyy-MM-dd').format(value.startDate!),
                                        to: DateFormat('yyyy-MM-dd').format(value.endDate!),
                                        fromDateTimeValue: value.startDate!,
                                        toDateTimeValue: value.endDate!,
                                      );
                                    }
                                    // if(value.startDate != null) {
                                    //   fromDateTime = value.startDate;
                                    //   fromDate.value = DateFormat('yyyy-MM-dd').format(value.startDate!);
                                    // }
                                    // if(value.endDate != null) {
                                    //   toDateTime = value.endDate;
                                    //   toDate.value = DateFormat('yyyy-MM-dd').format(value.endDate!);
                                    // }
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).w,
                                decoration: BoxDecoration(
                                  color: ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(10).w,
                                ),
                                child: SizedBox(
                                  width: 120.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.fromDate.value,
                                        style: GoogleFonts.inter(
                                          color: ColorUtils.textWhite.withOpacity(0.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: const Color(0xFF9A9A9A).withOpacity(0.6),
                                        size: 17.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () async {
                                // DateTime? picked = await pickDate(context);
                                // if(picked != null) {
                                //   toDate.value = DateFormat('yyyy-MM-dd').format(picked);
                                // }
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const ChooseRequestDates(),
                                  ),
                                ).then((value) {
                                  if (value != null && value is LeaveDates) {
                                    if(value.startDate != null && value.endDate != null) {
                                      controller.dateFilter(
                                        from: DateFormat('yyyy-MM-dd').format(value.startDate!),
                                        to: DateFormat('yyyy-MM-dd').format(value.endDate!),
                                        fromDateTimeValue: value.startDate!,
                                        toDateTimeValue: value.endDate!,
                                      );
                                    }
                                    // if(value.startDate != null) {
                                    //   fromDateTime = value.startDate;
                                    //   fromDate.value = DateFormat('yyyy-MM-dd').format(value.startDate!);
                                    // }
                                    // if(value.endDate != null) {
                                    //   toDateTime = value.endDate;
                                    //   toDate.value = DateFormat('yyyy-MM-dd').format(value.endDate!);
                                    // }
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).w,
                                decoration: BoxDecoration(
                                  color: ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(10).w,
                                ),
                                child: SizedBox(
                                  width: 120.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.toDate.value,
                                        style: GoogleFonts.inter(
                                          color: ColorUtils.textWhite.withOpacity(0.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: const Color(0xFF9A9A9A).withOpacity(0.6),
                                        size: 17.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.w),
                        GestureDetector(
                          onTap: () {
                            if(controller.approved.value ||
                                controller.pending.value ||
                                controller.rejected.value ||
                                controller.fromDateTime.value != null ||
                                controller.toDateTime.value != null) {
                              controller.apply(true);
                            } else {
                              controller.apply(false);
                            }
                            RequestFilter filterData = RequestFilter(
                              approved: controller.approved.value,
                              pending: controller.pending.value,
                              rejected: controller.rejected.value,
                              fromDate: controller.fromDateTime.value,
                              toDate: controller.toDateTime.value,
                            );
                            Get.find<MyRequestController>().filterList(filter: filterData, tabIndex: currentTabIndex);
                            Navigator.of(context).pop();
                          },
                          child: const LoyaltriBlueTextButton(text: "Apply Filter"),
                        ),
                        SizedBox(height: 10.w),
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
