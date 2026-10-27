
import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/app_bar.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/teave_tab_view.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/Work_Expenses/work_expense_widgets/Category_Bottom_Sheet.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../controller/userAuthentication.dart';
import '../../controller/work_expence_controller.dart';
import '../../models/user_profile_api_model.dart';
import '../../models/work_expense_list_model.dart';
import '../../services/connectivity_service.dart';
import '../../services/ui_model_services/work_expense_model.dart';
import '../Attendance_Page/attendance_widgets/date_header.dart';
import '../CWidgets/date_picker.dart';
import '../CWidgets/error_dialog.dart';
import '../../services/ui_model_services/leave_tab_model.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import '../../models/expense_category_model.dart' as categoryModel;
import '../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../Leave_Page/leave_widgets/leave_type_card.dart';

class MyWorkExpenses extends StatefulWidget {
  final bool isQuickActionEnable;
  const MyWorkExpenses({super.key, required this.isQuickActionEnable});

  @override
  State<MyWorkExpenses> createState() => _MyWorkExpensesState();
}

class _MyWorkExpensesState extends State<MyWorkExpenses> {
  ValueNotifier<int> tabNotifier = ValueNotifier(0);
  ValueNotifier<bool> categoryNameText = ValueNotifier(false);
  ValueNotifier<bool> dateOfSpendText = ValueNotifier(false);
  ValueNotifier<bool> amountSpentText = ValueNotifier(false);
  ValueNotifier<bool> descriptionText = ValueNotifier(false);
  ValueNotifier<String?> onDateChanged = ValueNotifier(null);
  categoryModel.Category? _selectedCategory;
  TextEditingController cateGoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  WorkExpenseController workExpenseController = Get.find<WorkExpenseController>();
  final UserAuthController _userAuthController = Get.find<UserAuthController>();
  final HomeController _homeController = Get.find<HomeController>();
  final RxBool _showValidation = false.obs;
  List<String> selectedImages = [];
  DateTime changedMonth = DateTime.now();
  Timer? _debounceTimer;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
        if (widget.isQuickActionEnable) {
          if(mounted) workExpenseAddSheet(mainContext: context);
        }
        if(!_homeController.isLoading.value && workExpenseController.workExpenseCategoryList.value.isEmpty) {
          if(mounted) context.loaderOverlay.show();
          await workExpenseController.fetchWorkExpenseCategory();
          if(mounted) context.loaderOverlay.hide();
        }
        if(!_homeController.isLoading.value && (workExpenseController.workExpenseListApi.value.result?.isEmpty ?? true)) {

          String formatted = DateFormat('MMMM yyyy').format(changedMonth);
          await workExpenseController.fetchWorkExpenseList(
              compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
              empId: _userAuthController.userData.value.userData?.employeeId ?? '--',
            monthYear: formatted
          );
        }
      }
    });
    // if(Get.find<HomeController>().isLoading.value) {
    //   if(workExpenseController.pendingWorkExpenseList.isEmpty && workExpenseController.approvedWorkExpenseList.isEmpty && workExpenseController.rejectedWorkExpenseList.isEmpty) {
    //     context.loaderOverlay.show();
    //   } else {
    //     Get.find<HomeController>().isLoading.listen((v) {
    //       if(!v) {
    //         context.loaderOverlay.hide();
    //       }
    //     });
    //   }
    // }
  }

  Future<void> _loadPageContent() async {
    // await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPageContent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                        title: "My Work Expense",
                        image: "assets/images/cashgreen3d.webp",
                        isActionVisible: true,
                      ),
                      DateHeader(
                        onMonthChanged: (String month) async {
                          changedMonth = DateFormat.yMMM().parse(month);
                          debugPrint('----------changedMonth--------$changedMonth');
                          String formatted = DateFormat('MMMM yyyy').format(changedMonth);
                          _debounceTimer?.cancel();
                          _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
                            await workExpenseController.fetchWorkExpenseList(
                                compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                empId: _userAuthController.userData.value.userData?.employeeId ?? '--',
                                monthYear: formatted
                            );
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8).w,
                        child: ValueListenableBuilder(
                          valueListenable: tabNotifier,
                          builder: (BuildContext context, value, Widget? child) {
                            return LeaveTabView(
                              onTabClick: (int tabIndex) {
                                tabNotifier.value = tabIndex;
                              },
                            );
                          },
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () async {
                          String formatted = DateFormat('MMMM yyyy').format(changedMonth);
                          await workExpenseController.fetchWorkExpenseList(
                              compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                              empId: _userAuthController.userData.value.userData?.employeeId ?? '--',
                            monthYear: formatted
                          );
                          await workExpenseController.fetchWorkExpenseCategory();
                        },
                        child: ValueListenableBuilder(
                          valueListenable: tabNotifier,
                          builder: (BuildContext context, value, Widget? child) {
                            return Obx(() {
                              WorkExpenseController workExpenseController = Get.find<WorkExpenseController>();
                              List<WorkExpenseData> expenseDetails = [];
                              if(value == 0) {
                                expenseDetails = workExpenseController.approvedWorkExpenseList;
                              } else if(value == 1) {
                                expenseDetails = workExpenseController.pendingWorkExpenseList;
                              } else if(value == 2) {
                                expenseDetails = workExpenseController.rejectedWorkExpenseList;
                              }
                              if(expenseDetails.isNotEmpty) {
                                return SizedBox(
                                  height: ScreenUtil().screenHeight * 0.8,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: Platform.isIOS ? 150 : View.of(context).viewPadding.bottom + 100).w,
                                    itemCount: expenseDetails.length,
                                    itemBuilder: (context, index) {
                                      String createdOn1 = "--";
                                      String createdOn2 = "--";
                                      String modifiedOn1 = "--";
                                      String modifiedOn2 = "--";
                                      try {
                                        createdOn1 = DateFormat('dd').format(DateTime.parse(expenseDetails[index].expenseDate!));
                                        createdOn2 = DateFormat('MMM yyyy').format(DateTime.parse(expenseDetails[index].expenseDate!));
                                        modifiedOn1 = DateFormat('dd').format(DateTime.parse(expenseDetails[index].createdOn!));
                                        modifiedOn2 = DateFormat('MMM yyyy').format(DateTime.parse(expenseDetails[index].createdOn!));
                                      } catch(e) {}
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0).w,
                                        child: Container(
                                          // height: 136.w,
                                          padding: const EdgeInsets.all(10).w,
                                          width: ScreenUtil().screenWidth,
                                          decoration: BoxDecoration(
                                              color: ColorUtils.backgroundBlack,
                                              borderRadius: BorderRadius.circular(14).w
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '--'} ${expenseDetails[index].amount}",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.sp,
                                                      color: ColorUtils.textWhite,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 10.w,
                                                        height: 10.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(50).w,
                                                          color: leaveTabItem[value].color,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        leaveTabItem[value].title,
                                                        style: GoogleFonts.poppins(
                                                          color: leaveTabItem[value].color,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.w),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Spend on",
                                                        style: GoogleFonts.inter(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12.sp,
                                                          color: ColorUtils.textWhite.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        createdOn1,
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12.sp,
                                                          color: ColorUtils.textWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        " $createdOn2",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12.sp,
                                                          color: ColorUtils.textWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Created on",
                                                        style: GoogleFonts.inter(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12.sp,
                                                          color: ColorUtils.textWhite.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        modifiedOn1,
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12.sp,
                                                          color: ColorUtils.textWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        " $modifiedOn2",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12.sp,
                                                          color: ColorUtils.textWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.w),
                                              Divider(
                                                height: 0,
                                                thickness: 1.w,
                                                color: ColorUtils.textWhite.withOpacity(0.1),
                                              ),
                                              SizedBox(height: 10.w),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    expenseDetails[index].categoryName ?? "--",
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.sp,
                                                      color: ColorUtils.textWhite,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if(expenseDetails[index].attachments?.isNotEmpty ?? false) {
                                                        showImagePopUp(mainContext: context, attachments: expenseDetails[index].attachments);
                                                      } else {
                                                        // no attachments
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/images/attach_icon.svg",
                                                          width: 17.w,
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                        SizedBox(width: 5.w),
                                                        Container(
                                                          width: 20.w,
                                                          height: 20.w,
                                                          decoration: BoxDecoration(
                                                            color: ColorUtils.textWhite.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              expenseDetails[index].attachments?.length.toString() ?? '0',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 10.sp,
                                                                color: ColorUtils.textWhite,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.w),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Description: ",
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12.sp,
                                                      color: ColorUtils.textWhite,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      expenseDetails[index].description ?? '--',
                                                      style: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12.sp,
                                                        color: ColorUtils.textWhite.withOpacity(0.5),
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
                                  ),
                                );
                              } else {
                                return GetX<HomeController>(
                                    builder: (HomeController homeController) {
                                      if(((workExpenseController.workExpenseListApi.value.result?.isEmpty ?? true) && homeController.isLoading.value) || workExpenseController.expListLoading.value) {
                                        return SizedBox(
                                          height: ScreenUtil().screenHeight * 0.6,
                                          child: Center(
                                            child: SpinKitThreeInOut(
                                              color: ColorUtils.primaryBlue,
                                              size: 28.h,
                                            ),
                                          ),
                                        );
                                      }
                                      return SingleChildScrollView(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        child: SizedBox(
                                          height: ScreenUtil().screenHeight * 0.8,
                                          child: Center(
                                            child: Text(
                                              "No Data Found",
                                              style: GoogleFonts.inter(
                                                color: Colors.white.withValues(alpha: 0.5),
                                                fontSize: 12.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }
                            });
                          },
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
                        workExpenseAddSheet(mainContext: context);
                      },
                      child: const LoyaltriBlueIconTextButton(
                        text: 'Add New Expense',
                        icon: Icons.add,
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

  Future<bool?> showImagePopUp({required BuildContext mainContext, List<Attachment>? attachments}) async {
    final ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);
    final PageController pageController = PageController();

    return showGeneralDialog<bool>(
      context: context,
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
              backgroundColor: ColorUtils.backgroundBlack,
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
                          color: ColorUtils.textWhite,
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
                      final imageUrl = attachments?[index].url ?? '';
                      return CachedNetworkImage(
                        imageUrl: imageUrl ?? '--',
                        width: ScreenUtil().screenWidth * 0.5,
                        fit: BoxFit.fitWidth,
                        placeholder:
                            (context, url) => Center(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: ColorUtils.textWhite),
                            SizedBox(height: 10.h),
                            Text(
                              "Loading...",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        )),
                        errorWidget: (context,
                            url, error) =>  FutureBuilder<File>(
                          future: loadPdf(imageUrl ?? '--'),
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
                                  color: ColorUtils.textWhite,
                                ),
                              ));
                            }
                            return Center(child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(color: ColorUtils.textWhite),
                                SizedBox(height: 10.h),
                                Text(
                                  "Loading...",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    color: ColorUtils.textWhite,
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
        ),
                    );
      },
    );
  }

  Future<bool?> workExpenseAddSheet({required BuildContext mainContext,}) async {
    return showModalBottomSheet(
      backgroundColor: ColorUtils.backgroundBlack,
      context: context,
      isScrollControlled: true,
      barrierColor: ColorUtils.workEntryHead,
      isDismissible: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Container(
                  height: 630.w,
                  width: ScreenUtil().screenWidth,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15).w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20).w,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      const Spacer(flex: 4),
                                      Image.asset(
                                        "assets/images/cashgreen3d.webp",
                                        width: 26.w,
                                      ),
                                      const Spacer(),
                                      Text(
                                        "Add Work Expense",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                      const Spacer(flex: 8),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 450.w,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20, bottom: 4).w,
                                          child: ValueListenableBuilder(
                                            valueListenable: categoryNameText,
                                            builder: (BuildContext context, value, Widget? child) {
                                              return Obx(() => Container(
                                                width: ScreenUtil().screenWidth,
                                                height: 70.w,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.foregroundBlack,
                                                  borderRadius: BorderRadius.circular(12).w,
                                                  border: Border.all(
                                                    width: _showValidation.value && cateGoryController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                                    color: _showValidation.value && cateGoryController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 13).w,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15).w,
                                                        child: Text(
                                                          "Category Name *",
                                                          style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp,
                                                            color: _showValidation.value && cateGoryController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30.w,
                                                        child: TextFormField(
                                                          // focusNode: _reasonFocus,
                                                          controller: cateGoryController,
                                                          cursorColor: Colors.grey,
                                                          readOnly: true,
                                                          onTap: () {
                                                            categoryNameText.value = true;
                                                            dateOfSpendText.value = false;
                                                            amountSpentText.value = false;
                                                            descriptionText.value = false;
                                                            showModalBottomSheet(
                                                              context: context,
                                                              backgroundColor: Colors.black,
                                                              barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
                                                              isScrollControlled: true,
                                                              enableDrag: true,
                                                              useSafeArea: true,
                                                              builder: (BuildContext context) {
                                                                return CategoryBottomSheet(
                                                                  selectedCategory: (categoryModel.Category category) {
                                                                    setState(() {
                                                                      cateGoryController.text = category.categoryName ?? '--';
                                                                      _selectedCategory = category;
                                                                    });
                                                                    if (_showValidation.value) {
                                                                      _showValidation.refresh();
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                          decoration: InputDecoration(
                                                            hintText: "Enter Category Name",
                                                            hintStyle: GoogleFonts.inter(
                                                              color: _showValidation.value && cateGoryController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 16.sp,
                                                            ),
                                                            border: InputBorder.none,
                                                            contentPadding: const EdgeInsets.only(left: 15, bottom: 13).w,
                                                          ),
                                                          style: GoogleFonts.inter(
                                                            color: ColorUtils.textWhite,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 16.sp,
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
                                        Obx(() => _showValidation.value && cateGoryController.text.trim().isEmpty ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.w, bottom: 5.w),
                                            child: Text(
                                              "Category is required",
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
                                            valueListenable: dateOfSpendText,
                                            builder: (BuildContext context, value, Widget? child) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  categoryNameText.value = false;
                                                  dateOfSpendText.value = true;
                                                  amountSpentText.value = false;
                                                  descriptionText.value = false;
                                                  DateTime? picked = await pickDate(context, ThemeMode.dark, firstDate: DateTime(DateTime.now().year), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
                                                  if(picked != null) {
                                                    onDateChanged.value = DateFormat('yyyy-MM-dd').format(picked);
                                                    if (_showValidation.value) {
                                                      _showValidation.refresh();
                                                    }
                                                  }
                                                },
                                                child: Obx(() => Container(
                                                  width: ScreenUtil().screenWidth,
                                                  height: 70.w,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.foregroundBlack,
                                                    borderRadius: BorderRadius.circular(12).w,
                                                    border: Border.all(
                                                      width: _showValidation.value && onDateChanged.value == null ? 1.w : (value ? 0.5.w : 0),
                                                      color: _showValidation.value && onDateChanged.value == null ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0).w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Date of spend *",
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 14.sp,
                                                                color: _showValidation.value && onDateChanged.value == null ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                                              ),
                                                            ),
                                                            SizedBox(height: 4.w),
                                                            ValueListenableBuilder(
                                                              valueListenable: onDateChanged,
                                                              builder: (BuildContext context, value, Widget? child) {
                                                                String date = "dd/MM/yyyy";
                                                                try {
                                                                  if(value != null) {
                                                                    date = DateFormat('dd/MM/yyyy').format(DateTime.parse(value));
                                                                  }
                                                                } catch(e) {}
                                                                return Text(
                                                                  date,
                                                                  style: GoogleFonts.poppins(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 16.sp,
                                                                    color: value == null ?  (_showValidation.value && onDateChanged.value == null ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2)) : ColorUtils.textWhite,
                                                                  )
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons.calendar_today_outlined,
                                                          color: const Color(0xFF9A9A9A).withOpacity(0.6),
                                                          size: 24.w,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                              );
                                            },
                                          ),
                                        ),
                                        Obx(() => _showValidation.value && onDateChanged.value == null ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.w, bottom: 5.w),
                                            child: Text(
                                              "Date is required",
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
                                            valueListenable: amountSpentText,
                                            builder: (BuildContext context, value, Widget? child) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Obx(() => Container(
                                                    // height: 80.w,
                                                    decoration: BoxDecoration(
                                                      color: ColorUtils.foregroundBlack,
                                                      borderRadius: BorderRadius.circular(12).w,
                                                      border: Border.all(
                                                        width: _showValidation.value && _amountController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                                        color: _showValidation.value && _amountController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                                      ),
                                                    ),
                                                    // padding: const EdgeInsets.all(10).w,
                                                    child: SizedBox(
                                                      width: ScreenUtil().screenWidth * 0.25,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 13).w,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "Currency",
                                                              style: GoogleFonts.inter(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 14.sp,
                                                                color: _showValidation.value && _amountController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  Get.find<UserProfileController>().userCompanyData.value.result?.currency ?? '--',
                                                                  style: GoogleFonts.inter(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 16.sp,
                                                                    color: ColorUtils.textWhite,
                                                                  ),
                                                                ),
                                                                // Icon(
                                                                //   Icons.keyboard_arrow_down,
                                                                //   color: const Color(0xFF9A9A9A).withOpacity(0.6),
                                                                //   size: 24.w,
                                                                // )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                  Obx(() => Container(
                                                    height: 70.w,
                                                    decoration: BoxDecoration(
                                                      color: ColorUtils.foregroundBlack,
                                                      borderRadius: BorderRadius.circular(12).w,
                                                      border: Border.all(
                                                        width: _showValidation.value && _amountController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                                        color: _showValidation.value && _amountController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 13).w,
                                                      child: SizedBox(
                                                        width: ScreenUtil().screenWidth * 0.65,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 15).w,
                                                              child: Text(
                                                                "Amount Spent *",
                                                                style: GoogleFonts.inter(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 14.sp,
                                                                  color: _showValidation.value && _amountController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30.w,
                                                              child: TextFormField(
                                                                // focusNode: _reasonFocus,
                                                                controller: _amountController,
                                                                cursorColor: Colors.grey,
                                                                onTap: () {
                                                                  categoryNameText.value = false;
                                                                  dateOfSpendText.value = false;
                                                                  amountSpentText.value = true;
                                                                  descriptionText.value = false;
                                                                },
                                                                onChanged: (value) {
                                                                  if (_showValidation.value) {
                                                                    _showValidation.refresh();
                                                                  }
                                                                },
                                                                decoration: InputDecoration(
                                                                  hintText: "Type here...",
                                                                  hintStyle: GoogleFonts.inter(
                                                                    color: _showValidation.value && _amountController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 16.sp,
                                                                  ),
                                                                  border: InputBorder.none,
                                                                  contentPadding: const EdgeInsets.only(left: 15, bottom: 13).w,
                                                                ),
                                                                style: GoogleFonts.inter(
                                                                  color: ColorUtils.textWhite,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16.sp,
                                                                ),
                                                                keyboardType: TextInputType.number,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Obx(() => _showValidation.value && _amountController.text.trim().isEmpty ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.w, bottom: 5.w),
                                            child: Text(
                                              "Amount is required",
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
                                                // height: 70.w,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.foregroundBlack,
                                                  borderRadius: BorderRadius.circular(12).w,
                                                  border: Border.all(
                                                    width: _showValidation.value && _descriptionController.text.trim().isEmpty ? 1.w : (value ? 0.5.w : 0),
                                                    color: _showValidation.value && _descriptionController.text.trim().isEmpty ? ColorUtils.errorRedBorder : (value ? const Color(0xFF666666) : Colors.transparent),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 13).w,
                                                  child: Column(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15).w,
                                                        child: Text(
                                                          "Description *",
                                                          style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp,
                                                            color: _showValidation.value && _descriptionController.text.trim().isEmpty ? ColorUtils.errorRedText : const Color(0xFFAAAAAA),
                                                          ),
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        controller: _descriptionController,
                                                        // focusNode: _reasonFocus,
                                                        cursorColor: Colors.grey,
                                                        maxLines: 10,
                                                        minLines: 1,
                                                        onTap: () {
                                                          categoryNameText.value = false;
                                                          dateOfSpendText.value = false;
                                                          amountSpentText.value = false;
                                                          descriptionText.value = true;
                                                        },
                                                        onChanged: (value) {
                                                          if (_showValidation.value) {
                                                            _showValidation.refresh();
                                                          }
                                                        },
                                                        decoration: InputDecoration(
                                                          hintText: "Type here...",
                                                          isDense: true,
                                                          hintStyle: GoogleFonts.inter(
                                                            color: _showValidation.value && _descriptionController.text.trim().isEmpty ? ColorUtils.errorRedText : ColorUtils.textWhite.withOpacity(0.2),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16.sp,
                                                          ),
                                                          border: InputBorder.none,
                                                          contentPadding: const EdgeInsets.only(left: 15, bottom: 0, right: 10, top: 0).w,
                                                        ),
                                                        style: GoogleFonts.inter(
                                                          color: ColorUtils.textWhite,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 16.sp,
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
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Attachment",
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14.sp,
                                                      color: const Color(0xFFAAAAAA),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    "Max 5 File (Optional)",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.h,
                                                      color: const Color(0xFF5D626D),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () async {
                                                  attachBottomSheetShow(mainContext, (bool value) {
                                                    if(value) {
                                                      setState(() {});
                                                    }
                                                  },);
                                                  // FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
                                                  //
                                                  // if (result != null) {
                                                  //   List<File> files = result.paths.map((path) => File(path!)).toList();
                                                  //   for (var file in files) {
                                                  //     setState(() {
                                                  //       selectedImages = [file.path];
                                                  //     });
                                                  //   }
                                                  // } else {
                                                  //   // User canceled the picker
                                                  // }
                                                },
                                                child: Container(
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
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for(int i = 0; i < selectedImages.length; i++)
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
                                                              selectedImages.removeAt(i);
                                                              setState(() {});
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              color: ColorUtils.textWhite,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.w),
                                                          if(selectedImages[i].split('.').last == 'pdf')
                                                            Image.asset(
                                                              "assets/images/manager_view/pdf_icon.png",
                                                              height: 35.h,
                                                            )
                                                          else
                                                            Image.file(
                                                              File(selectedImages[i]),
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
                                                          selectedImages[i].split("/").last,
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
                                        ),
                                        if (View.of(context).viewInsets.bottom != 0)
                                          SizedBox(height: 250.w),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Flexible(flex: 1, child: Container(color: Colors.transparent,)),
                            GetX<WorkExpenseController>(
                              builder: (WorkExpenseController controller) {
                                return GestureDetector(
                                  onTap: () async {
                                    String salaryMonthYear = DateFormat('MMMM yyyy').format(DateTime.now());
                                    UserProfile userData = Get.find<UserProfileController>().userData.value.result;
                                    String? compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
                                    if(cateGoryController.text.isNotEmpty && onDateChanged.value != null && _amountController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                                      num? spentAmount = num.tryParse(_amountController.text);
                                      if(spentAmount != null) {
                                        WorkExpenseSubmitModel workExpense = WorkExpenseSubmitModel(
                                          companyId: int.parse(compId),
                                          employeId: int.parse(userData.employeeId!),
                                          categoryId: _selectedCategory!.categoryId!,
                                          discription: _descriptionController.text,
                                          amount: num.parse(_amountController.text),
                                          expenseDate: onDateChanged.value!,
                                          saleryMonthYear: salaryMonthYear,
                                          createdBy: int.parse(userData.employeeId!),
                                        );
                                        String formatted = DateFormat('MMMM yyyy').format(changedMonth);
                                        String? message = await controller.submitWorkExpense(
                                            workExpense: workExpense,
                                            selectedFile: selectedImages,
                                          selectedMonth: formatted
                                        );
                                        if(message == null) {
                                          _showValidation.value = false;
                                          cateGoryController.clear();
                                          onDateChanged.value = null;
                                          _amountController.clear();
                                          _descriptionController.clear();
                                          _selectedCategory = null;
                                          selectedImages = [];
                                          setState(() {});
                                          Navigator.of(context).pop();
                                          HapticFeedback.lightImpact();
                                          showWarn(mainContext: mainContext);
                                        } else {
                                          ErrorDialog().showWarn(context: context, title: "Submission Failed", subTitle: message);
                                        }
                                      } else {
                                        ErrorDialog().showWarn(context: context, title: "Error", subTitle: "Please enter a valid amount spent");
                                      }
                                    } else {
                                      _showValidation.value = true;
                                    }
                                  },
                                  child: Container(
                                    width: ScreenUtil().screenWidth *  0.9,
                                    height: 52.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF6A4BFC),
                                        borderRadius: BorderRadius.circular(37).w
                                    ),
                                    child: Center(
                                      child: controller.buttonLoading.value
                                          ? SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child: const CircularProgressIndicator(color: Colors.white),
                                            )
                                          : Text(
                                              'Submit',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.sp,
                                                color: ColorUtils.textWhite,
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              );
            },
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
          child: Padding(
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

                          if ((selectedImages.length + 1) <= 5) {
                            selectedImages.add(value);
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

                          if((selectedImages.length + result.files.length) <= 5) {
                            selectedImages.addAll(result.files.map((e) => e.path ?? '').where((element) => element.isNotEmpty));
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

                          if((selectedImages.length + result.files.length) <= 5) {
                            selectedImages.addAll(result.files.map((e) => e.path ?? '').where((element) => element.isNotEmpty));
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
          ),
        );
      },
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
                    "Request Submitted",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM, yyyy | EEE').format(DateTime.now()),
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
                          workExpenseAddSheet(mainContext: mainContext);
                        },
                        child: FittedBox(
                          child: Text(
                            "Add More",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: ColorUtils.textWhite,
                            ),
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
      }
    );
  }
}
