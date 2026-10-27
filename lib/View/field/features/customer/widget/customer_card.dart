import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/customer/customer_details_screen.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/work_log_screen.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.context, required this.item});

  final BuildContext context; 
  final CustomerData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(color: ColourUtils.borderColour, width: 1.h),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomerDetailsScreen(customerId: item.id.toString()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14.h),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  svgWidget(height: 20.h, width: 20.h, icon: 'store'),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      // "Sharma Electronics sai jdaisjdosaj djaisjdoijidjo",
                      item.name ?? "",
                      style: GoogleFonts.inter(
                        color: ColourUtils.textWhite,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  svgWidget(height: 20.h, width: 20.h, icon: 'gps'),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      // "Connaught Place, New Delhi asdiasoidjodjsaiodjiso",
                      item.locationName ?? "",
                      style: GoogleFonts.inter(
                        color: ColourUtils.textWhite,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  svgWidget(height: 20.h, width: 20.h, icon: 'phone'),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      // "+91 91234 56789 sjdiasjdij aoisdjo",
                      item.phone ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: ColourUtils.fontColour1,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.h),

                  RoundFillButton(
                    icon: 'navigation_fill',
                    function: () {
                      openGoogleMaps(
                        latitude: item.location?.lat ?? 0.0,
                        longitude: item.location?.lng ?? 0.0,context: context
                      );
                    },
                  ),
                  SizedBox(width: 10.h),
                  RoundFillButton(
                    icon: 'phone_fill',
                    function: () {
                      makePhoneCall(item.phone);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}