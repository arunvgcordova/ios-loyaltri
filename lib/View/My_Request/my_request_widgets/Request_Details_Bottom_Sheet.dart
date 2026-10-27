
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';
import '../../CWidgets/cwidgets.dart';
import '../../Leave_Page/leave_widgets/leave_detail_bottomSheet.dart';
import '../controller/my_request_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/myRequestListApiModel.dart';
import '../../../utils/color_utils.dart';

class RequestDetailBottomSheet extends StatelessWidget {
  final RequestData excuse;
  const RequestDetailBottomSheet({super.key, required this.excuse});

  @override
  Widget build(BuildContext context) {
    int colorCode = 000000;
    String fromDate = '--';
    String toDate = '--';
    TextEditingController _reasonController = TextEditingController(text: excuse.requestDescription);
    bool isImage = false;
    try {
      // title = excuse.requestType == "1" ? "Work From Home" : "Letter Request";
      // String colorString = excuse.requestStatusColour?.split('#').last ?? '';
      // colorCode = int.parse('0xFF$colorString');
      fromDate = DateFormat('d MMM yyyy').format(DateTime.parse(excuse.fromDate!));
      toDate = DateFormat('d MMM yyyy').format(DateTime.parse(excuse.toDate!));
      // final extension = excuse.documentName?.split('.').last.toLowerCase();
      // isImage = Get.find<MyRequestController>()
      //     .supportedImageExtensions
      //     .map((e) => e.toLowerCase())
      //     .contains(extension);
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
          padding: EdgeInsets.only(left: 15.h, right: 15.h, top: 10.h),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const Spacer(),
                    GestureDetector(
                      onTap: () async {
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
                    const Spacer(flex: 4),
                    Image.asset(
                      "assets/images/Hourglass-3d.webp",
                      width: 40.h,
                    ),
                    Text(
                      "Request Details",
                      style: GoogleFonts.poppins(
                        color: ColorUtils.textWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.h,
                      ),
                    ),
                    const Spacer(flex: 8),
                  ],
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6).h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10.h,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50).r,
                                  color: Color(colorCode),
                                ),
                              ),
                              SizedBox(width: 5.h),
                              Text(
                                excuse.specialRequestType ?? '--',
                                style: GoogleFonts.poppins(
                                  color: Color(colorCode),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.h,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if(excuse.specialRequestTypeId == '1')
                            Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "From : ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.h,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                ),
                              ),
                              Text(
                                  fromDate,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.h,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 10).h,
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
                                      excuse.requestLetterType ?? excuse.specialRequestType ?? '--',
                                      // overflow: TextOverflow.ellipsis,
                                      // maxLines: 3,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.h,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if(excuse.specialRequestTypeId == '1')
                              Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "To : ",
                                  style:
                                  GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.h,
                                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                  ),
                                ),
                                Text(
                                  toDate,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.h,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                              ],
                            )
                            else if(fromDate != '--')
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Requested On : ",
                                    style:
                                    GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.h,
                                      color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  Text(
                                    fromDate,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.h,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                      if(excuse.specialRequestType == "Shift Swap Request")
                        Row(
                          children: [
                            Text(
                              "Requested Shift : ",
                              style:
                              GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.h,
                                color: ColorUtils.textWhite.withValues(alpha: 0.5),
                              ),
                            ),
                            Text(
                              excuse.requestedShift ?? '--',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 180.h,
                  width: ScreenUtil().screenWidth * 0.9,
                  padding: const EdgeInsets.all(15).h,
                  decoration: BoxDecoration(
                      color: ColorUtils.foregroundBlack,
                      borderRadius: BorderRadius.circular(15).r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reason",
                        style: GoogleFonts.inter(
                          color: Color(0xFFAAAAAA),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.h,
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        style: GoogleFonts.inter(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.h,
                        ),
                        controller: _reasonController,
                        decoration: InputDecoration(
                          hintText: "Description (Optional)",
                          contentPadding: const EdgeInsets.all(0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: GoogleFonts.inter(
                            color: ColorUtils.textWhite.withValues(alpha: 0.2),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.h,
                            letterSpacing: -0.35,
                          ),
                        ),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
                // if(excuse.approvedDocument != null)
                //   if(isImage)
                //     Row(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 9).w,
                //         child: GestureDetector(
                //           onTap: () async {
                //             try {
                //               await launchUrl(Uri.parse(excuse.approvedDocument!));
                //             } catch(e) {}
                //           },
                //           child: Container(
                //             constraints: BoxConstraints(
                //               maxHeight: 200.w,
                //             ),
                //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                //             decoration: BoxDecoration(
                //               color: ColorUtils.foregroundBlack,
                //               borderRadius: BorderRadius.circular(12).w,
                //             ),
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.circular(12).w,
                //               child: CachedNetworkImage(
                //                 imageUrl: excuse.approvedDocument ?? '',
                //                 errorWidget: (context, url, error) => Container(),
                //                 placeholder: (context, url) => Container(),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   )
                // else
                //   Padding(
                //     padding: EdgeInsets.symmetric(
                //       vertical: 15.h,
                //       horizontal: 5.h,
                //     ),
                //     child: GestureDetector(
                //       onTap: () async {
                //         try {
                //           await launchUrl(
                //               Uri.parse(excuse.approvedDocument!),
                //               mode: LaunchMode.externalApplication,
                //           );
                //         } catch(e) {}
                //       },
                //       child: LoyaltriBlueTextButton(text: "Download"),
                //     ),
                //   ),
                if(excuse.approvedDocument?.isNotEmpty ?? false)
                  SizedBox(
                    height: 200.w,
                    child: ListView.separated(
                      itemCount: excuse.approvedDocument?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9).w,
                          child: InkWell(
                            onTap: () async {
                              try {
                                await launchUrl(Uri.parse(excuse.approvedDocument![index]));
                              } catch(e) {}
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(12).w,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: excuse.approvedDocument?[index] ?? '',
                                errorWidget: (context, url, error) => Container(),
                                placeholder: (context, url) => Container(),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5.w),
                    ),
                  ),

                SizedBox(height: 20.h),
                if(excuse.track != null && (excuse.track?.isNotEmpty ?? false))
                  Row(
                  children: [
                    SizedBox(width: 5.h),
                    Text(
                      "Hierarchy Approval Status",
                      style: GoogleFonts.inter(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.lightGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                if(excuse.track != null && (excuse.track?.isNotEmpty ?? false))
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.h,
                    ),
                    child: Column(
                      children: List.generate((excuse.track?.length ?? 0), (stepIndex) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate((excuse.track?[stepIndex].length ?? 0), (itemIndex) {
                            final item = excuse.track?[stepIndex][itemIndex];
                            return Column(
                              children: [
                                if(itemIndex == 0)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Step ${stepIndex + 1}",
                                            style: TextStyle(color: ColorUtils.textWhite),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                    ],
                                  ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2).h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: statusColor(item?.status ?? ''),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(1000).r,
                                              child: CachedNetworkImage(
                                                imageUrl: item?.profilePicture ?? '',
                                                height: 30.h,
                                                width: 30.h,
                                                alignment: Alignment.center,
                                                placeholder: (context, url) {
                                                  return Container(
                                                    width: 30.h,
                                                    height: 30.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                        size: 18.h,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorWidget: (context, url, error) {
                                                  return Container(
                                                    width: 30.h,
                                                    height: 30.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                        size: 18.h,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          if(excuse.track?[stepIndex].length != itemIndex + 1)
                                            Expanded(
                                              child: excuse.track?[stepIndex][itemIndex + 1].status == "Approved" ? Container(
                                                width: 1.5.h,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      ColorUtils.jungleGreen,
                                                      ColorUtils.mediumAquamarine,
                                                    ],
                                                  ),
                                                ),
                                              ) : CustomPaint(
                                                size: Size(1.5.h, double.infinity),
                                                painter: DottedLinePainter(color: excuse.track?[stepIndex][itemIndex + 1].status == "Rejected" ?  ColorUtils.incorrectOTP : Color(0xFF323232)),
                                              ),
                                            ),
                                          // SvgPicture.asset(
                                          //   "assets/images/hierarchy_line_green.svg",
                                          // ),
                                        ],
                                      ),
                                      SizedBox(width: 10.h),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item?.name ?? '--',
                                                        style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 11.h,
                                                            color: ColorUtils.textWhite.withValues(alpha: 0.9)
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        item?.designation ?? '--',
                                                        style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 11.h,
                                                            color: ColorUtils.textWhite.withValues(alpha: 0.5)
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8.h),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    if(item?.status != null)
                                                      if(item?.status?.toLowerCase() == "approved")
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset("assets/images/thumb_green.svg"),
                                                            SizedBox(
                                                              width: 4.h,
                                                            ),
                                                            ConstrainedBox(
                                                              constraints: BoxConstraints(
                                                                maxWidth: 100.h,
                                                              ),
                                                              child: Text(
                                                                item?.status ?? '--',
                                                                style: GoogleFonts.poppins(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 11.h,
                                                                  color: ColorUtils.approved,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      else if(item?.status?.toLowerCase() == "rejected")
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset("assets/images/thumb_red.svg"),
                                                            SizedBox(
                                                              width: 4.h,
                                                            ),
                                                            ConstrainedBox(
                                                              constraints: BoxConstraints(
                                                                maxWidth: 100.h,
                                                              ),
                                                              child: Text(
                                                                item?.status ?? '--',
                                                                style: GoogleFonts.poppins(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 11.h,
                                                                  color: Color(0xFFFF5454),
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      else
                                                        Row(
                                                          children: [
                                                            ConstrainedBox(
                                                              constraints: BoxConstraints(
                                                                maxWidth: 100.h,
                                                              ),
                                                              child: Text(
                                                                item?.status ?? '--',
                                                                style: GoogleFonts.poppins(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 11.h,
                                                                  color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                    else
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          maxWidth: 100.h,
                                                        ),
                                                        child: Text(
                                                          "Not updated",
                                                          style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11.h,
                                                            color: const Color(0xFF666666),
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    SizedBox(height: 3.h),
                                                    ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                        maxWidth: 100.h,
                                                      ),
                                                      child: Text(
                                                        item?.modifiedOn ?? "--",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 11.h,
                                                          color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 10.h,
                                                bottom: 20.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Remarks : ${item?.remarks ?? ''}",
                                                      style: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 11.h,
                                                        color: ColorUtils.textWhite.withValues(alpha: 0.8),
                                                      ),
                                                      // overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                SizedBox(height: 4.h),
              ],
            ),
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
