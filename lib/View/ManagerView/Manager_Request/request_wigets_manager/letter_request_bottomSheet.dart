
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../../Leave_Page/leave_widgets/leave_type_card.dart';

class LetterRequestBottomSheetManager extends StatelessWidget {
  final WfhLrData? wfhLrList;
  const LetterRequestBottomSheetManager({super.key, this.wfhLrList});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              // height: MediaQuery.of(context).viewInsets.bottom + 530.h,
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ).r,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RegularizeTitle(
                      title: "Letter Request",
                      image: "assets/images/Hourglass-3d.webp",
                      action: () {
                        Get.find<ManagerRequestController>().reasonController.text = '';
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 18.h),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _EmployeeData(wfhLrList),
                              SizedBox(height: 20.h),
                              _RequestType(wfhLrList),
                              SizedBox(height: 16.h),
                              ReasonTextField(
                                  requestType: RequestType.letterRequest,
                                  fieldText: wfhLrList?.requestDescription,
                                  readOnly: true,
                                fieldController: Get.find<ManagerRequestController>().reasonController,
                              ),
                              if(wfhLrList?.requestStatusName.toString().toLowerCase() == 'pending')
                                SizedBox(height: 15.h),
                              if(wfhLrList?.requestStatusName.toString().toLowerCase() == 'pending')
                                ReasonTextField(
                                requestType: RequestType.letterRequest,
                                readOnly: false,
                                fieldController: Get.find<ManagerRequestController>().remarksController,
                              ),
                              if(wfhLrList?.requestStatusName.toString().toLowerCase() == 'pending')
                                SizedBox(height: 10.h),
                              GetX<ManagerRequestController>(
                                  builder: (ManagerRequestController controller) {
                                    if(controller.showReasonValidation.value) {
                                      return Row(
                                        children: [
                                          SizedBox(width: 6.h),
                                          Flexible(
                                            child: Text(
                                              'Please add your comments before approving.',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  }
                              ),
                              SizedBox(height: 15.h),
                              if(wfhLrList?.requestStatusName.toString().toLowerCase() == 'pending')
                                Obx(() {
                                  final controller = Get.find<ManagerRequestController>();
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (controller.letterRequestFiles.length < 5)
                                        const _FileUpload(),
                                      if (controller.letterRequestFiles.isNotEmpty) ...[
                                        SizedBox(height: 10.h),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: controller.letterRequestFiles.length,
                                          separatorBuilder: (context, index) => SizedBox(height: 8.h),
                                          itemBuilder: (context, index) {
                                            final fileData = controller.letterRequestFiles[index];
                                            return _SelectedFileItem(fileData: fileData);
                                          },
                                        ),
                                      ],
                                    ],
                                  );
                                }),
                              if(wfhLrList?.approvedDocument?.isNotEmpty ?? false)
                                SizedBox(
                                  height: 200.w,
                                  child: ListView.separated(
                                    itemCount: wfhLrList?.approvedDocument?.length ?? 0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 9).w,
                                        child: InkWell(
                                          onTap: () async {
                                            try {
                                              await launchUrl(Uri.parse(wfhLrList!.approvedDocument![index]));
                                            } catch(e) {}
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.lavenderMist,
                                              borderRadius: BorderRadius.circular(12).w,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: wfhLrList?.approvedDocument?[index] ?? '',
                                              errorWidget: (context, url, error) => Container(),
                                              placeholder: (context, url) => Container(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5.w),
                                  ),
                                ),
                              if((wfhLrList?.approvalData?.isNotEmpty ?? false) || wfhLrList?.adminData != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                                  child: HierarchyApprovalStatus(
                                      approvalData: wfhLrList?.approvalData,
                                    mainStatus: wfhLrList?.mainStatus,
                                    adminData: wfhLrList?.adminData,
                                  ),
                                ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).viewInsets.bottom + (wfhLrList?.mainStatus.toString().toLowerCase() == 'pending' ? 70.h : 30.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if(wfhLrList?.requestStatusName.toString().toLowerCase() == 'pending')
            Positioned(
              bottom: 0,
              right: 15.w,
              left: 15.w,
              child: Column(
                children: [
                  ActionButtons(
                    cancelText: "Reject",
                    okText: "Approve",
                    action: (value) async {
                      ManagerRequestController managerController = Get.find<ManagerRequestController>();
                      managerController.validateRemarksField();
                      if(managerController.remarksController.text.trim().isNotEmpty) {
                        String? result = await Get.find<ManagerRequestController>().submitWfhLrRequestUpdate(
                          action: value,
                        );
                        Navigator.of(context).pop();
                        if(result != null) {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.green,
                            message: result,
                          );
                        } else {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.red,
                            message: "Failed to submit.",
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 5.h),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EmployeeData extends StatelessWidget {
  final WfhLrData? wfhLrList;
  const _EmployeeData(this.wfhLrList);

  @override
  Widget build(BuildContext context) {
    String? requestDate;
    try {
      DateTime date = DateTime.parse(wfhLrList!.fromDate!);
      requestDate = DateFormat('dd MMM yyyy | EEE').format(date);
    } catch(e) {}
    return Row(
      children: [
        // Image.asset("assets/examples/user_request.png", height: 30.h),
        AttendanceCommonWidgets().cachedNetworkImage(
          wfhLrList?.profilePicture ?? '--',
          height: 28.h,
        ),
        SizedBox(width: 8.h),
        Expanded(
          child: AttendanceCommonWidgets().nameWithDesignation(
              name: wfhLrList?.employeeName ?? '--',
              designation:wfhLrList?.employeeDesignation?? '--',
          ),
        ),
        SizedBox(width: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date :",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
            Text(
              requestDate ?? '--',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RequestType extends StatelessWidget {
  final WfhLrData? wfhLrList;
  const _RequestType(this.wfhLrList);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 3.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  "Letter Request : ",
                  style: GoogleFonts.poppins(
                    fontSize: 11.h,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
                Expanded(
                  child: Text(
                    wfhLrList?.requestLetterType ?? '--',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11.h,
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.workEntryHead,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 5.h,
            ),
            child: Container(width: 1.h, height: 14.h, color: ColorUtils.paleSilver),
          ),
        ],
      ),
    );
  }
}

class _FileUpload extends StatelessWidget {
  const _FileUpload();

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: ColorUtils.lavenderBlue,
      strokeWidth: 1.h,
      dashPattern: [3, 1],
      borderType: BorderType.RRect,
      radius: Radius.circular(12).r,
      child: GestureDetector(
        onTap: () {
          attachBottomSheetShow(context);
        },
        child: Container(
          width: ScreenUtil().screenWidth * 0.9,
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Image.asset(
                "assets/images/manager_view/file_upload.png",
                height: 40.h,
              ),
              SizedBox(height: 10.h),
              Text(
                "Upload file here",
                style: GoogleFonts.inter(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "(Max. File size: 25 MB)",
                style: GoogleFonts.inter(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF353535).withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedFileItem extends StatelessWidget {
  final SelectedFileData fileData;
  const _SelectedFileItem({required this.fileData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ManagerRequestController>();
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(1).h,
            decoration: BoxDecoration(
              color: ColorUtils.whisperGrey,
              borderRadius: BorderRadius.circular(12).r,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.h,
              ),
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(11).r,
              ),
              child: Row(
                children: [
                  if (fileData.filePath.split(".").last.toLowerCase() == "pdf")
                    Image.asset(
                      "assets/images/manager_view/pdf_icon.png",
                      height: 35.h,
                    )
                  else
                    Icon(Icons.attachment, color: ColorUtils.silverGrey, size: 18.h),
                  SizedBox(width: 15.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileData.fileName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                        Text(
                          "Size: ${fileData.fileSize}",
                          style: GoogleFonts.inter(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF353535),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Image.asset(
                    "assets/images/manager_view/tick-circle-green.png",
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            controller.letterRequestFiles.remove(fileData);
          },
          icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 18.h),
        ),
      ],
    );
  }
}


attachBottomSheetShow(mainContext) {
  showModalBottomSheet(
    context: mainContext,
    backgroundColor: Colors.white,
    barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.3),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(1).h,
            decoration: BoxDecoration(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(21).w,
            ),
            child: Container(
              width: ScreenUtil().screenWidth,
              height: 273.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(20).w,
                // border: Border.all(
                //   width: 1.w,
                //   color: const Color(0xFF404040),
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Source",
                      style: GoogleFonts.poppins(
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        final controller = Get.find<ManagerRequestController>();
                        if (controller.letterRequestFiles.length >= 5) {
                          showMessage("You can only select up to 5 files");
                          return;
                        }
                        Navigator.of(context).push(
                          newSlideNavigation(const CameraViewLeave()),
                        ).then((value) async {
                          if (value == null) return;
                          File file = File(value);
                          int fileSizeInBytes = await file.length();
                          if (fileSizeInBytes < 25 * 1024 * 1024) {
                            controller.letterRequestFiles.add(SelectedFileData(
                              fileName: value.split("/").last.split(".").first,
                              filePath: value,
                              fileSize: getFileSize(fileSizeInBytes),
                            ));
                          } else {
                            showMessage("The selected file is above 25 MB");
                          }
                        });
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/camera.webp",
                        title: "Camera",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        final controller = Get.find<ManagerRequestController>();
                        if (controller.letterRequestFiles.length >= 5) {
                          showMessage("You can only select up to 5 files");
                          return;
                        }
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp'],
                          );
        
                          if (result == null) {
                            return; // User cancelled
                          }
        
                          bool showSizeLimitMsg = false;
                          bool showMaxLimitMsg = false;
        
                          for (var file in result.files) {
                            if (controller.letterRequestFiles.length >= 5) {
                              showMaxLimitMsg = true;
                              break;
                            }
                            final filePath = file.path;
                            if (filePath == null) continue;
                            final fileSizeInBytes = file.size;
        
                            if (fileSizeInBytes >= 25 * 1024 * 1024) {
                              showSizeLimitMsg = true;
                              continue;
                            }
        
                            controller.letterRequestFiles.add(
                              SelectedFileData(
                                fileName: p.basenameWithoutExtension(filePath),
                                filePath: filePath,
                                fileSize: getFileSize(fileSizeInBytes),
                              )
                            );
                          }
        
                          if (showSizeLimitMsg) {
                            showMessage("The selected file is above 25 MB");
                          }
                          if (showMaxLimitMsg) {
                            showMessage("You can only select up to 5 files");
                          }
                        } catch (e) {
                          AttendanceCommonWidgets().printF("------error-------${e.toString()}");
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/image-3d.webp",
                        title: "Photos",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        final controller = Get.find<ManagerRequestController>();
                        if (controller.letterRequestFiles.length >= 5) {
                          showMessage("You can only select up to 5 files");
                          return;
                        }
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                          );
        
                          if (result == null) {
                            return; // User cancelled
                          }
        
                          bool showSizeLimitMsg = false;
                          bool showMaxLimitMsg = false;
        
                          for (var file in result.files) {
                            if (controller.letterRequestFiles.length >= 5) {
                              showMaxLimitMsg = true;
                              break;
                            }
                            final filePath = file.path;
                            if (filePath == null) continue;
                            final fileSizeInBytes = file.size;
        
                            if (fileSizeInBytes >= 25 * 1024 * 1024) {
                              showSizeLimitMsg = true;
                              continue;
                            }
        
                            controller.letterRequestFiles.add(
                              SelectedFileData(
                                fileName: p.basenameWithoutExtension(filePath),
                                filePath: filePath,
                                fileSize: getFileSize(fileSizeInBytes),
                              )
                            );
                          }
        
                          if (showSizeLimitMsg) {
                            showMessage("The selected file is above 25 MB");
                          }
                          if (showMaxLimitMsg) {
                            showMessage("You can only select up to 5 files");
                          }
                        } catch (e) {
                          AttendanceCommonWidgets().printF("------error-------${e.toString()}");
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/file-3d.webp",
                        title: "Browse",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

String getFileSize(int fileSizeInBytes) {
  if (fileSizeInBytes < 1024) {
    return "$fileSizeInBytes B"; // Bytes
  } else if (fileSizeInBytes < 1024 * 1024) {
    return "${(fileSizeInBytes / 1024).toStringAsFixed(2)} KB"; // Kilobytes
  } else if (fileSizeInBytes < 1024 * 1024 * 1024) {
    return "${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB"; // Megabytes
  } else {
    return "${(fileSizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB"; // Gigabytes
  }
}

void showMessage(String message) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: Text(
        message,
        style: GoogleFonts.poppins(
          color: ColorUtils.workEntryHead,
          fontSize: 12.h,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: ColorUtils.textWhite,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(
        bottom: 50,
        right: 50,
        left: 50,
      ),
      borderRadius: 24.r,
    ),
  );
}

Future<void> getLostData(mainContext) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  final LostDataResponse response = await picker.retrieveLostData();
  final controller = Get.find<ManagerRequestController>();

  if(image != null) {
    if (controller.letterRequestFiles.length >= 5) {
      showMessage("You can only select up to 5 files");
    } else {
      File file = File(image.path);
      int fileSizeInBytes = await file.length();
      if (fileSizeInBytes < 25 * 1024 * 1024) {
        controller.letterRequestFiles.add(SelectedFileData(
          fileName: image.path.split("/").last.split(".").first,
          filePath: image.path,
          fileSize: getFileSize(fileSizeInBytes),
        ));
      } else {
        showMessage("The selected file is above 25 MB");
      }
    }
  }
  if (response.isEmpty) {
    return;
  }
  final List<XFile>? files = response.files;

  bool showSizeLimitMsg = false;
  bool showMaxLimitMsg = false;

  files?.forEach((element) async {
    if (controller.letterRequestFiles.length >= 5) {
      showMaxLimitMsg = true;
      return;
    }
    File file = File(element.path);

    int fileSizeInBytes = await file.length();
    if (fileSizeInBytes < 25 * 1024 * 1024) {
      controller.letterRequestFiles.add(SelectedFileData(
        fileName: element.path.split("/").last.split(".").first,
        filePath: element.path,
        fileSize: getFileSize(fileSizeInBytes),
      ));
    } else {
      showSizeLimitMsg = true;
    }
  });

  if (showSizeLimitMsg) {
    showMessage("The selected file is above 25 MB");
  }
  if (showMaxLimitMsg) {
    showMessage("You can only select up to 5 files");
  }
}



