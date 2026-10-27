
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../../services/api_services.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/api_constants.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../controller/myRequestController.dart';
import '../my_request_models/request_send_model.dart';
import 'Choose_Request_Dates.dart';

class WorkFromHomeRequestBottomSheet extends StatefulWidget {
  const WorkFromHomeRequestBottomSheet({super.key});

  @override
  State<WorkFromHomeRequestBottomSheet> createState() => _WorkEntryBottomSheetState();
}

class _WorkEntryBottomSheetState extends State<WorkFromHomeRequestBottomSheet> {
  ValueNotifier<String> fromDate = ValueNotifier("From Date");
  ValueNotifier<String> toDate = ValueNotifier("To Date");
  ValueNotifier<DateTime?> fromDateTime = ValueNotifier(null);
  ValueNotifier<DateTime?> toDateTime = ValueNotifier(null);
  TextEditingController _reasonController = TextEditingController();
  FocusNode _resonFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: KeyboardAvoider(
        child: IntrinsicHeight(
          child: Container(
            // height: 530.w,
            // width: ScreenUtil().screenWidth,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10).w,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5.w,
                          width: 100.w,
                          decoration: BoxDecoration(
                              color: ColorUtils.textWhite.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50).w
                          ),
                        ),
                        SizedBox(height: 15.w),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // const Spacer(),
                            GestureDetector(
                              onTap: () {
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/my_request.webp",
                                  width: 35.w,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Add Request",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 48.w,
                              width: 48.w,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                        SizedBox(height: 25.w),
                        Container(
                          height: 50.w,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 13).w,
                          width: ScreenUtil().screenWidth,
                          decoration: BoxDecoration(
                            color: ColorUtils.foregroundBlack,
                            borderRadius: BorderRadius.circular(10).w,
                          ),
                          child: Text(
                            "Work From Home Request",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.w),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ChooseRequestDates(),
                              ),
                            ).then((value) {
                              if (value != null && value is LeaveDates) {
                                if(value.startDate != null) {
                                  fromDateTime.value = value.startDate;
                                  fromDate.value = DateFormat('yyyy-MM-dd').format(value.startDate!);
                                }
                                if(value.endDate != null) {
                                  toDateTime.value = value.endDate;
                                  toDate.value = DateFormat('yyyy-MM-dd').format(value.endDate!);
                                }
                              }
                            });
                          },
                          child: SizedBox(
                            width: ScreenUtil().screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).w,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(10).w,
                                  ),
                                  child: SizedBox(
                                    width: 130.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: fromDate,
                                          builder: (BuildContext context, value, Widget? child) {
                                            return Text(
                                              value,
                                              style: GoogleFonts.inter(
                                                color: ColorUtils.textWhite.withOpacity(0.5),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: const Color(0xFF9A9A9A).withOpacity(0.6),
                                          size: 17.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).w,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(10).w,
                                  ),
                                  child: SizedBox(
                                    width: 130.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: toDate,
                                          builder: (BuildContext context, value, Widget? child) {
                                            return Text(
                                              value,
                                              style: GoogleFonts.inter(
                                                color: ColorUtils.textWhite.withOpacity(0.5),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: const Color(0xFF9A9A9A).withOpacity(0.6),
                                          size: 17.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.w),
                        Container(
                          height: 180.w,
                          width: ScreenUtil().screenWidth,
                          padding: const EdgeInsets.all(15).w,
                          decoration: BoxDecoration(
                              color: ColorUtils.foregroundBlack,
                              borderRadius: BorderRadius.circular(15).w
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Reason",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFAAAAAA).withOpacity(0.7),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              ),
                              TextField(
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                                controller: _reasonController,
                                focusNode: _resonFocus,
                                decoration: InputDecoration(
                                  hintText: "Description (Optional)",
                                  contentPadding: const EdgeInsets.all(0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFFAAAAAA).withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.w),
                        GestureDetector(
                          onTap: () async {
                            await applyWfhReq();
                          },
                          child: const LoyaltriBlueTextButton(text: "Apply for Work From Home"),
                        ),
                        SizedBox(height: 10.w),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<void> applyWfhReq() async {
    if(_resonFocus.hasFocus) {
      _resonFocus.unfocus();
    }
    String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
    String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
    bool connection = await ConnectivityService().check();
    if(fromDateTime.value != null && toDateTime.value != null) {
      if(_reasonController.text != '') {
        if (!mounted) return;
        context.loaderOverlay.show();
        RequestSendModel request = RequestSendModel(
          employeeId: empId,
          requestType: null,
          description: _reasonController.text,
          fromDate: fromDate.value,
          toDate: toDate.value,
          companyId: compId,
        );
        try {
          if(connection) {
            Map<String, dynamic> resp = await saveWorkFromHome(requestModel: request);
            if(resp['status'] == 200) {
              await Get.find<MyRequestController>().fetchRequestList(empId: empId, compId: compId);
            }
            if (!mounted) return;
            context.loaderOverlay.hide();
            if(resp['status'] == 200) {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              showWarn(mainContext: context);
            } else {
              Navigator.of(context).pop();
              HapticFeedback.lightImpact();
              ErrorDialog().submitDialogue(title: "Error: ${resp['status']}", subTitle: "${resp['message']}");
              // ErrorDialog().showWarn(context: context, title: "Failed to submit.");
            }
          } else {
            context.loaderOverlay.hide();
            Navigator.of(context).pop();
            HapticFeedback.lightImpact();
            ErrorDialog().submitDialogue(title: "Failed", subTitle: "No internet connection.");
          }
        } catch(e) {
          context.loaderOverlay.hide();
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
          ErrorDialog().submitDialogue(title: "Failed", subTitle: "Something went wrong.");
        }
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        HapticFeedback.lightImpact();
        ErrorDialog().submitDialogue(title: "Please enter description.");
      }
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
      HapticFeedback.lightImpact();
      ErrorDialog().submitDialogue(title: "Dates not selected", subTitle: "Please select dates.");
    }
  }

  static Future<Map<String, dynamic>> saveWorkFromHome({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workFromHomeSubmitAction,
      "method": "POST",
      "kwargs": {
        "companyId": requestModel.companyId,
        "employeeId": requestModel.employeeId,
        "requestType": 1,
        "requestDescription": requestModel.description,
        "fromDate": requestModel.fromDate,
        "toDate": requestModel.toDate,
        "requestStatus": 0,
        "createdBy": requestModel.employeeId,
        "requestLetterType": null,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  Future<bool?> showWarn({required BuildContext mainContext}) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        String date = '';
        try {
          date = DateFormat('dd MMM, yyyy | E').format(DateTime.now());
        } catch(e) {}
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: ColorUtils.backgroundBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(
                  color: const Color(0xFF666666),
                  width: 1.w,
                ),
              ),
              title: Image.asset(
                "assets/images/my_request.webp",
                // width: 10.w,
                height: 60.w,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Work From Home Request Submitted.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: 110.w,
                  height: 40.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // foregroundColor: Colors.white,
                        backgroundColor: ColorUtils.foregroundBlack,
                        elevation: 0),
                    onPressed: () {
                      Navigator.pop(ctx);
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
          ),
        );
      },
    );
  }
}
