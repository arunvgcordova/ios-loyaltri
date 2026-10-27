import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/quarter_score.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart' as sy_theme;
import '../../../models/growth_home_model.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Leave_Page/leave_widgets/success_dialogue.dart';
import 'app_bar.dart';

class RatePerformanceScreen extends StatefulWidget {
  final CyclePoints point;
  const RatePerformanceScreen({super.key, required this.point});

  @override
  State<RatePerformanceScreen> createState() => _RatePerformanceScreenState();
}

class _RatePerformanceScreenState extends State<RatePerformanceScreen> {
  ValueNotifier<double> selectedValue = ValueNotifier(0);
  ValueNotifier<double> progressValue = ValueNotifier(0);
  GrowthController _growthController = Get.find<GrowthController>();
  int _lastValue = -1;
  int totalPoints = 0;
  int currentPoint = 0;

  @override
  void initState() {
    totalPoints = _growthController.selfReviewData.value?.points?.length ?? 0;
    currentPoint =
        _growthController.selfReviewData.value?.points?.indexWhere(
          (p) => p.cyclePointId == widget.point.cyclePointId,
        ) ??
        0;
    changeProgress();
    super.initState();
  }

  void changeProgress() => progressValue.value = currentPoint + 1 / totalPoints;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          _growthController.selfReviewData.value = null;
          _growthController.selectedTemplate.value = [];
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorUtils.workEntryHead,
            body: Column(
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0).h,
                  child: GrowthAppBar(title: "Rate Performance"),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 18.h,
                    ),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${currentPoint + 1}',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15.h,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / $totalPoints',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15.h,
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.point.kraName ?? '--',
                                  style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.h,
                                    color: ColorUtils.textWhite.withValues(
                                      alpha: 0.56,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.point.title ?? '--',
                                  style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 23.h,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 80.h),
                          ValueListenableBuilder(
                            valueListenable: selectedValue,
                            builder: (context, value, child) {
                              return Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SfSlider(
                                          min: 0.0,
                                          max: 100.0,
                                          value: value,
                                          interval: 10,
                                          showLabels: true,
                                          enableTooltip: true,
                                          onChanged: (dynamic value) {
                                            final int v = (value as double)
                                                .round();

                                            if (v % 10 == 0 && v != _lastValue) {
                                              HapticFeedback.lightImpact();
                                              _lastValue = v;
                                            }
                                            selectedValue.value = double.parse(
                                              value.toString(),
                                            );
                                            _growthController
                                                .selfReviewData
                                                .value
                                                ?.points?[currentPoint]
                                                .score = selectedValue.value
                                                .toInt();
                                          },
                                          showDividers: true,
                                          dividerShape: CustomDividerShape(),
                                          trackShape: CustomTrackShape(),
                                          thumbShape: TransparentThumbShape(),
                                          tooltipShape: CustomTooltipShape(),
                                          tooltipTextFormatterCallback:
                                              (
                                                dynamic actualValue,
                                                String formattedText,
                                              ) {
                                                return actualValue
                                                    .toInt()
                                                    .toString();
                                              },
                                          shouldAlwaysShowTooltip: true,
                                          thumbIcon: Image.asset(
                                            'assets/images/growth/performance-thumb-icon.png',
                                            height: 39.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.h),
                                      Container(
                                        width: 42.h,
                                        height: 34.h,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            3.r,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 4.h,
                                    child: Container(
                                      width: 42.h,
                                      height: 34.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.graphite,
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          value.toStringAsFixed(0),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.h,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 80.h),
                          Row(
                            children: [
                              SizedBox(width: 5.h),
                              Text(
                                'Comment',
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            onChanged: (value) {
                              _growthController
                                  .selfReviewData
                                  .value
                                  ?.points?[currentPoint]
                                  .comments = [
                                Comments(comment: value),
                              ];
                            },
                            style: GoogleFonts.urbanist(
                              color: ColorUtils.textWhite,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.h,
                              letterSpacing: -0.1,
                            ),
                            decoration: InputDecoration(
                              hintText: "Type your comment here..",
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 15.h,
                              ),
                              fillColor: ColorUtils.darkIndigoGrey,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              hintStyle: GoogleFonts.urbanist(
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.5,
                                ),
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                                letterSpacing: -0.1,
                              ),
                            ),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: progressValue,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      color: ColorUtils.secondaryBlue,
                      backgroundColor: ColorUtils.textWhite.withValues(
                        alpha: 0.2,
                      ),
                      minHeight: 7.h,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(15.h),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(37).r,
                    onTap: !_growthController.performanceSubmitting.value
                        ? () async {
                            if (_growthController
                                    .selfReviewData
                                    .value
                                    ?.points?[currentPoint]
                                    .score !=
                                null && _growthController
                                    .selfReviewData
                                    .value
                                    ?.points?[currentPoint]
                                    .score !=
                                0) {
                              final point = _growthController.findNextPoint(
                                currentPoint + 1,
                              );
                              if (point != null) {
                                Navigator.of(context).pushReplacement(
                                  newSlideNavigation(
                                    RatePerformanceScreen(point: point),
                                  ),
                                );
                              } else {
                                changeProgress();
                                final result = await _growthController.submitSelfReview();
                                if(result?.status == 200) {
                                  _growthController.selfReviewData.value = null;
                                  _growthController.selectedTemplate.value = [];
                                  await ShowSuccessDialog().showSuccess(
                                      context: context,
                                      title: 'Message',
                                      subTitle: result?.message ?? 'Successfully added evaluation',
                                  );
                                } else {
                                  _growthController.selfReviewData.value = null;
                                  _growthController.selectedTemplate.value = [];
                                  await ErrorDialog().showWarn(
                                    context: context,
                                    title: "Message",
                                    subTitle: result?.message ?? "Something went wrong",
                                  );
                                }
                                Navigator.of(context).pop();
                              }
                            } else {
                              ErrorDialog().showWarn(
                                context: context,
                                title: "Message",
                                subTitle: "Score should not be zero",
                              );
                            }
                          }
                        : null,
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.secondaryBlue,
                        borderRadius: BorderRadius.circular(37).r,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GetX<GrowthController>(
                              builder: (GrowthController controller) {
                                if (controller.performanceSubmitting.value) {
                                  return SizedBox(
                                    width: 20.h,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: ColorUtils.textWhite,
                                    ),
                                  );
                                }
                                return Text(
                                  totalPoints == currentPoint + 1
                                      ? 'Submit'
                                      : 'Next',
                                  style: GoogleFonts.inter(
                                    color: ColorUtils.textWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.h,
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 3.h),
                            if (totalPoints != currentPoint + 1)
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorUtils.textWhite,
                                size: 15.h,
                              ),
                          ],
                        ),
                      ),
                    ),
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

class CustomDividerShape extends SfDividerShape {
  @override
  void paint(
    PaintingContext context,
    Offset center,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    dynamic currentValue,
    SfRangeValues? currentValues,
    required Animation<double> enableAnimation,
    required Paint? paint,
    required RenderBox parentBox,
    required TextDirection textDirection,
    required sy_theme.SfSliderThemeData themeData,
  }) {
    final canvas = context.canvas;

    final dividerPaint = Paint()
      ..color = ColorUtils.textWhite.withValues(alpha: 0.05)
      ..strokeWidth = 1.05;

    final double dividerHeight = 25.h;

    canvas.drawLine(
      Offset(center.dx, center.dy - dividerHeight / 2.h),
      Offset(center.dx, center.dy + dividerHeight / 2.h),
      dividerPaint,
    );
  }
}

class CustomTrackShape extends SfTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required sy_theme.SfSliderThemeData themeData,
    required Animation<double> enableAnimation,
    required Paint? inactivePaint,
    required Paint? activePaint,
    required TextDirection textDirection,
    dynamic currentValue,
    SfRangeValues? currentValues,
  }) {
    final Canvas canvas = context.canvas;

    final double trackHeight = 19.h;
    final double trackLeft = offset.dx;
    final double trackWidth = parentBox.size.width;
    final double trackTop = offset.dy - trackHeight / 2.h;

    /// Inactive track
    final RRect inactiveRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight),
      Radius.circular(6.r),
    );

    canvas.drawRRect(inactiveRRect, Paint()..color = Colors.grey.shade800);

    /// ✅ Active track (use thumbCenter)
    if (thumbCenter != null) {
      final double activeWidth = thumbCenter.dx - trackLeft;

      if (activeWidth > 0) {
        final RRect activeRRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(trackLeft, trackTop, activeWidth, trackHeight),
          Radius.circular(6.r),
        );

        canvas.drawRRect(
          activeRRect,
          Paint()..color = ColorUtils.secondaryBlue,
          // ..shader = const LinearGradient(
          //   colors: [
          //     Color(0xFF6C4DF6),
          //     Color(0xFF9A7DFF),
          //   ],
          // ).createShader(activeRRect.outerRect),
        );
      }
    }
  }
}

