import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';
import '../../CWidgets/app_bar.dart';
import 'Address_Information.dart';
import 'Basic_Information.dart';
import 'Contact_Information.dart';
class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
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
                title: "Personal Info",
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
                          "Basic Information",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 15).w,
                        child: BasicInformation(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10).w,
                        child: Text(
                          "Address Information",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10).w,
                        child: AddressInformation(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 15).w,
                        child: Text(
                          "Contact Information",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10).w,
                        child: ContactInformation(),
                      ),
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
