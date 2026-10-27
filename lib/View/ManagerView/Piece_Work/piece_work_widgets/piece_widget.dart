
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_controller/piece_work_controller.dart';
import 'package:loyaltri_minimal/models/manager/piece_work_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../../controller/userProfileController.dart';

class PieceWidget extends StatelessWidget {
  final PaymetArr paymetArr;
  final String? employeeId;
  const PieceWidget({super.key, required this.paymetArr, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 55.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymetArr.code ?? '--',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 10.h,
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    paymetArr.unitName ?? '--',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.h,
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.h,
              ),
              child: Container(
                color: ColorUtils.softGrey,
                width: 1.h,
                height: 18.h,
              ),
            ),
            SizedBox(
              width: 55.h,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          paymetArr.type ?? '--',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.h,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          paymetArr.subType ?? '--',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.h,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.h,
              ),
              child: Container(
                color: ColorUtils.softGrey,
                width: 1.h,
                height: 18.h,
              ),
            ),
            SizedBox(
              width: 55.h,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-',
                        style: GoogleFonts.inder(
                          fontWeight: FontWeight.w500,
                          fontSize: 11.h,
                          color: ColorUtils.workEntryHead,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          paymetArr.ratePerUnit ?? '--',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.h,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: paymetArr.unit ?? '--',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.h,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                        TextSpan(
                          text: ' units',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.h,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Text(
                  //       '55555',
                  //       overflow: TextOverflow.ellipsis,
                  //       style: GoogleFonts.poppins(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 10.h,
                  //         color: ColorUtils.workEntryHead,
                  //       ),
                  //     ),
                  //     Text(
                  //       ' units',
                  //       overflow: TextOverflow.ellipsis,
                  //       style: GoogleFonts.poppins(
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 10.h,
                  //         color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.h,
              ),
              child: Container(
                color: ColorUtils.softGrey,
                width: 1.h,
                height: 18.h,
              ),
            ),
          ],
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-',
                style: GoogleFonts.inder(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.h,
                  color: ColorUtils.steelBlue,
                ),
              ),
              Flexible(
                child: Text(
                  paymetArr.totalAmount ?? '--',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.h,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
              ),
              SizedBox(width: 15.h),
              InkWell(
                borderRadius: BorderRadius.circular(4).r,
                onTap: () async {
                  await Get.find<PieceWorkController>().deletePieceRate(paymetArr.pieceWorkEmpMappingId, employeeId);
                },
                child: Container(
                  width: 28.h,
                  height: 28.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4).r,
                    color: ColorUtils.blushPink,
                  ),
                  child: GetX<PieceWorkController>(
                    builder: (PieceWorkController controller) {
                      return Center(
                        child: (controller.pieceDeletingId.value == paymetArr.pieceWorkEmpMappingId)
                            ? SizedBox(
                          width: 8.h,
                          height: 8.h,
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2.h),
                          ),
                        )
                            : SvgPicture.asset(
                          'assets/images/manager_view/delete_piece.svg',
                          height: 16.h,
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