class TransparentThumbShape extends SfThumbShape {
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox? child,
    dynamic currentValue,
    SfRangeValues? currentValues,
    required Animation<double> enableAnimation,
    required Paint? paint,
    required RenderBox parentBox,
    required TextDirection textDirection,
    required sy_theme.SfSliderThemeData themeData,
    required SfThumb? thumb,
  }) {
    if (child != null) {
      final double scale = 4.h;

      context.canvas.save();
      context.canvas.translate(center.dx, center.dy);
      context.canvas.scale(scale);
      context.canvas.translate(
        -child.size.width / 2.h,
        -child.size.height / 2.h,
      );
      context.paintChild(child, Offset.zero);
      context.canvas.restore();
    }
  }
}

class CustomTooltipShape extends SfPaddleTooltipShape {
  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter,
    Offset offset,
    TextPainter textPainter, {
    required Animation<double> animation,
    required Paint paint,
    required RenderBox parentBox,
    required sy_theme.SfSliderThemeData sliderThemeData,
    required Rect trackRect,
  }) {
    final Canvas canvas = context.canvas;

    final double width = 42.h;
    final double height = 21.h;

    final double verticalOffset = 45.h;
    final Offset tooltipCenter = thumbCenter - Offset(-1.5.h, verticalOffset);

    final RRect tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: tooltipCenter, width: width, height: height),
      Radius.circular(4.r),
    );

    final Paint bgPaint = Paint()..color = ColorUtils.secondaryBlue;
    canvas.drawRRect(tooltipRect, bgPaint);

    textPainter.paint(
      canvas,
      Offset(
        tooltipCenter.dx - textPainter.width / 2.h,
        tooltipCenter.dy - textPainter.height / 2.h,
      ),
    );

    final Path arrowPath = Path();
    arrowPath.moveTo(tooltipCenter.dx - 6.h, tooltipCenter.dy + height / 2);
    arrowPath.lineTo(tooltipCenter.dx + 6.h, tooltipCenter.dy + height / 2);
    arrowPath.lineTo(tooltipCenter.dx, tooltipCenter.dy + height / 2 + 6.h);
    arrowPath.close();
    canvas.drawPath(arrowPath, bgPaint);
  }
}
