import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'dart:ui' as ui;

class DetailRow extends StatefulWidget {
  final String label;
  final String value;
  final bool isLongText;

  const DetailRow({
    required this.label,
    required this.value,
    this.isLongText = false,
  });

  @override
  State<DetailRow> createState() => _DetailRowState();
}

class _DetailRowState extends State<DetailRow> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = GoogleFonts.inter(
          color: ColourUtils.textMain,
          fontSize: 14.h,
          fontWeight: FontWeight.w400,
        );

        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final double textWidth = maxWidth - 32.w - 20.h - 14.w;

        final textPainter = TextPainter(
          text: TextSpan(text: widget.value, style: textStyle),
          maxLines: 2,
          textDirection: ui.TextDirection.ltr,
        );

        textPainter.layout(maxWidth: textWidth > 0 ? textWidth : 0);
        final bool isOverflowing = textPainter.didExceedMaxLines;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
                width: 20.h,
                child: SvgPicture.asset(AssetUtils.svg('menu')),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        color: ColourUtils.textMuted,
                        fontSize: 12.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      widget.value,
                      maxLines: _isExpanded ? null : 2,
                      overflow: _isExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                    if (isOverflowing) ...[
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'View less' : 'View more',
                          style: GoogleFonts.inter(
                            color: ColourUtils.fontColour1,
                            fontSize: 14.h,
                            decoration: TextDecoration.underline,
                            decorationColor: ColourUtils.fontColour1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}