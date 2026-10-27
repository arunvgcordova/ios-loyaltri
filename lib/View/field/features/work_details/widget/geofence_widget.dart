import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/controller/work_details_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/widget/geofence_override_request_dialog.dart';

class GeofenceWidget extends GetView<WorkDetailController> {
  const GeofenceWidget({
    super.key,
    // this.otpData,
    required this.workInstanceId,
    required this.workId,
    required this.status,
    this.isGeofenceRequired,
  });

  // final OtpData? otpData;
  final int workInstanceId;
  final int workId;
  final String? status;
  final bool? isGeofenceRequired;

  @override
  Widget build(BuildContext context) {
    if (status == 'pending') {
      return containerWidget(
        context: context,
        color: ColourUtils.delayed,
        title: 'Pending approval',
        subTitle: 'Override geofence request sent. Waiting for admin approval.',
        icon: 'shield',
      );
    } else if (status == 'approved') {
      return containerWidget(
        context: context,
        color: ColourUtils.bgColour20,
        title: 'Override Approved',
        subTitle: 'Override geofence approved by admin.',
        icon: 'round_check',
      );
    } else if (status == 'rejected') {
      return containerWidget(
        context: context,
        color: ColourUtils.bgColour21,
        title: 'Override Rejected',
        subTitle: 'Your request for override geofence was not approved.',
        icon: 'circle_close',
      );
    } else if(isGeofenceRequired ?? false) {
      String radiusDisplay = '500 mtr';
      if (Get.isRegistered<TrackingController>()) {
        final settings = Get.find<TrackingController>().companySettings.value;
        if (settings != null) {
          radiusDisplay = settings.geofencingRadiusDisplay;
        }
      }
      return containerWidget(
        context: context,
        color: ColourUtils.delayed,
        title: 'Geofence required',
        subTitle: 'You must be within $radiusDisplay.',
        icon: 'shield',
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Container containerWidget({
    required BuildContext context,
    required Color color,
    required String title,
    required String subTitle,
    required String icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColourUtils.delayedBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.w),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
            width: 20.h,
            child: SvgPicture.asset(AssetUtils.svg(icon)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Geofence required',
                  title,
                  style: GoogleFonts.inter(
                    color: color,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  // 'Pending admin approval.',
                  subTitle,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 14.h,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          status == null
              ? InkWell(
                  onTap: () async {
                    bool result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return GeofenceOverrideRequestDialog(
                          workid: workId,
                          workInstanceId: workInstanceId,
                        );
                      },
                    );
                    print("sdhashoiudsiu = $result");
                    if (result == true) {
                      controller.fetchWorkLogDetail(id: workId.toString());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColourUtils.textWhite.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      child: Text(
                        'Override',
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite,
                          fontSize: 14.h,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}


// Widget _buildGeofenceWarningCard() {
    
//   }