
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/app_bar.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/Filter_Bottom_Sheet.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/My_Request_Tab_VIew.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/My_Request_Widget.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/New_Request_Bottom_Sheet.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/Request_Details_Bottom_Sheet.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/addRequestSheet.dart';
import 'package:loyaltri_minimal/controller/work_expence_controller.dart';
import 'controller/my_request_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../models/myRequestListApiModel.dart';
import '../../services/connectivity_service.dart';
import '../../services/ui_model_services/leave_tab_model.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/error_dialog.dart';

enum RequestCategory {all, hr, finance, other}

enum RequestItem {letter, remote, shiftSwap, attendance, resignation, salaryAdvance, loan, it, workPlaceRelated, other}

class MyRequest extends StatefulWidget {
  const MyRequest({super.key});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  MyRequestControllerNew myRequestController = Get.find<MyRequestControllerNew>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  WorkExpenseController workExpenseController = Get.find<WorkExpenseController>();

  @override
  void initState() {
    myRequestController.tabNotifier.value = 0;
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    bool connection = await ConnectivityService().check();
    if(!connection) {
      await ErrorDialog().internetWarn(
        context: context,
        title: "No Internet Connection",
        subTitle: "Please check if your connection is stable.",
        onPressed: () {
          Navigator.of(context).pop();
          initialize();
        },
      );
    } else {
      context.loaderOverlay.show();
      await myRequestController.fetchRequestTypeList();
      await myRequestController.fetchRequestList();
      context.loaderOverlay.hide();
      await myRequestController.fetchShiftList();
      await myRequestController.fetchAllResignationReasons();
      await myRequestController.fetchLeaveTypes();
      await workExpenseController.fetchWorkExpenseCategory();
      await myRequestController.fetchAllLoanPolicies();
      await myRequestController.fetchAllItRequestTypes();
      await myRequestController.fetchWorkPlaceRequestTypes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).h,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0).h,
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
                                    size: 15.h,
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
                            'assets/images/my_request.webp',
                            height: 35.h,
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            'My Request',
                            style: GoogleFonts.poppins(
                              color: ColorUtils.textWhite,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.h,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: ColorUtils.backgroundBlack,
                            context: context,
                            isScrollControlled: true,
                            barrierColor: ColorUtils.workEntryHead,
                            builder: (BuildContext context) {
                              return RequestFilterBottomSheet(currentTabIndex: myRequestController.tabNotifier.value);
                            },
                          );
                        },
                        child: GetX<MyRequestControllerNew>(
                          builder: (MyRequestControllerNew controller) {
                            return Container(
                              width: 48.h,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(14).r,
                                border: Border.all(
                                  color: ColorUtils.border,
                                  width: 1.h,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: SvgPicture.asset(
                                      "assets/images/filter_icon.svg",
                                      height: 20.h,
                                    ),
                                  ),
                                  if(controller.isFilterEnabled.value)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10, top: 10).h,
                                        child: Container(
                                          width: 12.h,
                                          height: 12.h,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorUtils.filterFlag,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8).h,
                  child: MyRequestTabView(
                    onTabClick: (int tabIndex) async {
                      context.loaderOverlay.show();
                      Get.find<MyRequestControllerNew>().tabNotifier.value = tabIndex;
                      await Get.find<MyRequestControllerNew>().fetchRequestList();
                      context.loaderOverlay.hide();
                    },
                  ),
                ),
                GetX<MyRequestControllerNew>(
                  builder: (MyRequestControllerNew controller) {
                    List<RequestData> requestList = controller.requestList.value;
                    if(requestList.isNotEmpty) {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await initialize();
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                            itemCount: requestList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0).w,
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    showModalBottomSheet(
                                      backgroundColor: ColorUtils.backgroundBlack,
                                      context: context,
                                      isScrollControlled: true,
                                      barrierColor: ColorUtils.workEntryHead,
                                      useSafeArea: true,
                                      builder: (BuildContext context) {
                                        return RequestDetailBottomSheet(excuse: requestList[index]);
                                      },
                                    );
                                  },
                                  child: MyRequestWidget(requestData: requestList[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await initialize();
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: ScreenUtil().screenHeight * 0.7,
                            child: Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                              ),
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
        ),
        bottomNavigationBar: Container(
          width: ScreenUtil().screenWidth,
          height: 65.h,
          padding: const EdgeInsets.symmetric(horizontal: 8).h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorUtils.workEntryHead.withValues(alpha: 0),
                ColorUtils.workEntryHead.withValues(alpha: 0.2),
                ColorUtils.workEntryHead.withValues(alpha: 0.4),
                ColorUtils.workEntryHead.withValues(alpha: 0.6),
                ColorUtils.workEntryHead.withValues(alpha: 0.8),
                ColorUtils.workEntryHead.withValues(alpha: 1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10).h,
            child: InkWell(
              borderRadius: BorderRadius.circular(37).r,
              onTap: () {
                HapticFeedback.lightImpact();
                // newRequestBottomSheet(context: context);
                showModalBottomSheet(
                    context: context,
                    backgroundColor: ColorUtils.workEntryHead,
                    isScrollControlled: true,
                    useSafeArea: true,
                    enableDrag: true,
                    builder: (context) {
                      return AddRequestSheet();
                    },
                );
              },
              child: const LoyaltriBlueIconTextButton(text: "Add New Request"),
            ),
          ),
        ),
      ),
    );
  }
}
