import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class AppBarWithAddWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithAddWidget({
    super.key,
    required this.title,
    this.icon,
    this.onAddTap,
  });

  final String title;
  final String? icon;
  final VoidCallback? onAddTap;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: AppBar(
        backgroundColor: ColourUtils.background,
        elevation: 0,
        centerTitle: true,
        leading: Center(
          child: Container(
            margin: EdgeInsets.only(left: 10.w),
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: ColourUtils.bgColour17,
              borderRadius: BorderRadius.circular(15.h),
              border: Border.all(color: ColourUtils.borderColour1, width: 1.h),
            ),
            child: FittedBox(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: ColourUtils.textMain,
                  size: 20.h,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon == null
                ? SizedBox()
                : pngWidget(height: 30.h, width: 30.h, icon: icon ?? ""),
            // SizedBox(
            //     height: 20.h,
            //     width: 20.h,
            //     child: SvgPicture.asset(AssetUtils.svg(icon ?? "")),
            //   ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: GoogleFonts.inter(
                color: ColourUtils.textMain,
                fontWeight: FontWeight.w500,
                fontSize: 18.h,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            height: 50.h,
            width: 50.h,
            margin: EdgeInsets.only(right: 11.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.h),
              color: ColourUtils.bgColour18,
            ),
            child: FittedBox(
              child: IconButton(
                icon: Icon(Icons.add_rounded, color: ColourUtils.textWhite),
                onPressed: onAddTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.icon,
    this.onAddTap,
  });

  final String title;
  final String? icon;
  final VoidCallback? onAddTap;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: AppBar(
        centerTitle: true,
        backgroundColor: ColourUtils.background,
        elevation: 0,
        leading: Center(
          child: Container(
            margin: EdgeInsets.only(left: 10.w),
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: ColourUtils.bgColour17,
              borderRadius: BorderRadius.circular(15.h),
              border: Border.all(color: ColourUtils.borderColour1, width: 1.h),
            ),
            // decoration: BoxDecoration(
            //   color: ColourUtils.cardBackground,
            //   borderRadius: BorderRadius.circular(15.h),
            //   border: Border.all(color: ColourUtils.border, width: 1.w),
            // ),
            child: FittedBox(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColourUtils.textMain,
                  size: 20.h,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: ColourUtils.textMain,
            fontWeight: FontWeight.w600,
            fontSize: 18.h,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loyaltrifieldui/core/asset_utils.dart';
// import 'package:loyaltrifieldui/core/colour_utils.dart';

// class AppBarWithAddWidget extends StatelessWidget {
//   AppBarWithAddWidget(this.title, this.icon, {super.key});

//   final String title;
//   final String icon;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       // centerTitle: true,
//       backgroundColor: ColourUtils.background,
//       // automaticallyImplyLeading: true,
//       elevation: 0,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.inter(
//               color: ColourUtils.textMain,
//               fontWeight: FontWeight.w500,
//               fontSize: 19.h,
//             ),
//           ),
//           SizedBox(width: 12.w),

//           SizedBox(
//             height: 20.h,
//             width: 20.h,
//             child: SvgPicture.asset(AssetUtils.svg(icon)),
//           ),
//         ],
//       ),
//       actions: [
//         Container(
//           height: 32.h,
//           width: 32.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.h),
//             color: ColourUtils.primary,
//           ),
//           child: FittedBox(
//             child: IconButton(
//               icon: Icon(Icons.add, size: 24.sp),
//               onPressed: () {}, // Go to Add Work Screen
//             ),
//           ),
//         ),

//         SizedBox(width: 18.w),
//       ],
//     );
//   }
// }
