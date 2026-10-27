
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../growth_controller/growth_controller.dart';
import 'CWidgets.dart';

class MissionVisionPopUp extends StatefulWidget {
  final TabController tabController;
  final ValueNotifier<int> currentTabIndex;
  const MissionVisionPopUp({super.key, required this.tabController, required this.currentTabIndex});

  @override
  State<MissionVisionPopUp> createState() => _MissionVisionPopUpState();
}

class _MissionVisionPopUpState extends State<MissionVisionPopUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _yRotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(curved);

    _translateAnimation = Tween<double>(
      begin: 140.h, // from bottom
      end: 0.0,
    ).animate(curved);

    _fadeAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _yRotationAnimation = Tween<double>(
      begin: 2 * 3.141592653589793, // 360°
      end: 0.0,
    ).animate(curved);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10).h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: GrowthClose1(callBack: () async {
                      await _controller.reverse();
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }),
                  ),
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _translateAnimation.value),
                        child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0)
                            ..rotateY(_yRotationAnimation.value)
                            ..scale(_scaleAnimation.value),
                          child: child,
                        ),
                      ),
                    );
                  },
                    child: Container(
                      padding: EdgeInsets.all(0.4).h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30).r,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            ColorUtils.deepIndigo,
                            ColorUtils.charcoalBlack,
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30).r,
                          gradient: RadialGradient(
                            center: AlignmentGeometry.directional(0, -1),
                            radius: 0.5,
                            colors: [
                              ColorUtils.darkIndigo,
                              ColorUtils.nearBlack,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 6.h,
                                left: 15.h,
                                right: 15.h,
                              ).h,
                              child: SizedBox(
                                width: 200.h,
                                child: Stack(
                                  // mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 43.h,
                                      child: TabBar(
                                        controller: widget.tabController,
                                        isScrollable: true,
                                        dividerColor: Colors.transparent,
                                        indicatorColor: Colors.transparent,
                                        // indicatorWeight: 0,
                                        labelColor: ColorUtils.textWhite,
                                        dividerHeight: 0,
                                        unselectedLabelColor: ColorUtils.textWhite.withValues(alpha: 0.5),
                                        indicatorPadding: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                        labelPadding: EdgeInsets.only(
                                          right: 20.h,
                                        ),
                                        labelStyle: GoogleFonts.urbanist(
                                          color: ColorUtils.textWhite,
                                          fontSize: 23.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        tabAlignment: TabAlignment.start,

                                        indicator: BoxDecoration(
                                          color: Colors.transparent,
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //     "assets/images/growth/idicator.png",
                                          //   ),
                                          //   alignment: Alignment.bottomCenter,
                                          //   colorFilter: ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn),
                                          // ),
                                        ),
                                        tabs: const [
                                          Tab(text: "Vision"),
                                          Tab(text: "Mission"),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 45.h),
                                        child: ValueListenableBuilder(
                                          valueListenable: widget.currentTabIndex,
                                          builder: (context, value, child) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: AnimatedAlign(
                                                    duration: const Duration(milliseconds: 100),
                                                    curve: Curves.easeInOut,
                                                    alignment: value == 0 ? Alignment.topLeft : Alignment.topRight,
                                                    child: Image.asset(
                                                      'assets/images/growth/idicator.png',
                                                      height: 10.h,
                                                    ),
                                                  ),
                                                ),
                                                AnimatedContainer(
                                                  duration: const Duration(milliseconds: 100),
                                                  curve: Curves.easeInOut,
                                                  height: 4.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50).r,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      stops: [
                                                        if(value == 0) 0.0,
                                                        if(value == 0) 1.0,
                                                        if(value == 1) 0.0,
                                                        if(value == 1) 0.9
                                                      ],
                                                      colors: [
                                                        if(value == 0) ColorUtils.textWhite,
                                                        if(value == 0) ColorUtils.textWhite.withValues(alpha: 0.1),
                                                        if(value == 1) ColorUtils.textWhite.withValues(alpha: 0.1),
                                                        if(value == 1) ColorUtils.textWhite,
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
                              ),
                            ),
                            Divider(
                              color: ColorUtils.textWhite.withValues(alpha: 0.1),
                              thickness: 1.h,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 6.h,
                                  bottom: 15.h,
                                  left: 18.h,
                                  right: 18.h,
                                ).h,
                                child: Obx(() {
                                  GrowthController growthController = Get.find<GrowthController>();
                                    return TabBarView(
                                      controller: widget.tabController,
                                      children: [
                                        _content(
                                          growthController.missionVisionData.value?.vision ?? '',
                                        ),
                                        _content(
                                          growthController.missionVisionData.value?.mission ?? '',
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ),

              SizedBox(height: 20.h),
              ValueListenableBuilder(
                  valueListenable: widget.currentTabIndex,
                  builder: (context, value, child) {
                    return _bottomIndicator(value);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(String text) {
    return SingleChildScrollView(
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 23.h,
          fontWeight: FontWeight.w600,
          color: ColorUtils.textWhite,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _bottomIndicator(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6).h,
      decoration: BoxDecoration(
        color: ColorUtils.darkBlueViolet.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(40).r,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(2, (i) {
          return Container(
            margin: const EdgeInsets.all(4).h,
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              color: i == index
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 14.r),
              ],
            ),
          );
        }),
      ),
    );
  }
}
