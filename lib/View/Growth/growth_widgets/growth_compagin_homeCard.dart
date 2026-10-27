
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/quarter_card1.dart';
import 'package:loyaltri_minimal/models/growth_home_model.dart';
import '../../../../utils/color_utils.dart';
import '../evaluation_list.dart';
import 'CWidgets.dart';

class GrowthCampaignHomeCard extends StatelessWidget {
  final EvaluationData? evaluationData;
  const GrowthCampaignHomeCard({super.key, this.evaluationData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtils.workEntryHead,
      padding: EdgeInsets.only(
        top: evaluationData?.isSelfReview == 1 ? 20.h : 0.h,
        // bottom: 20.h,
      ),
      child: Column(
        children: [
          Container(
            height: 250.h,
            padding: const EdgeInsets.all(10.0).h,
            color: ColorUtils.workEntryHead,
            child: Stack(
              children: [
                if(evaluationData?.isSelfReview == 1)
                  Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25).h,
                    child: Container(
                      height: 100.h,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6).h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20).r,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            ColorUtils.warmBeige,
                            ColorUtils.softCream,
                          ],
                        ),
                      ),
                      child: Text(
                        'Hey! Action needed. Your self review is pending',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.h,
                          color: ColorUtils.bronzeBrown,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42).h,
                    child: Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        color: ColorUtils.softBlack,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20).h,
                    child: Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        color: ColorUtils.darkCharcoal,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 25.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(0.5).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18).r,
                      gradient: LinearGradient(
                        colors: [
                          ColorUtils.deepIndigo,
                          ColorUtils.charcoalBlack,
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17).r,
                        gradient: RadialGradient(
                          center: AlignmentGeometry.directional(0, -2),
                          radius: 1.2,
                          colors: [
                            ColorUtils.darkIndigo,
                            ColorUtils.nearBlack,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10).h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                EvaluationDateHead(isHome: true, templateName: evaluationData?.templateName, avgScore: evaluationData?.avgScore),
                                GrowthBack2(
                                  isRotate: true,
                                  callBack: () {
                                    Navigator.of(context).push(
                                      newSlideNavigation(EvaluationList()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: ColorUtils.textWhite.withValues(alpha: 0.1),
                            thickness: 1.h,
                            height: 0,
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.h,
                            ),
                            child: QuarterCard1(evaluationData: evaluationData),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
