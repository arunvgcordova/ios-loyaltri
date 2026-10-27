import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_events_hint.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/loyaltri_calender.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/work_entry_widget.dart';
import 'package:loyaltri_minimal/controller/WorkEntryListController.dart';
import 'package:loyaltri_minimal/models/work_entry_list_api_model.dart';
import '../../../utils/color_utils.dart';
import '../../Work_Entry/Work_Entry.dart';

class HomeWorkEntryView extends StatelessWidget {
  final List<WorkEntryDetail> workDetails;
  final Function()? callBack;
  const HomeWorkEntryView({super.key, required this.workDetails, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0).w,
      child: Container(
        height: 233.73.h,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          color: ColorUtils.backgroundBlack,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          ).w,
        ),
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(top: 14, left: 16, right: 26).w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Work Entry",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        newSlideNavigation(WorkEntry(isQuickActionEnable: false, callBack: callBack)),
                      );
                    },
                    child: Text(
                      "See more",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: ColorUtils.seeMore,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: 190.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workDetails.length > 2 ? 2 : 1,
                itemBuilder: (context, index) {
                  return WorkEntryWidget(workEntryDetail: workDetails[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
