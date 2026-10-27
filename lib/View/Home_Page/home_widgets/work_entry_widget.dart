import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/work_entry_list_api_model.dart';
import '../../../utils/color_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class WorkEntryWidget extends StatelessWidget {
  final WorkEntryDetail workEntryDetail;
  const WorkEntryWidget({super.key, required this.workEntryDetail});

  @override
  Widget build(BuildContext context) {
    String? dateTime;
    try {
      dateTime = timeago.format(DateTime.parse(workEntryDetail.dateTime!.toString()));
    } catch(e) {}
    return Padding(
      padding: const EdgeInsets.all(10).w,
      child: Container(
        width: 279.w,
        height: 170.h,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.1.w,
            color: ColorUtils.textWhite,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)).w,
        ),
        child: Column(
          children: [
            Container(
              width: 279.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorUtils.workEntryHead,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ).w,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20).w,
                child: Row(
                  children: [
                    // const Spacer(),
                    Image.asset(
                      "assets/images/calendargreen3d.webp",
                      width: 25.w,
                    ),
                    const SizedBox(width: 5),
                    // const Spacer(),
                    Text(
                      dateTime ?? '--',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                    // const Spacer(flex: 15),
                    // SvgPicture.asset(
                    //   "assets/images/attach_icon.svg",
                    //   width: 18.w,
                    //   height: 18.w,
                    // ),
                    // const Spacer(),
                    // Container(
                    //   width: 20.w,
                    //   height: 20.w,
                    //   decoration: BoxDecoration(
                    //     color: ColorUtils.textWhite.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(50),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "3",
                    //       style: GoogleFonts.poppins(
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 10.sp,
                    //         color: ColorUtils.textWhite,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const Spacer(),
                  ],
                ),
              ),
            ),
            Container(
              width: 279.w,
              height: 110.h,
              decoration: BoxDecoration(
                color: ColorUtils.workEntryHead.withOpacity(0.01),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ).w,
              ),
              child: Padding(
                padding:
                const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Container()),
                    Row(
                      children: [
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Work Name",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                workEntryDetail.workName ?? "",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: ColorUtils.textWhite,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 5),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unite Done",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                "${workEntryDetail.unitCount} units",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: ColorUtils.textWhite,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     const Spacer(),
                    //     SizedBox(
                    //       width: 70.w,
                    //       child: Text(
                    //         workEntryDetail.workName ?? "",
                    //         style: GoogleFonts.poppins(
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 14.sp,
                    //           color: ColorUtils.textWhite,
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //     const Spacer(flex: 8),
                    //     SizedBox(
                    //       width: 70.w,
                    //       child: Text(
                    //         "${workEntryDetail.unitCount} units",
                    //         style: GoogleFonts.poppins(
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 14.sp,
                    //           color: ColorUtils.textWhite,
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //     const Spacer(),
                    //   ],
                    // ),
                    Flexible(flex: 5, child: Container()),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          "Description",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite.withOpacity(0.5),
                          ),
                        ),
                        const Spacer(flex: 13),
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 210.w,
                          child: Text(
                            workEntryDetail.description ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: ColorUtils.textWhite,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                    Flexible(child: Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
