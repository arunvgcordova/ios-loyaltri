import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/strip_graph.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

import 'filter_button.dart';

class AttendanceCardShimmer extends StatelessWidget {
  const AttendanceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148.h,
      width: 358.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: Colors.white,
        border: Border.all(color: ColorUtils.frostedPearl, width: 1.h),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.grey[200]!,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Column(
                        children: [
                          Container(
                            height: 12.h,
                            width: 92.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 92.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        height: 24.h,
                        width: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43.h),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 12.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 12.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 12.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 12.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 12.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 12.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 14.h,
                    width: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Colors.white,
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        height: 14.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Container(
                        height: 14.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceSummaryShimmer extends StatelessWidget {
  const AttendanceSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10).h,
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(14).r,
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[100]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Colors.red,
                    ),
                    child: Text(
                      "Summary",
                      style: GoogleFonts.poppins(
                        color: Colors.transparent,
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100]!,
                  highlightColor: Colors.grey[200]!,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8).h,
                    child: Row(
                      children: [
                        StripGraph(
                          width: 20,
                          colors: [Color(0xFF229B63), Color(0xFF2E875D)],
                          height: 18,
                          radius: BorderRadius.circular(8.0.h),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.grey[200]!,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 8.0).h,
              child: Row(
                children: [
                  Expanded(
                    child: StripGraph(
                      width: 1,
                      colors: [Color(0xFF229B63), Color(0xFF2E875D)],
                      height: 8,
                      radius: BorderRadius.circular(8.0.h),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
            child: ListView.separated(
              itemCount: 7,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[100]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 5.h,
                        ),
                        SizedBox(width: 5.h),
                        Container(
                          width: 60.h,
                          height: 13.h,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.h),
                        Container(
                          width: 20.h,
                          height: 13.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: 9.h),
            ),
          ),
        ],
      ),
      // child: Theme(
      //   data: Theme.of(context).copyWith(
      //     dividerColor: Colors.transparent,
      //     splashColor: Colors.transparent,
      //   ),
      //   child: ExpansionTile(
      //     collapsedIconColor: ColorUtils.workEntryHead,
      //     iconColor: ColorUtils.workEntryHead,
      //     tilePadding: const EdgeInsets.symmetric(horizontal: 12).h,
      //     childrenPadding: const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 6).h,
      //     showTrailingIcon: false,
      //     onExpansionChanged: (value) {
      //       // controller.summaryExpansionChanged.value = value;
      //     },
      //     title: Column(
      //       children: [
      //         Padding(
      //           padding: EdgeInsets.only(
      //             top: 4.h,
      //             right: 8.h,
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Shimmer.fromColors(
      //                 baseColor: Colors.grey[100]!,
      //                 highlightColor: Colors.grey[200]!,
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(6.r),
      //                     color: Colors.red,
      //                   ),
      //                   child: Text(
      //                     "Summary",
      //                     style: GoogleFonts.poppins(
      //                       color: Colors.transparent,
      //                       fontSize: 13.h,
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               Shimmer.fromColors(
      //                 baseColor: Colors.grey[100]!,
      //                 highlightColor: Colors.grey[200]!,
      //                 child: Padding(
      //                   padding: const EdgeInsets.only(top: 4, bottom: 8).h,
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       StripGraph(
      //                         width: 20,
      //                         colors: [Color(0xFF229B63), Color(0xFF2E875D)],
      //                         height: 18,
      //                         radius: BorderRadius.circular(8.0.h),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Shimmer.fromColors(
      //           baseColor: Colors.grey[100]!,
      //           highlightColor: Colors.grey[200]!,
      //           child: Padding(
      //             padding: const EdgeInsets.only(top: 10.0, bottom: 8.0).h,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Expanded(
      //                   child: StripGraph(
      //                     width: 1,
      //                     colors: [Color(0xFF229B63), Color(0xFF2E875D)],
      //                     height: 8,
      //                     radius: BorderRadius.circular(8.0.h),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           height: 30.h,
      //           child: ListView.separated(
      //             itemCount: 7,
      //             shrinkWrap: true,
      //             scrollDirection: Axis.horizontal,
      //             itemBuilder: (context, index) {
      //               return Shimmer.fromColors(
      //                 baseColor: Colors.grey[100]!,
      //                 highlightColor: Colors.grey[200]!,
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(5.r),
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: Colors.white,
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         width: 60.h,
      //                         height: 13.h,
      //                         color: Colors.white,
      //                       ),
      //                       SizedBox(width: 10.h),
      //                       Container(
      //                         width: 20.h,
      //                         height: 13.h,
      //                         color: Colors.white,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               );
      //             },
      //             separatorBuilder: (context, index) => SizedBox(width: 9.h),
      //           ),
      //         ),
      //       ],
      //     ),
      //     children: [
      //       Shimmer.fromColors(
      //         baseColor: Colors.grey[100]!,
      //         highlightColor: Colors.grey[200]!,
      //         child: Column(
      //           children: [
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 3.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFF259662),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      //               thickness: 1.h,
      //               height: 0,
      //             ),
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFFD0453B),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      //               thickness: 1.h,
      //               height: 0,
      //             ),
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFFD0453B),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      //               thickness: 1.h,
      //               height: 0,
      //             ),
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFFD0453B),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      //               thickness: 1.h,
      //               height: 0,
      //             ),
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFFD0453B),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      //               thickness: 1.h,
      //               height: 0,
      //             ),
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFFD0453B),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      //               thickness: 1.h,
      //               height: 0,
      //             ),
      //             Padding(
      //               padding:
      //               const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundColor: const Color(0xFFD0453B),
      //                         radius: 5.h,
      //                       ),
      //                       SizedBox(width: 5.h),
      //                       Container(
      //                         height: 12.h,
      //                         width: 80.h,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(6.r),
      //                           color: Colors.red,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Container(
      //                     height: 12.h,
      //                     width: 18.h,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(2.r),
      //                       color: Colors.red,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
