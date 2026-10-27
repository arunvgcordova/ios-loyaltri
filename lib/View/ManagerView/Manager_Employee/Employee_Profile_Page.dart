
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../../models/manager/all_employee_list.dart';
import '../../../utils/color_utils.dart';

class EmployeeProfilePage extends StatelessWidget {
  final CompanyEmployeeData companyEmployeeData;
  const EmployeeProfilePage({super.key, required this.companyEmployeeData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: ColorUtils.textWhite,
        body: Stack(
          children: [
            gradientContainer1,
            Column(
              children: [
                SafeArea(
                  top: true,
                  left: false,
                  right: false,
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h, left: 15.h, right: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14).w,
                          child: Material(
                            color: ColorUtils.foregroundBlack,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 48.h,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.textWhite,
                                  borderRadius: BorderRadius.circular(14).r,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5).h,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: ColorUtils.workEntryHead,
                                      size: 15.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/manager_view/people_icon.png", width: 23.h),
                            SizedBox(width: 5.h),
                            Text(
                              "People",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.workEntryHead,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48.h,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14).r,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2).h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorUtils.textWhite.withValues(alpha: 0.1),
                                ColorUtils.textWhite.withValues(alpha: 0.1),
                                ColorUtils.textWhite,
                              ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF98A2B3).withValues(alpha: 0.28),
                              offset: Offset(0, 1),
                              blurRadius: 12,
                              spreadRadius: 0,
                              blurStyle: BlurStyle.outer,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000).r,
                          child: CachedNetworkImage(
                            imageUrl: companyEmployeeData.profilePicture ?? '',
                            height: 53.h,
                            width: 53.h,
                            alignment: Alignment.center,
                            placeholder: (context, url) {
                              return Container(
                                width: 53.h,
                                height: 53.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 25.h,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Container(
                                width: 53.h,
                                height: 53.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 25.h,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    companyEmployeeData.fullName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.h,
                                      color: ColorUtils.workEntryHead,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.h),
                                if(companyEmployeeData.statusColour != null)
                                  Container(
                                    width: 9.h,
                                    height: 9.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AttendanceCommonWidgets().hexToColor(companyEmployeeData.statusColour),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    companyEmployeeData.designation ?? '--',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.h,
                                      color: ColorUtils.secondaryBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.h),
                                if(companyEmployeeData.code != null)
                                  Text(
                                    "#${companyEmployeeData.code}",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.h,
                                      color: ColorUtils.deepSlate.withValues(alpha: 0.3),
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
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.h,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUtils.iceGrey,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/manager_view/mobile_icon.svg",
                              height: 18.h,
                            ),
                            SizedBox(width: 5.h),
                            Text(
                              companyEmployeeData.phone ?? '--',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.h,
                                color: ColorUtils.deepSlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.h,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUtils.iceGrey,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/manager_view/email_icon.svg",
                              height: 16.h,
                            ),
                            SizedBox(width: 5.h),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.4,
                              ),
                              child: Text(
                                companyEmployeeData.email ?? '--',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.h,
                                  color: ColorUtils.deepSlate,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.h,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUtils.iceGrey,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/manager_view/shift_time_icon.svg",
                              height: 14.h,
                            ),
                            SizedBox(width: 5.h),
                            Text(
                              companyEmployeeData.shiftSchemeName ?? '--',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.h,
                                color: ColorUtils.deepSlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.h,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUtils.iceGrey,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/manager_view/emp_code_icon.svg",
                              height: 11.h,
                            ),
                            SizedBox(width: 5.h),
                            Text(
                              "Emp code : ${companyEmployeeData.code ?? '--'}",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.h,
                                color: ColorUtils.deepSlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
