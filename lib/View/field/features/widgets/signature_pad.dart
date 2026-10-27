import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../core/colour_utils.dart';

class SignaturePad extends StatefulWidget {
  final ValueChanged<List<List<Offset>>>? onSignatureChanged;

  const SignaturePad({super.key, this.onSignatureChanged, required this.title});

  final String title;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool isSignatureDrawn = false;
  final List<List<Offset>> _strokes = [];

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
            Text(
              widget.title,
              style: GoogleFonts.inter(
                color: ColourUtils.textWhite,
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.h)),
                  child: SizedBox(
                    height: 150.h,

                    child: SfSignaturePad(
                      minimumStrokeWidth: 1,
                      maximumStrokeWidth: 3,
                      strokeColor: ColourUtils.textWhite.withValues(alpha: 0.1),
                      key: _signaturePadKey,
                      backgroundColor: ColourUtils.textWhite.withValues(
                        alpha: 0.1,
                      ),
                      onDraw: (offset, time) {
                        setState(() {
                          isSignatureDrawn = true;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    _signaturePadKey.currentState?.clear();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      svgWidget(
                        height: 15.h,
                        width: 15.h,
                        icon: 'trash',
                        color: ColourUtils.fontColour4,
                      ),
                      SizedBox(width: 10.h),
                      Text(
                        'Clear Signature',
                        style: GoogleFonts.inter(
                          color: ColourUtils.fontColour4,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
