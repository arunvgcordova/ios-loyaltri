import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/leave_widgets_manager/employee_leave_appBar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/searchAndFilter.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/options_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/taskTabSwitch.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/task_add_screen.dart';
import 'package:loyaltri_minimal/models/task_api_models.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../CWidgets/cwidgets.dart';
import '../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../Manager_Employee/employee_page_controller/employee_page_controller.dart';

class TaskScreen extends StatefulWidget {
  final bool fromEmployee;
  const TaskScreen({super.key, required this.fromEmployee});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    // if(Get.find<ManagerEmployeeController>().allEmployeesCopy.isEmpty) {
    //   await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: true);
    // }
    Get.find<ManagerTaskController>().isFromEmployee = widget.fromEmployee;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: BoxDecoration(
          gradient: widget.fromEmployee ? null : managerViewGradient,
        ),
        child: Scaffold(
          backgroundColor: widget.fromEmployee ? ColorUtils.workEntryHead : Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                if(widget.fromEmployee)
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.h,
                      right: 16.h,
                      top: 15.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14).r,
                          child: Material(
                            color: ColorUtils.foregroundBlack,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 48.h,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.backgroundBlack,
                                  borderRadius: BorderRadius.circular(14).r,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5).h,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: ColorUtils.textWhite,
                                      size: 18.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/manager_view/task-logo.png",
                              height: 20.h,
                            ),
                            SizedBox(width: 10.h),
                            Text(
                              "Task",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14).r,
                          child: Material(
                            color: ColorUtils.secondaryBlue,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14).r,
                              onTap: () {
                                ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                                managerTaskController.activityLogList.value = [];
                                managerTaskController.activityLogList.refresh();
                                managerTaskController.detailedTaskData.value = null;
                                Navigator.of(context).push(
                                  newSlideFromBottomNavigation(TaskAddScreen(taskCreate: true, isDarkMode: widget.fromEmployee)),
                                );
                              },
                              child: Container(
                                width: 48.h,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.textWhite,
                                  borderRadius: BorderRadius.circular(14).r,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: ColorUtils.secondaryBlue,
                                    size: 25.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.h,
                      right: 16.h,
                      top: 10.h,
                    ),
                    child: ManagerScreensAppBar(
                      title: "Task",
                      icon: "assets/images/manager_view/task-logo.png",
                      cancelAction: () {
                        Navigator.of(context).pop();
                      },
                      okAction: () {
                        ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                        managerTaskController.activityLogList.value = [];
                        managerTaskController.activityLogList.refresh();
                        managerTaskController.detailedTaskData.value = null;
                        Navigator.of(context).push(
                          newSlideFromBottomNavigation(TaskAddScreen(taskCreate: true, isDarkMode: widget.fromEmployee)),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.all(12.h),
                  child: TaskTabSwitch(isDarkMode: widget.fromEmployee),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.h,
                  ),
                  child: SearchAndFilter(
                      color: widget.fromEmployee ? ColorUtils.foregroundBlack : ColorUtils.snowGrey,
                      result: (value) {
                        Get.find<ManagerTaskController>().filterTaskList(text: value);
                      },
                      showFilter: true,
                      filterPage: FilterPage.task,
                    isDarkMode: widget.fromEmployee,
                  ),
                ),
                SizedBox(height: 10.h),
                GetX<ManagerTaskController>(
                  builder: (ManagerTaskController controller) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.h,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for(int i = 0; i < controller.filters.value[0].filters.length; i++)
                                if(controller.filters.value[0].filters[i].isSelected)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.h,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6.h,
                                        horizontal: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller.getFilterColors(controller.filters.value[0].filters[i].id),
                                        borderRadius: BorderRadius.circular(5).r,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${controller.filters.value[0].filters[i].name}  ${controller.getFilterCounts(controller.filters.value[0].filters[i].id)}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.workEntryHead,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          InkWell(
                                              onTap: () {
                                                controller.filters.value[0].filters[i].isSelected = false;
                                                controller.filters.refresh();
                                                UserProfileController userProfileController = Get.find<UserProfileController>();
                                                String? companyId;
                                                if(!widget.fromEmployee) {
                                                  companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
                                                } else {
                                                  companyId = userProfileController.userData.value.result.companyId.toString();
                                                }
                                                String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                                                Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId, compId: companyId);
                                              },
                                              child: Icon(Icons.close, size: 15.h, color: ColorUtils.workEntryHead.withValues(alpha: 0.5)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                              for(int j = 0; j < (controller.taskListCounts.value?.assignee?.length ?? 0); j++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10.h,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6.h,
                                      horizontal: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller.getFilterColors(controller.taskListCounts.value?.assignee?[j].id ?? ''),
                                      borderRadius: BorderRadius.circular(5).r,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${controller.taskListCounts.value?.assignee?[j].name ?? '--'}  ${controller.taskListCounts.value?.assignee?[j].count ?? ''}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.workEntryHead,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        SizedBox(width: 4.h),
                                        InkWell(
                                          onTap: () {
                                            for (var element in controller.filters.value[1].filters) {
                                              if (element.id == controller.taskListCounts.value?.assignee?[j].id) {
                                                element.isSelected = false;
                                              }
                                            }
                                            controller.filters.refresh();
                                            UserProfileController userProfileController = Get.find<UserProfileController>();
                                            String? companyId;
                                            if(!widget.fromEmployee) {
                                              companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
                                            } else {
                                              companyId = userProfileController.userData.value.result.companyId.toString();
                                            }
                                            String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                                            Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId, compId: companyId);
                                          },
                                          child: Icon(Icons.close, size: 15.h, color: ColorUtils.workEntryHead.withValues(alpha: 0.5)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.h,
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        UserProfileController userProfileController = Get.find<UserProfileController>();
                        String? companyId;
                        if(!widget.fromEmployee) {
                          companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId?.toString();
                        } else {
                          companyId = userProfileController.userData.value.result.companyId?.toString();
                        }
                        String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
                        await Get.find<ManagerTaskController>().fetchTaskDashboardCount(empId: employeeId, compId: companyId ?? '');
                        await Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId, compId: companyId ?? '');
                      },
                        child: TaskContainer(isDarkMode: widget.fromEmployee),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskContainer extends StatefulWidget {
  final bool isDarkMode;
  const TaskContainer({super.key, required this.isDarkMode});

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !Get.find<ManagerTaskController>().taskNextPageLoading.value) {
        UserProfileController userProfileController = Get.find<UserProfileController>();
        String? companyId;
        if(!widget.isDarkMode) {
          companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId?.toString();
        } else {
          companyId = userProfileController.userData.value.result.companyId?.toString();
        }
        String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
        Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId, compId: companyId ?? '', nextPage: true);
      }
    },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ManagerTaskController>(
      builder: (ManagerTaskController controller) {
        List<TaskData> taskList = controller.taskList.value;
        if(controller.taskLoading.value) {
          return LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Center(
                      child: Text(
                        "Loading...",
                        style: GoogleFonts.inter(
                          color: widget.isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          fontSize: 12.h,
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        } else if(taskList.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 10.h),
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    TaskData task = taskList[index];
                    String dueDate = '--';
                    try {
                      DateTime date = DateTime.parse(task.dueDate ?? '');
                      dueDate = DateFormat('MMM d').format(date);
                    } catch(e) {}
                    return GestureDetector(
                      onTap: () {
                        ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                        managerTaskController.activityLogList.value = [];
                        managerTaskController.activityLogList.refresh();
                        managerTaskController.detailedTaskData.value = null;
                        Navigator.of(context).push(
                          newSlideFromBottomNavigation(TaskAddScreen(taskCreate: false, taskId: task.workEntryId, isDarkMode: widget.isDarkMode)),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                              widget.isDarkMode ? ColorUtils.carbonGrey : task.status?.toLowerCase() == 'completed'
                                  ? Color(0xFFE5F4E9)
                                  : Color(0XFFFEF5E1),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: widget.isDarkMode ? Color(0xFF383838) : task.status?.toLowerCase() == 'completed' ? Color(0xFFB0E3C8) : Color(0xFFF1E3C4),
                                width: 1.h,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 13.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          controller.markingComplete.value = true;
                                          controller.markingTaskId?.value = task.workEntryId?.toString();
                                          setState(() {});
                                          await controller.updateTaskComplete(taskId: task.workEntryId?.toString() ?? '');
                                          setState(() {});
                                        },
                                        child: Image.asset(
                                          task.status == 'completed'
                                              ? 'assets/images/manager_view/tick-circle-green.png'
                                              : 'assets/images/manager_view/mark_complete_icon.png',
                                          height: 22.h,
                                          color: task.status == 'completed' ? widget.isDarkMode ? Colors.green : Color(0xFF014421).withValues(alpha: 0.6) : Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 6.h),
                                      Expanded(
                                        child: Text(
                                          task.workName ?? '--',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.dmSans(
                                            fontSize: 15.h,
                                            fontWeight: FontWeight.w500,
                                            color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.h),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: widget.isDarkMode ? Colors.black : ColorUtils.textWhite,
                                            context: context,
                                            barrierColor: widget.isDarkMode ? ColorUtils.workEntryHead.withValues(alpha: 0.81) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                            builder: (BuildContext context) {
                                              return OptionsBottomSheet(taskId: task.workEntryId, isDarkMode: widget.isDarkMode);
                                            },
                                          );
                                        },
                                          child: Icon(color: Color(0xFF8C6309), Icons.more_horiz, size: 20.h),
                                      ),
                                    ],
                                  ),
                                  if(task.fieldData?.any((element) => element.value?.isNotEmpty ?? false) ?? false)
                                    SizedBox(height: 3.h),
                                  Wrap(
                                    spacing: 8.h,
                                    runSpacing: 8.h,
                                    children: task.fieldData
                                        ?.expand<Options>((element) =>
                                    element.options?.where((option) => element.value?.contains(option.key) ?? false) ?? [])
                                        .map((matchedOption) {

                                      final bgColor = (matchedOption.value != null && matchedOption.value!.isNotEmpty)
                                          ? AttendanceCommonWidgets().hexToColor(matchedOption.value!)
                                          : Colors.grey;

                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: ScreenUtil().screenWidth,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4.h,
                                              horizontal: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              matchedOption.key ?? '--',
                                              style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 12.h,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList() ??
                                        [],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 29.h,
                                            width: 29.h,
                                            padding: EdgeInsets.all(7.h),
                                            decoration: BoxDecoration(
                                              color: widget.isDarkMode ? ColorUtils.notUpdated : ColorUtils.bone,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/manager_view/punch_approval_month.svg',
                                              colorFilter: widget.isDarkMode ? ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn) : null,
                                            ),
                                          ),
                                          SizedBox(width: 6.h),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Due Date',
                                                style: GoogleFonts.dmSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.h,
                                                  color: Color(0xff838383),
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                              Text(
                                                dueDate,
                                                style: GoogleFonts.dmSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.h,
                                                  color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 25.h),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 29.h,
                                              width: 29.h,
                                              decoration: BoxDecoration(
                                                color: ColorUtils.bone,
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(1000).r,
                                                child: CachedNetworkImage(
                                                  imageUrl: task.profilePicture ?? '',
                                                  alignment: Alignment.center,
                                                  placeholder: (context, url) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.grey,
                                                          size: 18.h,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorWidget: (context, url, error) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.grey,
                                                          size: 18.h,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 6.h),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Assigned to',
                                                    style: GoogleFonts.dmSans(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 11.h,
                                                      color: Color(0xff838383),
                                                      letterSpacing: -0.2,
                                                    ),
                                                  ),
                                                  Text(
                                                    task.employeeName ?? '--',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.dmSans(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.h,
                                                      color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                                      letterSpacing: -0.2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 15.h),
                                      InkWell(
                                        onTap: () {
                                          if(task.attachments?.isNotEmpty ?? false) {
                                            showImagePopUp(
                                                mainContext: context,
                                                isDarkMode: widget.isDarkMode,
                                                attachments: task.attachments,
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 24.h,
                                          width: 43.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.r),
                                            color: widget.isDarkMode ? Color(0xFF292929) : Color(0XFFE0DACC),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/AttachPin.svg',
                                                fit: BoxFit.fitHeight,
                                                height: 14.h,
                                                colorFilter: widget.isDarkMode ? ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn) : null,
                                              ),
                                              Text(
                                                task.attachments?.length.toString() ?? "0",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.h,
                                                  color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(controller.markingComplete.value && (controller.markingTaskId?.value == task.workEntryId?.toString()))
                            Positioned.fill(
                              child: Shimmer(
                              direction: ShimmerDirection.ltr,
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.transparent,
                                  widget.isDarkMode ? Colors.green : Color(0xFF014421),
                                  Colors.transparent,
                                ],
                                stops: const [0.1, 0.5, 0.9],
                              ),
                              period: Duration(seconds: 1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: widget.isDarkMode ? 0.1 : 0.5),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                            ),
                            )
                          else
                            Container()
                        ],
                      ),
                    );
                  },
                ),
              ),
              if(controller.taskNextPageLoading.value)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  child: SpinKitFadingCircle(
                    size: 20,
                    color: ColorUtils.royalPurple,
                  ),
                ),
            ],
          );
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Center(
                      child: Text(
                        "No Data Found",
                        style: GoogleFonts.inter(
                          color: widget.isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          fontSize: 12.h,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        }
      },
    );
  }
}

///shimmer
class TaskContainerShimmer extends StatelessWidget {
  const TaskContainerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(19.w),
      child: Container(
        height: 118.h,
        width: 345.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xffF2F3F3),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Shimmer.fromColors(
            baseColor: Color(0xffE3E3E3),
            highlightColor: Color(0xffECE8E8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120.w,
                  height: 17.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 17.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 60.w,
                      height: 17.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 60.w,
                          height: 17.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w),

                    Row(
                      children: [
                        Container(
                          width: 34.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 60.w,
                          height: 17.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
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
    );
  }
}
