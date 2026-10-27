
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/app_bar.dart';
import 'package:loyaltri_minimal/View/Excuse_Page/my_excuse_widgets/Excuse_Widget.dart';
import 'package:loyaltri_minimal/View/Excuse_Page/my_excuse_widgets/RegularizeDetail_BottomSheet.dart';
import 'package:loyaltri_minimal/controller/myExcuseListController.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../services/connectivity_service.dart';
import '../../services/ui_model_services/leave_tab_model.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/error_dialog.dart';
import 'my_excuse_widgets/My_Excuse_Tab_View.dart';

class MyExcuse extends StatefulWidget {
  const MyExcuse({super.key});

  @override
  State<MyExcuse> createState() => _MyExcuseState();
}

class _MyExcuseState extends State<MyExcuse> {
  ValueNotifier<int> tabNotifier = ValueNotifier(0);
  MyExcuseController myExcuseController = Get.find<MyExcuseController>();
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
      context.loaderOverlay.show();
      await myExcuseController.fetchMyExcuseList(empId: userAuthController.userData.value.userData?.employeeId ?? '--');
      if(!mounted) return;
      context.loaderOverlay.hide();
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
                  const CustomAppBar(
                    title: "My Excuse",
                    image: "assets/images/Hourglass-3d.webp",
                    isActionVisible: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8).w,
                    child: ValueListenableBuilder(
                      valueListenable: tabNotifier,
                      builder: (BuildContext context, value, Widget? child) {
                        return MyExcuseTabView(
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
                      return IndexedStack(
                        index: value,
                        children: [
                          GetX<MyExcuseController>(
                            builder: (MyExcuseController controller) {
                              if(controller.regularisationReqList.isNotEmpty) {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: controller.regularisationReqList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0).w,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor: ColorUtils.backgroundBlack,
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                              builder: (BuildContext context) {
                                                return RegularizeDetailBottomSheet(excuse: controller.regularisationReqList[index]);
                                              },
                                            );
                                          },
                                          child: ExcuseWidget(requestData: controller.regularisationReqList[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          GetX<MyExcuseController>(
                            builder: (MyExcuseController controller) {
                              if(controller.pendingRegularizationList.isNotEmpty) {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: controller.pendingRegularizationList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0).w,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor: ColorUtils.backgroundBlack,
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                              builder: (BuildContext context) {
                                                return RegularizeDetailBottomSheet(excuse: controller.pendingRegularizationList[index]);
                                              },
                                            );
                                          },
                                          child: ExcuseWidget(requestData: controller.pendingRegularizationList[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          GetX<MyExcuseController>(
                            builder: (MyExcuseController controller) {
                              if(controller.approvedRegularizationList.isNotEmpty) {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: controller.approvedRegularizationList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0).w,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor: ColorUtils.backgroundBlack,
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                              builder: (BuildContext context) {
                                                return RegularizeDetailBottomSheet(excuse: controller.approvedRegularizationList[index]);
                                              },
                                            );
                                          },
                                          child: ExcuseWidget(requestData: controller.approvedRegularizationList[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          GetX<MyExcuseController>(
                            builder: (MyExcuseController controller) {
                              if(controller.rejectedRegularizationList.isNotEmpty) {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 200 : 100).w,
                                    itemCount: controller.rejectedRegularizationList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0).w,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor: ColorUtils.backgroundBlack,
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                              builder: (BuildContext context) {
                                                return RegularizeDetailBottomSheet(excuse: controller.rejectedRegularizationList[index]);
                                              },
                                            );
                                          },
                                          child: ExcuseWidget(requestData: controller.rejectedRegularizationList[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
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
          height: 30.w,
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
        ),
      ),
    );
  }
}
