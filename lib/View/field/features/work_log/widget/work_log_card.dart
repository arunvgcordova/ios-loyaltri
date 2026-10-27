import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/work_details_screen.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/controller/work_log_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/work_log_screen.dart';

class WorkLogCard extends GetView<WorkLogController> {
  const WorkLogCard({
    super.key,
    required this.context,
    required this.workId,
    required this.workTitle,
    required this.workTypeName,
    required this.customerName,
    required this.locationName,
    required this.startTime,
    required this.scheduledDate,
    required this.lat,
    required this.lng,
    required this.customerNumber,
    required this.priority,
    required this.status,
    required this.type,
  });

  final BuildContext context;

  final String workId;

  final String workTitle;

  final String workTypeName;

  final String customerName;

  final String locationName;

  final String startTime;

  final String scheduledDate;

  final double lat;

  final double lng;

  final String customerNumber;

  final String priority;

  final String status;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      SizedBox(height: 16.h),
      Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          // color: ColourUtils.cardBackground,
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
            colors: [ColourUtils.gdColourS, ColourUtils.gdColourE],
          ),
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: ColourUtils.borderColour, width: 1.h),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkDetailsScreen(
                  // workId: item.id.toString(),
                  workId: workId,
                  selectedDate: controller.selectedDate,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14.h),
          child: Padding(
            padding: EdgeInsets.all(14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workTitle,
                  // item.title ?? "",
                  style: GoogleFonts.inter(
                    color: ColourUtils.textMain,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                WorkTypeContainerWidget(
                  // text: item.workTypeDetail?.name ?? "",
                  text: workTypeName,
                ),
                SizedBox(height: 10.h),
                StoreNamewidget(
                  // text: item.customerDetail?.name ?? ""
                  text: customerName,
                ),
                SizedBox(height: 10.h),
                LocationTextWidget(
                  // text: item.location ?? ""
                  text: locationName,
                ),

                SizedBox(height: 10.h),
                Row(
                  children: [
                    svgWidget(
                      height: 20.h,
                      width: 20.h,
                      icon: 'clock',
                      color: ColourUtils.textWhite,
                    ),
                    SizedBox(width: 10.w),
                    Row(
                      children: [
                        Text(
                          startTime,
                          style: GoogleFonts.inter(
                            color: ColourUtils.textWhite,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: CircleAvatar(radius: 3.h),
                        ),
                        Text(
                          scheduledDate,
                          style: GoogleFonts.inter(
                            color: ColourUtils.textWhite,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(
                      height: 30.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color:type == "Overdue" ? ColourUtils.overdueBg : ColourUtils.pendingBg,
                        borderRadius: BorderRadius.circular(6.h),
                      ),
                      child: Center(
                        child: Text(
                          // "High",
                          // item.priority ?? "",
                          priority,
                          style: GoogleFonts.inter(
                            color:type == "Overdue" ? ColourUtils.overdue : ColourUtils.pending,
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.h),
                    Container(
                      height: 30.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        // vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color:type == "Overdue" ? ColourUtils.overdueBg : ColourUtils.pendingBg,
                        borderRadius: BorderRadius.circular(6.h),
                      ),
                      child: Row(
                        children: [
                          svgWidget(
                            height: 16.h,
                            width: 16.h,
                            icon: 'clock',
                            color:type == "Overdue" ? ColourUtils.overdue : ColourUtils.pending,
                          ),
                          SizedBox(width: 4.h),
                          Text(
                           type == "Overdue" ? "Overdue" : status.capitalizeFirst!.replaceAll("_", " "),
                            style: GoogleFonts.inter(
                              color:type == "Overdue" ? ColourUtils.overdue : ColourUtils.pending,
                              fontSize: 12.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),

                    RoundFillButton(
                      icon: 'navigation_fill',
                      function: () {
                        openGoogleMaps(
                          latitude: lat,
                          longitude: lng,
                          context: context,
                        );
                      },
                    ),
                    SizedBox(width: 10.h),
                    RoundFillButton(
                      icon: 'phone_fill',
                      function: () {
                        makePhoneCall(
                          // item.customerDetail?.dynamicFields?.phoneNumber,
                          customerNumber,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  }
}

// Widget _buildWorkCard({
//     required BuildContext context,
//     required String workId,
//     required String workTitle,
//     required String workTypeName,
//     required String customerName,
//     required String locationName,
//     required String startTime,
//     required String scheduledDate,
//     required double lat,
//     required double lng,
//     required String customerNumber,
//     required String priority,
//     required String status,
//   }) {
//     return Column(
//       children: [
//         SizedBox(height: 16.h),
//         Container(
//           margin: EdgeInsets.only(bottom: 12.h),
//           decoration: BoxDecoration(
//             // color: ColourUtils.cardBackground,
//             gradient: LinearGradient(
//               begin: AlignmentGeometry.topCenter,
//               end: AlignmentGeometry.bottomCenter,
//               colors: [ColourUtils.gdColourS, ColourUtils.gdColourE],
//             ),
//             borderRadius: BorderRadius.circular(12.h),
//             border: Border.all(color: ColourUtils.borderColour, width: 1.h),
//           ),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => WorkDetailsScreen(
//                     // workId: item.id.toString(),
//                     workId: workId,
//                     selectedDate: controller.selectedDate,
//                   ),
//                 ),
//               );
//             },
//             borderRadius: BorderRadius.circular(14.h),
//             child: Padding(
//               padding: EdgeInsets.all(14.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     workTitle,
//                     // item.title ?? "",
//                     style: GoogleFonts.inter(
//                       color: ColourUtils.textMain,
//                       fontSize: 16.h,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 10.h),
//                   WorkTypeContainerWidget(
//                     // text: item.workTypeDetail?.name ?? "",
//                     text: workTypeName,
//                   ),
//                   SizedBox(height: 10.h),
//                   StoreNamewidget(
//                     // text: item.customerDetail?.name ?? ""
//                     text: customerName,
//                   ),
//                   SizedBox(height: 10.h),
//                   LocationTextWidget(
//                     // text: item.location ?? ""
//                     text: locationName,
//                   ),

//                   SizedBox(height: 10.h),
//                   Row(
//                     children: [
//                       svgWidget(
//                         height: 20.h,
//                         width: 20.h,
//                         icon: 'clock',
//                         color: ColourUtils.textWhite,
//                       ),
//                       SizedBox(width: 10.w),
//                       Row(
//                         children: [
//                           Text(
//                             startTime,
//                             style: GoogleFonts.inter(
//                               color: ColourUtils.textWhite,
//                               fontSize: 14.h,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),

//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10.h),
//                             child: CircleAvatar(radius: 3.h),
//                           ),
//                           Text(
//                             scheduledDate,
//                             style: GoogleFonts.inter(
//                               color: ColourUtils.textWhite,
//                               fontSize: 14.h,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//                   Row(
//                     children: [
//                       Container(
//                         height: 30.h,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8.w,
//                           vertical: 3.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColourUtils.pendingBg,
//                           borderRadius: BorderRadius.circular(6.h),
//                         ),
//                         child: Center(
//                           child: Text(
//                             // "High",
//                             // item.priority ?? "",
//                             priority,
//                             style: GoogleFonts.inter(
//                               color: ColourUtils.pending,
//                               fontSize: 12.h,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8.h),
//                       Container(
//                         height: 30.h,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8.w,
//                           // vertical: 3.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColourUtils.pendingBg,
//                           borderRadius: BorderRadius.circular(6.h),
//                         ),
//                         child: Row(
//                           children: [
//                             svgWidget(
//                               height: 16.h,
//                               width: 16.h,
//                               icon: 'clock',
//                               color: ColourUtils.pending,
//                             ),
//                             SizedBox(width: 4.h),
//                             Text(
//                               status.capitalizeFirst!.replaceAll("_", " "),
//                               style: GoogleFonts.inter(
//                                 color: ColourUtils.pending,
//                                 fontSize: 12.h,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Spacer(),

//                       RoundFillButton(
//                         icon: 'navigation_fill',
//                         function: () {
//                           openGoogleMaps(latitude: lat, longitude: lng,context: context);
//                         },
//                       ),
//                       SizedBox(width: 10.h),
//                       RoundFillButton(
//                         icon: 'phone_fill',
//                         function: () {
//                           makePhoneCall(
//                             // item.customerDetail?.dynamicFields?.phoneNumber,
//                             customerNumber,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
