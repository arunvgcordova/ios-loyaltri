import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Employee/Manager_Employee_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../models/goals_and_subgoals_model.dart';
import '../../../../models/manager/all_employee_list.dart';
import '../../../../models/task_api_models.dart';
import '../../../CWidgets/date_picker.dart';
import '../../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../../Leave_Page/leave_widgets/leave_type_card.dart';

class TaskAddScreen extends StatefulWidget {
  final bool taskCreate;
  final bool? fromGoals;
  final bool? subGoalCreate;
  final bool? subGoalEdit;
  final int? taskId;
  final bool isDarkMode;
  const TaskAddScreen({
    super.key,
    required this.taskCreate,
    this.taskId,
    required this.isDarkMode,
    this.subGoalCreate,
    this.subGoalEdit,
    this.fromGoals,
  });

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  bool showAssigneeValidation = false;
  TextEditingController _workNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ManagerTaskController managerTaskController =
      Get.find<ManagerTaskController>();
  GrowthController growthController = Get.find<GrowthController>();
  ValueNotifier<bool> isOpen = ValueNotifier(false);
  ValueNotifier<bool> taskNameValidator = ValueNotifier(false);
  ValueNotifier<bool> assigneeValidation = ValueNotifier(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initialize();
    });
    super.initState();
  }

  Future<void> _initialize() async {
    context.loaderOverlay.show();
    showAssigneeValidation = (widget.fromGoals ?? false) && (widget.subGoalCreate ?? false) == true;
    managerTaskController.draftTaskData.value = CreateTaskModel();
    await managerTaskController.deleteAllFilesInDirectory();
    if (widget.taskCreate) {
      await Get.find<ManagerTaskController>().fetchTaskExtraFieldData(
        callTimePeriod: widget.subGoalCreate ?? widget.subGoalEdit ?? false,
      );
    } else {
      await Get.find<ManagerTaskController>().fetchTaskDetailedResp(
        taskId: widget.taskId?.toString() ?? '',
      );
    }

    if (widget.subGoalEdit ?? false) {
      managerTaskController.draftTaskData.value.workName =
          growthController.subGoalDetails.value?.goalTitile;
      managerTaskController.draftTaskData.value.assignedToName =
          growthController.subGoalDetails.value?.assignedEmployee;
      managerTaskController.draftTaskData.value.assignedToId = growthController
          .subGoalDetails
          .value
          ?.assignedEmployeeId
          ?.toString();
      managerTaskController.draftTaskData.value.assignedToImage =
          growthController.subGoalDetails.value?.assignedEmployeeProfile;
      managerTaskController.draftTaskData.value.dueDate =
          growthController.subGoalDetails.value?.goalDueDate;
      managerTaskController.draftTaskData.value.description =
          growthController.subGoalDetails.value?.goalDescription;
      managerTaskController.draftTaskData.value.fieldData?.forEach((element) {
        if (element.fieldName == 'Time Period') {
          element.options?.forEach((e) {
            List<String> optionParts = e.key?.split('<#>') ?? [];
            String? opt;
            if (optionParts.isNotEmpty) {
              opt = optionParts.last;
            }

            if (opt == growthController.subGoalDetails.value?.goalTimePeriod) {
              managerTaskController.draftTaskData.value.timePeriodValue = opt;
              element.value = e.key != null ? [e.key!] : [];
            }
          });
        }
      });
    }

    if (growthController.subGoalDetails.value != null) {
      List<FieldData> data =
          managerTaskController.draftTaskData.value.fieldData
              ?.where((element) => element.fieldName == 'Subgoal')
              .toList() ??
          [];
      managerTaskController.draftTaskData.value.fieldData?.removeWhere(
        (element) => element.fieldName == 'Subgoal',
      );
      if (data.isNotEmpty) {
        List<Options> options =
            data.first.options?.where((element) {
              List<String> optionParts = element.key?.split('<#>') ?? [];
              String? opt;
              if (optionParts.isNotEmpty) {
                opt = optionParts.first;
              }
              if (opt == growthController.subGoalDetails.value?.goalTitile) {
                return true;
              } else {
                return false;
              }
            }).toList() ??
            [];
        if (options.isNotEmpty) {
          List<String> optionParts = options.first.key?.split('<#>') ?? [];
          String? opt;
          if (optionParts.isNotEmpty) {
            opt = optionParts.last;
          }
          data.first.value = [options.first.key!];
          managerTaskController.draftTaskData.value.subGoalId = opt;
          managerTaskController.draftTaskData.value.fieldData?.insert(
            0,
            data.first,
          );
        }
      }
    }
    context.loaderOverlay.hide();
    _workNameController = TextEditingController(
      text: managerTaskController.draftTaskData.value.workName,
    );
    _descriptionController = TextEditingController(
      text: managerTaskController.draftTaskData.value.description,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isSubGoalCreate = widget.subGoalCreate ?? widget.subGoalEdit ?? false;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        isOpen.value = false;
      },
      child: PopScope(
        canPop:
            !managerTaskController.markingComplete.value &&
            !managerTaskController.submitLoading.value,
        child: SafeArea(
          top: false,
          bottom: true,
          left: false,
          right: false,
          child: Scaffold(
            backgroundColor: widget.isDarkMode
                ? ColorUtils.workEntryHead
                : ColorUtils.textWhite,
            body: SafeArea(
              top: true,
              bottom: false,
              left: false,
              right: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 14.h,
                      right: 14.h,
                      top: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isSubGoalCreate && !(widget.fromGoals ?? false))
                          GestureDetector(
                            onTap: () async {
                              if (!managerTaskController
                                      .markingComplete
                                      .value &&
                                  !managerTaskController.submitLoading.value &&
                                  managerTaskController
                                          .draftTaskData
                                          .value
                                          .assignedToId !=
                                      null) {
                                await managerTaskController.updateTaskComplete(
                                  taskId: widget.taskId?.toString() ?? '',
                                );
                              }
                            },
                            child: Container(
                              height: 48.h,
                              width: 48.h,
                              padding: EdgeInsets.all(12.h),
                              decoration: BoxDecoration(
                                color: widget.isDarkMode
                                    ? ColorUtils.paleLavenderMist
                                    : Color(0xFFF4F1F9),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(
                                child: Obx(() {
                                  String? status = managerTaskController
                                      .detailedTaskData
                                      .value
                                      ?.status
                                      ?.toString()
                                      .toLowerCase();
                                  if (managerTaskController
                                      .markingComplete
                                      .value) {
                                    return SizedBox(
                                      width: 18.h,
                                      height: 18.h,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Image.asset(
                                      status == 'completed'
                                          ? 'assets/images/manager_view/tick-circle-green.png'
                                          : 'assets/images/manager_view/tick-circle-outlined-grey.png',
                                    );
                                  }
                                }),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 48.h,
                            width: 48.h,
                            color: Colors.transparent,
                          ),
                        // if(isSubGoalCreate)
                        //   Container(
                        //   height: 48.h,
                        //   width: 48.h,
                        //   decoration: BoxDecoration(
                        //     color: Colors.transparent,
                        //     borderRadius: BorderRadius.circular(14.r),
                        //     border: Border.all(
                        //       color: Colors.transparent,
                        //     ),
                        //   ),
                        // ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isSubGoalCreate)
                              Image.asset(
                                "assets/images/manager_view/task-logo.png",
                                fit: BoxFit.fitHeight,
                                width: 23.h,
                              ),
                            if (!isSubGoalCreate) SizedBox(width: 6.h),
                            Text(
                              isSubGoalCreate
                                  ? (widget.subGoalEdit ?? false)
                                        ? 'Update Sub-goal'
                                        : 'Create Sub-goal'
                                  : 'Create Task',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                                color: widget.isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.workEntryHead,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: 48.h,
                            width: 48.h,
                            decoration: BoxDecoration(
                              color: widget.isDarkMode
                                  ? ColorUtils.jetGrey
                                  : ColorUtils.textWhite,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: ColorUtils.charcoalBlue.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 23.h,
                                color: widget.isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.workEntryHead,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  if (!isSubGoalCreate)
                    Obx(() {
                      String? status = managerTaskController
                          .detailedTaskData
                          .value
                          ?.status
                          ?.toString()
                          .toLowerCase();
                      if (status == 'completed') {
                        return Container(
                          height: 31.h,
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode ? Color(0xFF2D7041) : null,
                            gradient: widget.isDarkMode
                                ? null
                                : LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF73B386),
                                      Color(0xFF4DB36C),
                                    ],
                                  ),
                          ),
                          child: Center(
                            child: Text(
                              'COMPLETED',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _initialize();
                      },
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 14.h, right: 14.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10.h),
                                ValueListenableBuilder(
                                  valueListenable: taskNameValidator,
                                  builder: (context, validator, child) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 18.h),
                                      decoration: BoxDecoration(
                                        color: widget.isDarkMode
                                            ? ColorUtils.jetGrey
                                            : ColorUtils.paleLavenderMist,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12).r,
                                        ),
                                        border: Border.all(
                                          color: validator
                                              ? Colors.red
                                              : widget.isDarkMode
                                              ? ColorUtils.textWhite.withValues(
                                                  alpha: 0.1,
                                                )
                                              : ColorUtils.workEntryHead
                                                    .withValues(alpha: 0.1),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _workNameController,
                                        onChanged: (value) {
                                          managerTaskController
                                                  .draftTaskData
                                                  .value
                                                  .workName =
                                              value;
                                          if(taskNameValidator.value) {
                                            validateFields();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12).r,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12).r,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          fillColor: widget.isDarkMode
                                              ? ColorUtils.jetGrey
                                              : ColorUtils.paleLavenderMist,
                                          filled: true,
                                          label: Text.rich(
                                            TextSpan(
                                              text: isSubGoalCreate
                                                  ? 'Sub-goal Title '
                                                  : "Task Name ",
                                              style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.h,
                                                color: validator
                                                    ? Colors.red
                                                    : widget.isDarkMode
                                                    ? ColorUtils.textWhite
                                                    : ColorUtils.obsidianGrey,
                                                letterSpacing: -0.2,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '*',
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.h,
                                                    color: Colors.red,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // label: Text(
                                          //   isSubGoalCreate
                                          //       ? 'Sub-goal Title *'
                                          //       : "Task Name *",
                                          //   style: GoogleFonts.dmSans(
                                          //     fontWeight: FontWeight.w400,
                                          //     fontSize: 16.h,
                                          //     color: validator
                                          //         ? Colors.red
                                          //         : widget.isDarkMode
                                          //         ? ColorUtils.textWhite
                                          //         : ColorUtils.obsidianGrey,
                                          //     letterSpacing: -0.2,
                                          //   ),
                                          // ),
                                          hintText: isSubGoalCreate
                                              ? 'Enter sub-goal title...'
                                              : 'Write a task name',
                                          hintStyle: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.h,
                                            color: validator
                                                ? Colors.red.withValues(
                                                    alpha: 0.5,
                                                  )
                                                : widget.isDarkMode
                                                ? ColorUtils.textWhite
                                                      .withValues(alpha: 0.5)
                                                : ColorUtils.workEntryHead
                                                      .withValues(alpha: 0.5),
                                            letterSpacing: -0.2,
                                          ),
                                          contentPadding: EdgeInsets.all(15.h),
                                        ),
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.h,
                                          color: widget.isDarkMode
                                              ? ColorUtils.textWhite
                                              : ColorUtils.workEntryHead,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: taskNameValidator,
                                  builder: (context, validator, child) {
                                    if (!validator) return SizedBox.shrink();
                                    return Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 4.h),
                                          Text(
                                              '${isSubGoalCreate ? 'Sub-goal title' : 'Task name'} is required.',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 13.h,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 14.h),
                                Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.h),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                newSlideNavigation(
                                                  ManagerEmployeePage(
                                                    isSelectEmployee: true,
                                                    isDarkMode:
                                                        widget.isDarkMode,
                                                    onSelected:
                                                        (
                                                          CompanyEmployeeData
                                                          employee,
                                                        ) {
                                                          managerTaskController
                                                                  .draftTaskData
                                                                  .value
                                                                  .assignedToName =
                                                              employee.fullName;
                                                          managerTaskController
                                                                  .draftTaskData
                                                                  .value
                                                                  .assignedToId =
                                                              employee
                                                                  .employeeId;
                                                          managerTaskController
                                                                  .draftTaskData
                                                                  .value
                                                                  .assignedToImage =
                                                              employee
                                                                  .profilePicture;
                                                          print(
                                                            '----assignedToId----${managerTaskController.draftTaskData.value.assignedToId}',
                                                          );
                                                          managerTaskController
                                                              .draftTaskData
                                                              .refresh();

                                                          if(showAssigneeValidation && assigneeValidation.value) {
                                                            validateFields();
                                                          }
                                                        },
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ValueListenableBuilder(
                                                valueListenable: assigneeValidation,
                                                builder: (context, validator, child) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Assignee',
                                                          style: GoogleFonts.dmSans(
                                                            fontSize: 13.h,
                                                            fontWeight: FontWeight.w400,
                                                            color: showAssigneeValidation && validator ? Colors.red : widget.isDarkMode
                                                                ? ColorUtils.textWhite
                                                                : ColorUtils
                                                                      .obsidianGrey,
                                                          ),
                                                        ),
                                                        if(isSubGoalCreate)
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 2.h),
                                                            child: Text(
                                                            ' *',
                                                            style: GoogleFonts.dmSans(
                                                              fontSize: 13.h,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.red,
                                                            ),
                                                                                                                    ),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 46.h,
                                                          width: 46.h,
                                                          decoration: BoxDecoration(
                                                            color: ColorUtils.bone,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  1000,
                                                                ).r,
                                                            child: Obx(() {
                                                              return CachedNetworkImage(
                                                                imageUrl:
                                                                    managerTaskController
                                                                        .draftTaskData
                                                                        .value
                                                                        .assignedToImage ??
                                                                    '',
                                                                alignment: Alignment
                                                                    .center,
                                                                placeholder: (context, url) {
                                                                  return Container(
                                                                    height: 46.h,
                                                                    width: 46.h,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          13.h,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          widget
                                                                              .isDarkMode
                                                                          ? ColorUtils
                                                                                .jetGrey
                                                                          : ColorUtils
                                                                                .paleLavenderMist,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Image.asset(
                                                                      'assets/images/penrson_icon2.png',
                                                                      color:
                                                                      showAssigneeValidation && validator ? Colors.red : widget
                                                                              .isDarkMode
                                                                          ? ColorUtils
                                                                                .textWhite
                                                                          : ColorUtils
                                                                                .workEntryHead,
                                                                    ),
                                                                  );
                                                                },
                                                                errorWidget: (context, url, error) {
                                                                  return Container(
                                                                    height: 46.h,
                                                                    width: 46.h,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          13.h,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                      widget
                                                                              .isDarkMode
                                                                          ? ColorUtils
                                                                                .jetGrey
                                                                          : ColorUtils
                                                                                .paleLavenderMist,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Image.asset(
                                                                      'assets/images/penrson_icon2.png',
                                                                      color:
                                                                      showAssigneeValidation && validator ? Colors.red : widget
                                                                              .isDarkMode
                                                                          ? ColorUtils
                                                                                .textWhite
                                                                          : ColorUtils
                                                                                .workEntryHead,
                                                                    ),
                                                                  );
                                                                },
                                                                fit: BoxFit.cover,
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.h),
                                                        Expanded(
                                                          child: Obx(() {
                                                            String assignee =
                                                                managerTaskController
                                                                    .draftTaskData
                                                                    .value
                                                                    .assignedToName
                                                                    ?.toString()
                                                                    .trim() ??
                                                                '';
                                                            return Text(
                                                              assignee.isNotEmpty
                                                                  ? assignee
                                                                  : 'Unassigned',
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: GoogleFonts.dmSans(
                                                                fontWeight:
                                                                    FontWeight.w400,
                                                                color:
                                                                showAssigneeValidation && validator ? Colors.red : widget
                                                                        .isDarkMode
                                                                    ? ColorUtils
                                                                          .textWhite
                                                                          .withValues(
                                                                            alpha:
                                                                                assignee.isNotEmpty
                                                                                ? 1.0
                                                                                : 0.4,
                                                                          )
                                                                    : ColorUtils
                                                                          .eerieBlack
                                                                          .withValues(
                                                                            alpha:
                                                                                assignee.isNotEmpty
                                                                                ? 1.0
                                                                                : 0.4,
                                                                          ),
                                                                fontSize: 13.h,
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.h),
                                      if (widget.fromGoals ?? false)
                                        if (!isSubGoalCreate)
                                          GestureDetector(
                                            onTap: () async {
                                              DateTime? picked = await pickDate(
                                                context,
                                                widget.isDarkMode
                                                    ? ThemeMode.dark
                                                    : ThemeMode.light,
                                                firstDate: DateTime(
                                                  DateTime.now().year - 85,
                                                ),
                                                lastDate: DateTime(
                                                  DateTime.now().year + 2,
                                                ),
                                              );
                                              if (picked != null) {
                                                managerTaskController
                                                    .draftTaskData
                                                    .value
                                                    .dueDate = DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(picked);
                                                managerTaskController
                                                    .draftTaskData
                                                    .refresh();
                                              }
                                              // showDialog(
                                              //   context: context,
                                              //   useSafeArea: true,
                                              //   barrierColor: Colors.transparent,
                                              //   builder: (context) {
                                              //     return Dialog(
                                              //       alignment: Alignment.center,
                                              //       insetPadding: EdgeInsets.zero,
                                              //       backgroundColor: Colors.transparent,
                                              //       child: SizedBox(
                                              //         height: ScreenUtil().screenHeight / 2,
                                              //         width: ScreenUtil().screenWidth * 0.9,
                                              //         child: Column(
                                              //           children: [
                                              //             Spacer(),
                                              //             LeaveCalender(
                                              //               isRangeSelection: false,
                                              //               leaveDates: (LeaveDates leaveDays) {
                                              //                 // leaveStart.value = leaveDays.startDate;
                                              //                 // leaveEnd.value = leaveDays.endDate;
                                              //                 if(leaveDays.startDate != null) {
                                              //                   managerTaskController.draftTaskData.value.dueDate = DateFormat('yyyy-MM-dd').format(leaveDays.startDate!);
                                              //                   managerTaskController.draftTaskData.refresh();
                                              //                 }
                                              //               },
                                              //               onMonthChange: (DateTime date) {
                                              //                 // currentDate.value = date;
                                              //               },
                                              //             ),
                                              //             Spacer(),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     );
                                              //   },
                                              // );
                                            },
                                            child: SizedBox(
                                              width:
                                                  (ScreenUtil().screenWidth /
                                                      2) -
                                                  30.h,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 10.h,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Due date',
                                                      style: GoogleFonts.dmSans(
                                                        fontSize: 13.h,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: widget.isDarkMode
                                                            ? ColorUtils
                                                                  .textWhite
                                                            : ColorUtils
                                                                  .obsidianGrey,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 46.h,
                                                          width: 46.h,
                                                          padding:
                                                              EdgeInsets.all(
                                                                13.h,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                widget
                                                                    .isDarkMode
                                                                ? ColorUtils
                                                                      .jetGrey
                                                                : ColorUtils
                                                                      .paleLavenderMist,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/manager_view/punch_approval_month.svg',
                                                            colorFilter: ColorFilter.mode(
                                                              widget.isDarkMode
                                                                  ? ColorUtils
                                                                        .textWhite
                                                                  : ColorUtils
                                                                        .workEntryHead,
                                                              BlendMode.srcIn,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.h),
                                                        Obx(() {
                                                          String? date;
                                                          try {
                                                            date = DateFormat('d MMMM').format(
                                                              DateTime.parse(
                                                                managerTaskController
                                                                        .draftTaskData
                                                                        .value
                                                                        .dueDate ??
                                                                    '',
                                                              ),
                                                            );
                                                          } catch (e) {}
                                                          return Text(
                                                            date ?? 'DD MM',
                                                            style: GoogleFonts.dmSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  widget
                                                                      .isDarkMode
                                                                  ? ColorUtils.textWhite.withValues(
                                                                      alpha:
                                                                          date !=
                                                                              null
                                                                          ? 1.0
                                                                          : 0.4,
                                                                    )
                                                                  : ColorUtils.eerieBlack.withValues(
                                                                      alpha:
                                                                          date !=
                                                                              null
                                                                          ? 1.0
                                                                          : 0.4,
                                                                    ),
                                                              fontSize: 13.h,
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          SizedBox.shrink()
                                      else
                                        GestureDetector(
                                          onTap: () async {
                                            DateTime? picked = await pickDate(
                                              context,
                                              widget.isDarkMode
                                                  ? ThemeMode.dark
                                                  : ThemeMode.light,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(
                                                DateTime.now().year + 2,
                                              ),
                                            );
                                            if (picked != null) {
                                              managerTaskController
                                                  .draftTaskData
                                                  .value
                                                  .dueDate = DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(picked);
                                              managerTaskController
                                                  .draftTaskData
                                                  .refresh();
                                            }
                                            // showDialog(
                                            //   context: context,
                                            //   useSafeArea: true,
                                            //   barrierColor: Colors.transparent,
                                            //   builder: (context) {
                                            //     return Dialog(
                                            //       alignment: Alignment.center,
                                            //       insetPadding: EdgeInsets.zero,
                                            //       backgroundColor: Colors.transparent,
                                            //       child: SizedBox(
                                            //         height: ScreenUtil().screenHeight / 2,
                                            //         width: ScreenUtil().screenWidth * 0.9,
                                            //         child: Column(
                                            //           children: [
                                            //             Spacer(),
                                            //             LeaveCalender(
                                            //               isRangeSelection: false,
                                            //               leaveDates: (LeaveDates leaveDays) {
                                            //                 // leaveStart.value = leaveDays.startDate;
                                            //                 // leaveEnd.value = leaveDays.endDate;
                                            //                 if(leaveDays.startDate != null) {
                                            //                   managerTaskController.draftTaskData.value.dueDate = DateFormat('yyyy-MM-dd').format(leaveDays.startDate!);
                                            //                   managerTaskController.draftTaskData.refresh();
                                            //                 }
                                            //               },
                                            //               onMonthChange: (DateTime date) {
                                            //                 // currentDate.value = date;
                                            //               },
                                            //             ),
                                            //             Spacer(),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            // );
                                          },
                                          child: SizedBox(
                                            width:
                                                (ScreenUtil().screenWidth / 2) -
                                                30.h,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 10.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Due date',
                                                    style: GoogleFonts.dmSans(
                                                      fontSize: 13.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: widget.isDarkMode
                                                          ? ColorUtils.textWhite
                                                          : ColorUtils
                                                                .obsidianGrey,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 46.h,
                                                        width: 46.h,
                                                        padding: EdgeInsets.all(
                                                          13.h,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              widget.isDarkMode
                                                              ? ColorUtils
                                                                    .jetGrey
                                                              : ColorUtils
                                                                    .paleLavenderMist,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          'assets/images/manager_view/punch_approval_month.svg',
                                                          colorFilter: ColorFilter.mode(
                                                            widget.isDarkMode
                                                                ? ColorUtils
                                                                      .textWhite
                                                                : ColorUtils
                                                                      .workEntryHead,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.h),
                                                      Obx(() {
                                                        String? date;
                                                        try {
                                                          date =
                                                              DateFormat(
                                                                'd MMMM',
                                                              ).format(
                                                                DateTime.parse(
                                                                  managerTaskController
                                                                          .draftTaskData
                                                                          .value
                                                                          .dueDate ??
                                                                      '',
                                                                ),
                                                              );
                                                        } catch (e) {}
                                                        return Text(
                                                          date ?? 'DD MM',
                                                          style: GoogleFonts.dmSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                widget
                                                                    .isDarkMode
                                                                ? ColorUtils
                                                                      .textWhite
                                                                      .withValues(
                                                                        alpha:
                                                                            date !=
                                                                                null
                                                                            ? 1.0
                                                                            : 0.4,
                                                                      )
                                                                : ColorUtils
                                                                      .eerieBlack
                                                                      .withValues(
                                                                        alpha:
                                                                            date !=
                                                                                null
                                                                            ? 1.0
                                                                            : 0.4,
                                                                      ),
                                                            fontSize: 13.h,
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: assigneeValidation,
                                  builder: (context, validator, child) {
                                    if (!validator) return SizedBox.shrink();
                                    return Padding(
                                      padding: EdgeInsets.only(top: 6.h),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 6.h),
                                          Text(
                                            'Assignee is Required',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 13.h,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 8.h),
                                if (isSubGoalCreate) SizedBox(height: 8.h),
                                if (isSubGoalCreate)
                                  Container(
                                    padding: EdgeInsets.only(top: 18.h),
                                    decoration: BoxDecoration(
                                      color: widget.isDarkMode
                                          ? ColorUtils.jetGrey.withValues(
                                              alpha: 0.5,
                                            )
                                          : ColorUtils.paleLavenderMist,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12).r,
                                      ),
                                      border: Border.all(
                                        color: widget.isDarkMode
                                            ? ColorUtils.textWhite.withValues(
                                                alpha: 0.05,
                                              )
                                            : ColorUtils.workEntryHead
                                                  .withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: TextEditingController(
                                        text:
                                            growthController
                                                .goalDetails
                                                .value
                                                ?.goalTitile ??
                                            '--',
                                      ),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12).r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12).r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        fillColor: widget.isDarkMode
                                            ? ColorUtils.jetGrey.withValues(
                                                alpha: 0,
                                              )
                                            : ColorUtils.paleLavenderMist,
                                        filled: true,
                                        label: Text.rich(
                                          TextSpan(
                                            text: 'Linked Goal ',
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.h,
                                              color: widget.isDarkMode
                                                  ? ColorUtils.textWhite
                                                  : ColorUtils.obsidianGrey,
                                              letterSpacing: -0.2,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '*',
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 16.h,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        hintText: "--",
                                        hintStyle: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.h,
                                          color: widget.isDarkMode
                                              ? ColorUtils.textWhite.withValues(
                                                  alpha: 0.5,
                                                )
                                              : ColorUtils.workEntryHead
                                                    .withValues(alpha: 0.5),
                                          letterSpacing: -0.2,
                                        ),
                                        contentPadding: EdgeInsets.all(15.h),
                                      ),
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: widget.isDarkMode
                                            ? ColorUtils.textWhite
                                            : ColorUtils.workEntryHead,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                GetX<ManagerTaskController>(
                                  builder: (ManagerTaskController controller) {
                                    List<FieldData> extraFields =
                                        controller
                                            .draftTaskData
                                            .value
                                            .fieldData ??
                                        [];
                                    return Column(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < extraFields.length;
                                          i++
                                        )
                                          if (extraFields[i].fieldType ==
                                              'radio')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10.h),
                                                      Text(
                                                        extraFields[i]
                                                                .fieldName ??
                                                            '--',
                                                        style: GoogleFonts.dmSans(
                                                          fontSize: 13.h,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              widget.isDarkMode
                                                              ? ColorUtils
                                                                    .textWhite
                                                              : ColorUtils
                                                                    .obsidianGrey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10.h,
                                                      top: 8.h,
                                                    ),
                                                    child: Wrap(
                                                      spacing: 10.h,
                                                      runSpacing: 10.h,
                                                      children:
                                                          extraFields[i].options?.map((
                                                            option,
                                                          ) {
                                                            return customRadio(
                                                              label:
                                                                  option.key ??
                                                                  '--',
                                                              value:
                                                                  option.key ??
                                                                  '',
                                                              color:
                                                                  option
                                                                      .value ??
                                                                  '',
                                                              groupValue:
                                                                  (extraFields[i]
                                                                          .value
                                                                          ?.isNotEmpty ??
                                                                      false)
                                                                  ? extraFields[i]
                                                                            .value
                                                                            ?.first ??
                                                                        ''
                                                                  : '',
                                                              onTap: () {
                                                                extraFields[i]
                                                                    .value = [
                                                                  option.key!,
                                                                ];
                                                                controller
                                                                    .draftTaskData
                                                                    .refresh();
                                                              },
                                                            );
                                                          }).toList() ??
                                                          [],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else if (extraFields[i].fieldType ==
                                              'text')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: 18.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: widget.isDarkMode
                                                      ? ColorUtils.jetGrey
                                                      : ColorUtils
                                                            .paleLavenderMist,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(12).r,
                                                      ),
                                                  border: Border.all(
                                                    color: widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                              .withValues(
                                                                alpha: 0.1,
                                                              )
                                                        : ColorUtils
                                                              .workEntryHead
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  controller: extraFields[i]
                                                      .textEditingController,
                                                  onChanged: (value) {
                                                    extraFields[i].value = [
                                                      value,
                                                    ];
                                                    controller.draftTaskData
                                                        .refresh();
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  12,
                                                                ).r,
                                                              ),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  12,
                                                                ).r,
                                                              ),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    fillColor: widget.isDarkMode
                                                        ? ColorUtils.jetGrey
                                                        : ColorUtils
                                                              .paleLavenderMist,
                                                    filled: true,
                                                    label: Text(
                                                      extraFields[i]
                                                              .fieldName ??
                                                          '--',
                                                      style: GoogleFonts.dmSans(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.h,
                                                        color: widget.isDarkMode
                                                            ? ColorUtils
                                                                  .textWhite
                                                            : ColorUtils
                                                                  .obsidianGrey,
                                                        letterSpacing: -0.2,
                                                      ),
                                                    ),
                                                    hintText: 'Enter',
                                                    hintStyle: GoogleFonts.dmSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13.h,
                                                      color: widget.isDarkMode
                                                          ? ColorUtils.textWhite
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                )
                                                          : ColorUtils
                                                                .workEntryHead
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                      letterSpacing: -0.2,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(15.h),
                                                  ),
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.h,
                                                    color: widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                        : ColorUtils
                                                              .workEntryHead,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else if (extraFields[i].fieldType ==
                                              'checkbox')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10.h),
                                                      Text(
                                                        extraFields[i]
                                                                .fieldName ??
                                                            '--',
                                                        style: GoogleFonts.dmSans(
                                                          fontSize: 13.h,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              widget.isDarkMode
                                                              ? ColorUtils
                                                                    .textWhite
                                                              : ColorUtils
                                                                    .obsidianGrey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10.h,
                                                      top: 8.h,
                                                    ),
                                                    child: Wrap(
                                                      spacing: 10.0,
                                                      runSpacing: 10.0,
                                                      children:
                                                          extraFields[i].options?.map((
                                                            option,
                                                          ) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                if (!(extraFields[i]
                                                                            .value ??
                                                                        [])
                                                                    .contains(
                                                                      option
                                                                          .key,
                                                                    )) {
                                                                  extraFields[i]
                                                                      .value
                                                                      ?.add(
                                                                        option
                                                                            .key!,
                                                                      );
                                                                } else {
                                                                  extraFields[i]
                                                                      .value
                                                                      ?.remove(
                                                                        option
                                                                            .key!,
                                                                      );
                                                                }
                                                                controller
                                                                    .draftTaskData
                                                                    .refresh();
                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    AnimatedContainer(
                                                                      duration: const Duration(
                                                                        milliseconds:
                                                                            500,
                                                                      ),
                                                                      curve: Curves
                                                                          .fastLinearToSlowEaseIn,
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            (extraFields[i].value ??
                                                                                    [])
                                                                                .contains(
                                                                                  option.key,
                                                                                )
                                                                            ? AttendanceCommonWidgets().hexToColor(
                                                                                    option.value,
                                                                                  ) ??
                                                                                  ColorUtils.secondaryBlue
                                                                            : ColorUtils.paleLilac,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              5,
                                                                            ).r,
                                                                        border: Border.all(
                                                                          color:
                                                                              (extraFields[i].value ??
                                                                                      [])
                                                                                  .contains(
                                                                                    option.key,
                                                                                  )
                                                                              ? AttendanceCommonWidgets().hexToColor(
                                                                                      option.value,
                                                                                    ) ??
                                                                                    ColorUtils.secondaryBlue
                                                                              : ColorUtils.silverGrey,
                                                                          width:
                                                                              0.5.h,
                                                                        ),
                                                                      ),
                                                                      width:
                                                                          16.h,
                                                                      height:
                                                                          16.h,
                                                                      child:
                                                                          (extraFields[i].value ??
                                                                                  [])
                                                                              .contains(
                                                                                option.key,
                                                                              )
                                                                          ? Icon(
                                                                              Icons.check,
                                                                              color: Colors.white,
                                                                              size: 12.h,
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          8.h,
                                                                    ),
                                                                    Text(
                                                                      option.key ??
                                                                          '',
                                                                      style: GoogleFonts.dmSans(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color:
                                                                            (extraFields[i].value ??
                                                                                    [])
                                                                                .contains(
                                                                                  option.key,
                                                                                )
                                                                            ? AttendanceCommonWidgets().hexToColor(
                                                                                    option.value,
                                                                                  ) ??
                                                                                  (widget.isDarkMode
                                                                                      ? ColorUtils.textWhite
                                                                                      : ColorUtils.eerieBlack)
                                                                            : widget.isDarkMode
                                                                            ? ColorUtils.textWhite.withValues(
                                                                                alpha: 0.6,
                                                                              )
                                                                            : ColorUtils.eerieBlack.withValues(
                                                                                alpha: 0.6,
                                                                              ),
                                                                        fontSize:
                                                                            12.h,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          8.h,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }).toList() ??
                                                          [],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else if (extraFields[i].fieldType ==
                                              'multipleChoice')
                                            ValueListenableBuilder(
                                              valueListenable: isOpen,
                                              builder: (context, value, child) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => setState(
                                                          () => isOpen.value =
                                                              !isOpen.value,
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color:
                                                                widget
                                                                    .isDarkMode
                                                                ? ColorUtils
                                                                      .jetGrey
                                                                : ColorUtils
                                                                      .paleLavenderMist,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ).r,
                                                            border: Border.all(
                                                              color:
                                                                  widget
                                                                      .isDarkMode
                                                                  ? ColorUtils
                                                                        .textWhite
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        )
                                                                  : ColorUtils
                                                                        .workEntryHead
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        ),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      13.h,
                                                                  vertical:
                                                                      10.h,
                                                                ).h,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      extraFields[i]
                                                                              .fieldName ??
                                                                          '--',
                                                                      style: GoogleFonts.dmSans(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            13.h,
                                                                        color:
                                                                            widget.isDarkMode
                                                                            ? ColorUtils.textWhite
                                                                            : ColorUtils.obsidianGrey,
                                                                        letterSpacing:
                                                                            -0.2,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 2.h,
                                                                ),

                                                                Row(
                                                                  children: [
                                                                    if ((extraFields[i].value ??
                                                                            [])
                                                                        .isEmpty)
                                                                      Text(
                                                                        'Select ${extraFields[i].fieldName ?? ''}',
                                                                        style: GoogleFonts.dmSans(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              13.h,
                                                                          color:
                                                                              widget.isDarkMode
                                                                              ? ColorUtils.textWhite.withValues(
                                                                                  alpha: 0.5,
                                                                                )
                                                                              : ColorUtils.workEntryHead.withValues(
                                                                                  alpha: 0.5,
                                                                                ),
                                                                          letterSpacing:
                                                                              -0.2,
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    children: [
                                                                      // Chips OR placeholder text
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                          right:
                                                                              30.h,
                                                                        ), // space for search icon
                                                                        child: Wrap(
                                                                          spacing:
                                                                              6,
                                                                          children:
                                                                              (extraFields[i].value ??
                                                                                      [])
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) {
                                                                                      return Theme(
                                                                                        data: ThemeData(
                                                                                          splashColor: Colors.transparent,
                                                                                        ),
                                                                                        child: Chip(
                                                                                          shadowColor: Colors.transparent,
                                                                                          padding: EdgeInsets.zero,
                                                                                          surfaceTintColor: Colors.transparent,
                                                                                          labelPadding: EdgeInsets.only(
                                                                                            left: 14.h,
                                                                                          ),
                                                                                          color: WidgetStatePropertyAll(
                                                                                            widget.isDarkMode
                                                                                                ? ColorUtils.workEntryHead.withValues(
                                                                                                    alpha: 0.5,
                                                                                                  )
                                                                                                : ColorUtils.filterFlag.withValues(
                                                                                                    alpha: 0.3,
                                                                                                  ),
                                                                                          ),
                                                                                          shape: StadiumBorder(),
                                                                                          label: Text(
                                                                                            item,
                                                                                            style: TextStyle(
                                                                                              fontSize: 12.h,
                                                                                              color: widget.isDarkMode
                                                                                                  ? ColorUtils.textWhite
                                                                                                  : ColorUtils.secondaryBlue,
                                                                                            ),
                                                                                          ),
                                                                                          deleteIcon: Icon(
                                                                                            Icons.close,
                                                                                            size: 15.h,
                                                                                            color: ColorUtils.secondaryBlue,
                                                                                          ),
                                                                                          onDeleted: () {
                                                                                            extraFields[i].value?.remove(
                                                                                              item,
                                                                                            );
                                                                                            controller.draftTaskData.refresh();
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  )
                                                                                  .toList(),
                                                                        ),
                                                                      ),

                                                                      // Search icon right aligned
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0,
                                                                        child: Center(
                                                                          child: Icon(
                                                                            Icons.search,
                                                                            size:
                                                                                25.h,
                                                                            color:
                                                                                Colors.transparent,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      // ---------- Dropdown List ----------
                                                      if (value)
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                top: 6,
                                                              ).h,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                widget
                                                                    .isDarkMode
                                                                ? ColorUtils
                                                                      .foregroundBlack
                                                                : ColorUtils
                                                                      .lavenderMist,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ).r,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius:
                                                                    12.r,
                                                                color: Colors
                                                                    .black
                                                                    .withValues(
                                                                      alpha:
                                                                          0.1,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            primary: false,
                                                            children:
                                                                extraFields[i].options?.map((
                                                                  item,
                                                                ) {
                                                                  bool
                                                                  isSelected =
                                                                      (extraFields[i].value ??
                                                                              [])
                                                                          .contains(
                                                                            item.key,
                                                                          );

                                                                  return InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          13,
                                                                        ).r,
                                                                    onTap: () {
                                                                      if (!(extraFields[i].value ??
                                                                              [])
                                                                          .contains(
                                                                            item.key,
                                                                          )) {
                                                                        extraFields[i]
                                                                            .value
                                                                            ?.add(
                                                                              item.key!,
                                                                            );
                                                                      } else {
                                                                        extraFields[i]
                                                                            .value
                                                                            ?.remove(
                                                                              item.key!,
                                                                            );
                                                                      }
                                                                      controller
                                                                          .draftTaskData
                                                                          .refresh();
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            isSelected
                                                                            ? ColorUtils.filterFlag.withValues(
                                                                                alpha: 0.3,
                                                                              )
                                                                            : Colors.transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              13,
                                                                            ).r,
                                                                      ),
                                                                      margin:
                                                                          EdgeInsets.all(
                                                                            3,
                                                                          ).h,
                                                                      padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10.h,
                                                                        horizontal:
                                                                            10.h,
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            item.key ??
                                                                                '',
                                                                            style: TextStyle(
                                                                              fontSize: 12.h,
                                                                              color: widget.isDarkMode
                                                                                  ? ColorUtils.textWhite
                                                                                  : ColorUtils.workEntryHead,
                                                                            ),
                                                                          ),
                                                                          if (isSelected)
                                                                            Icon(
                                                                              Icons.check,
                                                                              color: ColorUtils.textWhite,
                                                                              size: 18.h,
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList() ??
                                                                [],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          else if (extraFields[i].fieldType ==
                                              'date')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: 18.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: widget.isDarkMode
                                                      ? ColorUtils.jetGrey
                                                      : ColorUtils
                                                            .paleLavenderMist,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(12).r,
                                                      ),
                                                  border: Border.all(
                                                    color: widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                              .withValues(
                                                                alpha: 0.1,
                                                              )
                                                        : ColorUtils
                                                              .workEntryHead
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  // controller: TextEditingController(text: appliedLeave?.leaveReason ?? '--'),
                                                  readOnly: true,
                                                  onTap: () async {
                                                    DateTime?
                                                    picked = await pickDate(
                                                      context,
                                                      widget.isDarkMode
                                                          ? ThemeMode.dark
                                                          : ThemeMode.light,
                                                      firstDate: DateTime(
                                                        DateTime.now().year -
                                                            85,
                                                      ),
                                                      lastDate: DateTime(
                                                        DateTime.now().year + 2,
                                                      ),
                                                    );
                                                    if (picked != null) {
                                                      extraFields[i].value = [
                                                        DateFormat(
                                                          'yyyy-MM-dd',
                                                        ).format(picked),
                                                      ];
                                                      controller.draftTaskData
                                                          .refresh();
                                                    }
                                                    // showDialog(
                                                    //   context: context,
                                                    //   useSafeArea: true,
                                                    //   barrierColor: Colors.transparent,
                                                    //   builder: (context) {
                                                    //     return Dialog(
                                                    //       alignment: Alignment.center,
                                                    //       insetPadding: EdgeInsets.zero,
                                                    //       backgroundColor: Colors.transparent,
                                                    //       child: SizedBox(
                                                    //         height:
                                                    //         ScreenUtil().screenHeight / 1.8,
                                                    //         width:
                                                    //         ScreenUtil().screenWidth *
                                                    //             0.9,
                                                    //         child: Column(
                                                    //           children: [
                                                    //             Spacer(),
                                                    //             LeaveCalender(
                                                    //               isRangeSelection: false,
                                                    //               leaveDates: (LeaveDates leaveDays) {
                                                    //                 // leaveStart.value = leaveDays.startDate;
                                                    //                 // leaveEnd.value = leaveDays.endDate;
                                                    //                 if(leaveDays.startDate != null) {
                                                    //                   extraFields[i].value = [DateFormat('yyyy-MM-dd').format(leaveDays.startDate!)];
                                                    //                   controller.draftTaskData.refresh();
                                                    //                 }
                                                    //               },
                                                    //               onMonthChange: (DateTime date) {
                                                    //                 // currentDate.value = date;
                                                    //               },
                                                    //             ),
                                                    //             Spacer(),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // );
                                                  },
                                                  controller:
                                                      TextEditingController(
                                                        text:
                                                            (extraFields[i]
                                                                    .value
                                                                    ?.isNotEmpty ??
                                                                false)
                                                            ? extraFields[i]
                                                                      .value
                                                                      ?.first ??
                                                                  ''
                                                            : '',
                                                      ),
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  12,
                                                                ).r,
                                                              ),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  12,
                                                                ).r,
                                                              ),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    fillColor: widget.isDarkMode
                                                        ? ColorUtils.jetGrey
                                                        : ColorUtils
                                                              .paleLavenderMist,
                                                    filled: true,
                                                    label: Text(
                                                      extraFields[i]
                                                              .fieldName ??
                                                          '--',
                                                      style: GoogleFonts.dmSans(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.h,
                                                        color: widget.isDarkMode
                                                            ? ColorUtils
                                                                  .textWhite
                                                            : ColorUtils
                                                                  .obsidianGrey,
                                                        letterSpacing: -0.2,
                                                      ),
                                                    ),
                                                    hintText:
                                                        extraFields[i]
                                                            .fieldName ??
                                                        '--',
                                                    hintStyle: GoogleFonts.dmSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13.h,
                                                      color: widget.isDarkMode
                                                          ? ColorUtils.textWhite
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                )
                                                          : ColorUtils
                                                                .workEntryHead
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                      letterSpacing: -0.2,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(15.h),
                                                  ),
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.h,
                                                    color: widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                        : ColorUtils
                                                              .workEntryHead,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else if (extraFields[i].fieldType ==
                                              'dropdown')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                              ),
                                              child: Container(
                                                width: ScreenUtil().screenWidth,
                                                height: 70.h,
                                                decoration: BoxDecoration(
                                                  color: widget.isDarkMode
                                                      ? ColorUtils.jetGrey
                                                      : ColorUtils
                                                            .paleLavenderMist,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12,
                                                      ).r,
                                                  border: Border.all(
                                                    color: widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                              .withValues(
                                                                alpha: 0.1,
                                                              )
                                                        : ColorUtils
                                                              .workEntryHead
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 15.h,
                                                              ),
                                                              Text(
                                                                extraFields[i]
                                                                        .fieldName ??
                                                                    '--',
                                                                style: GoogleFonts.dmSans(
                                                                  fontSize:
                                                                      13.h,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      widget
                                                                          .isDarkMode
                                                                      ? ColorUtils
                                                                            .textWhite
                                                                      : ColorUtils
                                                                            .obsidianGrey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          DropdownButtonHideUnderline(
                                                            child: DropdownButton2<String>(
                                                              isExpanded: true,
                                                              hint: Text(
                                                                'Select',
                                                                style: GoogleFonts.dmSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      13.h,
                                                                  color:
                                                                      widget
                                                                          .isDarkMode
                                                                      ? ColorUtils
                                                                            .textWhite
                                                                            .withValues(
                                                                              alpha: 0.5,
                                                                            )
                                                                      : ColorUtils
                                                                            .workEntryHead
                                                                            .withValues(
                                                                              alpha: 0.5,
                                                                            ),
                                                                  letterSpacing:
                                                                      -0.5,
                                                                ),
                                                              ),
                                                              selectedItemBuilder: (context) {
                                                                return extraFields[i].options!.map((
                                                                  option,
                                                                ) {
                                                                  List<String>
                                                                  optionParts =
                                                                      option.key
                                                                          ?.split(
                                                                            '<#>',
                                                                          ) ??
                                                                      [];
                                                                  String opt =
                                                                      'Select';
                                                                  if (optionParts
                                                                      .isNotEmpty) {
                                                                    opt = optionParts
                                                                        .first;
                                                                  } else {
                                                                    opt =
                                                                        option
                                                                            .key ??
                                                                        'Select';
                                                                  }
                                                                  return Row(
                                                                    children: [
                                                                      if (option.key !=
                                                                              'Select' &&
                                                                          (option.value?.isNotEmpty ??
                                                                              false) &&
                                                                          !isSubGoalCreate &&
                                                                          extraFields[i].fieldName !=
                                                                              'Subgoal')
                                                                        Container(
                                                                          width:
                                                                              15.h,
                                                                          height:
                                                                              15.h,
                                                                          decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: AttendanceCommonWidgets().hexToColor(
                                                                              option.value,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (option.key !=
                                                                              'Select' &&
                                                                          (option.value?.isNotEmpty ??
                                                                              false) &&
                                                                          !isSubGoalCreate &&
                                                                          extraFields[i].fieldName !=
                                                                              'Subgoal')
                                                                        SizedBox(
                                                                          width:
                                                                              10.h,
                                                                        ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          opt,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.dmSans(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                13.h,
                                                                            color:
                                                                                widget.isDarkMode
                                                                                ? ColorUtils.textWhite.withValues(
                                                                                    alpha:
                                                                                        option.key ==
                                                                                            'Select'
                                                                                        ? 0.5
                                                                                        : 1.0,
                                                                                  )
                                                                                : ColorUtils.workEntryHead.withValues(
                                                                                    alpha:
                                                                                        option.key ==
                                                                                            'Select'
                                                                                        ? 0.5
                                                                                        : 1.0,
                                                                                  ),
                                                                            letterSpacing:
                                                                                -0.5,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }).toList();
                                                              },
                                                              items: extraFields[i].options?.map((
                                                                option,
                                                              ) {
                                                                List<String>
                                                                optionParts =
                                                                    option.key
                                                                        ?.split(
                                                                          '<#>',
                                                                        ) ??
                                                                    [];
                                                                String opt =
                                                                    'Select';
                                                                if (optionParts
                                                                    .isNotEmpty) {
                                                                  opt =
                                                                      optionParts
                                                                          .first;
                                                                } else {
                                                                  opt =
                                                                      option
                                                                          .key ??
                                                                      'Select';
                                                                }
                                                                return DropdownMenuItem<
                                                                  String
                                                                >(
                                                                  value: option
                                                                      .key,
                                                                  child: Row(
                                                                    children: [
                                                                      if (option.key !=
                                                                              'Select' &&
                                                                          (option.value?.isNotEmpty ??
                                                                              false) &&
                                                                          !isSubGoalCreate &&
                                                                          extraFields[i].fieldName !=
                                                                              'Subgoal')
                                                                        Container(
                                                                          width:
                                                                              15.h,
                                                                          height:
                                                                              15.h,
                                                                          decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: AttendanceCommonWidgets().hexToColor(
                                                                              option.value,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (option.key !=
                                                                              'Select' &&
                                                                          (option.value?.isNotEmpty ??
                                                                              false) &&
                                                                          !isSubGoalCreate &&
                                                                          extraFields[i].fieldName !=
                                                                              'Subgoal')
                                                                        SizedBox(
                                                                          width:
                                                                              10.h,
                                                                        ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          opt,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.dmSans(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                13.h,
                                                                            color:
                                                                                widget.isDarkMode
                                                                                ? ColorUtils.textWhite.withValues(
                                                                                    alpha:
                                                                                        option.key ==
                                                                                            'Select'
                                                                                        ? 0.5
                                                                                        : 1.0,
                                                                                  )
                                                                                : ColorUtils.workEntryHead.withValues(
                                                                                    alpha:
                                                                                        option.key ==
                                                                                            'Select'
                                                                                        ? 0.5
                                                                                        : 1.0,
                                                                                  ),
                                                                            letterSpacing:
                                                                                -0.5,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              value:
                                                                  (extraFields[i]
                                                                          .value
                                                                          ?.isNotEmpty ??
                                                                      false)
                                                                  ? extraFields[i]
                                                                        .value
                                                                        ?.first
                                                                  : null,
                                                              onChanged: (selectedValue) async {
                                                                setState(() {
                                                                  extraFields[i]
                                                                      .value = [
                                                                    selectedValue!,
                                                                  ];

                                                                  if (extraFields[i]
                                                                          .fieldName ==
                                                                      'Subgoal') {
                                                                    List<String>
                                                                    optionParts =
                                                                        selectedValue?.split(
                                                                          '<#>',
                                                                        ) ??
                                                                        [];
                                                                    String? opt;
                                                                    if (optionParts
                                                                        .isNotEmpty) {
                                                                      opt = optionParts
                                                                          .last;
                                                                    }
                                                                    controller
                                                                            .draftTaskData
                                                                            .value
                                                                            .subGoalId =
                                                                        opt;
                                                                  } else if (extraFields[i]
                                                                          .fieldName ==
                                                                      'Time Period') {
                                                                    List<String>
                                                                    optionParts =
                                                                        selectedValue?.split(
                                                                          '<#>',
                                                                        ) ??
                                                                        [];
                                                                    String? opt;
                                                                    if (optionParts
                                                                        .isNotEmpty) {
                                                                      opt = optionParts
                                                                          .last;
                                                                    }
                                                                    controller
                                                                            .draftTaskData
                                                                            .value
                                                                            .timePeriodValue =
                                                                        opt;
                                                                  }
                                                                });
                                                              },
                                                              iconStyleData:
                                                                  IconStyleData(
                                                                    icon:
                                                                        SizedBox.shrink(),
                                                                  ),
                                                              buttonStyleData: ButtonStyleData(
                                                                height: 20.h,
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      right:
                                                                          16.h,
                                                                    ),
                                                                overlayColor:
                                                                    WidgetStateProperty.all(
                                                                      Colors
                                                                          .transparent,
                                                                    ),
                                                              ),
                                                              dropdownStyleData: DropdownStyleData(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      widget
                                                                          .isDarkMode
                                                                      ? ColorUtils
                                                                            .foregroundBlack
                                                                      : ColorUtils
                                                                            .textWhite,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ).r,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Color(0xFF9A9A9A),
                                                    ),
                                                    SizedBox(width: 10.h),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: extraFields.isNotEmpty
                                                ? 0
                                                : 10.h,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(top: 18.h),
                                            decoration: BoxDecoration(
                                              color: widget.isDarkMode
                                                  ? ColorUtils.jetGrey
                                                  : ColorUtils.paleLavenderMist,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12).r,
                                              ),
                                              border: Border.all(
                                                color: widget.isDarkMode
                                                    ? ColorUtils.textWhite
                                                          .withValues(
                                                            alpha: 0.1,
                                                          )
                                                    : ColorUtils.workEntryHead
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  _descriptionController,
                                              onChanged: (value) {
                                                managerTaskController
                                                        .draftTaskData
                                                        .value
                                                        .description =
                                                    value;
                                              },
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              12,
                                                            ).r,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              12,
                                                            ).r,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                fillColor: widget.isDarkMode
                                                    ? ColorUtils.jetGrey
                                                    : ColorUtils
                                                          .paleLavenderMist,
                                                filled: true,
                                                label: Text(
                                                  "Description",
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.h,
                                                    color: widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                        : ColorUtils
                                                              .obsidianGrey,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                                hintText: 'Write description',
                                                hintStyle: GoogleFonts.dmSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.h,
                                                  color: widget.isDarkMode
                                                      ? ColorUtils.textWhite
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                      : ColorUtils.workEntryHead
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                  letterSpacing: -0.2,
                                                ),
                                                contentPadding: EdgeInsets.all(
                                                  15.h,
                                                ),
                                              ),
                                              style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.h,
                                                color: widget.isDarkMode
                                                    ? ColorUtils.textWhite
                                                    : ColorUtils.workEntryHead,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (!isSubGoalCreate)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.h,
                                            ),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      minWidth:
                                                          constraints.maxWidth,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10.r,
                                                              ),
                                                          onTap: () {
                                                            attachBottomSheetShow(
                                                              context,
                                                              widget.isDarkMode,
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 47.h,
                                                            // width: 158.h,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  widget
                                                                      .isDarkMode
                                                                  ? ColorUtils
                                                                        .jetGrey
                                                                  : ColorUtils
                                                                        .paleLavenderMist,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10.r,
                                                                  ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 14.h,
                                                                ),
                                                                SvgPicture.asset(
                                                                  'assets/images/AttachPin.svg',
                                                                  height: 16.h,
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  colorFilter: ColorFilter.mode(
                                                                    widget.isDarkMode
                                                                        ? ColorUtils
                                                                              .textWhite
                                                                        : ColorUtils
                                                                              .workEntryHead,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10.h,
                                                                ),
                                                                Text(
                                                                  'Add Attachment',
                                                                  style: GoogleFonts.dmSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        13.h,
                                                                    color:
                                                                        widget
                                                                            .isDarkMode
                                                                        ? ColorUtils
                                                                              .textWhite
                                                                        : ColorUtils
                                                                              .workEntryHead,
                                                                    letterSpacing:
                                                                        -0.2,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 14.h,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.h),
                                                        if (controller
                                                                    .draftTaskData
                                                                    .value
                                                                    .attachment !=
                                                                null &&
                                                            (controller
                                                                    .draftTaskData
                                                                    .value
                                                                    .attachment
                                                                    ?.isNotEmpty ??
                                                                false))
                                                          for (
                                                            int i = 0;
                                                            i <
                                                                (controller
                                                                        .draftTaskData
                                                                        .value
                                                                        .attachment
                                                                        ?.length ??
                                                                    0);
                                                            i++
                                                          )
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                    right: 8.h,
                                                                  ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6.r,
                                                                    ),
                                                                child: Stack(
                                                                  children: [
                                                                    if (!(controller
                                                                            .draftTaskData
                                                                            .value
                                                                            .attachment?[i]
                                                                            .contains(
                                                                              'http',
                                                                            ) ??
                                                                        false))
                                                                      InkWell(
                                                                        onTap: () {
                                                                          showImagePopUp(
                                                                            mainContext:
                                                                                context,
                                                                            attachments:
                                                                                controller.draftTaskData.value.attachment,
                                                                            isDarkMode:
                                                                                widget.isDarkMode,
                                                                            index: i
                                                                          );
                                                                        },
                                                                        child: Image.file(
                                                                          File(
                                                                            controller.draftTaskData.value.attachment![i],
                                                                          ),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              44.h,
                                                                          width:
                                                                              44.h,
                                                                          errorBuilder:
                                                                              (
                                                                              context,
                                                                              url,
                                                                              error,
                                                                              ) {
                                                                            return Container(
                                                                              decoration: BoxDecoration(
                                                                                color: widget.isDarkMode
                                                                                    ? ColorUtils.jetGrey
                                                                                    : ColorUtils.paleLavenderMist,
                                                                              ),
                                                                              child: Center(
                                                                                child: Icon(
                                                                                  Icons.broken_image,
                                                                                  color: widget.isDarkMode
                                                                                      ? ColorUtils.textWhite
                                                                                      : Colors.grey,
                                                                                  size: 18.h,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      )
                                                                    else
                                                                      InkWell(
                                                                        onTap: () {
                                                                          showImagePopUp(
                                                                            mainContext:
                                                                                context,
                                                                            attachments:
                                                                                controller.draftTaskData.value.attachment,
                                                                            isDarkMode:
                                                                                widget.isDarkMode,
                                                                            index: i
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          height:
                                                                              44.h,
                                                                          width:
                                                                              44.h,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                ColorUtils.paleLavenderMist,
                                                                          ),
                                                                          child: CachedNetworkImage(
                                                                            imageUrl:
                                                                                controller.draftTaskData.value.attachment?[i] ??
                                                                                '',
                                                                            alignment:
                                                                                Alignment.center,
                                                                            placeholder:
                                                                                (
                                                                                  context,
                                                                                  url,
                                                                                ) {
                                                                                  return Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: widget.isDarkMode
                                                                                          ? ColorUtils.jetGrey
                                                                                          : ColorUtils.paleLavenderMist,
                                                                                    ),
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.broken_image,
                                                                                        color: widget.isDarkMode
                                                                                            ? ColorUtils.textWhite
                                                                                            : Colors.grey,
                                                                                        size: 18.h,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                            errorWidget:
                                                                                (
                                                                                  context,
                                                                                  url,
                                                                                  error,
                                                                                ) {
                                                                                  return Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: widget.isDarkMode
                                                                                          ? ColorUtils.jetGrey
                                                                                          : ColorUtils.paleLavenderMist,
                                                                                    ),
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.broken_image,
                                                                                        color: widget.isDarkMode
                                                                                            ? ColorUtils.textWhite
                                                                                            : Colors.grey,
                                                                                        size: 18.h,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    Positioned(
                                                                      top: 2,
                                                                      right: 2,
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          controller
                                                                              .draftTaskData
                                                                              .value
                                                                              .attachment
                                                                              ?.removeAt(
                                                                                i,
                                                                              );
                                                                          controller
                                                                              .draftTaskData
                                                                              .refresh();
                                                                        },
                                                                        child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              ColorUtils.textWhite,
                                                                          size:
                                                                              12.h,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        if (!isSubGoalCreate)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3.h,
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/manager_view/task_location_icon.svg',
                                                  height: 16.h,
                                                  fit: BoxFit.fitHeight,
                                                  colorFilter: ColorFilter.mode(
                                                    widget.isDarkMode
                                                        ? ColorUtils.textWhite
                                                        : ColorUtils
                                                              .workEntryHead,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                SizedBox(width: 5.h),
                                                GetX<ManagerTaskController>(
                                                  builder:
                                                      (
                                                        ManagerTaskController
                                                        controller,
                                                      ) {
                                                        if (controller
                                                            .locationLoading
                                                            .value) {
                                                          return SizedBox(
                                                            width: 10.h,
                                                            height: 10.h,
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2.h,
                                                                ),
                                                          );
                                                        } else {
                                                          return Expanded(
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (widget
                                                                    .taskCreate) {
                                                                  await controller
                                                                      .addLocationData();
                                                                }
                                                              },
                                                              child: Text(
                                                                controller.draftTaskData.value.locationData?.locationName !=
                                                                            null &&
                                                                        (controller.draftTaskData.value.locationData?.locationName?.isNotEmpty ??
                                                                            false)
                                                                    ? '${controller.draftTaskData.value.locationData?.locationName}'
                                                                    : 'Add Location (Optional)',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts.dmSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      12.h,
                                                                  color:
                                                                      widget
                                                                          .isDarkMode
                                                                      ? ColorUtils
                                                                            .textWhite
                                                                      : ColorUtils
                                                                            .workEntryHead,
                                                                  letterSpacing:
                                                                      -0.2,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                ),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 10.h),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if (!widget.taskCreate && !isSubGoalCreate)
                            GetX<ManagerTaskController>(
                              builder: (ManagerTaskController controller) {
                                if (controller
                                    .activityLogList
                                    .value
                                    .isNotEmpty) {
                                  return Container(
                                    // height: 300.h,
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    decoration: BoxDecoration(
                                      color: widget.isDarkMode
                                          ? Color(0xFF1D1D1D)
                                          : null,
                                      gradient: widget.isDarkMode
                                          ? null
                                          : LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFFFFF0E7),
                                                ColorUtils.textWhite,
                                              ],
                                            ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                            vertical: 16.h,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/History.svg',
                                                height: 15.h,
                                                fit: BoxFit.fitHeight,
                                                colorFilter: widget.isDarkMode
                                                    ? ColorFilter.mode(
                                                        ColorUtils.textWhite,
                                                        BlendMode.srcIn,
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(width: 5.h),
                                              Text(
                                                'Activity Log',
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w400,
                                                  color: widget.isDarkMode
                                                      ? ColorUtils.textWhite
                                                      : ColorUtils
                                                            .workEntryHead,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                          itemBuilder: (context, index) {
                                            ActivityLog activityLog = controller
                                                .activityLogList
                                                .value[index];
                                            final message =
                                                activityLog.massage ?? '';
                                            final daysAgoText = formatDaysAgo(
                                              activityLog.daysAgo,
                                            );
                                            final combinedText =
                                                (message.isNotEmpty &&
                                                    daysAgoText.isNotEmpty)
                                                ? '$message - $daysAgoText'
                                                : message.isNotEmpty
                                                ? message
                                                : daysAgoText;
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.h,
                                                vertical: 5.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  activityLog.profilePicture !=
                                                          null
                                                      ? AttendanceCommonWidgets()
                                                            .cachedNetworkImage(
                                                              activityLog
                                                                      .profilePicture ??
                                                                  '',
                                                              height: 24.h,
                                                            )
                                                      : SizedBox(),
                                                  SizedBox(width: 5.h),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                (activityLog
                                                                        .assignedEmployeeName ??
                                                                    '') +
                                                                (combinedText
                                                                        .isNotEmpty
                                                                    ? ' - '
                                                                    : ''),
                                                            style: GoogleFonts.inter(
                                                              fontSize: 11.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  widget
                                                                      .isDarkMode
                                                                  ? ColorUtils
                                                                        .textWhite
                                                                  : Colors
                                                                        .grey
                                                                        .shade900,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: combinedText,
                                                            style: GoogleFonts.inter(
                                                              fontSize: 11.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: ColorUtils
                                                                  .steelBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: controller
                                              .activityLogList
                                              .value
                                              .length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () async {
                validateFields();
                if((managerTaskController.draftTaskData.value.workName?.trim().isNotEmpty ?? false) && (showAssigneeValidation ? managerTaskController.draftTaskData.value.assignedToId != null : true)) {
                  if (!managerTaskController.submitLoading.value) {
                    if (isSubGoalCreate) {
                      final result = await Get.find<GrowthController>()
                          .createSubgoal(
                        isCreate: !(widget.subGoalEdit ?? false),
                        goalId: growthController.goalDetails.value?.goalId,
                        subGolId: growthController.subGoalDetails.value?.goalId
                      );
                      if (result != null) {
                        AttendanceCommonWidgets().showSnackBar(
                          context: context,
                          backgroundColor: Colors.green,
                          message: result,
                        );
                        Navigator.of(context).pop();
                        managerTaskController.draftTaskData.value =
                            CreateTaskModel();
                      } else {
                        AttendanceCommonWidgets().showSnackBar(
                          context: context,
                          backgroundColor: Colors.red,
                          message: 'Something went wrong',
                        );
                      }
                    } else {
                      await managerTaskController.createNewTask(
                        context,
                        widget.taskId?.toString(),
                      );
                    }
                  }
                }
              },
              child: Container(
                width: ScreenUtil().screenWidth,
                height: 76.h,
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? Color(0xFF1D1D1D)
                      : ColorUtils.textWhite,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xFFB9B8FF).withValues(alpha: 0.18),
                  //     offset: Offset(0, -16),
                  //     blurRadius: 31,
                  //     spreadRadius: 0,
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        height: 55.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(37.r),
                          color: ColorUtils.secondaryBlue,
                        ),
                        child: Obx(() {
                          return Center(
                            child: managerTaskController.submitLoading.value
                                ? SizedBox(
                                    width: 20.h,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: ColorUtils.textWhite,
                                    ),
                                  )
                                : Text(
                                    widget.taskId != null
                                        ? 'Update'
                                        : (widget.subGoalCreate ?? false)
                                        ? (widget.subGoalEdit ?? false)
                                              ? 'Update Sub-goal'
                                              : 'Create Sub-goal'
                                        : 'Create Task',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.h,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          );
                        }),
                      ),
                    ),
                    if (widget.taskId != null) SizedBox(width: 10.h),
                    if (widget.taskId != null)
                      GestureDetector(
                        onTap: () async {
                          await Get.find<ManagerTaskController>().taskDelete(
                            taskId: widget.taskId?.toString() ?? '',
                            context: context,
                          );
                          if (Get.find<ManagerTaskController>()
                              .deleteSuccess
                              .value) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 69.h,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFD13131),
                            borderRadius: BorderRadius.circular(37).r,
                          ),
                          child: Center(
                            child: GetX<ManagerTaskController>(
                              builder: (ManagerTaskController controller) {
                                if (controller.deletionWorking.value) {
                                  return SizedBox(
                                    width: 15.h,
                                    height: 15.h,
                                    child: CircularProgressIndicator(
                                      color: ColorUtils.textWhite,
                                    ),
                                  );
                                } else {
                                  return Image.asset(
                                    'assets/images/manager_view/delete_task.png',
                                    color: ColorUtils.textWhite,
                                    height: 24.h,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateFields() {
    if(managerTaskController.draftTaskData.value.workName?.trim().isEmpty ?? true) {
      taskNameValidator.value = true;
    } else {
      taskNameValidator.value = false;
    }
    if(showAssigneeValidation) {
      if(managerTaskController.draftTaskData.value.assignedToId == null) {
        assigneeValidation.value = true;
      } else {
        assigneeValidation.value = false;
      }
    }
  }

  String formatDaysAgo(String? daysAgo) {
    int? days = int.tryParse(daysAgo ?? '');
    if (days != null) {
      switch (days) {
        case 0:
          return 'Today';
        case 1:
          return 'Yesterday';
        default:
          return (daysAgo != null && daysAgo.isNotEmpty)
              ? '$daysAgo days ago'
              : '';
      }
    } else {
      return daysAgo ?? '';
    }
  }

  Widget customRadio({
    required String label,
    required String value,
    required String groupValue,
    required String color,
    required VoidCallback onTap,
  }) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AttendanceCommonWidgets().hexToColor(color) ??
                            ColorUtils.secondaryBlue
                      : widget.isDarkMode
                      ? ColorUtils.textWhite
                      : Colors.grey,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AttendanceCommonWidgets().hexToColor(color) ??
                                    ColorUtils.secondaryBlue
                              : widget.isDarkMode
                              ? ColorUtils.textWhite
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? AttendanceCommonWidgets().hexToColor(color) ??
                          (widget.isDarkMode
                              ? ColorUtils.textWhite
                              : ColorUtils.eerieBlack)
                    : widget.isDarkMode
                    ? ColorUtils.textWhite.withValues(alpha: 0.6)
                    : ColorUtils.eerieBlack.withValues(alpha: 0.6),
                fontSize: 12.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  attachBottomSheetShow(mainContext, bool isDarkMode) {
    showModalBottomSheet(
      context: mainContext,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.81),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: ScreenUtil().screenWidth,
              height: 273.w,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorUtils.backgroundBlack
                    : ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(20).w,
                border: isDarkMode
                    ? Border.all(width: 1.w, color: const Color(0xFF404040))
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  left: 15.0,
                  right: 15.0,
                ).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Source",
                      style: GoogleFonts.poppins(
                        color: isDarkMode
                            ? ColorUtils.textWhite
                            : ColorUtils.workEntryHead.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .push(newSlideNavigation(const CameraViewLeave()))
                            .then((value) async {
                              if (value == null) return;
                              final file = File(value);
                              if (await file.length() > 2 * 1024 * 1024) {
                                AttendanceCommonWidgets().showSnackBar(
                                  context: mainContext,
                                  backgroundColor: Colors.red,
                                  message: "File size must be 2 MB or less",
                                );
                              } else {
                                managerTaskController
                                        .draftTaskData
                                        .value
                                        .attachment ??=
                                    [];
                                managerTaskController
                                    .draftTaskData
                                    .value
                                    .attachment
                                    ?.add(value);
                                managerTaskController.draftTaskData.refresh();
                              }
                            });
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/camera.webp",
                        title: "Camera",
                        subTitle:
                            "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: isDarkMode
                            ? null
                            : ColorUtils.softPearl,
                        textColor: isDarkMode
                            ? null
                            : ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: [
                              'png',
                              'jpg',
                              'jpeg',
                              'gif',
                              'bmp',
                              'tiff',
                              'webp'
                            ],
                          );

                          if (result == null) return; // User cancelled

                          List<String> paths = result.files
                              .where((file) => file.path != null)
                              .map((file) => file.path!)
                              .toList();

                          final skipped = await addFilesIfValid(paths);

                          if (skipped != 0) {
                            AttendanceCommonWidgets().showSnackBar(
                              context: mainContext,
                              backgroundColor: Colors.red,
                              message:
                              "${(skipped == 1 && paths.length == 1) ? '' : skipped.toString()} ${skipped == 1 ? 'file' : 'files'} size above 2 MB",
                            );
                          }

                        } catch (e) {
                          AttendanceCommonWidgets().printF(
                            "------error-------${e.toString()}",
                          );
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/image-3d.webp",
                        title: "Photos",
                        subTitle:
                            "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: isDarkMode
                            ? null
                            : ColorUtils.softPearl,
                        textColor: isDarkMode
                            ? null
                            : ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(allowMultiple: true);

                        if (result != null) {
                          List<String> path = result.paths.whereType<String>().toList();
                          final skipped = await addFilesIfValid(path);
                          if (skipped != 0) {
                            AttendanceCommonWidgets().showSnackBar(
                              context: mainContext,
                              backgroundColor: Colors.red,
                              message:
                                  "${(skipped == 1 && path.length == 1) ? '' : skipped.toString()} ${skipped == 1 ? 'file' : 'files'} size above 2 MB",
                            );
                          }
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/file-3d.webp",
                        title: "Browse",
                        subTitle:
                            "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: isDarkMode
                            ? null
                            : ColorUtils.softPearl,
                        textColor: isDarkMode
                            ? null
                            : ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<int> addFilesIfValid(List<String> paths) async {
    int skipped = 0;
    managerTaskController.draftTaskData.value.attachment ??= [];

    for (var path in paths) {
      final file = File(path);
      if (await file.length() > 2 * 1024 * 1024) {
        skipped++;
      } else {
        managerTaskController.draftTaskData.value.attachment!.add(path);
      }
    }

    managerTaskController.draftTaskData.refresh();
    return skipped;
  }

  Future<void> getLostData(mainContext) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> image = await picker.pickMultiImage();
    final LostDataResponse response = await picker.retrieveLostData();
    if (image != null) {
      final skipped = await addFilesIfValid(image.map((f) => f.path).toList());

      if (skipped != 0) {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message:
              "${skipped.toString()} ${skipped == 1 ? 'file' : 'files'} size above 2 MB",
        );
      }
    }
    if (response.isEmpty) {
      return;
    }
    final List<XFile> files = response.files ?? [];

    if (files.isNotEmpty) {
      final skipped = await addFilesIfValid(files.map((f) => f.path).toList());

      if (skipped != 0) {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message:
              "${skipped.toString()} ${skipped == 1 ? 'file' : 'files'} size above 2 MB",
        );
      }
    }
  }
}

Future<bool?> showImagePopUp({
  required BuildContext mainContext,
  required bool isDarkMode,
  List<String>? attachments,
  int? index,
}) async {
  final ValueNotifier<int> currentIndexNotifier = ValueNotifier(index ?? 0);
  final PageController pageController = PageController(initialPage: index ?? 0);

  return showGeneralDialog<bool>(
    context: mainContext,
    barrierDismissible: false,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return SafeArea(
        child: Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: isDarkMode
                  ? ColorUtils.backgroundBlack
                  : ColorUtils.textWhite,
              constraints: BoxConstraints.expand(),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.all(8.h),
              actionsPadding: EdgeInsets.only(bottom: 8.h, left: 8.h, right: 8.h),
              titlePadding: EdgeInsets.only(top: 16.h, bottom: 8.h, left: 8.h, right: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(
                  color: const Color(0xFF666666),
                  width: 1.w,
                ),
              ),
              title: ValueListenableBuilder<int>(
                  valueListenable: currentIndexNotifier,
                  builder: (context, currentIndex, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Preview",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: isDarkMode
                                ? ColorUtils.textWhite
                                : ColorUtils.workEntryHead,
                          ),
                        ),

                        SizedBox(width: 5.h),

                        Text(
                          "${currentIndex + 1}/${attachments?.length ?? 0}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    );
                  }
              ),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(10.0).w,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: attachments?.length,
                  onPageChanged: (index) {
                    currentIndexNotifier.value = index;
                  },
                  itemBuilder: (context, index) {
                    final imageUrl = attachments?[index] ?? '';
                    bool isNetworkUrl = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
                    if(!isNetworkUrl) {
                      return _buildLocalFileViewer(imageUrl);
                    }
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: ScreenUtil().screenWidth * 0.5,
                      fit: BoxFit.fitWidth,
                      placeholder:
                          (context, url) => Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: isDarkMode
                              ? ColorUtils.textWhite
                              : Colors.grey,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Loading...",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: isDarkMode
                                  ? ColorUtils.textWhite
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      )),
                      errorWidget: (context,
                          url, error) =>  FutureBuilder<File>(
                        future: loadPdf(imageUrl),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SfPdfViewer.file(snapshot.data!);
                          }
                          if(snapshot.hasError) {
                            return Center(child: Text(
                              "${snapshot.error}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.workEntryHead,
                              ),
                            ));
                          }
                          return Center(child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: isDarkMode
                                  ? ColorUtils.textWhite
                                  : Colors.grey,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Loading...",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  color: isDarkMode
                                      ? ColorUtils.textWhite
                                      : ColorUtils.workEntryHead,
                                ),
                              ),
                            ],
                          ));
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // foregroundColor: Colors.white,
                        backgroundColor: isDarkMode
                            ? ColorUtils.foregroundBlack
                            : ColorUtils.paleLavenderMist,
                        elevation: 0),
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          color: isDarkMode
                              ? ColorUtils.textWhite
                              : ColorUtils.workEntryHead,
                          size: 15.w,
                        ),
                        Text(
                          "Close",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: isDarkMode
                                ? ColorUtils.textWhite
                                : ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<File> loadPdf(String url) async {
  final file = await DefaultCacheManager().getSingleFile(url);
  return file;
}

Widget _buildLocalFileViewer(String path) {
  final extension = path.split('.').last.toLowerCase();

  if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
    return Image.file(
      File(path),
      fit: BoxFit.contain,
    );
  }

  if (extension == 'pdf') {
    return SfPdfViewer.file(
      File(path),
    );
  }

  return const Center(
    child: Text('Unsupported file'),
  );
}

// Future<bool?> showImagePopUp({
//   required BuildContext mainContext,
//   required bool isDarkMode,
//   String? imageUrl,
// }) async {
//   return showGeneralDialog<bool>(
//     context: mainContext,
//     barrierDismissible: false,
//     pageBuilder: (ctx, a1, a2) {
//       return Container();
//     },
//     transitionDuration: const Duration(milliseconds: 300),
//     transitionBuilder: (ctx, a1, a2, child) {
//       var curve = Curves.easeInOut.transform(a1.value);
//       return SafeArea(
//         child: Transform.scale(
//           scale: curve,
//           child: PopScope(
//             canPop: false,
//             child: AlertDialog(
//               backgroundColor: isDarkMode
//                   ? ColorUtils.backgroundBlack
//                   : ColorUtils.textWhite,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(29.0).r,
//                 side: BorderSide(color: const Color(0xFF666666), width: 1.h),
//               ),
//               // titlePadding: EdgeInsets.zero,
//               // contentPadding: EdgeInsets.zero,
//               // actionsPadding: EdgeInsets.zero,
//               // buttonPadding: EdgeInsets.zero,
//               // iconPadding: EdgeInsets.zero,
//               insetPadding: EdgeInsets.all(10.h),
//               title: Text(
//                 "Attachment",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16.sp,
//                   color: isDarkMode
//                       ? ColorUtils.textWhite
//                       : ColorUtils.workEntryHead,
//                 ),
//               ),
//               content: !(imageUrl?.contains('http') ?? true)
//                   ? Image.file(File(imageUrl ?? ''))
//                   : CachedNetworkImage(
//                       imageUrl: imageUrl ?? '--',
//                       width: ScreenUtil().screenWidth * 0.5,
//                       fit: BoxFit.fitWidth,
//                       placeholder: (context, url) => SizedBox(
//                         width: ScreenUtil().screenWidth * 0.5,
//                         height: ScreenUtil().screenHeight * 0.5,
//                         child: Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: isDarkMode
//                                     ? ColorUtils.textWhite
//                                     : Colors.grey,
//                               ),
//                               SizedBox(height: 10.h),
//                               Text(
//                                 "Loading...",
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13.sp,
//                                   color: isDarkMode
//                                       ? ColorUtils.textWhite
//                                       : Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       errorWidget: (context, url, error) => SizedBox(
//                         width: ScreenUtil().screenWidth * 0.5,
//                         height: ScreenUtil().screenHeight * 0.5,
//                         child: Center(
//                           child: Text(
//                             "No Data Found",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 13.sp,
//                               color: isDarkMode
//                                   ? ColorUtils.textWhite
//                                   : ColorUtils.workEntryHead,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//               actions: [
//                 Container(
//                   width: ScreenUtil().screenWidth,
//                   height: 50.w,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       // foregroundColor: Colors.white,
//                       backgroundColor: isDarkMode
//                           ? ColorUtils.foregroundBlack
//                           : ColorUtils.paleLavenderMist,
//                       elevation: 0,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(ctx);
//                     },
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.close,
//                           color: isDarkMode
//                               ? ColorUtils.textWhite
//                               : ColorUtils.workEntryHead,
//                           size: 15.w,
//                         ),
//                         Text(
//                           "Close",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 13.sp,
//                             color: isDarkMode
//                                 ? ColorUtils.textWhite
//                                 : ColorUtils.workEntryHead,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// class MultiSelectDropdown extends StatefulWidget {
//   final List<Options> items;
//   final bool isDarkMode;
//   final String? fieldName;
//   final Function(List<Options>) onChanged;
//
//   const MultiSelectDropdown({
//     super.key,
//     required this.items,
//     required this.onChanged,
//     required this.isDarkMode,
//     required this.fieldName,
//   });
//
//   @override
//   State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
// }
//
// class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
//   List<Options> selectedItems = [];
//   bool isOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
