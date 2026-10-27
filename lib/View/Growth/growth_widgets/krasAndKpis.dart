
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/models/growth_home_model.dart';
import '../../../utils/color_utils.dart';

class KraAndKpis extends StatelessWidget {
  final EvaluationData? evaluationData;
  final bool showAvg;
  const KraAndKpis({super.key, this.evaluationData, required this.showAvg});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: evaluationData?.kraTemplate?.length ?? 0,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        KraTemplate? kra = evaluationData?.kraTemplate?[index];
        return Container(
          decoration: BoxDecoration(
            color: ColorUtils.midnightIndigo,
            borderRadius: BorderRadius.circular(15).r,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor:
              ColorUtils.backgroundBlack,
              splashColor: Colors.transparent,
            ),
            child: ExpansionTile(
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 0,
              ).h,
              // childrenPadding: const EdgeInsets.only(
              //   left: 15,
              //   right: 30,
              //   bottom: 8,
              // ).h,
              title: Row(
                children: [
                  Container(
                    width: 4.h,
                    height: 19.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500.r),
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Flexible(
                    child: Text(
                      kra?.kraName ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                for(int i = 0; i < (kra?.cyclePoints?.length ?? 0); i++)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 20,
                      top: i == 0 ? 15 : 0,
                      bottom: i == ((kra?.cyclePoints?.length ?? 0) - 1) ? 10 : 0,
                    ).h,
                    decoration: BoxDecoration(
                      color: Color(0xFF36324F),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(i == ((kra?.cyclePoints?.length ?? 0) - 1) ? 10.r : 0)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 7.h,
                                ),
                                child: Container(
                                  width: 6.h,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Expanded(
                                child: Text(
                                  kra?.cyclePoints?[i].title ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                              ),
                              if(showAvg)
                                Text(
                                kra?.cyclePoints?[i].avgScore?.toStringAsFixed(0) ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 13.h,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFA28EFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
        // return Container(
        //   child: Text(
        //     'Customer Relationship & Account Retention',
        //     style: GoogleFonts.inter(
        //       fontSize: 13.h,
        //       fontWeight: FontWeight.w400,
        //       color: ColorUtils.textWhite,
        //     ),
        //   ),
        // );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
    );
  }
}
