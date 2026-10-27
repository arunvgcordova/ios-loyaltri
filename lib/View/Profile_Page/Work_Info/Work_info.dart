import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Work_Info/Info1.dart';

import '../../../utils/color_utils.dart';
import '../../CWidgets/app_bar.dart';
import 'Info2.dart';
class WorkInfo extends StatelessWidget {
  const WorkInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 10,top: 8,right: 10).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                title: "Work Info",
                isActionVisible: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 50).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20).w,
                        child: Text(
                          "Work Information",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 15).w,
                        child: Info1(),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10).w,
                      //   child: const Info2(),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
