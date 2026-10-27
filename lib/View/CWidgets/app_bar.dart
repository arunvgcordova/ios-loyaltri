import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color_utils.dart';

class CustomAppBar extends StatelessWidget {
  final String? image;
  final String title;
  final bool isActionVisible;
  const CustomAppBar({super.key, this.image, required this.title, required this.isActionVisible});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).h,
      child: Row(
        children: [
          if (isActionVisible)
            ClipRRect(
              borderRadius: BorderRadius.circular(14).r,
              child: Material(
                color: ColorUtils.foregroundBlack,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 48.h,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.backgroundBlack,
                      borderRadius: BorderRadius.circular(14).r,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5).h,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ColorUtils.textWhite,
                          size: 15.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (image != null)
            const Spacer(flex: 5),
          if (image == null)
            const Spacer(flex: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image != null)
                Image.asset(
                  image!,
                  height: 25.h,
                ),
              if (image != null)
                SizedBox(width: 10.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.h,
                ),
              ),
            ],
          ),
          const Spacer(flex: 10),
        ],
      ),
    );
  }
}
