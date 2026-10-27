
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/evaluation_detail_bottomSheet.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/rate_performance_screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/growth_home_model.dart';

import '../../../../utils/color_utils.dart';

class QuarterCard1 extends StatelessWidget {
  final EvaluationData? evaluationData;
  const QuarterCard1({super.key, this.evaluationData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: ColorUtils.midnightIndigo,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1.h,
          color: ColorUtils.carbonGrey,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF6B7280).withValues(alpha: 0.125),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          evaluationData?.displayShortForm ?? '--',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.h,
                            color: AttendanceCommonWidgets().hexToColor(evaluationData?.statusColor) ?? Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evaluationData?.cycleName ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13.h,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/air_ticket/air_ticket_calendar.png',
                                height: 13.h,
                                color: ColorUtils.textWhite.withValues(alpha: 0.5),
                              ),
                              SizedBox(width: 5.h),
                              Text(
                                '${evaluationData?.startMonth ?? ''} - ${evaluationData?.endMonth ?? ''}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.h,
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if(evaluationData?.isSelfReview == 1) {
                    final point = Get.find<GrowthController>().addSelfReviewData(evaluationData);
                    if(point == null) return;
                    Navigator.of(context).push(
                      newSlideNavigation(RatePerformanceScreen(point: point)),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500.r),
                    color: (AttendanceCommonWidgets().hexToColor(evaluationData?.statusColor) ?? Colors.grey).withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        evaluationData?.isSelfReview == 1 ? 'assets/images/growth/in_progress_yellow.png' : evaluationData?.status?.trim().toLowerCase() == 'completed' ? 'assets/images/manager_view/mark_complete_icon.png' : evaluationData?.status?.trim().toLowerCase() == 'upcoming' ? 'assets/images/ic_clock.png' : 'assets/images/growth/in_progress_yellow.png',
                        height: 14.h,
                        color: AttendanceCommonWidgets().hexToColor(evaluationData?.statusColor) ?? Colors.grey,
                      ),
                      SizedBox(width: 6.h),
                      Text(
                        evaluationData?.status ?? '--',
                        style: GoogleFonts.inter(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w400,
                          color: AttendanceCommonWidgets().hexToColor(evaluationData?.statusColor) ?? Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if(evaluationData?.status?.trim().toLowerCase() == 'completed')
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Divider(
                  color: ColorUtils.textWhite.withValues(alpha: 0.1),
                  thickness: 1.h,
                  height: 0.h,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Score',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.h,
                        color: ColorUtils.textWhite.withValues(alpha: 0.6)
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(evaluationData?.avgScore != null)
                          Text(
                          '${evaluationData?.avgScore?.toStringAsFixed(0)}%',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.h,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                enableDrag: false,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (context) {
                                  return EvaluationDetailBottomSheet(evaluationData: evaluationData);
                                },
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 18.h,
                            child: Center(
                              child: Text(
                                'Tap to view details',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
