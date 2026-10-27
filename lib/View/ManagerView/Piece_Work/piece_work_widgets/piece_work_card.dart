import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/create_work.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/piece_widget.dart';
import 'package:loyaltri_minimal/models/manager/piece_work_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../../controller/userProfileController.dart';

class PieceWorkCard extends StatelessWidget {
  final EmployeePiece employeePiece;
  const PieceWorkCard({super.key, required this.employeePiece});

  @override
  Widget build(BuildContext context) {
    String totalAmount = '--';
    try {
      int total = employeePiece.paymetArr
          ?.map((e) => int.tryParse(e.totalAmount!) ?? 0)
          .fold(0, (sum, element) => sum! + element) ?? 0;

      totalAmount = total.toString();
    } catch(e) {}
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(14).r,
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
          width: 1.h,
        ),
      ),
      padding: EdgeInsets.all(10.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    AttendanceCommonWidgets().cachedNetworkImage(
                        employeePiece.employeeImage ?? '--',
                      height: 30.h,
                    ),
                    SizedBox(width: 6.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  employeePiece.employeeName ?? '--',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.h,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 4.h),
                              if(employeePiece.employeeCode != null)
                                ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 60.h,
                                ),
                                child: Text(
                                  "#${employeePiece.employeeCode}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.h,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            employeePiece.employeeDesignation ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 10.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.h),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Amount',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 10.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.steelBlue,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 80.h,
                            ),
                            child: Text(
                              totalAmount,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 10.h,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 15.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(6).r,
                    onTap: () {
                      Navigator.of(context).push(
                        newSlideFromBottomNavigation(CreatePieceWork(employeePiece: employeePiece)),
                      );
                    },
                    child: Container(
                      width: 28.h,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.secondaryBlue,
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      child: Icon(Icons.add, color: ColorUtils.textWhite),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if(employeePiece.paymetArr?.isNotEmpty ?? false)
            SizedBox(height: 3.h),
          for(int index = 0; index < (employeePiece.paymetArr?.length ?? 0); index++)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: ColorUtils.workEntryHead.withValues(alpha: 0.1), thickness: 1.h, height: 20.h),
                PieceWidget(paymetArr: employeePiece.paymetArr![index], employeeId: employeePiece.employeeId),
              ],
            ),
        ],
      ),
    );
  }
}
