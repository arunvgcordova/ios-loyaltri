import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/customer_form/add_customer_screen.dart';
import 'package:loyaltri_minimal/View/field/features/add_work_log/add_work_screen.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';

class AddWorkCustomreDialog extends StatefulWidget {
  const AddWorkCustomreDialog({super.key});

  @override
  State<AddWorkCustomreDialog> createState() => _AddWorkCustomreDialogState();
}

class _AddWorkCustomreDialogState extends State<AddWorkCustomreDialog> {
  @override
  Widget build(BuildContext context) {
    final trackingCtrl = Get.isRegistered<TrackingController>()
        ? Get.find<TrackingController>()
        : null;
    final empId = Get.find<UserAuthController>().userData.value.userData?.employeeId;
    final settings = trackingCtrl?.companySettings.value;
    final canCreateWork = settings?.canStaffCreateWork(empId) ?? true;
    final canCreateCustomer = settings?.canStaffCreateCustomer(empId) ?? true;

    final List<Widget> actionContainers = [];
    if (canCreateWork) {
      actionContainers.add(
        _buildContainer(
          label: 'Add Work',
          icon: 'bag',
          color: ColourUtils.bgColour1,
          function: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddWorkScreen()),
            );
          },
        ),
      );
    }

    if (canCreateWork && canCreateCustomer) {
      actionContainers.add(SizedBox(width: 10.w));
    }

    if (canCreateCustomer) {
      actionContainers.add(
        _buildContainer(
          label: 'Add Customer',
          icon: 'user',
          color: ColourUtils.bgColour15,
          function: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddCustomerScreen(),
              ),
            );
          },
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ColourUtils.bgColour14,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.h),
          topRight: Radius.circular(30.h),
        ),
      ),
      height: 200.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Request',
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close_rounded, size: 20.h, color: ColourUtils.textWhite),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            if (actionContainers.isNotEmpty)
              Row(
                children: actionContainers,
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'No creation permissions available.',
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite.withValues(alpha: 0.6),
                    fontSize: 14.h,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Expanded _buildContainer({
    required String label,
    required String icon,
    Color? color,
    Function()? function,
  }) {
    return Expanded(
      child: InkWell(
        onTap: function,
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: ColourUtils.textSecondary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: color?.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: Center(
                  child: svgWidget(
                    height: 20.h,
                    width: 20.h,
                    icon: icon,
                    color: color,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: ColourUtils.textWhite,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
// import 'package:loyaltri_minimal/View/field/core/utils.dart';
// import 'package:loyaltri_minimal/View/field/features/customer_form/add_customer_screen.dart';
// import 'package:loyaltri_minimal/View/field/features/add_work_log/add_work_screen.dart';

// class AddWorkCustomreDialog extends StatefulWidget {
//   const AddWorkCustomreDialog({super.key});

//   @override
//   State<AddWorkCustomreDialog> createState() => _AddWorkCustomreDialogState();
// }

// class _AddWorkCustomreDialogState extends State<AddWorkCustomreDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColourUtils.bgColour14,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30.h),
//           topRight: Radius.circular(30.h),
//         ),
//       ),
//       height: 200.h,
//       width: double.infinity,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.h),
//         child: Column(
//           children: [
//             SizedBox(height: 20.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'New Request',
//                   style: GoogleFonts.inter(
//                     color: ColourUtils.textWhite,
//                     fontSize: 16.h,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(Icons.close_rounded, size: 20.h,color: ColourUtils.textWhite,),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 _buildContainer(
//                   label: 'Add Work',
//                   icon: 'bag',
//                   color: ColourUtils.bgColour1,
//                   function: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => AddWorkScreen()),
//                     );
//                   },
//                 ),
//                 SizedBox(width: 10.w),
//                 _buildContainer(
//                   label: 'Add Customer',
//                   icon: 'user',
//                   color: ColourUtils.bgColour15,
//                   function: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddCustomerScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Expanded _buildContainer({
//     required String label,
//     required String icon,
//     Color? color,
//     Function()? function,
//   }) {
//     return Expanded(
//       child: InkWell(
//         onTap: function,
//         child: Container(
//           height: 100.h,
//           decoration: BoxDecoration(
//             color: ColourUtils.textSecondary.withValues(alpha: 0.05),
//             borderRadius: BorderRadius.circular(12.h),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 40.h,
//                 width: 40.h,
//                 decoration: BoxDecoration(
//                   color: color?.withValues(alpha: 0.2),
//                   borderRadius: BorderRadius.circular(12.h),
//                 ),
//                 child: Center(
//                   child: svgWidget(
//                     height: 20.h,
//                     width: 20.h,
//                     icon: icon,
//                     color: color,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 label,
//                 style: GoogleFonts.inter(
//                   color: ColourUtils.textWhite,
//                   fontSize: 14.h,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
