import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class ShiftSchedulerShimmer extends StatelessWidget {
  const ShiftSchedulerShimmer({super.key});

  Map<int, TableColumnWidth> get _columnWidths => {
    0: FixedColumnWidth(140.h),
    1: FixedColumnWidth(150.h),
    2: FixedColumnWidth(150.h),
    3: FixedColumnWidth(150.h),
    4: FixedColumnWidth(150.h),
    5: FixedColumnWidth(150.h),
    6: FixedColumnWidth(150.h),
    7: FixedColumnWidth(150.h),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        width: 140.h + (150.h * 7),
        child: Column(
          children: [
            // Header row shimmer
            Table(
              columnWidths: _columnWidths,
              border: const TableBorder(
                bottom: BorderSide(color: ColorUtils.platinum, width: 0.8),
              ),
              children: [
                TableRow(
                  children: [
                    _buildHeaderShimmerCell(isEmpHeader: true),
                    ...List.generate(7, (_) => _buildHeaderShimmerCell()),
                  ],
                ),
              ],
            ),
            // Data rows shimmer
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[50]!,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Table(
                      columnWidths: _columnWidths,
                      border: const TableBorder(
                        bottom: BorderSide(color: ColorUtils.platinum, width: 0.8),
                      ),
                      children: [
                        TableRow(
                          children: [
                            _buildEmpCellShimmer(),
                            ...List.generate(7, (_) => _buildShiftCellShimmer()),
                          ],
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
    );
  }

  /// Header cell shimmer — matches the real header layout
  Widget _buildHeaderShimmerCell({bool isEmpHeader = false}) {
    return SizedBox(
      height: 50.h,
      child: Padding(
        padding: EdgeInsets.only(left: isEmpHeader ? 13.h : 0),
        child: Align(
          alignment: isEmpHeader ? Alignment.centerLeft : Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: isEmpHeader
                ? Container(
                    width: 70.h,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 20.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Employee cell shimmer — avatar circle + two text lines
  Widget _buildEmpCellShimmer() {
    return Container(
      padding: EdgeInsets.only(left: 10.h, top: 8.h, bottom: 8.h, right: 8.h),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: ColorUtils.textWhite,
        border: Border(
          right: BorderSide(color: ColorUtils.platinum, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 8.h),
          // Name + ID text lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70.h,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 40.h,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shift cell shimmer — rounded rectangle matching the shift chip
  Widget _buildShiftCellShimmer() {
    return Container(
      padding: EdgeInsets.all(4.h),
      decoration: const BoxDecoration(
        color: ColorUtils.textWhite,
        border: Border(
          right: BorderSide(color: ColorUtils.platinum, width: 0.8),
        ),
      ),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
