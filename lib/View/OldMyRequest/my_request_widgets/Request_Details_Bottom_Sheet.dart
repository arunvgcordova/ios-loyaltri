
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/color_utils.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../controller/myRequestController.dart';
import '../model/myRequestListApiModel.dart';

class RequestDetailBottomSheet extends StatelessWidget {
  final RequestData excuse;
  const RequestDetailBottomSheet({super.key, required this.excuse});

  @override
  Widget build(BuildContext context) {
    int colorCode = 000000;
    String title = '--';
    String fromDate = '--';
    String toDate = '--';
    TextEditingController _reasonController = TextEditingController(text: excuse.requestDescription);
    bool isImage = false;
    try {
      title = excuse.requestType == "1" ? "Work From Home" : "Letter Request";
      String colorString = excuse.requestStatusColour?.split('#').last ?? '';
      colorCode = int.parse('0xFF$colorString');
      fromDate = DateFormat('d MMM yyyy').format(DateTime.parse(excuse.fromDate!));
      toDate = DateFormat('d MMM yyyy').format(DateTime.parse(excuse.toDate!));
      final extension = excuse.documentName?.split('.').last.toLowerCase();
      isImage = Get.find<MyRequestController>()
          .supportedImageExtensions
          .map((e) => e.toLowerCase())
          .contains(extension);
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
                        "Request Details",
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
                                    color: Color(colorCode),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  excuse.requestStatusName ?? '--',
                                  style: GoogleFonts.poppins(
                                    color: Color(colorCode),
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
                                Text(
                                    "From : ",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: ColorUtils.textWhite.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                    fromDate,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 10).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 30.h,
                                  maxWidth: ScreenUtil().screenWidth * 0.5,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "$title ${excuse.requestLetterType != null ? "- ${excuse.requestLetterType}" : ''}",
                                        // overflow: TextOverflow.ellipsis,
                                        // maxLines: 3,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "To : ",
                                    style:
                                    GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    toDate,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite,
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
                          controller: _reasonController,
                          decoration: InputDecoration(
                            hintText: "Description (Optional)",
                            contentPadding: const EdgeInsets.all(0),
                            border: OutlineInputBorder(
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
                  if(excuse.approvedDocument != null)
                    if(isImage)
                      Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9).w,
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                await launchUrl(Uri.parse(excuse.approvedDocument!));
                              } catch(e) {}
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 200.w,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(12).w,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12).w,
                                child: CachedNetworkImage(
                                  imageUrl: excuse.approvedDocument ?? '',
                                  errorWidget: (context, url, error) => Container(),
                                  placeholder: (context, url) => Container(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 5.h,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            await launchUrl(
                                Uri.parse(excuse.approvedDocument!),
                                mode: LaunchMode.externalApplication,
                            );
                          } catch(e) {}
                        },
                        child: LoyaltriBlueTextButton(text: "Download"),
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
                  //                 color: const Color(0xFFAAAAAA),
                  //               ),
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
