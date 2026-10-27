
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../controller/userAuthentication.dart';
import '../../controller/userProfileController.dart';
import '../../services/connectivity_service.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/app_bar.dart';
import '../CWidgets/error_dialog.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import 'controller/myRequestController.dart';
import 'model/myRequestListApiModel.dart';
import 'my_request_widgets/Filter_Bottom_Sheet.dart';
import 'my_request_widgets/My_Request_Tab_VIew.dart';
import 'my_request_widgets/My_Request_Widget.dart';
import 'my_request_widgets/New_Request_Bottom_Sheet.dart';
import 'my_request_widgets/Request_Details_Bottom_Sheet.dart';

class MyRequest extends StatefulWidget {
  const MyRequest({super.key});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  ValueNotifier<int> tabNotifier = ValueNotifier(0);
  MyRequestController myRequestController = Get.find<MyRequestController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();

  @override
  void initState() {
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
      await myRequestController.fetchRequestList(
        empId: userAuthController.userData.value.userData?.employeeId ?? '--',
        compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).w,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      const CustomAppBar(
                        title: "My Request",
                        image: "assets/images/my_request.webp",
                        isActionVisible: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0).w,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: ColorUtils.backgroundBlack,
                              context: context,
                              isScrollControlled: true,
                              barrierColor: ColorUtils.workEntryHead,
                              builder: (BuildContext context) {
                                return RequestFilterBottomSheet(currentTabIndex: tabNotifier.value);
                              },
                            );
                          },
                          child: GetX<MyRequestFilterController>(
                            builder: (MyRequestFilterController controller) {
                              return Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: ColorUtils.foregroundBlack.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(14).w,
                                  border: Border.all(
                                    color: ColorUtils.border,
                                    width: 1.w,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        "assets/images/filter_icon.svg",
                                      ),
                                    ),
                                    if(controller.isFilterEnabled.value)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10, top: 10).w,
                                          child: Container(
                                            width: 12.w,
                                            height: 12.w,
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
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8).w,
                    child: ValueListenableBuilder(
                      valueListenable: tabNotifier,
                      builder: (BuildContext context, value, Widget? child) {
                        return MyRequestTabView(
                          onTabClick: (int tabIndex) {
                            tabNotifier.value = tabIndex;
                          },
                        );
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: tabNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return SizedBox(
                        height: ScreenUtil().screenHeight * 0.8,
                        child: IndexedStack(
                          index: value,
                          children: [
                            GetX<MyRequestController>(
                              builder: (MyRequestController controller) {
                                if(controller.isLoading.value) {
                                  context.loaderOverlay.show();
                                } else {
                                  context.loaderOverlay.hide();
                                }
                                List<RequestData> allRequestList = controller.allRequestList;
                                if(allRequestList.isNotEmpty) {
                                  return ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: allRequestList.length,
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
                                              builder: (BuildContext context) {
                                                return RequestDetailBottomSheet(excuse: allRequestList[index]);
                                              },
                                            );
                                          },
                                          child: MyRequestWidget(requestData: allRequestList[index]),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox(
                                    height: ScreenUtil().screenHeight * 0.7,
                                    child: Center(
                                      child: Text(
                                        "Empty",
                                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            GetX<MyRequestController>(
                              builder: (MyRequestController controller) {
                                List<RequestData> wFHReqList = controller.wFHRequestList;
                                if(wFHReqList.isNotEmpty) {
                                  return ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: wFHReqList.length,
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
                                              builder: (BuildContext context) {
                                                return RequestDetailBottomSheet(excuse: wFHReqList[index]);
                                              },
                                            );
                                          },
                                          child: MyRequestWidget(requestData: wFHReqList[index]),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox(
                                    height: ScreenUtil().screenHeight * 0.7,
                                    child: Center(
                                      child: Text(
                                        "Empty",
                                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            GetX<MyRequestController>(
                              builder: (MyRequestController controller) {
                                List<RequestData> letterReqList = controller.letterRequestList;
                                if(letterReqList.isNotEmpty) {
                                  return ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: letterReqList.length,
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
                                              builder: (BuildContext context) {
                                                return RequestDetailBottomSheet(excuse: letterReqList[index]);
                                              },
                                            );
                                          },
                                          child: MyRequestWidget(requestData: letterReqList[index]),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox(
                                    height: ScreenUtil().screenHeight * 0.7,
                                    child: Center(
                                      child: Text(
                                        "Empty",
                                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: ScreenUtil().screenWidth,
          height: 65.w,
          padding: const EdgeInsets.symmetric(horizontal: 8).w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorUtils.workEntryHead.withOpacity(0),
                ColorUtils.workEntryHead.withOpacity(0.2),
                ColorUtils.workEntryHead.withOpacity(0.4),
                ColorUtils.workEntryHead.withOpacity(0.6),
                ColorUtils.workEntryHead.withOpacity(0.8),
                ColorUtils.workEntryHead.withOpacity(1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10).w,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                newRequestBottomSheet(context: context);
              },
                child: const LoyaltriBlueIconTextButton(text: "Add New Request"),
            ),
          ),
        ),
      ),
    );
  }
}
