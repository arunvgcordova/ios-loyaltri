
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/krasAndKpis.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../models/growth_home_model.dart';

class EvaluationDetailBottomSheet extends StatelessWidget {
  final EvaluationData? evaluationData;
  const EvaluationDetailBottomSheet({super.key, this.evaluationData});

  @override
  Widget build(BuildContext context) {
    final List<ManagerCommentData> comments = evaluationData?.reviews ?? [];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.h,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.backgroundBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B7280).withValues(alpha: 0.125),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        evaluationData?.cycleName?.substring(0, 2) ?? '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.h,
                          color: evaluationData?.status?.trim().toLowerCase() == 'completed'
                              ? const Color(0xFF00D492)
                              : evaluationData?.status?.trim().toLowerCase() == 'upcoming'
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFFFFB900),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${evaluationData?.cycleName} - Scores',
                        style: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/air_ticket/air_ticket_calendar.png',
                            height: 13.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.5),
                          ),
                          SizedBox(width: 5.h),
                          Text(
                            '${evaluationData?.startMonth ?? ''} - ${evaluationData?.endMonth ?? ''}',
                            style: GoogleFonts.inter(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.textWhite.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.foregroundBlack,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 23.h,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 25.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KRAs & KPIs List',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.7)
                        ),
                      ),
                      if(evaluationData?.avgScore != null)
                        Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Score',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite.withValues(alpha: 0.6)
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            '${evaluationData?.avgScore?.toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.h,
                                color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  KraAndKpis(evaluationData: evaluationData, showAvg: true),
                  SizedBox(height: 25.h),
                  if(comments.isNotEmpty)
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manager comments',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.h,
                          color: ColorUtils.textWhite.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        '${comments.length} comments',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.h,
                          color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  if(comments.isNotEmpty)
                    SizedBox(height: 12.h),
                  if(comments.isNotEmpty)
                    ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final item = comments[index];
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.h),
                        decoration: BoxDecoration(
                          color: ColorUtils.foregroundBlack4,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: CachedNetworkImage(
                                    imageUrl: item.createdByEmployee?.profilePicture ?? '',
                                    height: 38.h,
                                    width: 38.h,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => _avatarPlaceholder(item.createdByEmployee?.fullName),
                                    errorWidget: (context, url, error) => _avatarPlaceholder(item.createdByEmployee?.fullName),
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.createdByEmployee?.fullName ?? '',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.h,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                        Text(
                                          (item.createdByEmployee?.designation?.trim().isNotEmpty ?? false)
                                              ? '${item.createdByEmployee?.designation}${(item.createdOn?.isNotEmpty ?? false) ? ' · ${item.createdOn}' : ''}'
                                              : (item.createdOn ?? ''),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.h,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              item.overallComment ?? '',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.h,
                                height: 1.35,
                                color: ColorUtils.textWhite.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if(comments.isNotEmpty)
                    SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(String? name) {
    String initials = '';
    if (name != null && name.trim().isNotEmpty) {
      List<String> parts = name.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
      }
    }
    return Container(
      width: 38.h,
      height: 38.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12.h,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
