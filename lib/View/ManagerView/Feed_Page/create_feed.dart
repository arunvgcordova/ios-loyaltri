import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_widgets/filter_bottom_sheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/feed_data_list_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../controller/ui_controller/home_controller.dart';
import '../../../controller/ui_controller/page_controller.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../Leave_Page/leave_widgets/leave_type_card.dart';

class CreateFeed extends StatefulWidget {
  const CreateFeed({super.key});

  @override
  State<CreateFeed> createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    Get.find<FeedViewController>().clearSelections(except: PostSettings.organization);
    await Get.find<FeedViewController>().fetchAllCompanyList();
    await Get.find<FeedViewController>().fetchSettings(settings: PostSettings.location);
    await Get.find<FeedViewController>().fetchSettings(settings: PostSettings.category);
    await Get.find<FeedViewController>().fetchSettings(settings: PostSettings.department);
    context.loaderOverlay.hide();
  }

  @override
  void dispose() {
    Get.find<FeedViewController>().showFieldValidation.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppView appView = Get.find<UserPageController>().appView.value;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: appView == AppView.manager ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
          body: Padding(
            padding: EdgeInsets.only(
              left: 15.h,
              right: 15.h,
              bottom: 8.h,
              top: 15.h,
            ),
            child: Column(
              children: [
                SafeArea(
                  top: true,
                  bottom: false,
                  left: false,
                  right: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 48.h,
                          width: 48.h,
                          decoration: BoxDecoration(
                            color: appView == AppView.manager ? ColorUtils.textWhite.withValues(alpha: 0.8) : ColorUtils.foregroundBlack,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              width: 1.h,
                              color: appView == AppView.manager ? ColorUtils.charcoalBlue.withValues(alpha: 0.1) : const Color(0xFF3F4450),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              size: 18.h,
                              color: appView == AppView.manager ? ColorUtils.workEntryHead : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/feed_icon.svg",
                            height: 17.h,
                          ),
                          SizedBox(width: 7.h),
                          Text(
                            "Create a Post",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.h,
                              color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 48.h,
                        width: 48.h,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    GetX<FeedViewController>(
                      builder: (FeedViewController controller) {
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Post to ',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                ),
                              ),
                              TextSpan(
                                text: postTo(controller.selectedSettings.value),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                  decoration: TextDecoration.underline,
                                  decorationColor: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    bool? save = await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        backgroundColor: appView == AppView.manager ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
                                        barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.55),
                                        builder: (context) {
                                          return FilterBottomSheet();
                                        },
                                    );
          
                                    if(save != true) {
                                      Get.find<FeedViewController>().clearSelections(except: PostSettings.organization);
                                    }
                                  },
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Obx(() {
                            return TextField(
                              onChanged: (value) {
                                Get.find<FeedViewController>().feedText.value = value;
                                Get.find<FeedViewController>().showFieldValidation.refresh();
                              },
                              style: GoogleFonts.inter(
                                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                              ),
                              decoration: InputDecoration(
                                hintText: "Type Feed *",
                                contentPadding: EdgeInsets.all(10.h),
                                fillColor: appView == AppView.manager ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: (Get.find<FeedViewController>().showFieldValidation.value && Get.find<FeedViewController>().feedText.value.trim().isEmpty)
                                      ? BorderSide(
                                    color: ColorUtils.errorRedBorder,
                                    width: 1.h
                                  )
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: (Get.find<FeedViewController>().showFieldValidation.value && Get.find<FeedViewController>().feedText.value.trim().isEmpty)
                                      ? BorderSide(
                                      color: ColorUtils.errorRedBorder,
                                      width: 1.h
                                  )
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: (Get.find<FeedViewController>().showFieldValidation.value && Get.find<FeedViewController>().feedText.value.trim().isEmpty)
                                      ? BorderSide(
                                      color: ColorUtils.errorRedBorder,
                                      width: 1.h
                                  )
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                hintStyle: GoogleFonts.inter(
                                  color: (Get.find<FeedViewController>().showFieldValidation.value && Get.find<FeedViewController>().feedText.value.trim().isEmpty)
                                      ? ColorUtils.errorRedBorder.withValues(alpha: 0.5)
                                      : appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.6) : ColorUtils.textWhite.withValues(alpha: 0.2),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                ),
                              ),
                              maxLines: 10,
                            );
                          }
                        ),
                        Obx(() => (Get.find<FeedViewController>().showFieldValidation.value && Get.find<FeedViewController>().feedText.value.trim().isEmpty) ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, top: 5.w),
                            child: Text(
                              "Feed content is required",
                              style: GoogleFonts.inter(
                                color: ColorUtils.errorRedText,
                                fontWeight: FontWeight.w400,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ) : const SizedBox()),
                        SizedBox(height: 15.h),
                        GetX<FeedViewController>(
                          builder: (FeedViewController controller) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if(controller.selectedImgPath.value.isEmpty)
                                  InkWell(
                                    borderRadius: BorderRadius.circular(23).r,
                                    onTap: () {
                                      attachBottomSheetShow(context, appView);
                                    },
                                    child: Container(
                                      height: 48.h,
                                      decoration: BoxDecoration(
                                        color: appView == AppView.manager ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                        borderRadius: BorderRadius.circular(23).r,
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/manager_view/add_image_icon.svg",
                                              height: 16.h,
                                              colorFilter: ColorFilter.mode(appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 10.h),
                                            Text(
                                              "Add Image",
                                              style: GoogleFonts.poppins(
                                                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if(controller.selectedImgPath.value.isNotEmpty)
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15).r,
                                        child: Image.file(
                                          File(controller.selectedImgPath.value),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          width: 30.h,
                                          height: 30.h,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.textWhite.withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(1000).r,
                                              onTap: () {
                                              controller.selectedImgPath.value = '';
                                              },
                                              child: Icon(Icons.close, color: ColorUtils.textWhite, size: 15.h),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          }
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 10.h,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(37).r,
              onTap: () async {
                if(Get.find<FeedViewController>().feedText.value.trim().isEmpty) {
                  Get.find<FeedViewController>().showFieldValidation.value = true;
                  return;
                }
                Map<String, dynamic> feedResp = {};
                try {
                  context.loaderOverlay.show();
                  String nickName = Get.find<UserProfileController>().userData.value.result.nickName ?? '';
                  String empName = nickName.trim().isNotEmpty ? nickName : Get.find<UserProfileController>().userData.value.result.firstName ?? '';
                  String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
                  String orgId = Get.find<UserProfileController>().userData.value.result.organisationId ?? '';
                  String empCompId = Get.find<UserPageController>().appView.value == AppView.manager
                      ? Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? ''
                      : Get.find<UserProfileController>().userData.value.result.companyId ?? '';
                  FeedViewController feedViewController = Get.find<FeedViewController>();
                  PostSettings selectedSettings = feedViewController.selectedSettings.value;
                  List<String> companyIds = feedViewController.selectedCompanies.value.map((e) => e.companyId.toString()).toList();
                  List<String> locationIds = feedViewController.selectedLocations.value.map((e) => e.locationId.toString()).toList();
                  List<String> categoryIds = feedViewController.selectedCategories.value.map((e) => e.categoryId.toString()).toList();
                  List<String> departmentIds = feedViewController.selectedDepartments.value.map((e) => e.departmentId.toString()).toList();
                  if(!companyIds.contains(empCompId) && selectedSettings != PostSettings.organization) {
                    companyIds.add(empCompId);
                  }
                  feedResp = await ApiServices.postAFeed(
                    title: empName,
                    empId: empId,
                    orgId: orgId,
                    compIds: companyIds,
                    locIds: locationIds,
                    categoryIds: categoryIds,
                    deptIds: departmentIds,
                    description: Get.find<FeedViewController>().feedText.value,
                  );
                  AttendanceCommonWidgets().printF("---------feedResp-------$feedResp");
                  if(Get.find<FeedViewController>().selectedImgPath.value.isNotEmpty) {
                    Map<String, dynamic> feedFileResp = await ApiServices.feedFileUpload(
                      imagePath: Get.find<FeedViewController>().selectedImgPath.value,
                      insertedId: feedResp['result']?['insertedId']?.toString() ?? '',
                    );
                    AttendanceCommonWidgets().printF("---------feedFileResp-------$feedFileResp");
                  }
                  if(feedResp['status']?.toString() == "200") {
                    AttendanceCommonWidgets().showSnackBar(context: context, backgroundColor: Colors.green, message: feedResp['message']);
                    await Get.find<FeedViewController>().fetchFeedListUser(loadMore: false);
                  } else {
                    AttendanceCommonWidgets().showSnackBar(context: context, backgroundColor: Colors.red, message: feedResp['message'] ?? '${feedResp['error'] ?? feedResp['errors'] ?? 'Something went wrong'}');
                  }
                  Get.find<FeedViewController>().feedText.value = '';
                  Get.find<FeedViewController>().selectedImgPath.value = '';
                  context.loaderOverlay.hide();
                  Navigator.of(context).pop();
                } catch(e) {
                  context.loaderOverlay.hide();
                  AttendanceCommonWidgets().showSnackBar(context: context, backgroundColor: Colors.red, message: feedResp['message'] ?? '${feedResp['error'] ?? feedResp['errors']}');
                } finally {
        
                }
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: ColorUtils.secondaryBlue,
                  borderRadius: BorderRadius.circular(37).r,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/images/manager_view/post_feed_icon.svg",
                        height: 21.h,
                      ),
                      SizedBox(width: 10.h),
                      Text(
                        "Looks Good, Post Now!",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  attachBottomSheetShow(mainContext, appView) {
    showModalBottomSheet(
      context: mainContext,
      backgroundColor: appView == AppView.manager ? ColorUtils.textWhite : Colors.black,
      barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: ScreenUtil().screenWidth,
              height: 273.w,
              decoration: BoxDecoration(
                color: appView == AppView.manager ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
                borderRadius: BorderRadius.circular(20).w,
                border: appView == AppView.manager ? null : Border.all(
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
                        color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : ColorUtils.textWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          newSlideNavigation(const CameraViewLeave()),
                        ).then((value) async {
                          if(value == null) return;
                          final file = File(value);
                          final fileSizeInBytes = await file.length();
                          final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                          if (fileSizeInMB > 5) {
                            if(appView == AppView.manager) {
                              ErrorDialog().showWarnManager(
                                context: mainContext,
                                title: "Error",
                                subTitle: "File size should be less than 5 MB",
                              );
                            } else {
                              ErrorDialog().showWarn(
                                context: mainContext,
                                title: "Error",
                                subTitle: "File size should be less than 5 MB",
                              );
                            }
                            return;
                          }
                          Get.find<FeedViewController>().selectedImgPath.value = value;
                        });
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/camera.webp",
                        title: "Camera",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: appView == AppView.manager ? ColorUtils.softPearl : null,
                        textColor: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : null,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp'],
                          );

                          if (result != null && result.files.single.path != null) {
                            final file = File(result.files.single.path!);
                            final fileSizeInBytes = await file.length();
                            final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                            if (fileSizeInMB > 5) {
                              if(appView == AppView.manager) {
                                ErrorDialog().showWarnManager(
                                  context: mainContext,
                                  title: "Error",
                                  subTitle: "File size should be less than 5 MB",
                                );
                              } else {
                                ErrorDialog().showWarn(
                                  context: mainContext,
                                  title: "Error",
                                  subTitle: "File size should be less than 5 MB",
                                );
                              }
                              return;
                            }
                            Get.find<FeedViewController>().selectedImgPath.value = file.path;
                          } else {
                            // User canceled the picker
                          }
                        } catch(e) {
                          AttendanceCommonWidgets().printF("------error-------${e.toString()}");
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/image-3d.webp",
                        title: "Photos",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: appView == AppView.manager ? ColorUtils.softPearl : null,
                        textColor: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : null,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp'],
                        );
          
                        if (result != null && result.files.single.path != null) {
                          final file = File(result.files.single.path!);
                          final fileSizeInBytes = await file.length();
                          final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                          if (fileSizeInMB > 5) {
                            if(appView == AppView.manager) {
                              ErrorDialog().showWarnManager(
                                context: mainContext,
                                title: "Error",
                                subTitle: "File size should be less than 5 MB",
                              );
                            } else {
                              ErrorDialog().showWarn(
                                context: mainContext,
                                title: "Error",
                                subTitle: "File size should be less than 5 MB",
                              );
                            }
                            return;
                          }
                          Get.find<FeedViewController>().selectedImgPath.value = file.path;
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/file-3d.webp",
                        title: "Browse",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: appView == AppView.manager ? ColorUtils.softPearl : null,
                        textColor: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : null,
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

  Future<void> getLostData(mainContext) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final LostDataResponse response = await picker.retrieveLostData();
    // AttendanceCommonWidgets().printF("------path------${image.path}");
    if(image != null) {
      Get.find<FeedViewController>().selectedImgPath.value = image.path;
    }
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;

    files?.forEach((element) {
      Get.find<FeedViewController>().selectedImgPath.value = files.first.path;
      AttendanceCommonWidgets().printF("------path------${element.path}");
    });
    if (files != null) {
      // _handleLostFiles(files);
    } else {
      // _handleError(response.exception);
    }
  }

  String postTo(PostSettings settings) {
    switch(settings) {
      case PostSettings.entity: return 'Your entity';
      case PostSettings.location: return 'Your location';
      case PostSettings.category: return 'Your category';
      case PostSettings.department: return 'Your department';
      default: return 'Anyone';
    }
  }
}
