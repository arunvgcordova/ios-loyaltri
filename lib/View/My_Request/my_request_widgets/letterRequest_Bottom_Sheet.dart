
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/Choose_Letter_Type.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../controller/my_request_controller.dart';
import '../../../controller/userAuthentication.dart';
import '../../../services/api_services.dart';
import '../../../services/connectivity_service.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../my_request_models/request_send_model.dart';

class LetterRequestBottomSheet extends StatefulWidget {
  const LetterRequestBottomSheet({super.key});

  @override
  State<LetterRequestBottomSheet> createState() => _WorkEntryBottomSheetState();
}

class _WorkEntryBottomSheetState extends State<LetterRequestBottomSheet> {
  ValueNotifier<String> selectedType = ValueNotifier("");
  TextEditingController _reasonController = TextEditingController();
  FocusNode _resonFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: MediaQuery.of(context).viewInsets.bottom + 450.w,
        width: ScreenUtil().screenWidth,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10).w,
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
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        newSlideNavigation(ChooseLetterType(selectedValue: selectedType.value, setSelectedValue: (String value) => selectedType.value = value)),
                      );
                    },
                    child: Container(
                      height: 50.w,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 13, right: 13).w,
                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                        color: ColorUtils.foregroundBlack,
                        borderRadius: BorderRadius.circular(10).w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: selectedType,
                            builder: (BuildContext context, value, Widget? child) {
                              return Text(
                                value == "" ? "Choose Letter type" : value,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: value == "" ? ColorUtils.textWhite.withOpacity(0.5) : ColorUtils.textWhite,
                                ),
                              );
                            },
                          ),
                          Text(
                            String.fromCharCode(Icons.arrow_forward_ios.codePoint),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.textWhite.withOpacity(0.5),
                              fontFamily: Icons.arrow_forward_ios.fontFamily,
                              package: Icons.arrow_forward_ios.fontPackage,
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
                      await applyLetterReq();
                    },
                    child: const LoyaltriBlueTextButton(text: "Apply Letter Request"),
                  ),
                  SizedBox(height: 10.w),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> applyLetterReq() async {
    if(_resonFocus.hasFocus) {
      _resonFocus.unfocus();
    }
    String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
    String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);
    bool connection = await ConnectivityService().check();
    if(_reasonController.text != '') {
      if (!mounted) return;
      context.loaderOverlay.show();
      RequestSendModel request = RequestSendModel(
        employeeId: empId,
        requestType: selectedType.value,
        description: _reasonController.text,
        fromDate: todayDate,
        toDate: todayDate,
        companyId: compId,
      );
      try {
        if(connection) {
          Map<String, dynamic> resp = await ApiServices.saveLetterRequest(requestModel: request);
          if(resp['status'] == 200) {
            // await Get.find<MyRequestController>().fetchRequestList(empId: empId, compId: compId);
          }
          if (!mounted) return;
          context.loaderOverlay.hide();
          if(resp['status'] == 200) {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            showWarn(mainContext: context);
          } else {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            ErrorDialog().submitDialogue(title: "Error: ${resp['status']}", subTitle: "${resp['message']}");
            // ErrorDialog().showWarn(context: context, title: "Failed to submit.");
          }
        } else {
          context.loaderOverlay.hide();
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
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
      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
      ErrorDialog().submitDialogue(title: "Please enter description.");
    }
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
                    "Letter Request Submitted.",
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
