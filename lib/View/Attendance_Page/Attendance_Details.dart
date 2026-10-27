
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/controller/attendanceListController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/userAuthentication.dart';
import '../../models/detailed_attendance_api_model.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/app_bar.dart';

class AttendanceDetails extends StatefulWidget {
  final String attendanceId;
  final String employeeId;
  const AttendanceDetails({super.key, required this.attendanceId, required this.employeeId});

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  AttendanceList attendanceListController = Get.find<AttendanceList>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    await attendanceListController.fetchAttendanceDetails(attId: widget.attendanceId, empId: widget.employeeId);
    if(!mounted) return;
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        body: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const CustomAppBar(
                  title: "Attendance Detail",
                  isActionVisible: true,
                ),
                Obx(() => attendanceListController.detailsLoading.value || attendanceListController.attendanceDetail.value.result?.employeeData?.shift == null ? const SizedBox() : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 8.h),
                        decoration: BoxDecoration(
                          color: ColorUtils.foregroundBlack,
                          borderRadius: BorderRadius.circular(20).r,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF959CBD),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              attendanceListController.attendanceDetail.value.result?.employeeData?.shift ?? '--',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: ColorUtils.textWhite,
                                fontSize: 12.h,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      // const Spacer(),
                      // SizedBox(
                      //   width: 160.w,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () async {
                      //           if (currentValue != 0) {
                      //             setState(() => currentValue = currentValue - 1);
                      //             String dateString = _formattedMonthYear(monthYear: monthString[currentValue]);
                      //             DateTime dateTime = DateFormat('MMMM yyyy').parse(dateString);
                      //           }
                      //         },
                      //         child: const ChevronIconLeft(chevronIcon: Icons.arrow_back_ios),
                      //       ),
                      //       FittedBox(
                      //         child: Text(
                      //           monthString[currentValue], // Month and year text
                      //           style: GoogleFonts.poppins(
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 12.h,
                      //             color: ColorUtils.textWhite,
                      //           ),
                      //         ),
                      //       ),
                      //       GestureDetector(
                      //         onTap: () async {
                      //           if (currentValue != (monthString.length - 1)) {
                      //             setState(() => currentValue = currentValue + 1);
                      //             String dateString = _formattedMonthYear(monthYear: monthString[currentValue]);
                      //             DateTime dateTime = DateFormat('MMMM yyyy').parse(dateString);
                      //           }
                      //         },
                      //         child: const ChevronIconRight(chevronIcon: Icons.arrow_forward_ios),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                ),
                const _AttendanceDetail(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceDetail extends GetView<AttendanceList> {
  const _AttendanceDetail();

  @override
  Widget build(BuildContext context) {
    UserProfileController userProfileController = Get.find<UserProfileController>();
    return Obx(() {
      List<Logs> attendanceLog = controller.attendanceDetail.value.result?.logs ?? [];
      return SizedBox(
        width: ScreenUtil().screenWidth * 0.96,
        height: ScreenUtil().screenHeight * 0.77,
        child: attendanceLog.isNotEmpty
            ? Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: ScreenUtil().screenWidth * 0.96,
            // height: ScreenUtil().screenHeight * 0.77,
            padding: const EdgeInsets.all(12).h,
            decoration: BoxDecoration(
              color: ColorUtils.backgroundBlack,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ).r,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(int i = 0; i < attendanceLog.length; i++)
                    if(attendanceLog[i].remark == "punchIn")
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 36.h,
                                      height: 36.h,
                                      padding: const EdgeInsets.all(6).h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorUtils.attCheckIn,
                                        border: Border.all(
                                          color: ColorUtils.attCheckIn.withOpacity(0.17),
                                          width: 6.h,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/check-in.svg",
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            convertTimeTo12HourFormat(attendanceLog[i].datas?.time),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.h,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${convertToTitleCase(attendanceLog[i].remark ?? '')} via ",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.h,
                                                  color: ColorUtils.offDayCircle,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  attendanceLog[i].datas?.punchType ?? '--',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.h,
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
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
                              SizedBox(width: 8.w),
                              // Expanded(
                              //   child: SizedBox(
                              //     child: Center(
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12).h,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(45).r,
                              //           gradient: const LinearGradient(
                              //             begin: Alignment.centerLeft,
                              //             end: Alignment.centerRight,
                              //             colors: [
                              //               ColorUtils.lateColorForAttDetail1,
                              //               ColorUtils.lateColorForAttDetail2,
                              //             ],
                              //           ),
                              //         ),
                              //         child: Text(
                              //           "Late : 10 Minutes",
                              //           style: GoogleFonts.poppins(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 8.h,
                              //             color: ColorUtils.textWhite,
                              //           ),
                              //           overflow: TextOverflow.ellipsis,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if(attendanceLog.last.datas != attendanceLog[i].datas)
                                Padding(
                                  padding: const EdgeInsets.only(left: 18).h,
                                  child: SvgPicture.asset(
                                    "assets/images/att-detail-status-line-1.svg",
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: attendanceLog.last.datas == attendanceLog[i].datas
                                      ? const EdgeInsets.only(left: 45, top: 30).h
                                      : const EdgeInsets.only(left: 28).h,
                                  child: Container(
                                    // width: 270.w,
                                    // height: 70.h,
                                    padding: const EdgeInsets.all(8).h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(16).r,
                                      border: Border.all(
                                        color: ColorUtils.foregroundBlack2,
                                        width: 1.h,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.h,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.textWhite,
                                            borderRadius: BorderRadius.circular(10).r,
                                            border: Border.all(
                                              color: ColorUtils.foregroundBlack3,
                                              width: 2.h,
                                              strokeAlign: BorderSide.strokeAlignCenter,
                                            ),
                                            // image: DecorationImage(
                                            //   image: userProfileController.profileImageLocation.value.path != ""
                                            //       ? FileImage(userProfileController.profileImageLocation.value)
                                            //       : userProfileController.userData.value.result.profilePicture.toString().isNotEmpty
                                            //       ? NetworkImage(userProfileController.userData.value.result.profilePicture.toString())
                                            //       : const AssetImage("assets/images/profile_pic.png") as ImageProvider, // Fallback to AssetImage
                                            //   fit: BoxFit.fitWidth,
                                            // ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10).r,
                                            child: punchViewWidget(context, data: attendanceLog[i].datas, isIn: true),
                                          ),
                                        ),

                                        SizedBox(width: 8.h),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/timer-att-details.svg",
                                                    width: 14.h,
                                                    height: 14.h,
                                                  ),
                                                  SizedBox(width: 8.h),
                                                  Expanded(
                                                    child: Text(
                                                      "${convertToTitleCase(attendanceLog[i].remark ?? '')}: ${convertTimeTo12HourFormat(attendanceLog[i].datas?.time)}",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12.h,
                                                        color: ColorUtils.textWhite,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/location-att-details.svg",
                                                    width: 16.h,
                                                    height: 16.h,
                                                  ),
                                                  SizedBox(width: 8.h),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        if(attendanceLog[i].datas?.latitude == null || attendanceLog[i].datas?.longitude == null) return;
                                                        try {
                                                          await openGoogleMap(double.parse(attendanceLog[i].datas!.latitude!), double.parse(attendanceLog[i].datas!.longitude!));
                                                        } catch(e) {}
                                                      },
                                                      child: Text(
                                                        attendanceLog[i].datas?.punchInLocation ?? '--',
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12.h,
                                                          decoration: (attendanceLog[i].datas?.punchInLocation != null && attendanceLog[i].datas?.latitude != null && attendanceLog[i].datas?.longitude != null) ? TextDecoration.underline : null,
                                                          decorationColor: ColorUtils.babyBlue,
                                                          color: (attendanceLog[i].datas?.latitude == null || attendanceLog[i].datas?.longitude == null) ? ColorUtils.textWhite : ColorUtils.babyBlue,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else if(attendanceLog[i].remark == "startBreak")
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 36.h,
                                height: 36.h,
                                padding: const EdgeInsets.all(6).h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorUtils.textWhite,
                                  border: Border.all(
                                    color: ColorUtils.attBreakStr.withOpacity(0.2),
                                    width: 6.h,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/mug-hot-break.svg",
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Start Break",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.h,
                                      color: ColorUtils.offDayCircle,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${formatDate(attendanceLog[i].datas?.eventDate)} ",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.h,
                                          color: ColorUtils.offDayCircle,
                                        ),
                                      ),
                                      Text(
                                        convertTimeTo12HourFormat(attendanceLog[i].datas?.time),
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
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18).h,
                                child: SvgPicture.asset(
                                  "assets/images/att-detail-status-line-2.svg",
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    else if(attendanceLog[i].remark == "endBreak")
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 36.h,
                                height: 36.h,
                                padding: const EdgeInsets.all(6).h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorUtils.textWhite,
                                  border: Border.all(
                                    color: ColorUtils.attBreakStr.withOpacity(0.2),
                                    width: 6.h,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/mug-hot-break.svg",
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "End Break",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.h,
                                      color: ColorUtils.offDayCircle,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${formatDate(attendanceLog[i].datas?.eventDate)} ",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.h,
                                          color: ColorUtils.offDayCircle,
                                        ),
                                      ),
                                      Text(
                                        convertTimeTo12HourFormat(attendanceLog[i].datas?.time),
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
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18).h,
                                child: SvgPicture.asset(
                                  "assets/images/att-detail-status-line-2.svg",
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else if(attendanceLog[i].remark == "punchOut")
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 36.h,
                                      height: 36.h,
                                      padding: const EdgeInsets.all(6).h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorUtils.attCheckOut,
                                        border: Border.all(
                                          color: ColorUtils.attCheckOut1.withOpacity(0.22),
                                          width: 6.h,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/check-out.svg",
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            convertTimeTo12HourFormat(attendanceLog[i].datas?.time),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.h,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${convertToTitleCase(attendanceLog[i].remark ?? '')} via ",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.h,
                                                  color: ColorUtils.offDayCircle,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  attendanceLog[i].datas?.punchOutType ?? '--',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.h,
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
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
                              SizedBox(width: 8.w),
                              // Expanded(
                              //   child: SizedBox(
                              //     child: Center(
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12).h,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(45).r,
                              //           gradient: const LinearGradient(
                              //             begin: Alignment.centerRight,
                              //             end: Alignment.centerLeft,
                              //             colors: [
                              //               ColorUtils.otColorForAttDetail1,
                              //               ColorUtils.otColorForAttDetail2,
                              //             ],
                              //           ),
                              //         ),
                              //         child: Text(
                              //           "Over Time : 10 Minutes",
                              //           style: GoogleFonts.poppins(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 8.h,
                              //             color: ColorUtils.textWhite,
                              //           ),
                              //           overflow: TextOverflow.ellipsis,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if(attendanceLog.last.datas != attendanceLog[i].datas)
                                Padding(
                                  padding: const EdgeInsets.only(left: 18).h,
                                  child: SvgPicture.asset(
                                    "assets/images/att-detail-status-line-1.svg",
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: attendanceLog.last.datas == attendanceLog[i].datas
                                      ? const EdgeInsets.only(left: 45, top: 30).h
                                      : const EdgeInsets.only(left: 28).h,
                                  child: Container(
                                    // width: 270.w,
                                    // height: 70.h,
                                    padding: const EdgeInsets.all(8).h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(16).r,
                                      border: Border.all(
                                        color: ColorUtils.foregroundBlack2,
                                        width: 1.h,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.h,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.textWhite,
                                            borderRadius: BorderRadius.circular(10).r,
                                            border: Border.all(
                                              color: ColorUtils.foregroundBlack3,
                                              width: 2.h,
                                              strokeAlign: BorderSide.strokeAlignCenter,
                                            ),
                                            // image: DecorationImage(
                                            //   image: userProfileController.profileImageLocation.value.path != ""
                                            //       ? FileImage(userProfileController.profileImageLocation.value)
                                            //       : userProfileController.userData.value.result.profilePicture.toString().isNotEmpty
                                            //       ? NetworkImage(userProfileController.userData.value.result.profilePicture.toString())
                                            //       : const AssetImage("assets/images/profile_pic.png") as ImageProvider, // Fallback to AssetImage
                                            //   fit: BoxFit.fitWidth,
                                            // ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10).r,
                                            child: punchViewWidget(context, data: attendanceLog[i].datas, isIn: false),
                                          ),
                                        ),
                                        SizedBox(width: 8.h),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/timer-att-details.svg",
                                                    width: 14.h,
                                                    height: 14.h,
                                                  ),
                                                  SizedBox(width: 8.h),
                                                  Expanded(
                                                    child: Text(
                                                      "${convertToTitleCase(attendanceLog[i].remark ?? '')}: ${convertTimeTo12HourFormat(attendanceLog[i].datas?.time)}",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12.h,
                                                        color: ColorUtils.textWhite,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/location-att-details.svg",
                                                    width: 16.h,
                                                    height: 16.h,
                                                  ),
                                                  SizedBox(width: 8.h),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        if(attendanceLog[i].datas?.latitude == null || attendanceLog[i].datas?.longitude == null) return;
                                                        try {
                                                          await openGoogleMap(double.parse(attendanceLog[i].datas!.latitude!), double.parse(attendanceLog[i].datas!.longitude!));
                                                        } catch(e) {}
                                                      },
                                                      child: Text(
                                                        attendanceLog[i].datas?.punchOutLocation ?? '--',
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12.h,
                                                          decoration: (attendanceLog[i].datas?.punchInLocation != null && attendanceLog[i].datas?.latitude != null && attendanceLog[i].datas?.longitude != null) ? TextDecoration.underline : null,
                                                          decorationColor: ColorUtils.babyBlue,
                                                          color: (attendanceLog[i].datas?.latitude == null || attendanceLog[i].datas?.longitude == null) ? ColorUtils.textWhite : ColorUtils.babyBlue,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
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
                                  ),
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
        )
            : Center(
                child: Text(
                  controller.detailsLoading.value ? "Loading..." : "No Data",
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
        ),
      );
    },
    );
  }

  Widget punchViewWidget(BuildContext context, {Datas? data, required bool isIn}) {
    if(data?.punchInImage != null || data?.punchOutImage != null) {
      return InkWell(
        borderRadius: BorderRadius.circular(10).r,
        onTap: () {
          locationViewPopUp(context, image: isIn ? data?.punchInImage ?? '' : data?.punchOutImage ?? '');
        },
        child: CachedNetworkImage(
          imageUrl: isIn ? data?.punchInImage ?? '' : data?.punchOutImage ?? '',
          errorWidget: (context, url, error) {
            return data?.latitude != null && data?.longitude != null ? InkWell(
              onTap: () {
                locationViewPopUp(context, latLng: LatLng(double.parse(data!.latitude!), double.parse(data.longitude!)));
              },
              child: Image.asset(
                'assets/images/manager_view/map_preview.png',
              ),
            ) : const Icon(Icons.person, color: Colors.grey);
          },
          fit: BoxFit.fitWidth,
        ),
      );
    } else if(data?.latitude != null && data?.longitude != null) {
      return InkWell(
        onTap: () {
          locationViewPopUp(context, latLng: LatLng(double.parse(data!.latitude!), double.parse(data.longitude!)));
        },
        child: Image.asset(
          'assets/images/manager_view/map_preview.png',
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: isIn ? data?.punchInImage ?? '' : data?.punchOutImage ?? '',
        errorWidget: (context, url, error) {
          return const Icon(Icons.person, color: Colors.grey);
        },
        fit: BoxFit.fitWidth,
      );
    }
  }

  Future<void> locationViewPopUp(BuildContext context, {LatLng? latLng, String? image}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: ColorUtils.workEntryHead,
          content: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                                        imageUrl: image,
                                        errorWidget: (context, url, error) {
                      return latLng?.latitude != null && latLng?.longitude != null ? ClipRRect(
                        borderRadius: BorderRadius.circular(12).r,
                        child: GestureDetector(
                          onTap: () {},
                          onVerticalDragStart: (_) {},
                          onHorizontalDragStart: (_) {},
                          child: GoogleMap(
                            style: darkModeMapStyle,
                            liteModeEnabled: true,
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: latLng!,
                              zoom: 16,
                            ),
                            markers: <Marker>{
                              Marker(
                                markerId: const MarkerId('loc'),
                                position: latLng,
                              ),
                            },
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                          ),
                        ),
                      )  : SizedBox();
                                        },
                                        fit: BoxFit.fitWidth,
                                      ),
                    )
                    : latLng != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12).r,
                  child: GestureDetector(
                    onTap: () {},
                    onVerticalDragStart: (_) {},
                    onHorizontalDragStart: (_) {},
                    child: GoogleMap(
                      style: darkModeMapStyle,
                      liteModeEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: latLng,
                        zoom: 16,
                      ),
                      markers: <Marker>{
                        Marker(
                          markerId: const MarkerId('loc'),
                          position: latLng,
                        ),
                      },
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                    ),
                  ),
                )
                    : SizedBox(),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 30.h,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000).r,
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, color: ColorUtils.textWhite, size: 15.h),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDate(String? inputDate) {
    try {
      DateTime parsedDate = DateTime.parse(inputDate!);
      String formattedDate = DateFormat('d MMM yyyy').format(parsedDate);
      return formattedDate;
    } catch(e) {return '--';}
  }

  String convertToTitleCase(String input) {
    return input.split(RegExp(r'(?=[A-Z])')) // Split based on uppercase letters
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()) // Capitalize each word
        .join(' '); // Join words with a space
  }

  String convertTimeTo12HourFormat(String? time24Hour) {
    if (time24Hour == null || time24Hour.isEmpty) return '--';

    try {
      final normalized =
      time24Hour.length == 5 ? '$time24Hour:00' : time24Hour;

      final parsed = DateFormat("HH:mm:ss").parse(normalized);
      return DateFormat("hh:mm a").format(parsed);
    } catch (_) {
      return '--';
    }
  }

  Future<void> openGoogleMap(double lat, double lng) async {
    final googleMapUrl = Uri.parse("geo:$lat,$lng?q=$lat,$lng");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      await launchUrl(
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng"),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
