import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class FillButtonWidget extends StatelessWidget {
  const FillButtonWidget({
    super.key,
    required this.label,
    this.icon,
    required this.function,
    this.isRound = true,
    this.isLoading = false,
  });

  final String label;
  final String? icon;
  final Function()? function;
  final bool? isRound;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: isLoading ? null : function,
        borderRadius: isRound == true
            ? BorderRadius.circular(100.h)
            : BorderRadius.circular(12.h),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: ColourUtils.bgColour1,
            borderRadius: isRound == true
                ? BorderRadius.circular(100.h)
                : BorderRadius.circular(12.h),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.h,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColourUtils.textWhite,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: svgWidget(
                            height: 20.h,
                            width: 20.h,
                            icon: icon!,
                          ),
                        ),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            color: ColourUtils.textWhite,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// class FillButtonWidget extends StatelessWidget {
//   const FillButtonWidget({
//     super.key,
//     required this.label,
//     this.icon,
//     required this.function,
//     this.isRound = true,
//   });

//   final String label;
//   final String? icon;
//   final Function()? function;
//   final bool? isRound;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: function,
//         child: Container(
//           height: 48.h,
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//           decoration: BoxDecoration(
//             color: ColourUtils.bgColour1,
//             borderRadius: isRound == true
//                 ? BorderRadius.circular(100.h)
//                 : BorderRadius.circular(12.h),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               icon == null
//                   ? SizedBox()
//                   : Padding(
//                       padding: EdgeInsets.only(right: 10.w),
//                       child: svgWidget(
//                         height: 20.h,
//                         width: 20.h,
//                         icon: icon ?? '',
//                       ),
//                     ),

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
