
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';

import '../../../models/regularisation_request_model.dart';
import '../../../services/ui_model_services/leave_tab_model.dart';
import '../../../utils/color_utils.dart';

class RegularizeDetailBottomSheet extends StatelessWidget {
  final RequestData excuse;
  RegularizeDetailBottomSheet({super.key, required this.excuse});

  @override
  Widget build(BuildContext context) {
    String excuseType = excuse.excuseType ?? '--';
    String excuseDate = excuse.excuseDate ?? '--';
    try {
      excuseDate = DateFormat('d MMM yyyy | EEE').format(DateTime.parse(excuse.excuseDate!));
    } catch(e) {}
    return SafeArea(
      child: Container(
        width: ScreenUtil().screenWidth,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(15).w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const Spacer(),
                      GestureDetector(
                        onTap: () async {
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
                      const Spacer(flex: 4),
                      Image.asset(
                        "assets/images/Hourglass-3d.webp",
                        width: 40.w,
                      ),
                      Text(
                        "Regularize",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(flex: 8),
                    ],
                  ),
                  SizedBox(height: 25.w),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6).w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50).w,
                                    color: colorStatus(excuse.status ?? '--'),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  statusTitle(excuse.status ?? '--'),
                                  style: GoogleFonts.poppins(
                                    color: colorStatus(excuse.status ?? '--'),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if(excuseType == "Late Entry")
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10)
                                        .w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4).w,
                                        gradient: const LinearGradient(
                                          colors: [
                                            ColorUtils.lf1,
                                            ColorUtils.lf2,
                                          ],
                                        )),
                                    child: Text(
                                      "LE",
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                // const SizedBox(width: 8),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //           vertical: 3, horizontal: 10)
                                //       .w,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(4).w,
                                //       gradient: const LinearGradient(
                                //         colors: [
                                //           ColorUtils.ot1,
                                //           ColorUtils.ot2,
                                //         ],
                                //       )),
                                //   child: Text(
                                //     "OT",
                                //     style: LoyaltriFonts.interW600_14sp_textWhite,
                                //   ),
                                // ),
                                // const SizedBox(width: 8),
                                if(excuseType == "Excess Break")
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10)
                                        .w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4).w,
                                        gradient: const LinearGradient(
                                          colors: [
                                            ColorUtils.eb1,
                                            ColorUtils.eb2,
                                          ],
                                        )),
                                    child: Text(
                                      "EB",
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                // const SizedBox(width: 8),
                                if(excuseType == "Early Exit")
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10)
                                        .w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4).w,
                                        gradient: const LinearGradient(
                                          colors: [
                                            ColorUtils.ee1,
                                            ColorUtils.ee2,
                                          ],
                                        )),
                                    child: Text(
                                      "EE",
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: ColorUtils.textWhite.withOpacity(0.1),
                          thickness: 1.w,
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "$excuseType :",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    excuse.timeDifference ?? "--",
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Date : ",
                                    style:
                                    GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    excuseDate,
                                    style:
                                    GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite.withOpacity(0.5),
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
                  SizedBox(height: 15.w),
                  Container(
                    height: 180.w,
                    width: ScreenUtil().screenWidth * 0.9,
                    padding: const EdgeInsets.all(15).w,
                    decoration: BoxDecoration(
                        color: ColorUtils.foregroundBlack,
                        borderRadius: BorderRadius.circular(15).w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reason",
                          style: GoogleFonts.inter(
                            color: Color(0xFFAAAAAA),
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          style: GoogleFonts.inter(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: excuse.excuseReason ?? '--',
                            contentPadding: const EdgeInsets.all(0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: GoogleFonts.inter(
                              color: ColorUtils.textWhite.withOpacity(0.2),
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              letterSpacing: -0.35,
                            ),
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 6).w,
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 20).w,
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               "Hierarchy Approval Status",
                  //               style: LoyaltriFonts.interW400_12sp_textWhite.copyWith(
                  //                     color: const Color(0xFFAAAAAA),
                  //                   ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       ...List.generate(hierarchyList.length, (index) {
                  //         return Column(
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     CircleAvatar(
                  //                       radius: 19.w,
                  //                       backgroundColor: hierarchyList[index].status == null ? ColorUtils.notUpdated : ColorUtils.approved,
                  //                       child: CircleAvatar(
                  //                         radius: 16.w,
                  //                         backgroundColor: ColorUtils.textWhite,
                  //                         child: hierarchyList[index].image != null
                  //                             ? Container()
                  //                             : const Icon(Icons.person, color: Colors.grey),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 8.w,
                  //                     ),
                  //                     Container(
                  //                       width: ScreenUtil().screenWidth * 0.5,
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             hierarchyList[index].name,
                  //                             style: LoyaltriFonts.poppinsW500_12sp_textWhiteOp90,
                  //                             overflow: TextOverflow.ellipsis,
                  //                           ),
                  //                           Text(
                  //                             hierarchyList[index].designation,
                  //                             style: LoyaltriFonts.poppinsW400_12sp_textWhiteOp50,
                  //                             overflow: TextOverflow.ellipsis,
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     if(hierarchyList[index].status != null)
                  //                       Row(
                  //                         mainAxisSize: MainAxisSize.min,
                  //                         children: [
                  //                           SvgPicture.asset("assets/images/thumb_green.svg"),
                  //                           SizedBox(
                  //                             width: 4.w,
                  //                           ),
                  //                           Text(
                  //                             hierarchyList[index].status ?? '',style: LoyaltriFonts.poppinsW500_12sp_textWhite.copyWith(
                  //                             color: ColorUtils.approved,
                  //                           ),
                  //                             overflow: TextOverflow.ellipsis,
                  //                           ),
                  //                         ],
                  //                       )
                  //                     else
                  //                       Text(
                  //                         "Not updated",
                  //                         style: LoyaltriFonts.poppinsW500_12sp_textWhite.copyWith(
                  //                           color: const Color(0xFF666666),
                  //                         ),
                  //                         overflow: TextOverflow.ellipsis,
                  //                       ),
                  //                     if(hierarchyList[index].time != null)
                  //                       Text(
                  //                         hierarchyList[index].time ?? "--.--.----",
                  //                         style: LoyaltriFonts.poppinsW400_12sp_textWhiteOp40,
                  //                         overflow: TextOverflow.ellipsis,
                  //                       )
                  //                     else
                  //                       Text(
                  //                         "--.--.----",
                  //                         style: LoyaltriFonts.poppinsW400_12sp_textWhite.copyWith(
                  //                           color: const Color(0xFF666666),
                  //                         ),
                  //                         overflow: TextOverflow.ellipsis,
                  //                       )
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             if(hierarchyList.length != index + 1)
                  //               if(hierarchyList[index].status == null)
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(left: 18).w,
                  //                   child: Row(
                  //                     children: [
                  //                       SvgPicture.asset(
                  //                           "assets/images/hierarchy_line_gray.svg"
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 )
                  //               else
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(left: 18).w,
                  //                   child: Row(
                  //                     children: [
                  //                       SvgPicture.asset(
                  //                           "assets/images/hierarchy_line_green.svg"
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 )
                  //           ],
                  //         );
                  //       }),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 4.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color colorStatus(String type) {
    switch(type.toLowerCase()) {
      case "pending": return const Color(0xFFF8A24E);
      case "pardon": return const Color(0xFF50BC61);
      case "fine": return const Color(0xFFD40000);
      default: return ColorUtils.textWhite;
    }
  }

  String statusTitle(String type) {
    switch(type.toLowerCase()) {
      case "pending": return "Pending";
      case "pardon": return "Pardon";
      case "fine": return "Fine";
      default: return "--";
    }
  }
}

List<HierarchyModel> hierarchyList = [
  const HierarchyModel(
    name: "Brendon Stokes",
    designation: "Chief Operations Officer",
    image: null,
    status: null,
    time: null,
  ),
  HierarchyModel(
    name: "Brendon Stokes",
    designation: "Chief Operations Officer",
    image: null,
    status: "Approved",
    time: DateFormat('d MMM yyyy').format(DateTime.now()),
  ),
  HierarchyModel(
    name: "Kennedy Clark",
    designation: "Human Resource Manager",
    image: null,
    status: "Approved",
    time: DateFormat('d MMM yyyy').format(DateTime.now()),
  ),
];

class HierarchyModel {
  final String name;
  final String designation;
  final String? image;
  final String? status;
  final String? time;

  const HierarchyModel(
      {required this.name,
      required this.designation,
      this.image,
      this.status,
      this.time});
}
