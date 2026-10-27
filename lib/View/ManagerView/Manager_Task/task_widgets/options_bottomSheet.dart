
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/task_add_screen.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class OptionsBottomSheet extends StatelessWidget {
  final int? taskId;
  final bool isDarkMode;
  const OptionsBottomSheet({super.key, this.taskId, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.0).h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Options",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.h,
                  color: isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          GetX<ManagerTaskController>(
            builder: (ManagerTaskController controller) {
              bool? isCompleted = controller.taskList.value.singleWhere((element) => element.workEntryId == taskId).status?.toString().toLowerCase() == 'completed';
              List<String> icons = [ isCompleted ? 'assets/images/manager_view/tick-circle-green.png' :'assets/images/manager_view/mark_complete_icon.png', 'assets/images/manager_view/edit_task_icon.png', 'assets/images/manager_view/delete_task.png'];
              List<String> titles = [ isCompleted ? 'Completed' : 'Mark Completed', 'Edit Task', 'Delete Task'];
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      if(index == 0) {
                        ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                        await managerTaskController.updateTaskComplete(taskId: taskId?.toString() ?? '');
                      }
                      if(index == 1) {
                        Navigator.of(context).pop();
                        ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                        managerTaskController.activityLogList.value = [];
                        managerTaskController.activityLogList.refresh();
                        managerTaskController.detailedTaskData.value = null;
                        Navigator.of(context).push(
                          newSlideFromBottomNavigation(TaskAddScreen(taskCreate: false, taskId: taskId, isDarkMode: isDarkMode)),
                        );
                      }
                      if(index == 2) {
                        Navigator.of(context).pop();
                        await Get.find<ManagerTaskController>().taskDelete(taskId: taskId?.toString() ?? '', context: context);
                      }
                    },
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(13).r,
                    child: Container(
                      padding: EdgeInsets.all(index == 2 ? 1 : 0).h,
                      decoration: BoxDecoration(
                        color: index == 2 ? isDarkMode ? null : Color(0xFFAA3939) : null,
                        borderRadius: BorderRadius.circular(13).r,
                      ),
                      child: Container(
                        height: 61.h,
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF27252C) : ColorUtils.paleLavenderMist,
                          borderRadius: BorderRadius.circular(12).r,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 48.h,
                              width: 48.h,
                              padding: EdgeInsets.all(12.h),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF27252C) : Color(0xFFF4F1F9),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(child: Image.asset(icons[index], color: index == 2 ? null : (index == 0 && isCompleted) ? null : isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead)),
                            ),
                            Text(
                              titles[index],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.h,
                                color: isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: 3,
              );
            },
          ),
        ],
      ),
    );
  }
}
