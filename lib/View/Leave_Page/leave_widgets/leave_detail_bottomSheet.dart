
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/leave_list_api_model.dart';

class LeaveDetailBottomSheet extends StatelessWidget {
  final AppliedLeave? appliedLeave;
  const LeaveDetailBottomSheet({super.key, required this.appliedLeave});

  @override
  Widget build(BuildContext context) {
    String fromDate = '--';
    String toDate = '--';
    String createdDate = '--';
    int totalLeaveHour = 0;
    List<String> attachments = appliedLeave?.leaveAttachments ?? [];
    try {
      if(appliedLeave?.isHourBased == '1') {
        DateTime from = DateFormat("yyyy-MM-dd").parse(appliedLeave?.leaveDate ?? '');
        fromDate = DateFormat("dd-MM-yyyy").format(from);
        DateTime createdOn = DateFormat("yyyy-MM-dd").parse((appliedLeave?.createdOn ?? '').trim().toUpperCase());
        createdDate = DateFormat("d-M-yyyy").format(createdOn);
        totalLeaveHour = int.tryParse(appliedLeave?.totalLeaveTime ?? '0') ?? 0;
      } else {
        DateTime from = DateFormat("yyyy-MM-dd").parse(appliedLeave?.leaveDateFrom ?? '');
        fromDate = DateFormat("dd-MM-yyyy").format(from);
        DateTime to = DateFormat("yyyy-MM-dd").parse(appliedLeave?.leaveDateTo ?? '');
        toDate = DateFormat("dd-MM-yyyy").format(to);
        DateTime createdOn = DateFormat("yyyy-MM-dd hh:mm a").parse((appliedLeave?.requestedDate ?? '').trim().toUpperCase());
        createdDate = DateFormat("hh:mm a | d-M-yyyy").format(createdOn);
      }
    } catch(e) {}
    return KeyboardAvoider(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.h,
            right: 8.h,
            top: 8.h,
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0, top: 8.0).r,
            decoration: BoxDecoration(
              color: ColorUtils.backgroundBlack,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
              ).r,
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0).r,
                    child: Container(
                      width: 75.h,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20).r,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 48.h,
                        width: 48.h,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/manager_view/employee_leave_calendar.png",
                            width: 26.h,
                          ),
                          SizedBox(width: 5.h),
                          Text(
                            "Leave Request Info",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.h,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(1.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3F4450),
                            borderRadius: BorderRadius.circular(14).r,
                          ),
                          child: Container(
                            height: 48.h,
                            width: 48.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.foregroundBlack,
                              borderRadius: BorderRadius.circular(13).r,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 18.w,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Flexible(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8.h,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AttendanceCommonWidgets().hexToColor(appliedLeave?.requestStatusColour),
                                    ),
                                  ),
                                  SizedBox(width: 5.h),
                                  Flexible(
                                    child: Text(
                                      appliedLeave?.requestStatusName ?? '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.h,
                                        color: AttendanceCommonWidgets().hexToColor(appliedLeave?.requestStatusColour),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.h),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Type : ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.h,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      appliedLeave?.leaveType ?? '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.h,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: ColorUtils.textWhite.withValues(alpha: 0.1),
                          height: 20.h,
                          thickness: 1.h,
                        ),
                        if(appliedLeave?.isHourBased == '1')
                          Row(
                            children: [
                              Text(
                                "Leave Date : ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                              Text(
                                fromDate,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                          children: [
                            Text(
                              "Start date : ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Text(
                              fromDate,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "End date : ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Text(
                              toDate,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Text(
                              appliedLeave?.isHourBased == '1' ? "Total hours : " : "No of days : ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Text(
                              appliedLeave?.isHourBased == '1' ? totalLeaveHour.toString() : appliedLeave?.totalLeaveDays ?? '--',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Requested On : ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              // "10:30 PM | 22-4-2025",
                              createdDate,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          padding: EdgeInsets.only(top: 15.h),
                          decoration: BoxDecoration(
                            color: ColorUtils.foregroundBlack,
                            borderRadius: BorderRadius.all(Radius.circular(12).r),
                          ),
                          child: TextFormField(
                            controller: TextEditingController(text: appliedLeave?.leaveReason ?? '--'),
                            readOnly: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12).r),
                                borderSide: BorderSide(
                                  color: ColorUtils.foregroundBlack,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12).r),
                                borderSide: BorderSide(
                                  color: ColorUtils.foregroundBlack,
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              fillColor: ColorUtils.foregroundBlack,
                              filled: true,
                              label: Text(
                                  "Reason",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            minLines: 1,
                            maxLines: 3,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.h,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        if(attachments.isNotEmpty)
                          SizedBox(
                            height: 200.w,
                            child: ListView.separated(
                              itemCount: attachments.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 9).w,
                                  child: InkWell(
                                    onTap: () async {
                                      try {
                                        await launchUrl(Uri.parse(attachments[index]));
                                      } catch(e) {}
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.foregroundBlack,
                                        borderRadius: BorderRadius.circular(12).w,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: attachments[index],
                                        errorWidget: (context, url, error) => SizedBox(
                                          width: 200,
                                          height: 200.w,
                                          child: Center(
                                            child: Icon(Icons.error_outline, color: Colors.orange),
                                          ),
                                        ),
                                        placeholder: (context, url) => SizedBox(
                                          width: 200,
                                          height: 200.w,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5.w),
                            ),
                          ),
                        SizedBox(height: 10.h),
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
                      ],
                    ),
                  ),
                  if(appliedLeave?.adminData != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Row(
                        children: [
                          if(appliedLeave?.mainStatus != null)
                            Text(
                              "${appliedLeave?.mainStatus} ",
                              style: TextStyle(color: ColorUtils.textWhite),
                            ),
                          Text(
                            "By Admin",
                            style: TextStyle(color: ColorUtils.textWhite),
                          ),
                        ],
                      ),
                    ),
                  if(appliedLeave?.adminData != null)
                    SizedBox(height: 10.h),
                  if(appliedLeave?.adminData != null)
                    Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2).h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor(appliedLeave?.mainStatus ?? ''),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000).r,
                            child: CachedNetworkImage(
                              imageUrl: appliedLeave?.adminData?.profilePicture ?? '',
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
                                          appliedLeave?.adminData?.fullName ?? '--',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.h,
                                              color: ColorUtils.textWhite.withValues(alpha: 0.9)
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          appliedLeave?.adminData?.designation ?? '--',
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
                                      if(appliedLeave?.mainStatus != null)
                                        if(appliedLeave?.mainStatus?.toLowerCase() == "approved")
                                          Row(
                                            children: [
                                              SvgPicture.asset("assets/images/thumb_green.svg"),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 100.h,
                                                ),
                                                child: Text(
                                                  appliedLeave?.mainStatus ?? '--',
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
                                        else if(appliedLeave?.mainStatus?.toLowerCase() == "rejected")
                                          Row(
                                            children: [
                                              SvgPicture.asset("assets/images/thumb_red.svg"),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 100.h,
                                                ),
                                                child: Text(
                                                  appliedLeave?.mainStatus ?? '--',
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
                                                  appliedLeave?.mainStatus ?? '--',
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
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 100.h,
                                        ),
                                        child: Text(
                                          appliedLeave?.adminData?.modifiedOn ?? "--",
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
                                        "Remarks : ${appliedLeave?.adminData?.remarks ?? ''}",
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
                  SizedBox(height: 10.h),
                  if(appliedLeave?.track != null && (appliedLeave?.track?.isNotEmpty ?? false))
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Column(
                        children: List.generate((appliedLeave?.track?.length ?? 0), (stepIndex) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate((appliedLeave?.track?[stepIndex].length ?? 0), (itemIndex) {
                              final item = appliedLeave?.track?[stepIndex][itemIndex];
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
                                            if(appliedLeave?.track?[stepIndex].length != itemIndex + 1)
                                              Expanded(
                                                child: appliedLeave?.track?[stepIndex][itemIndex + 1].status == "Approved" ? Container(
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
                                                  painter: DottedLinePainter(color: appliedLeave?.track?[stepIndex][itemIndex + 1].status == "Rejected" ?  ColorUtils.incorrectOTP : Color(0xFF323232)),
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
                                                                width: 4.w,
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
                                                                width: 4.w,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch(status.toLowerCase()) {
      case "pending": return const Color(0xFF323232);
      case "pardon": return const Color(0xFF50BC61);
      case "approved": return const Color(0xFF00CA7A);
      case "fine": return const Color(0xFFD40000);
      case "rejected": return const Color(0xFFCA0000);
      default: return const Color(0xFF323232);
    }
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotHeight;
  final double spaceHeight;

  DottedLinePainter({
    required this.color,
    this.dotHeight = 4,
    this.spaceHeight = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = size.width;

    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dotHeight), paint);
      y += dotHeight + spaceHeight;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}