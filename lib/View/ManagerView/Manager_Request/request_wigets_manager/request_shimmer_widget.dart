import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeRequestDayCardShimmer extends StatelessWidget {
  const EmployeeRequestDayCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h,
      width: 333.w,
      decoration: BoxDecoration(
        color: ColorUtils.paleLavenderMist,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 23.w, top: 10.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.grey[200]!,
              child: Row(
                children: [
                  Container(
                    width: 84.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 335.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
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
                                      width: 30.h,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 3.h),
                                    Column(
                                      children: [
                                        Container(
                                          width: 90.h,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          width: 90.h,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 74.h,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 90.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 90.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 90.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              children: [
                                Container(
                                  width: 96.h,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5.h),
                                Container(
                                  width: 96.h,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Column(
                children: [
                  Container(
                    width: 335.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
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
                                      width: 30.h,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 3.h),
                                    Column(
                                      children: [
                                        Container(
                                          width: 90.h,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          width: 90.h,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 74.h,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 90.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 90.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 90.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              children: [
                                Container(
                                  width: 96.h,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5.h),
                                Container(
                                  width: 96.h,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//bottom sheet shimmer

class BottomSheetShimmer extends StatelessWidget {
  final bool isMissPunch;
  const BottomSheetShimmer({super.key, required this.isMissPunch});

  @override
  Widget build(BuildContext context) {
    // ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
    return Container(
      // height: isMissPunch ? 520.h : 470.h,
      padding: EdgeInsets.only(bottom: 20.h),
      width: ScreenUtil().screenWidth,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RegularizeTitle(
                    title: "Regularize",
                    image: "assets/images/Hourglass-3d.webp",
                    action: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(height: 20.h),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[100]!,
                    highlightColor: Colors.grey[200]!,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                    ),
                                  ],
                                ),
              
                                SizedBox(width: 5.h),
                                Column(
                                  children: [
                                    Container(
                                      height: 12.h,
                                      width: 92.h,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Container(
                                      height: 12.h,
                                      width: 92.h,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
              
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 12.h,
                                  width: 45.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 12.h,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              ],
                            ),
              
                            Column(
                              children: [
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              ],
                            ),
              
                            Column(
                              children: [
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 12,
                                  width: 92.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        if(isMissPunch)
                          Container(
                            height: 52,
                            width: 355.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 145.h,
                          width: 355.w,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
          //   Positioned(
          //     bottom: 0,
          //     right: 15.w,
          //     left: 15.w,
          //     child: Column(
          //       children: [
          //         ActionButtons(
          //           cancelText: "Apply Fine",
          //           okText: "Pardon",
          //           action: (p0) {},
          //         ),
          //         SizedBox(
          //           height: MediaQuery.of(context).viewInsets.bottom + 5.h,
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class PunchApprovalShimmmer extends StatelessWidget {
  const PunchApprovalShimmmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.grey[200]!,
          child: Row(
            children: [
              Container(
                height: 17.h,
                width: 84.h,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          height: 135.h,
          width: 345.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
              width: 1.h,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.grey[200]!,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5.h),
                      Column(
                        children: [
                          Container(
                            height: 12.h,
                            width: 92.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 92.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 17.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                height: 12.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                height: 12.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 12.h,
                        width: 92.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 12.h,
                        width: 92.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WorkFromHomeCardShimmer extends StatelessWidget {
  const WorkFromHomeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144.h,
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.grey[200]!,
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 3.h),
                      Column(
                        children: [
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 87.h,
                    height: 24.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  Container(
                    width: 200.h,
                    height: 12.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LetterRequestCardShimmer extends StatelessWidget {
  const LetterRequestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144.h,
      width: 360.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(12.h),
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
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 3.h),
                      Column(
                        children: [
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 74.h,
                    height: 22.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 90.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Container(
                    width: 200.h,
                    height: 12.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaveRequestCardShimmer extends StatelessWidget {
  const LeaveRequestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135.h,
      width: 360.w,

      decoration: BoxDecoration(
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.grey[200]!,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30.h,
                          height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Column(
                          children: [
                            Container(
                              width: 90.h,
                              height: 12.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              width: 90.h,
                              height: 12.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 74.h,
                      height: 22.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 90.h,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 90.h,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 90.h,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 90.h,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 90.h,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 90.h,
                          height: 12.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                Row(
                  children: [
                    Container(
                      width: 200.h,
                      height: 12.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
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

class LeaveRequestPageCardShimmer extends StatelessWidget {
  const LeaveRequestPageCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100.h,
          width: 360.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.h),
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
                            width: 30.h,
                            height: 30.h,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(16.r),
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 3.h),
                          Column(
                            children: [
                              Container(
                                width: 90.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                width: 90.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 74.h,
                        height: 22.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 90.h,
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
