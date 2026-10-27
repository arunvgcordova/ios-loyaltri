import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/color_utils.dart';

class DocumentsView extends StatelessWidget {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(16).r,
          border: Border.all(
            color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/manager_view/documents_colorImg.png",
                        height: 22.h,
                      ),
                      SizedBox(width: 8.h),
                      Text(
                        'Documents',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View All',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: ColorUtils.workEntryHead,
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 3.h),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: ColorUtils.workEntryHead,
                        size: 9.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
              height: 0.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.h,
                right: 8.h,
                bottom: 12.h,
                top: 25.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9).r,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9).r,
                          color: ColorUtils.frostGrey,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.h),
                                  child: Image.asset(
                                    "assets/images/manager_view/expired_fg.png",
                                    height: 33.h,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/manager_view/expired_bg.png",
                                      height: 45.h,
                                    ),
                                    Positioned(
                                      bottom: -3,
                                      left: 13,
                                      child: Text(
                                        '3',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 27.h,
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 8.h,
                                    left: 8.h,
                                  ),
                                  child: Text(
                                    'Expired',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtils.fireRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9).r,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9).r,
                          color: ColorUtils.frostGrey,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.h),
                                  child: Image.asset(
                                    "assets/images/manager_view/expire_soon_fg.png",
                                    height: 32.h,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/manager_view/expire_soon_bg.png",
                                      height: 45.h,
                                    ),
                                    Positioned(
                                      bottom: -3,
                                      left: 5,
                                      child: Text(
                                        '5',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 27.h,
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 8.h,
                                    left: 8.h,
                                  ),
                                  child: Text(
                                    'Expiring Soon',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtils.tigerOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9).r,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9).r,
                          color: ColorUtils.frostGrey,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.h),
                                  child: Image.asset(
                                    "assets/images/manager_view/missing_fg.png",
                                    height: 33.h,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/manager_view/missing_bg.png",
                                      height: 45.h,
                                    ),
                                    Positioned(
                                      bottom: -3,
                                      left: 13,
                                      child: Text(
                                        '8',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 27.h,
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 8.h,
                                    left: 8.h,
                                  ),
                                  child: Text(
                                    'Missing',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtils.sapphireBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
