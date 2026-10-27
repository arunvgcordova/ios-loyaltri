import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? icon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isSuffix;
  final ValueChanged<String>? onChanged;
  final Widget? labelTrailing;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isSuffix = false,
    this.onChanged,
    this.labelTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour2,
        borderRadius: BorderRadius.all(Radius.circular(15.h)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (labelTrailing != null) labelTrailing!,
              ],
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: controller,
              maxLines: maxLines,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              keyboardType: keyboardType,
              validator: validator,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.inter(
                color: ColourUtils.textMain,
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(
                  color: ColourUtils.textWhite.withValues(alpha: 0.4),
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: isSuffix
                    ? null
                    : icon != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          svgWidget(
                            height: 20.h,
                            width: 20.h,
                            icon: icon ?? '',
                            color: ColourUtils.textWhite.withValues(alpha: 0.4),
                          ),
                        ],
                      )
                    : null,
                suffix: isSuffix
                    ? icon != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                svgWidget(
                                  height: 20.h,
                                  width: 20.h,
                                  icon: icon ?? '',
                                  color: ColourUtils.textWhite.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ],
                            )
                          : null
                    : null,
                // prefixIcon: isSuffix
                //     ? null
                //     : icon != null
                //     ? Icon(icon, color: ColourUtils.textMuted, size: 20.h)
                //     : null,
                // suffix: isSuffix
                //     ? icon != null
                //           ? Icon(icon, color: ColourUtils.textMuted, size: 20.h)
                //           : null
                //     : null,
                // isDense: true,
                filled: true,
                fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: maxLines > 1 ? 12.h : 14.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: BorderSide(
                    color: ColourUtils.textWhite.withValues(alpha: 0.1),
                    width: 1.h,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: BorderSide(
                    color: ColourUtils.primary,
                    width: 1.h,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: BorderSide(
                    color: ColourUtils.overdue,
                    width: 1.h,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: BorderSide(
                    color: ColourUtils.overdue,
                    width: 1.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loyaltrifieldui/core/colour_utils.dart';

// class TextFieldWidgetFrom extends StatelessWidget {
//   TextFieldWidgetFrom({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.icon,
//     this.onTap,
//     this.validator,
//   });

//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final IconData? icon;
//   final int maxLines = 1;
//   final bool readOnly = false;
//   final VoidCallback? onTap;
//   final TextInputType keyboardType = TextInputType.text;
//   final String? Function(String?)? validator;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColourUtils.bgColour2,
//         borderRadius: BorderRadius.all(Radius.circular(15.h)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textWhite,
//                 fontSize: 13.h,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             TextFormField(
//               controller: controller,
//               maxLines: maxLines,
//               readOnly: readOnly,
//               onTap: onTap,
//               keyboardType: keyboardType,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textMain,
//                 fontSize: 14.h,
//               ),
//               validator: validator,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: GoogleFonts.inter(
//                   color: ColourUtils.textMuted,
//                   fontSize: 13.h,
//                 ),
//                 prefixIcon: icon == null
//                     ? null
//                     : Icon(icon, color: ColourUtils.textMuted, size: 20.h),
//                 filled: true,
//                 fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: maxLines > 1 ? 12.h : 14.h,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.h),
//                   borderSide: BorderSide(
//                     color: ColourUtils.textWhite.withValues(alpha: 0.1),
//                     width: 1.h,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                   borderSide: const BorderSide(
//                     color: ColourUtils.primary,
//                     width: 1.5,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                   borderSide: const BorderSide(
//                     color: ColourUtils.overdue,
//                     width: 1.5,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                   borderSide: const BorderSide(
//                     color: ColourUtils.overdue,
//                     width: 1.5,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//     ;
//   }
// }
