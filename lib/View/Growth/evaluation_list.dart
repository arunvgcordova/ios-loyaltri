import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/krasAndKpis.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../models/growth_home_model.dart';
import '../Attendance_Page/attendance_widgets/date_header.dart';
import 'growth_widgets/CWidgets.dart';
import 'growth_widgets/app_bar.dart';
import 'growth_widgets/evaluation_progress.dart';
import 'growth_widgets/quarter_card1.dart';
import 'growth_widgets/quarter_card2.dart';

class EvaluationList extends StatefulWidget {
  const EvaluationList({super.key});

  @override
  State<EvaluationList> createState() => _EvaluationListState();
}

class _EvaluationListState extends State<EvaluationList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        body: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0).h,
              child: GrowthAppBar(title: "Evaluation List"),
            ),
            SizedBox(height: 6.h),
            GrowthDateHeader(
              onMonthChanged: (String month) async {
                debugPrint('-----------changedMonth---------$month');
                await Get.find<GrowthController>().fetchEvaluationList();
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Get.find<GrowthController>().fetchEvaluationList();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 10).h,
                    child: GetX<GrowthController>(
                        builder: (GrowthController controller) {
                          double avgScore = 0;
                          try {
                            if(controller.evaluationList.value.isNotEmpty) {
                              List<EvaluationData> completedList = controller.evaluationList.value.where((e) => e.status?.toLowerCase() == 'completed').toList();
                              avgScore = completedList.map((element) => element.avgScore ?? 0).toList().reduce((a, b) => a + b) / completedList.length;
                            }
                          } catch(e) {}
                          if(controller.evaluationListLoading.value) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Center(
                                          child: SpinKitThreeInOut(color: ColorUtils.primaryBlue, size: 28.w),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            );
                          } else if(controller.evaluationList.value.isEmpty) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Center(
                                          child: Text(
                                            "No Data Found",
                                            style: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                              fontSize: 12.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(0.5).h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18).r,
                                    gradient: LinearGradient(
                                      colors: [ColorUtils.deepIndigo, ColorUtils.charcoalBlack],
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17).r,
                                      gradient: RadialGradient(
                                        center: AlignmentGeometry.directional(0, -2),
                                        radius: 3,
                                        stops: [0.0, 0.5],
                                        colors: [ColorUtils.darkIndigo, ColorUtils.nearBlack],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: -10.w,
                                          right: 0,
                                          left: 0,
                                          child: Center(
                                            child: Transform.scale(
                                              scaleX: 2,
                                              child: Container(
                                                width: 130.w,
                                                height: 50.w,
                                                decoration: BoxDecoration(
                                                  // color: ColorUtils.darkIndigo.withValues(alpha: 0.3),
                                                  borderRadius: BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ColorUtils.darkIndigo.withValues(alpha: 0.5),
                                                      blurRadius: 20,
                                                      spreadRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.all(10).h,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              if(controller.evaluationList.value.isNotEmpty)
                                                EvaluationDateHead(
                                                  isHome: false,
                                                  templateName: controller.evaluationList.value.first.templateName,
                                                  avgScore: avgScore,
                                                )
                                              else
                                                SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                ListView.separated(
                                  itemCount: controller.evaluationList.value.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                  ),
                                  itemBuilder: (context, index) {
                                    EvaluationData evaluation = controller.evaluationList.value[index];
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if(evaluation.isSelfReview == 1)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25).h,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 23.h,
                                                    padding: EdgeInsets.only(right: 10, left: 10, top: 5).h,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(20).r,
                                                      ),
                                                      gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: [ColorUtils.warmBeige, ColorUtils.softCream],
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Hey! Action needed. Your self review is pending',
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 11.h,
                                                        color: ColorUtils.bronzeBrown,
                                                        letterSpacing: -0.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        QuarterCard1(evaluationData: evaluation),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                ),
                                SizedBox(height: 25.h),
                                Row(
                                  children: [
                                    Text(
                                      'KRAs & KPIs List',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.h,
                                          color: ColorUtils.textWhite.withValues(alpha: 0.7)
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                if(controller.evaluationList.value.isNotEmpty)
                                  KraAndKpis(evaluationData: controller.evaluationList.value.first, showAvg: false)
                                else
                                  SizedBox.shrink(),
                                // ListView.separated(
                                //   itemCount: 5,
                                //     shrinkWrap: true,
                                //   padding: EdgeInsets.zero,
                                //   physics: NeverScrollableScrollPhysics(),
                                //     itemBuilder: (context, index) {
                                //     return Container(
                                //       decoration: BoxDecoration(
                                //         color: ColorUtils.midnightIndigo,
                                //         borderRadius: BorderRadius.circular(15).r,
                                //       ),
                                //       child: Theme(
                                //         data: Theme.of(context).copyWith(
                                //           dividerColor:
                                //           ColorUtils.backgroundBlack,
                                //           splashColor: Colors.transparent,
                                //         ),
                                //         child: ExpansionTile(
                                //           collapsedIconColor: Colors.white,
                                //           iconColor: Colors.white,
                                //           tilePadding: const EdgeInsets.symmetric(
                                //             horizontal: 15,
                                //             vertical: 0,
                                //           ).h,
                                //           // childrenPadding: const EdgeInsets.only(
                                //           //   left: 15,
                                //           //   right: 30,
                                //           //   bottom: 8,
                                //           // ).h,
                                //           title: Row(
                                //             children: [
                                //               Container(
                                //                 width: 4.h,
                                //                 height: 19.h,
                                //                 decoration: BoxDecoration(
                                //                   borderRadius: BorderRadius.circular(500.r),
                                //                   color: Color(0xFF6366F1),
                                //                 ),
                                //               ),
                                //               SizedBox(width: 10.h),
                                //               Flexible(
                                //                 child: Text(
                                //                   'Customer Relationship & Account Retention',
                                //                   overflow: TextOverflow.ellipsis,
                                //                   style: GoogleFonts.inter(
                                //                     fontSize: 13.h,
                                //                     fontWeight: FontWeight.w400,
                                //                     color: ColorUtils.textWhite,
                                //                   ),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           children: [
                                //             for(int i = 0; i < 5; i++)
                                //               Container(
                                //                 width: double.infinity,
                                //                 padding: EdgeInsets.only(
                                //                   left: 15,
                                //                   right: 30,
                                //                   top: i == 0 ? 15 : 0,
                                //                   bottom: i == 4 ? 10 : 0,
                                //                 ).h,
                                //                 decoration: BoxDecoration(
                                //                   color: Color(0xFF36324F),
                                //                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(i == 4 ? 10.r : 0)),
                                //                 ),
                                //                 child: Column(
                                //                   children: [
                                //                     Padding(
                                //                       padding: EdgeInsets.only(bottom: 10.h),
                                //                       child: Row(
                                //                         crossAxisAlignment: CrossAxisAlignment.start,
                                //                         children: [
                                //                           Padding(
                                //                             padding: EdgeInsets.only(
                                //                               top: 7.h,
                                //                             ),
                                //                             child: Container(
                                //                               width: 6.h,
                                //                               height: 6.h,
                                //                               decoration: BoxDecoration(
                                //                                 shape: BoxShape.circle,
                                //                                 color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           SizedBox(width: 10.h),
                                //                           Flexible(
                                //                             child: Text(
                                //                               'Effectively manages project scope and requirements in specified deadline',
                                //                               style: GoogleFonts.inter(
                                //                                 fontSize: 13.h,
                                //                                 fontWeight: FontWeight.w400,
                                //                                 color: ColorUtils.textWhite,
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //           ],
                                //         ),
                                //       ),
                                //     );
                                //     // return Container(
                                //     //   child: Text(
                                //     //     'Customer Relationship & Account Retention',
                                //     //     style: GoogleFonts.inter(
                                //     //       fontSize: 13.h,
                                //     //       fontWeight: FontWeight.w400,
                                //     //       color: ColorUtils.textWhite,
                                //     //     ),
                                //     //   ),
                                //     // );
                                //     },
                                //     separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                // ),
                              ],
                            );
                          }
                      }
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GrowthDateHeader extends StatefulWidget {
  final Function(String) onMonthChanged;
  const GrowthDateHeader({super.key, required this.onMonthChanged});

  @override
  State<GrowthDateHeader> createState() => _GrowthDateHeaderState();
}

class _GrowthDateHeaderState extends State<GrowthDateHeader> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: Get.find<GrowthController>().currentYearIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5).h,
      child: GetX<GrowthController>(
        builder: (GrowthController controller) {
          return Container(
            height: 38.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorUtils.datePickColor.withValues(alpha: 0.4),
                  ColorUtils.datePickColor,
                  ColorUtils.datePickColor.withValues(alpha: 0.4),
                ],
              ),
            ),
            child: RotatedBox(
              quarterTurns: 1,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                physics: const FixedExtentScrollPhysics(),
                magnification: 2.0,
                itemExtent: 80,
                diameterRatio: 2.0,
                onSelectedItemChanged: (index) {
                  setState(() {
                    controller.currentYearIndex = index;
                    widget.onMonthChanged(controller.yearString.value[index]);
                  });
                  HapticFeedback.lightImpact();
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (BuildContext context, int index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: index == controller.currentYearIndex
                          ? 65.h
                          : 54.h, // Adjust red widget size
                      height: index == controller.currentYearIndex ? 21.h : 21.h,
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            controller.yearString.value[index],
                            style: GoogleFonts.poppins(
                              color: index == controller.currentYearIndex
                                  ? ColorUtils.textWhite
                                  : ColorUtils.textWhite.withValues(alpha: 0.4),
                              fontSize: index == controller.currentYearIndex ? 13.h : 11.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: controller.yearString.value.length,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
