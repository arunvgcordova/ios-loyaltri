
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/work_apply_model.dart';
import 'package:loyaltri_minimal/models/work_entry_list_api_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../controller/WorkEntryListController.dart';
import '../../controller/locationFetchController.dart';
import '../../controller/sendWorkEntry.dart';
import '../../services/connectivity_service.dart';
import '../Attendance_Page/attendance_widgets/date_header.dart';
import '../CWidgets/app_bar.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import '../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../Leave_Page/leave_widgets/leave_type_card.dart';

class WorkEntry extends StatefulWidget {
  final bool isQuickActionEnable;
  final Function()? callBack;
  const WorkEntry({super.key, required this.isQuickActionEnable, this.callBack});

  @override
  State<WorkEntry> createState() => _WorkEntryState();
}

class _WorkEntryState extends State<WorkEntry> {
  WorkEntryListController workEntryListController = Get.find<WorkEntryListController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  SendWorkEntryController sendWorkEntryController = Get.find<SendWorkEntryController>();
  LocationFetchController locationFetchController = Get.find<LocationFetchController>();
  ValueNotifier<bool> workNameText = ValueNotifier(false);
  ValueNotifier<bool> unitsDoneText = ValueNotifier(false);
  ValueNotifier<bool> descriptionText = ValueNotifier(false);
  ValueNotifier<String?> filePath = ValueNotifier(null);
  TextEditingController _workNameController = TextEditingController();
  TextEditingController _unitsDoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  RxBool _showValidation = false.obs;
  DateTime? switchedMonth;

  @override
  void initState() {
    _loadPageContent();
    super.initState();
  }

