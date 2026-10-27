import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../controller/userProfileController.dart';
import '../../models/growth_home_model.dart';
import 'growth_widgets/CWidgets.dart';
import 'growth_widgets/goals_and_sub_homeCard.dart';
import 'growth_widgets/growth_compagin_homeCard.dart';
import 'growth_widgets/mood_pulse.dart';
import 'growth_widgets/vision_mission_popup.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen>
    with TickerProviderStateMixin {
  GrowthController growthController = Get.find<GrowthController>();
  late TabController _tabController;
  ValueNotifier<int> currentTabIndex = ValueNotifier(0);
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _percentSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    growthController.fetchMoodPulse();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      final newIndex = _tabController.animation!.value.round();

      if (currentTabIndex.value != newIndex) {
        currentTabIndex.value = newIndex;
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _rotationAnimation = Tween<double>(
      begin: math.pi * 1.0,
      end: math.pi * (1 + (growthController.avgPercentage.value / 100)),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _percentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
    // growthController.fetchGrowthHomeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool showGoals = (Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false) && (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(166) ?? false);
    return Scaffold(
      backgroundColor: ColorUtils.workEntryHead,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: () async {
                await growthController.fetchGrowthHomeData();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/growth/growth-home-pattern.png',
                            ),
                            alignment: Alignment.topCenter,
                            fit: BoxFit.fitWidth,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorUtils.mediumViolet,
                              ColorUtils.workEntryHead,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18).h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18.h),
                            _buildTopNav(),
                            SizedBox(height: 15.h),
                            FadeTransition(
                              opacity: _textFadeAnimation,
                              child: SlideTransition(
                                position: _textSlideAnimation,
                                child: _buildTabSwitcher(),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            FadeTransition(
                              opacity: _textFadeAnimation,
                              child: SlideTransition(
                                position: _textSlideAnimation,
                                child: _buildVisionText(),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            Obx(() {
                                return _buildProgressGauge(growthController.avgPercentage.value / 100);
                              }
                            ),
                            // GlassyProgress(),
                            SizedBox(height: 13.h),
                          ],
                        ),
                      ),
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: SlideTransition(
                          position: _percentSlideAnimation,
                          child: Container(
                            color: ColorUtils.workEntryHead,
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Average',
                                  style: GoogleFonts.urbanist(
                                    color: ColorUtils.textWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.h,
                                  ),
                                ),
                                Text(
                                  'Performance Score',
                                  style: GoogleFonts.urbanist(
                                    color: ColorUtils.textWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: GetX<GrowthController>(
                            builder: (GrowthController controller) {
                              return Container(
                                padding: EdgeInsets.only(top: 20.h),
                                color: ColorUtils.workEntryHead,
                                child: controller.evaluationListForHome.value.length > 4 ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(width: 10.h),
                                      for(int i = 0; i < controller.evaluationListForHome.value.length; i++)
                                        _questionCard(
                                          aboveFour: controller.evaluationListForHome.value.length > 3,
                                            needPadding: true,
                                            quarter: controller.evaluationListForHome.value[i].cycleName?.substring(0, 3) ?? '--',
                                            percent: controller.evaluationListForHome.value[i].avgScore?.toStringAsFixed(0).toString() ?? '--',
                                        ),
                                    ],
                                  ),
                                ) : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(width: 18.h),
                                    for(int i = 0; i < controller.evaluationListForHome.value.length; i++)
                                      Expanded(
                                        child: controller.evaluationListForHome.value.length == 1
                                            ? _questionCardSingle(
                                          quarter: controller.evaluationListForHome.value[i].cycleName?.substring(0, 3) ?? '--',
                                          percent: controller.evaluationListForHome.value[i].avgScore?.toStringAsFixed(0).toString() ?? '--',
                                        )
                                            : _questionCard(
                                          aboveFour: controller.evaluationListForHome.value.length > 3,
                                          quarter: controller.evaluationListForHome.value[i].cycleName?.substring(0, 3) ?? '--',
                                          percent: controller.evaluationListForHome.value[i].avgScore?.toStringAsFixed(0).toString() ?? '--',
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: GetX<GrowthController>(
                            builder: (GrowthController controller) {
                              final evaluations = controller.evaluationListForHome.value;

                              EvaluationData? evaluation = evaluations.firstWhereOrNull((e) => e.status?.toLowerCase() == "let's start");
                              evaluation ??= evaluations.firstWhereOrNull((e) => e.status?.toLowerCase() == "pending");
                              evaluation ??= evaluations.firstWhereOrNull((e) => e.status?.toLowerCase() == "upcoming");
                              if(evaluations.isNotEmpty) {
                                return GrowthCampaignHomeCard(evaluationData: evaluation ?? evaluations.first);
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          ),
                        ),
                      ),
                      // if(showGoals)
                      //   const GoalsAndSubHomeCard(),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: const MoodPulse(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildTopNav() {
    return SafeArea(
      top: true,
      bottom: false,
      right: false,
      left: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SlideTransition(
            position: _slideAnimation,
              child: GrowthBack1(callBack: () => Navigator.of(context).pop()),
          ),
          FadeTransition(
            opacity: _textFadeAnimation,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/growth/growth-home-icon.png',
                    height: 25.h,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(width: 10.h),
                  Text(
                    "Growth",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14).r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return SizedBox(
      width: 200.h,
      child: Stack(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 35.h,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              // indicatorWeight: 0,
              labelColor: ColorUtils.textWhite,
              dividerHeight: 0,
              unselectedLabelColor: ColorUtils.textWhite.withValues(alpha: 0.5),
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.only(right: 20.h),
              labelStyle: GoogleFonts.urbanist(
                color: ColorUtils.textWhite,
                fontSize: 17.5.h,
                fontWeight: FontWeight.w500,
              ),
              tabAlignment: TabAlignment.start,

              // indicator: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(
              //       "assets/images/growth/idicator.png",
              //     ),
              //     alignment: Alignment.bottomCenter,
              //     colorFilter: ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn),
              //   ),
              // ),
              tabs: const [
                Tab(text: "Vision"),
                Tab(text: "Mission"),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: -5,
            child: Padding(
              padding: EdgeInsets.only(right: 75.h),
              child: ValueListenableBuilder(
                valueListenable: currentTabIndex,
                builder: (context, value, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        alignment: value == 0
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: Image.asset(
                          'assets/images/growth/idicator.png',
                          height: 10.h,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        height: 3.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50).r,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              if (value == 0) 0.0,
                              if (value == 0) 1.0,
                              if (value == 1) 0.0,
                              if (value == 1) 0.9,
                            ],
                            colors: [
                              if (value == 0) ColorUtils.textWhite,
                              if (value == 0)
                                ColorUtils.textWhite.withValues(alpha: 0.1),
                              if (value == 1)
                                ColorUtils.textWhite.withValues(alpha: 0.1),
                              if (value == 1) ColorUtils.textWhite,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionText() {
    final textStyle = GoogleFonts.urbanist(
      color: ColorUtils.textWhite,
      fontSize: 25.h,
      fontWeight: FontWeight.w600,
      height: 1.15,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ValueListenableBuilder(
              valueListenable: currentTabIndex,
              builder: (context, value, child) {
                return Obx(() {
                  final isVisionTab = value == 0;
                  final text = isVisionTab
                      ? growthController.missionVisionData.value?.vision ?? ''
                      : growthController.missionVisionData.value?.mission ?? '';

                  final isOverflowing = _isTextOverflow(
                    text: text,
                    style: textStyle,
                    maxWidth: constraints.maxWidth,
                    maxHeight: 90.h,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 90.h,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Text(
                              text,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle,
                              maxLines: 3,
                            ),
                            Text(
                              text,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),

                      if (isOverflowing) ...[
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor:
                              ColorUtils.workEntryHead.withValues(alpha: 0.9),
                              barrierDismissible: false,
                              builder: (_) {
                                return MissionVisionPopUp(
                                  tabController: _tabController,
                                  currentTabIndex: currentTabIndex,
                                );
                              },
                            );
                          },
                          child: Text(
                            "Read More",
                            style: GoogleFonts.jetBrainsMono(
                              color: ColorUtils.textWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.h,
                              decoration: TextDecoration.underline,
                              decorationColor: ColorUtils.textWhite,
                              decorationThickness: 1,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressGauge(double progress) {
    String progressString = '${(progress * 100).toStringAsFixed(0)}%';
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.489,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/growth/background-progress2.png',
              width: 270.h,
            ),
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/growth/forground-progress2.png',
                width: 255.h,
              ),
            ),

            Positioned(
              top: 86.h,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: SlideTransition(
                  position: _percentSlideAnimation,
                  child: Text(
                    progressString,
                    style: GoogleFonts.urbanist(
                      color: ColorUtils.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 42.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionCard({required String quarter, required String percent, required bool aboveFour, bool? needPadding}) {
    return Padding(
      padding: EdgeInsets.only(right: aboveFour ? 10.h : 18.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: (needPadding ?? false) ? (aboveFour ? 25.h : 20.h) : 10.h),
        decoration: BoxDecoration(
          color: aboveFour ? ColorUtils.veryDarkGrey : ColorUtils.midnightIndigo,
          borderRadius: BorderRadius.circular(aboveFour ? 10 : 14).r,
          border: Border.all(
            color: aboveFour ? ColorUtils.veryDarkGrey : ColorUtils.carbonGrey,
            width: 0.5.h,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quarter,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 15.h,
                color: ColorUtils.textWhite,
              ),
            ),
            Text(
              '$percent${percent != '--' ? '%' : ''}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 15.h,
                color: ColorUtils.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionCardSingle({required String quarter, required String percent}) {
    return Padding(
      padding: EdgeInsets.only(right: 18.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.h),
        decoration: BoxDecoration(
          color: ColorUtils.midnightIndigo,
          borderRadius: BorderRadius.circular(14).r,
          border: Border.all(
            color: ColorUtils.carbonGrey,
            width: 0.5.h,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              quarter,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 15.h,
                color: ColorUtils.textWhite,
              ),
            ),
            Text(
              '$percent${percent != '--' ? '%' : ''}',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 15.h,
                color: ColorUtils.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CUSTOM PAINTER FOR GAUGE ---

class GlassyProgress extends StatelessWidget {
  const GlassyProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: SizedBox(
          width: 270.h,
          child: CustomPaint(
            size: Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight),
            painter: GlassyHalfCirclePainter(
              progress: 1.0,
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: const Text(
                '75%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'sans-serif-light',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassyHalfCirclePainter extends CustomPainter {
  final double progress;
  GlassyHalfCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final thickness = size.width * 0.25;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - thickness;
    final arcRect = Rect.fromCircle(
      center: center,
      radius: (outerRadius + innerRadius) / 2,
    );

    // 2. MAIN BACKGROUND TRACK (Depth/Inner Shadow)
    Paint trackPaint = Paint()
      ..color = ColorUtils.workEntryHead
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    canvas.drawArc(arcRect, math.pi, math.pi, false, trackPaint);

    final shadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11);

    canvas.save();
    canvas.clipPath(
      Path()..addOval(
        Rect.fromCircle(
          center: center,
          radius: (outerRadius + innerRadius) * 0.666,
        ),
      ),
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: (outerRadius + innerRadius) * 0.66,
      ),
      math.pi,
      math.pi,
      false,
      shadowPaint,
    );
    canvas.restore();

    // // 3. PURPLE CORE (The actual progress)
    double purpleThickness = thickness * 0.9;
    double purpleArcRadius = innerRadius + (purpleThickness / 2);

    final Rect rect = Rect.fromCircle(center: center, radius: purpleArcRadius);

    // 1. Define the Gradient Colors from your image
    final List<Color> colors = [
      Color(0xFF5646A4),
      Color(0xFF5646A4),
      // Color(0xFF8A78E8),
      // Color(0xFF927AFF), // Vibrant Purple
      Color(0xFF927AFF), // Vibrant Purple
      Color(0xFF5A66DA), // Mid Blue-Purple
      Color(0xFF927AFF), // Vibrant Purple
      Color(0xFF2A1D66), // Dark Deep Purple
    ];

    // 2. Main Gradient Stroke
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness
      ..strokeCap = StrokeCap.butt
      ..shader = SweepGradient(
        colors: colors,
        startAngle: math.pi,
        endAngle: 2 * math.pi,
        tileMode: TileMode.clamp,
      ).createShader(rect);

    // Draw the main arc
    canvas.drawArc(rect, math.pi, math.pi * progress, false, paint);

    final Paint darkShadow0 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF5646A4).withValues(alpha: 0.7);

    final Rect shadowRect0 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    if (progress > 0.3)
      canvas.drawArc(
        shadowRect0,
        (13 * math.pi) / 12,
        math.pi * 0.3,
        false,
        darkShadow0,
      );

    final Paint darkShadow1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF5646A4).withValues(alpha: 0.25);

    final Rect shadowRect1 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    if (progress > 0.2)
      canvas.drawArc(shadowRect1, math.pi, math.pi * 0.3, false, darkShadow1);

    final Paint darkShadow2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF2A1D66).withValues(alpha: 0.4);

    final Rect shadowRect2 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 20,
    );
    if (progress > 0.2)
      canvas.drawArc(shadowRect2, math.pi, math.pi * 0.2, false, darkShadow2);

    final Paint darkShadow5 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF2A1D66).withValues(alpha: 0.25);

    final Rect shadowRect5 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 20,
    );
    if (progress > 0.3)
      canvas.drawArc(
        shadowRect5,
        (41 * math.pi) / 36,
        math.pi * 0.15,
        false,
        darkShadow5,
      );

    final Paint darkShadow3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF2A1D66).withValues(alpha: 0.5);

    final Rect shadowRect3 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 20,
    );
    if (progress > 0.1)
      canvas.drawArc(shadowRect3, math.pi, math.pi * 0.1, false, darkShadow3);

    final Paint darkShadow4 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite.withValues(alpha: 0.1);

    final Rect shadowRect4 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius - 15,
    );
    if (progress > 0.2)
      canvas.drawArc(
        shadowRect4,
        (41 * math.pi) / 36,
        math.pi * 0.1,
        false,
        darkShadow4,
      );
    if (progress > 0.1)
      canvas.drawArc(shadowRect3, math.pi, math.pi * 0.1, false, darkShadow3);

    final Paint darkShadow7 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite;

    final Rect shadowRect7 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    canvas.drawArc(
      shadowRect7,
      (17 * math.pi) / 12,
      math.pi * 0.15,
      false,
      darkShadow7,
    );

    final Paint darkShadow8 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite;

    final Rect shadowRect8 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    canvas.drawArc(
      shadowRect8,
      (49 * math.pi) / 36,
      math.pi * 0.15,
      false,
      darkShadow8,
    );

    final Paint darkShadow9 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite;

    final Rect shadowRect9 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    canvas.drawArc(
      shadowRect9,
      (47 * math.pi) / 36,
      math.pi * 0.15,
      false,
      darkShadow9,
    );

    final Paint darkShadow10 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite;

    final Rect shadowRect10 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    canvas.drawArc(
      shadowRect10,
      (53 * math.pi) / 36,
      math.pi * 0.15,
      false,
      darkShadow10,
    );

    final Paint darkShadow11 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite;

    final Rect shadowRect11 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    canvas.drawArc(
      shadowRect11,
      (55 * math.pi) / 36,
      math.pi * 0.15,
      false,
      darkShadow11,
    );

    final Paint darkShadow12 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF5A66DA);

    final Rect shadowRect12 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius - 15,
    );
    if (progress > 0.5)
      canvas.drawArc(
        shadowRect12,
        (17 * math.pi) / 12,
        math.pi * 0.15,
        false,
        darkShadow12,
      );

    final Paint darkShadow13 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF5A66DA);

    final Rect shadowRect13 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius - 20,
    );
    if (progress > 0.4)
      canvas.drawArc(
        shadowRect13,
        (47 * math.pi) / 36,
        math.pi * 0.15,
        false,
        darkShadow13,
      );

    final Paint darkShadow14 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF5646A4).withValues(alpha: 0.7);

    final Rect shadowRect14 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    if (progress > 0.9) {
      canvas.drawArc(
        shadowRect14,
        (59 * math.pi) / 36, // ⬅ opposite
        math.pi * 0.3,
        false,
        darkShadow14,
      );
    }

    final Paint darkShadow15 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF5646A4).withValues(alpha: 0.25);

    final Rect shadowRect15 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 15,
    );
    if (progress > 0.95) {
      canvas.drawArc(
        shadowRect15,
        (61 * math.pi) / 36, // = 2π
        math.pi * 0.3,
        false,
        darkShadow15,
      );
    }

    final Paint darkShadow16 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF2A1D66).withValues(alpha: 0.4);

    final Rect shadowRect16 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 20,
    );
    if (progress > 0.95) {
      canvas.drawArc(
        shadowRect16,
        (65 * math.pi) / 36, // = 2π
        math.pi * 0.2,
        false,
        darkShadow16,
      );
    }

    final Paint darkShadow17 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF2A1D66).withValues(alpha: 0.25);

    final Rect shadowRect17 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 20,
    );
    if (progress > 0.95) {
      canvas.drawArc(
        shadowRect17,
        (67 * math.pi) / 36,
        math.pi * 0.15,
        false,
        darkShadow17,
      );
    }

    final Paint darkShadow18 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = Color(0xFF2A1D66).withValues(alpha: 0.5);

    final Rect shadowRect18 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 20,
    );
    if (progress > 0.95) {
      canvas.drawArc(
        shadowRect18,
        (67 * math.pi) / 36,
        math.pi * 0.1,
        false,
        darkShadow18,
      );
    }

    final Paint darkShadow19 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite.withValues(alpha: 0.1);

    final Rect shadowRect19 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius - 15,
    );
    if (progress > 0.95) {
      canvas.drawArc(
        shadowRect19,
        (65 * math.pi) / 36,
        math.pi * 0.1,
        false,
        darkShadow19,
      );
    }
    if (progress > 0.95) {
      canvas.drawArc(
        shadowRect18,
        (65 * math.pi) / 36,
        math.pi * 0.1,
        false,
        darkShadow18,
      );
    }

    final Paint darkShadow20 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite.withValues(alpha: 0.1);

    final Rect shadowRect20 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 10,
    );
    if (progress < 0.9) {
      canvas.drawArc(
        shadowRect20,
        (19 * math.pi) / 12,
        math.pi * 0.4,
        false,
        darkShadow20,
      );
    }

    final Paint darkShadow21 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite.withValues(alpha: 0.1);

    final Rect shadowRect21 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius + 10,
    );
    if (progress < 0.2) {
      canvas.drawArc(shadowRect21, math.pi, math.pi * 0.4, false, darkShadow21);
    }

    final Paint darkShadow6 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = purpleThickness * 0.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11.11)
      ..color = ColorUtils.textWhite.withValues(alpha: 0.1);

    final Rect shadowRect6 = Rect.fromCircle(
      center: center,
      radius: purpleArcRadius - 15,
    );

    // ⬇ Bottom half
    canvas.drawArc(
      shadowRect6,
      math.pi, // start at 180°
      math.pi, // sweep 180°
      false,
      darkShadow6,
    );

    // --- 4. GLASS DOME OVERLAY (Clipping is key here) ---
    canvas.save();
    Path ringPath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        math.pi,
        math.pi,
      )
      ..arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        0,
        -math.pi,
        false,
      )
      ..close();
    canvas.clipPath(ringPath);

    // High-altitude shine (The big white glare at the top center)
    Paint shinePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.9),
        radius: 0.5,
        colors: [Colors.white.withValues(alpha: 0.5), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), shinePaint);
    canvas.restore();

    // 5. INNER TICKS (Matching the notches in image)
    Paint tickPaint = Paint()
      ..color = ColorUtils.workEntryHead.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i <= 8; i++) {
      double angle = math.pi + (math.pi * (i / 8));
      if (i != 1 && i != 7) {
        canvas.drawLine(
          Offset(
            center.dx + (innerRadius + 5) * math.cos(angle),
            center.dy + (innerRadius + 5) * math.sin(angle),
          ),
          Offset(
            center.dx + (innerRadius + 12) * math.cos(angle),
            center.dy + (innerRadius + 12) * math.sin(angle),
          ),
          tickPaint,
        );
      }
    }

    // 6. PARTICLES (The white "star" dots)
    final random = math.Random(1);
    double centerAngle =
        math.pi + (math.pi / 2); // This is exactly the 90-degree top point

    for (int i = 0; i < 40; i++) {
      // --- Angle Logic: Cluster around the center ---
      // Spread the dots by roughly 20 degrees in either direction (0.35 radians)
      double angleSpread = 0.60;
      double pAngle =
          centerAngle + (random.nextDouble() * angleSpread * 2 - angleSpread);

      // --- Thickness Logic: Stay in the middle of the tube ---
      // 30% padding from inner and outer edges
      double verticalPadding = thickness * 0.2;
      double pDist =
          innerRadius +
          verticalPadding +
          (thickness - (verticalPadding * 2)) * random.nextDouble();

      // Only draw if the progress has actually reached this angle
      if (pAngle <= (math.pi + math.pi * progress)) {
        canvas.drawCircle(
          Offset(
            center.dx + pDist * math.cos(pAngle),
            center.dy + pDist * math.sin(pAngle),
          ),
          random.nextDouble() * 2,
          Paint()
            ..color = Colors.white.withValues(alpha: random.nextDouble() * 0.6),
        );
      }
    }

    // 7. BLACK SEPARATOR LINE (The progress cap)
    Paint divider = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    double barThickness = outerRadius - innerRadius;
    double lineLength = barThickness * 0.30;
    double lineStartRadius = innerRadius;
    double lineEndRadius = innerRadius + lineLength;

    double endAngle = math.pi + (math.pi * progress);
    canvas.drawLine(
      Offset(
        center.dx + lineStartRadius * math.cos(endAngle),
        center.dy + lineStartRadius * math.sin(endAngle),
      ),
      Offset(
        center.dx + lineEndRadius * math.cos(endAngle),
        center.dy + lineEndRadius * math.sin(endAngle),
      ),
      divider..strokeCap = StrokeCap.round,
    );

    // 1. OUTER GLOW BORDER (The thin white rim)
    double rimStroke = 4;

    Paint rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = rimStroke
      ..color = ColorUtils.textWhite.withValues(alpha: 0.6);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius + (rimStroke / 2)),
      math.pi + (math.pi * (progress + 0.01)),
      math.pi * (1.0 - (progress + 0.01)),
      false,
      rimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.1, size.height * 0.5);

    path.quadraticBezierTo(
      size.width * 0.05,
      size.height * 0.2,
      size.width * 0.3,
      size.height * 0.25,
    );

    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.05,
      size.width * 0.6,
      size.height * 0.2,
    );

    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.25,
      size.width * 0.9,
      size.height * 0.45,
    );

    path.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.7,
      size.width * 0.75,
      size.height * 0.75,
    );

    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.95,
      size.width * 0.4,
      size.height * 0.8,
    );

    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.85,
      size.width * 0.1,
      size.height * 0.5,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

bool _isTextOverflow({
  required String text,
  required TextStyle style,
  required double maxWidth,
  required double maxHeight,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: null,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.height > maxHeight;
}