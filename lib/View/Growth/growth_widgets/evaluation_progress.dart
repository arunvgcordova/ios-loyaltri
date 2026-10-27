import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../../../utils/color_utils.dart';

class EvaluationProgress extends StatefulWidget {
  const EvaluationProgress({super.key});

  @override
  State<EvaluationProgress> createState() => _EvaluationProgressState();
}

class _EvaluationProgressState extends State<EvaluationProgress> {
  final GlobalKey _stackKey = GlobalKey();
  List<ProgressData> progressList = [
    for (int i = 0; i < 8; i++)
      ProgressData(
        title: 'Revenue & Market Growth',
        subTitle: 'Sales Target Achievement',
        score: 80,
        isCurrent: i == 2,
        isCompleted: i > 2,
        key: GlobalKey(),
      ),
  ];

  ValueNotifier<LinePoints> linePoints = ValueNotifier(LinePoints());

  void drawLine(BuildContext context, ProgressData current) {
    try {
      final stackBox =
          _stackKey.currentContext?.findRenderObject() as RenderBox?;
      final firstBox =
          progressList.first.key.currentContext?.findRenderObject()
              as RenderBox?;
      final lastBox =
          current.key.currentContext?.findRenderObject() as RenderBox?;

      if (stackBox == null || firstBox == null || lastBox == null) return;

      final p1Global = firstBox.localToGlobal(
        firstBox.size.center(Offset.zero),
      );
      final p2Global = lastBox.localToGlobal(lastBox.size.center(Offset.zero));

      final p1 = stackBox.globalToLocal(p1Global);
      final p2 = stackBox.globalToLocal(p2Global);

      final dx = p2.dx - p1.dx;
      final dy = p2.dy - p1.dy;

      for (int i = 0; i < progressList.length; i++) {
        final box =
            progressList[i].key.currentContext?.findRenderObject()
                as RenderBox?;
        if (box == null) return;

        final pGlobal = box.localToGlobal(box.size.center(Offset.zero));
        final p = box.globalToLocal(pGlobal);

        progressList[i].dx = p.dx;
        progressList[i].dy = p.dy;
        progressList[i].angle = math.atan2(dy, dx);
      }

      linePoints.value = LinePoints(
        dx: p1.dx,
        dy: p1.dy,
        length: math.sqrt(dx * dx + dy * dy),
        angle: math.atan2(dy, dx),
      );
    } catch (_) {}
  }

  void _drawCurrentLine() {
    final current = progressList
        .where((e) => e.isCurrent)
        .cast<ProgressData?>()
        .firstOrNull;
    if (current == null) return;
    drawLine(context, current);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawCurrentLine();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = progressList.indexWhere((e) => e.isCurrent);
    return SizedBox(
      height: 350.h,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Stack(
              key: _stackKey,
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for(int index = 0; index < progressList.length; index++)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(key: progressList[index].key, width: 20.h, height: 20.h),

                              SizedBox(width: 10.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      progressList[index].title,
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Text(
                                      progressList[index].subTitle,
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Text(
                                progressList[index].score.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 17.h,
                                  fontWeight: FontWeight.w500,
                                  color:Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: linePoints,
                  builder: (context, value, child) {
                    if (value.dx == null ||
                        value.dy == null ||
                        value.angle == null ||
                        value.length == null) {
                      return SizedBox.shrink();
                    }
                    return Positioned(
                      left: (value.dx ?? 0) + 9.5.h,
                      top: (value.dy ?? 0) - 12.h,
                      child: Transform.rotate(
                        angle: value.angle ?? 0,
                        alignment: Alignment.topLeft,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: (value.length ?? 0) + 30.h,
                          ),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          builder: (context, width, _) {
                            return Container(
                              width: width,
                              height: 20.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(500).r,
                                gradient: LinearGradient(
                                  colors: [
                                    ColorUtils.softPeriwinkle,
                                    ColorUtils.workEntryHead,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for(int index = 0; index < progressList.length; index++)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: SizedBox(
                                  width: 20.h,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        progressList[index].isCompleted
                                            ? 'assets/images/growth/future-progress-dot.png'
                                            : progressList[index].isCurrent
                                            ? 'assets/images/growth/current-progress-dot.png'
                                            : 'assets/images/growth/prev-progress-dot.png',
                                        height: 12.h,
                                      ),

                                      if (index != progressList.length - 1)
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.h,
                                            ),
                                            child: Container(
                                              width: 2.h,
                                              decoration: BoxDecoration(
                                                color: index < currentIndex
                                                    ? ColorUtils.lightPeriwinkle
                                                    : ColorUtils.softSilver,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      progressList[index].title,
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w600,
                                        color: ColorUtils.textWhite.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      progressList[index].subTitle,
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w600,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Text(
                                progressList[index].score.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 17.h,
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressData {
  final String title;
  final String subTitle;
  final int score;
  double? dx;
  double? dy;
  double? angle;
  final bool isCurrent;
  final bool isCompleted;
  final GlobalKey key;
  ProgressData({
    required this.title,
    required this.subTitle,
    required this.score,
    this.dx,
    this.dy,
    this.angle,
    required this.isCurrent,
    required this.isCompleted,
    required this.key,
  });
}

class LinePoints {
  double? dx;
  double? dy;
  double? length;
  double? angle;
  LinePoints({this.dx, this.dy, this.length, this.angle});
}