  Future<void> _loadPageContent() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool connection = await ConnectivityService().check();
      if(!connection) {
        await ErrorDialog().internetWarn(
          context: context,
          title: "No Internet Connection",
          subTitle: "Please check if your connection is stable.",
          onPressed: () {
            Navigator.of(context).pop();
            _loadPageContent();
          },
        );
      } else {
        if (widget.isQuickActionEnable) {
          sendWorkEntryController.selectedFiles.value = [];
          showWorkSheet(mainContext: context);
        }
        workEntryListController.fetchWorkEntryList(month: DateTime.now(), empId: userAuthController.userData.value.userData?.employeeId ?? '--');
      }
    });
    // if(mounted) {
    //   await workEntryListController.fetchWorkEntryList(month: DateTime.now()).then((value) {
    //     if (widget.isQuickActionEnable) {
    //       showWorkSheet(mainContext: context);
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        if(widget.callBack != null) {
          widget.callBack!();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorUtils.workEntryHead,
          extendBody: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0).w,
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(
                      title: "Work Entry",
                      isActionVisible: true,
                      image: "assets/images/workentry-3d.webp",
                    ),
                    SizedBox(height: 10.w),
                    DateHeader(
                      onMonthChanged: (String month) async {
                        switchedMonth = DateFormat("MMM y").parse(month);
                        await workEntryListController.fetchWorkEntryList(month: switchedMonth ?? DateTime.now(), empId: userAuthController.userData.value.userData?.employeeId ?? '--');
                        // await workEntryListController.getListPerMonth(date: month);
                      },
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await workEntryListController.fetchWorkEntryList(month: switchedMonth ?? DateTime.now(), empId: userAuthController.userData.value.userData?.employeeId ?? '--');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10).w,
                        child: GetX<WorkEntryListController>(
                          builder: (WorkEntryListController controller) {
                            // if (controller.isLoading.value) {
                            //   context.loaderOverlay.show();
                            // } else {
                            //   context.loaderOverlay.hide();
                            // }
                            if (controller.isLoading.value) {
                              return Center(
                                child: SpinKitThreeInOut(
                                  color: ColorUtils.primaryBlue,
                                  size: 28.h,
                                ),
                              );
                            } else if(controller.dataPerMonth.isNotEmpty) {
                              if (controller.dataLoaded.value) {
                                return Container(
                                  height: ScreenUtil().screenWidth * 1.7,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 200).w,
                                    itemCount: controller.dataPerMonth.length,
                                    itemBuilder: (context, index) {
                                      return controller.dataPerMonth[index];
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: ScreenUtil().screenHeight * 0.6,
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            width: ScreenUtil().screenWidth,
            height: 70.w,
            decoration: blueTextButtonDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20).w,
                  child: GestureDetector(
                    onTap: () {
                      _workNameController.clear();
                      _unitsDoneController.clear();
                      _descriptionController.clear();
                      sendWorkEntryController.selectedFiles.value = [];
                      showWorkSheet(mainContext: context);
                    },
                    child: const LoyaltriBlueIconTextButton(
                      text: 'Add New Entry',
                      icon: Icons.add,
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

  Future<bool?> showWarn(
      {required BuildContext mainContext,}) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
            scale: curve,
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: ColorUtils.backgroundBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(
                  color: const Color(0xFF666666),
                  width: 1.w,
                ),
              ),
              title: Image.asset(
                "assets/images/Success-icon3d.webp",
                // width: 10.w,
                height: 60.w,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Work Entry Saved",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  Text(
                    DateFormat("dd MMM, yyyy | EEE").format(DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF6A4BFC),
                            elevation: 0),
                        onPressed: () {
                          Navigator.pop(ctx);
                          showWorkSheet(mainContext: mainContext, readOnly: true);
                        },
                        child: Text(
                          "View",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 110.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                            backgroundColor: ColorUtils.foregroundBlack,
                            elevation: 0),
                        onPressed: () {
                          Navigator.pop(ctx);
                          sendWorkEntryController.selectedFiles.value.clear();
                          _workNameController.clear();
                          _unitsDoneController.clear();
                          _descriptionController.clear();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              color: ColorUtils.textWhite,
                              size: 15.w,
                            ),
                            Text(
                              "Close",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: ColorUtils.textWhite,
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
        );
      },
    );
  }

  Future<bool?> showWorkSheet({required BuildContext mainContext, bool? readOnly}) async {
    return showModalBottomSheet(
      backgroundColor: ColorUtils.backgroundBlack,
      context: context,
      isScrollControlled: true,
      barrierColor: ColorUtils.workEntryHead,
      isDismissible: false,
      useSafeArea: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return KeyboardAvoider(
          child: SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)),
                    child: Padding(
                      padding: const EdgeInsets.all(15).w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    // await locationFetchController.resetLoc();
                                    filePath.value = null;
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 48.w,
                                    width: 48.w,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(14).w,
                                      border: Border.all(
                                        width: 1.w,
                                        color: const Color(0xFF3F4450),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.close,
                                        size: 18.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 4),
                                Image.asset(
                                  "assets/images/workentry-3d.webp",
                                  width: 26.w,
                                ),
                                const Spacer(),
                                Text(
                                  "Add Work Entry",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                                const Spacer(flex: 8),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20).w,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat("dd MMM, yyyy | EEE").format(DateTime.now()),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite.withOpacity(0.54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 4).w,
                              child: ValueListenableBuilder(
                                valueListenable: workNameText,
                                builder: (BuildContext context, value, Widget? child) {
                                  return Obx(() => Container(
                                    width: ScreenUtil().screenWidth,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(12).r,
                                      border: Border.all(
                                        width: _showValidation.value && _workNameController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                        color: _showValidation.value && _workNameController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 13, top: 10).h,
                                            child: Text(
                                              "Work Name *",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.h,
                                                color: _showValidation.value && _workNameController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 13).h,
                                            child: SizedBox(
                                              height: 35.h,
                                              child: TextFormField(
                                                controller: _workNameController,
                                                cursorColor: Colors.grey,
                                                readOnly: readOnly ?? false,
                                                onTap: () {
                                                  workNameText.value = true;
                                                  unitsDoneText.value = false;
                                                  descriptionText.value = false;
                                                },
                                                onChanged: (value) {
                                                  if (_showValidation.value) {
                                                    _showValidation.refresh();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Enter Work Name",
                                                  hintStyle: GoogleFonts.inter(
                                                    color: _showValidation.value && _workNameController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.h,
                                                  ),
                                                  border: InputBorder.none,
                                                  // contentPadding: const EdgeInsets.only(
                                                  //     left: 10, bottom: 0, top: 0)
                                                  //     .h,
                                                ),
                                                style: GoogleFonts.inter(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                              ),
                            ),
                            Obx(() => _showValidation.value && _workNameController.text.trim().isEmpty ? Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w, bottom: 5.w),
                                child: Text(
                                  "Work Name is required",
                                  style: GoogleFonts.inter(
                                    color: ColorUtils.errorRedText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ) : const SizedBox()),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4).w,
                              child: ValueListenableBuilder(
                                valueListenable: unitsDoneText,
                                builder: (BuildContext context, value, Widget? child) {
                                  return Obx(() => Container(
                                    width: ScreenUtil().screenWidth,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(12).r,
                                      border: Border.all(
                                        width: _showValidation.value && _unitsDoneController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                        color: _showValidation.value && _unitsDoneController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 13, top: 10).h,
                                            child: Text(
                                              "Units Done *",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.h,
                                                color: _showValidation.value && _unitsDoneController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 13).h,
                                            child: SizedBox(
                                              height: 35.h,
                                              child: TextFormField(
                                                controller: _unitsDoneController,
                                                cursorColor: Colors.grey,
                                                keyboardType: TextInputType.number,
                                                readOnly: readOnly ?? false,
                                                onTap: () {
                                                  workNameText.value = false;
                                                  unitsDoneText.value = true;
                                                  descriptionText.value = false;
                                                },
                                                onChanged: (value) {
                                                  if (_showValidation.value) {
                                                    _showValidation.refresh();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Enter Count",
                                                  hintStyle: GoogleFonts.inter(
                                                    color: _showValidation.value && _unitsDoneController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.h,
                                                  ),
                                                  border: InputBorder.none,
                                                  // contentPadding: const EdgeInsets.only(
                                                  //     left: 10, bottom: 0, top: 0)
                                                  //     .h,
                                                ),
                                                style: GoogleFonts.inter(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                              ),
                            ),
                            Obx(() => _showValidation.value && _unitsDoneController.text.trim().isEmpty ? Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w, bottom: 5.w),
                                child: Text(
                                  "Count is required",
                                  style: GoogleFonts.inter(
                                    color: ColorUtils.errorRedText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ) : const SizedBox()),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4).w,
                              child: ValueListenableBuilder(
                                valueListenable: descriptionText,
                                builder: (BuildContext context, value, Widget? child) {
                                  return Obx(() => Container(
                                    width: ScreenUtil().screenWidth,
                                    constraints: BoxConstraints(minHeight: 85.h),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(12).r,
                                      border: Border.all(
                                        width: _showValidation.value && _descriptionController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                        color: _showValidation.value && _descriptionController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 10.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Description *",
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.h,
                                              color: _showValidation.value && _descriptionController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          TextFormField(
                                            controller: _descriptionController,
                                            cursorColor: Colors.grey,
                                            readOnly: readOnly ?? false,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            minLines: 3,
                                            textInputAction: TextInputAction.newline,
                                            onTap: () {
                                              workNameText.value = false;
                                              unitsDoneText.value = false;
                                              descriptionText.value = true;
                                            },
                                            onChanged: (value) {
                                              if (_showValidation.value) {
                                                _showValidation.refresh();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: "Type here...",
                                              hintStyle: GoogleFonts.inter(
                                                color: _showValidation.value && _descriptionController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.h,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            style: GoogleFonts.inter(
                                              color: ColorUtils.textWhite,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                              ),
                            ),
                            Obx(() => _showValidation.value && _descriptionController.text.trim().isEmpty ? Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w, bottom: 5.w),
                                child: Text(
                                  "Description is required",
                                  style: GoogleFonts.inter(
                                    color: ColorUtils.errorRedText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ) : const SizedBox()),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 15).w,
                              child: GestureDetector(
                                onTap: () async {
                                  if(!(readOnly ?? false)) {
                                    await attachBottomSheetShow(mainContext, (bool value) {
                                      if(value) {
                                        setState(() {});
                                      }
                                    },);
                                  }
                                  // FilePickerResult? result = await FilePicker.platform.pickFiles();
                                  //
                                  // if (result != null) {
                                  //   List<File> files = result.paths.map((path) => File(path!)).toList();
                                  //   // setState(() {
                                  //   if(selectedFiles.length < 5) {
                                  //     if(files.length < (6 - selectedFiles.length)) {
                                  //       for (var file in files) {
                                  //         selectedFiles.add(file.path);
                                  //         setState(() {});
                                  //       }
                                  //     } else {
                                  //       ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
                                  //     }
                                  //   } else {
                                  //     ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
                                  //   }
                                  //   // });
                                  //   filePath.value = files.first.path;
                                  // } else {
                                  //   // User canceled the picker
                                  // }
                                },
                                child: Row(
                                  children: [
                                    // Text(
                                    //   "Attachments",
                                    //   style: GoogleFonts.inter(
                                    //     fontWeight: FontWeight.w400,
                                    //     fontSize: 14.sp,
                                    //     color: const Color(0xFFAAAAAA),
                                    //   ),
                                    // ),
                                    Column(
                                      children: [
                                        Text(
                                          "Attachments",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            color: const Color(0xFFAAAAAA),
                                          ),
                                        ),
                                        SizedBox(height: 5.w),
                                        Text(
                                          "Max 5 Files",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            color: const Color(0xFF5D626D),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8).w,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.foregroundBlack,
                                        borderRadius: BorderRadius.circular(23).w,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/attach_icon.svg",
                                            width: 17.w,
                                          ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            "Add",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8).w,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/add_location.webp",
                                    width: 35.w,
                                  ),
                                  SizedBox(width: 10.w),
                                  GetX<LocationFetchController>(
                                    builder: (LocationFetchController controller) {
                                      if(controller.isLoading.value) {
                                        return SizedBox(
                                          width: 15.w,
                                          height: 15.w,
                                          child: const CircularProgressIndicator(),
                                        );
                                      } else {
                                        return SizedBox(
                                          width: ScreenUtil().screenWidth * 0.7,
                                          child: InkWell(
                                            onTap: () async {
                                              if(!(readOnly ?? false)) {
                                                await locationFetchController.fetchLocationData();
                                              }
                                            },
                                            child: Text(
                                              controller.dataLoaded.value && controller.locName.toString() != "null" ? "${controller.locName}" : "Add Location (Optional)",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: const Color(0xFF5185D8),
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
                            if(readOnly ?? false)
                              Container(
                                height: 200.w,
                                child: ListView.separated(
                                  itemCount: sendWorkEntryController.selectedFiles.value.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 9).w,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 100.w,
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                                        decoration: BoxDecoration(
                                          color: ColorUtils.foregroundBlack,
                                          borderRadius: BorderRadius.circular(12).w,
                                        ),
                                        child: Image.file(
                                          File(sendWorkEntryController.selectedFiles.value[index]),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5.w),
                                ),
                              ),
                            if(!(readOnly ?? false))
                              Obx(() {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for(int index = 0; index < sendWorkEntryController.selectedFiles.value.length; index++)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 9).w,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ).h,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.foregroundBlack,
                                            borderRadius: BorderRadius.circular(12).r,
                                          ),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      sendWorkEntryController.selectedFiles.value.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: ColorUtils.textWhite,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  if(sendWorkEntryController.selectedFiles.value[index].split('.').last == 'pdf')
                                                    Image.asset(
                                                      "assets/images/manager_view/pdf_icon.png",
                                                      height: 35.h,
                                                    )
                                                  else
                                                    Image.file(
                                                      File(sendWorkEntryController.selectedFiles.value[index]),
                                                      height: 60.h,
                                                      width: 80.h,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Transform.rotate(
                                                          angle: 180,
                                                          child: Icon(
                                                            Icons.attach_file,
                                                            size: 28.h,
                                                            color: Colors.blueGrey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                ],
                                              ),
                                              SizedBox(width: 10.h),
                                              Flexible(
                                                child: Text(
                                                  sendWorkEntryController.selectedFiles.value[index].split("/").last,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.h,
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                            SizedBox(height: 50.h),
                            if(!(readOnly ?? false))
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    if(_workNameController.text.isNotEmpty &&
                                        _unitsDoneController.text.isNotEmpty &&
                                        _descriptionController.text.isNotEmpty) {
                                      // if(selectedFiles.isNotEmpty) {
                                      String? lat;
                                      String? long;
                                      if (locationFetchController.position.value != null) {
                                        lat = locationFetchController.position.value!.latitude.toString();
                                        long = locationFetchController.position.value!.longitude.toString();
                                      }
                                      WorkData workData = WorkData(
                                        workName: _workNameController.text,
                                        unitCount: _unitsDoneController.text,
                                        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                        description: _descriptionController.text,
                                        isActive: 1,
                                        createdBy: userAuthController.userData.value.userData?.employeeId ?? '--',
                                        files: sendWorkEntryController.selectedFiles.value,
                                        location: {
                                          "latitude": lat.toString(),
                                          "longitude": long.toString(),
                                          "locationName": locationFetchController.locName.value ?? '',
                                        },
                                        employeeId: userAuthController.userData.value.userData?.employeeId ?? '--',
                                        companyId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                      );
                                      await sendWorkEntryController.applyWorkEntry(workData: workData);
                                      await workEntryListController.fetchWorkEntryList(month: DateTime.now(), empId: userAuthController.userData.value.userData?.employeeId ?? '--');
                                      if(sendWorkEntryController.dataLoaded.value) {
                                        Navigator.of(context).pop();
                                        HapticFeedback.lightImpact();
                                        showWarn(mainContext: mainContext);
                                      } else {
                                        ErrorDialog().showWarn(context: context, title: "Submission Failed!", subTitle: "Something went wrong");
                                      }
                                    } else {
                                      _showValidation.value = true;
                                    }
                                  } catch(_) {} finally {
                                    sendWorkEntryController.dataLoaded.value = false;
                                  }
                                },
                                child: Container(
                                  height: 52.w,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF6A4BFC),
                                      borderRadius: BorderRadius.circular(37).w
                                  ),
                                  child: Center(
                                    child: Obx(() {
                                      if(sendWorkEntryController.isLoading.value) {
                                        return SizedBox(
                                          width: 15.w,
                                          height: 15.w,
                                          child: const CircularProgressIndicator(color: ColorUtils.textWhite),
                                        );
                                      } else {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/disk.svg",
                                              width: 18.h,
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              'Save',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.h,
                                                color: ColorUtils.textWhite,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> attachBottomSheetShow(mainContext, Function(bool) callBack) async {
    showModalBottomSheet(
      context: mainContext,
      backgroundColor: Colors.black,
      barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: 273.w,
                  decoration: BoxDecoration(
                    color: ColorUtils.backgroundBlack,
                    borderRadius: BorderRadius.circular(20).w,
                    border: Border.all(
                      width: 1.w,
                      color: const Color(0xFF404040),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Source",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(mainContext)
                                .push(newSlideNavigation(const CameraViewLeave()))
                                .then((value) async {
                              if (value == null) return;

                              final file = File(value);
                              final fileSizeInBytes = await file.length();
                              final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                              if (fileSizeInMB > 5) {
                                ErrorDialog().showWarn(
                                  context: mainContext,
                                  title: "Error",
                                  subTitle: "File size should be less than 5 MB",
                                );
                                return;
                              }

                              if ((sendWorkEntryController.selectedFiles.value.length + 1) <= 5) {
                                sendWorkEntryController.setFiles([value]);
                                callBack(true);
                              } else {
                                ErrorDialog().showWarn(
                                  context: mainContext,
                                  title: "Error",
                                  subTitle: "Maximum 5 files allowed",
                                );
                              }
                            });
                          },
                          child: const AttachMenuCard(
                            imageIcon: "assets/images/camera.webp",
                            title: "Camera",
                            subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
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

                              if (result == null || result.files.isEmpty) {
                                return; // User cancelled
                              }

                              List<int> removeFiles = [];

                              for (int i = 0; i < result.files.length; i++) {
                                final fileSizeInBytes = result.files[i].size;
                                final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                                if (fileSizeInMB > 5) {
                                  removeFiles.add(i);
                                }
                              }

                              if(removeFiles.length == 1) {
                                Get.snackbar(
                                  "Message",
                                  "The file ${result.files[removeFiles.first].name} was removed because its size exceeds 5 MB.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10.h),
                                );
                                result.files.removeAt(removeFiles.first);
                              } else if(removeFiles.length > 1) {
                                Get.snackbar(
                                  "Message",
                                  "${removeFiles.length} files were removed because they exceed the 5 MB size limit.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10.h),
                                );
                                removeFiles.sort((a, b) => b.compareTo(a));

                                for (final index in removeFiles) {
                                  result.files.removeAt(index);
                                }
                              }

                              if (result.files.isEmpty) {
                                return;
                              }

                              if((sendWorkEntryController.selectedFiles.value.length + result.files.length) <= 5) {
                                sendWorkEntryController.setFiles(result.files.map((e) => e.path ?? '').where((element) => element.isNotEmpty).toList());
                                callBack(true);
                              } else {
                                ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
                              }

                            } catch (e) {
                              AttendanceCommonWidgets()
                                  .printF("------error-------${e.toString()}");
                            }
                          },
                          child: const AttachMenuCard(
                            imageIcon: "assets/images/image-3d.webp",
                            title: "Photos",
                            subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                            );

                            if (result != null) {

                              List<int> removeFiles = [];

                              for (int i = 0; i < result.files.length; i++) {
                                final fileSizeInBytes = result.files[i].size;
                                final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                                if (fileSizeInMB > 5) {
                                  removeFiles.add(i);
                                }
                              }

                              if(removeFiles.length == 1) {
                                Get.snackbar(
                                  "Message",
                                  "The file ${result.files[removeFiles.first].name} was removed because its size exceeds 5 MB.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10.h),
                                );
                                result.files.removeAt(removeFiles.first);
                              } else if(removeFiles.length > 1) {
                                Get.snackbar(
                                  "Message",
                                  "${removeFiles.length} files were removed because they exceed the 5 MB size limit.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10.h),
                                );
                                removeFiles.sort((a, b) => b.compareTo(a));

                                for (final index in removeFiles) {
                                  result.files.removeAt(index);
                                }
                              }

                              if (result.files.isEmpty) {
                                return;
                              }

                              if((sendWorkEntryController.selectedFiles.value.length + result.files.length) <= 5) {
                                sendWorkEntryController.setFiles(result.files.map((e) => e.path ?? '').where((element) => element.isNotEmpty).toList());
                                callBack(true);
                              } else {
                                ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
                              }
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: const AttachMenuCard(
                            imageIcon: "assets/images/file-3d.webp",
                            title: "Browse",
                            subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
