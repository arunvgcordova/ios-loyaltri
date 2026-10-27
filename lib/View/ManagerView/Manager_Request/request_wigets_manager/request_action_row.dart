import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

List<String> actions = [
  "Excuses",
  "Punch Approval",
  "Overtime",
  "Work From Home",
  "Letter Request",
  "Leave Request",
];

AutoScrollController autoScrollController = AutoScrollController();

class RequestActionRow extends StatelessWidget {
  const RequestActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (autoScrollController.hasClients) {
        autoScrollController.scrollToIndex(Get.find<ManagerRequestController>().currentTabIndex.value, preferPosition: AutoScrollPosition.begin);
      }
    });
    return Container(
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.all(2).h,
      decoration: BoxDecoration(
        color: ColorUtils.snowGrey,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(100).r),
        border: Border(
          left: BorderSide(
            color: ColorUtils.cloudySilver.withValues(alpha: 0.12),
            width: 1.h,
            style: BorderStyle.solid,
          ),
          top: BorderSide(
            color: ColorUtils.cloudySilver.withValues(alpha: 0.12),
            width: 1.h,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            color: ColorUtils.cloudySilver.withValues(alpha: 0.12),
            width: 1.h,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(100).r),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: autoScrollController,
          child: Row(
            children: [
              ...List.generate(actions.length, (index) {
                return AutoScrollTag(
                    index: index,
                    highlightColor: ColorUtils.generalShift1,
                    key: ValueKey(index),
                    controller: autoScrollController,
                    child: _RequestActionButton(index: index),
                );
              }),
              SizedBox(width: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestActionButton extends GetView<ManagerRequestController> {
  final int index;
  const _RequestActionButton({required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () async {
          controller.currentTabIndex.value = index;
          // context.loaderOverlay.show();
          if(controller.currentTabIndex.value == 0) {
            if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending) {
              await controller.fetchExcuseList(
                monthYear: controller.monthString[controller.currentMonthIndex.value],
              );
            } else {
              await controller.fetchExcuseListFilter(
                monthYear: controller.monthString[controller.currentMonthIndex.value],
              );
            }
          } else if(controller.currentTabIndex.value == 1) {
            await controller.fetchPunchApprovalReqList(
              monthYr: controller.monthString[controller.currentMonthIndex.value],
            );
          } else if(controller.currentTabIndex.value == 2) {
            await controller.fetchOvertimeList(
              monthYear: controller.monthString[controller.currentMonthIndex.value],
            );
          } else if(controller.currentTabIndex.value == 3 || controller.currentTabIndex.value == 4) {
            await controller.fetchWfhOrLrList(
              monthYr: controller.monthString[controller.currentMonthIndex.value],
            );
          } else if(controller.currentTabIndex.value == 5) {
            await controller.fetchEmployeeLeaveList(
              monthYr: controller.monthString[controller.currentMonthIndex.value],
            );
          }
          // context.loaderOverlay.hide();
        },
        child: Container(
          constraints: BoxConstraints(minWidth: 100.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
          decoration:
              controller.currentTabIndex.value == index
                  ? BoxDecoration(
                    color: ColorUtils.textWhite,
                    borderRadius: BorderRadius.circular(100).r,
                    border: Border.all(
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                      width: 1.h,
                    ),
                  )
                  : null,
          child: Center(
            child: Text(
              actions[index],
              style: GoogleFonts.poppins(
                fontSize: 12.h,
                fontWeight:
                    controller.currentTabIndex.value == index
                        ? FontWeight.w600
                        : FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(
                  alpha: controller.currentTabIndex.value == index ? 1.0 : 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
