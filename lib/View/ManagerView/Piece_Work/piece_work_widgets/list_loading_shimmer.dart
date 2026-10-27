
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/color_utils.dart';

class ListLoadingShimmer extends StatelessWidget {
  const ListLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(14).r,
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
          width: 1.h,
        ),
      ),
      padding: EdgeInsets.all(10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.grey[200]!,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30.h,
                      width: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.h),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Column(
                      children: [
                        Container(
                          height: 12.h,
                          width: 92.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.h),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          height: 12.h,
                          width: 92.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.h),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 10.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 12.h,
                          width: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.h),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          height: 12.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.h),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15.h),
                    Container(
                      width: 28.h,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite,
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Divider(color: ColorUtils.workEntryHead.withValues(alpha: 0.1), thickness: 1.h, height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 55.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Container(
                        color: ColorUtils.softGrey,
                        width: 1.h,
                        height: 18.h,
                      ),
                    ),
                    SizedBox(
                      width: 55.h,
                      child: Column(
                        children: [
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Container(
                        color: ColorUtils.softGrey,
                        width: 1.h,
                        height: 18.h,
                      ),
                    ),
                    SizedBox(
                      width: 55.h,
                      child: Column(
                        children: [
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Container(
                        color: ColorUtils.softGrey,
                        width: 1.h,
                        height: 18.h,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 12.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.h),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15.h),
                      Container(
                        width: 28.h,
                        height: 28.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4).r,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: ColorUtils.workEntryHead.withValues(alpha: 0.1), thickness: 1.h, height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 55.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Container(
                        color: ColorUtils.softGrey,
                        width: 1.h,
                        height: 18.h,
                      ),
                    ),
                    SizedBox(
                      width: 55.h,
                      child: Column(
                        children: [
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Container(
                        color: ColorUtils.softGrey,
                        width: 1.h,
                        height: 18.h,
                      ),
                    ),
                    SizedBox(
                      width: 55.h,
                      child: Column(
                        children: [
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.h),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                      ),
                      child: Container(
                        color: ColorUtils.softGrey,
                        width: 1.h,
                        height: 18.h,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 12.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.h),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15.h),
                      Container(
                        width: 28.h,
                        height: 28.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4).r,
                          color: ColorUtils.textWhite,
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
