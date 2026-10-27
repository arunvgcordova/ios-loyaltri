import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_chevron.dart';
import 'package:loyaltri_minimal/controller/payrollController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/payroll_model.dart';
import '../../controller/userAuthentication.dart';
import '../../services/connectivity_service.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/app_bar.dart';
import '../CWidgets/error_dialog.dart';

class MyPay extends StatefulWidget {
  const MyPay({super.key});

  @override
  State<MyPay> createState() => _MyPayState();
}

class _MyPayState extends State<MyPay> {
  int currentValue = 29;
  PayrollController payrollController = Get.find<PayrollController>();
  final UserAuthController _userAuthController = Get.find<UserAuthController>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool connection = await ConnectivityService().check();
      if (!connection) {
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
        if (mounted) context.loaderOverlay.show();
        await payrollController.fetchPayrollData(
          compId:
              Get.find<UserProfileController>().userData.value.result.companyId
                  ?.toString() ??
              '',
          empId:
              _userAuthController.userData.value.userData?.employeeId ?? '--',
          dateTime: DateTime.now(),
        );
        if (mounted) context.loaderOverlay.hide();
      }
    });
  }

  Future<void> fetchPayrollPerMonth({required DateTime dateTime}) async {
    if (mounted) context.loaderOverlay.show();
    await payrollController.fetchPayrollData(
      compId:
          Get.find<UserProfileController>().userData.value.result.companyId
              ?.toString() ??
          '',
      empId: _userAuthController.userData.value.userData?.employeeId ?? '--',
      dateTime: dateTime,
    );
    if (mounted) context.loaderOverlay.hide();
  }

  List<String> monthString = List.generate(30, (index) {
    final currentDate = DateTime.now();

    final targetDate = DateTime(
      currentDate.year,
      currentDate.month - 29 + index,
      1,
    );

    return DateFormat.yMMM().format(targetDate);
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (_) {
          payrollController.resetData();
        },
        child: Scaffold(
          backgroundColor: ColorUtils.workEntryHead,
          extendBody: true,
          body: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8).w,
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const CustomAppBar(
                      title: "My Payroll",
                      image: "assets/images/cash-3d.webp",
                      isActionVisible: true,
                    ),
                    SizedBox(height: 15.w),
                    SizedBox(
                      height: ScreenUtil().screenHeight * 0.9,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          String dateString = _formattedMonthYear(
                            monthYear: monthString[currentValue],
                          );
                          DateTime dateTime = DateFormat(
                            'MMMM yyyy',
                          ).parse(dateString);
                          await fetchPayrollPerMonth(dateTime: dateTime);
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 80).w,
                          child: Column(
                            children: [
                              Container(
                                // height: 175.5.w,
                                width: 300.w,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/my_pay_card.svg",
                                      fit: BoxFit.fitWidth,
                                      width: 300.w,
                                    ),
                                    Positioned(
                                      right: 0.w,
                                      top: 50.w,
                                      child: SvgPicture.asset(
                                        "assets/images/pypay1.svg",
                                      ),
                                    ),
                                    Positioned(
                                      right: 0.w,
                                      top: 65.w,
                                      child: SvgPicture.asset(
                                        "assets/images/mypay2.svg",
                                      ),
                                    ),
                                    Positioned(
                                      right: 0.w,
                                      top: 80.w,
                                      child: SvgPicture.asset(
                                        "assets/images/mypay3.svg",
                                      ),
                                    ),
                                    Positioned(
                                      top: 20.w,
                                      left: 20.w,
                                      child: GetX<PayrollController>(
                                        builder: (
                                          PayrollController controller,
                                        ) {
                                          final accountNo = controller.salaryData.value.accountNo ?? '';
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller
                                                        .salaryData
                                                        .value
                                                        .monthYear ??
                                                    '--',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      ColorUtils.workEntryHead,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${controller.salaryData.value.currency ?? "--"} ${controller.amount1.value}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 25.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          ColorUtils
                                                              .workEntryHead,
                                                    ),
                                                  ),
                                                  if (controller
                                                      .salaryShow
                                                      .value)
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                            maxWidth: 120.w,
                                                          ),
                                                      child: Text(
                                                        controller
                                                            .amount2
                                                            .value,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 25.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              ColorUtils
                                                                  .workEntryHead,
                                                        ),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                            maxWidth: 120.w,
                                                          ),
                                                      child: Text(
                                                        "*" *
                                                            controller
                                                                .amount2
                                                                .value
                                                                .length,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 25.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              ColorUtils
                                                                  .workEntryHead,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  if (controller
                                                              .amount2
                                                              .value !=
                                                          "--" &&
                                                      controller
                                                              .amount2
                                                              .value !=
                                                          "")
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 2,
                                                          ).w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .setSalary();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8,
                                                              ).w,
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFC5BDF9,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  127,
                                                                ).w,
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .remove_red_eye_outlined,
                                                            color:
                                                                ColorUtils
                                                                    .workEntryHead,
                                                            size: 14.w,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              if(accountNo.isNotEmpty)
                                                Text(
                                                'Account No',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      ColorUtils.workEntryHead,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 200.w,
                                                child: Text(
                                                  accountNo.length <= 4
                                                      ? accountNo
                                                      : accountNo.substring(0, 4) +
                                                      '*' * (accountNo.length - 4),
                                                  // controller.salaryData.value.accountNo?.substring(0, 4) ?? '--',
                                                  // '5402 2***** ****',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ColorUtils
                                                            .workEntryHead,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      right: 43.w,
                                      bottom: 10.w,
                                      child: GetX<PayrollController>(
                                    builder: (PayrollController controller) {
                                      if(controller.salaryData.value.paymentMethod == null) return SizedBox.shrink();
                                          return Container(
                                            height: 36.67.w,
                                            width: 111.09.w,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorUtils.workEntryHead,
                                              borderRadius: BorderRadius.circular(500).r,
                                            ),
                                            child: Center(
                                              child: Text(
                                                controller.salaryData.value.paymentMethodMobile ?? '--',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFFE3DEFF),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 5).w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (currentValue != 0) {
                                                setState(
                                                  () =>
                                                      currentValue =
                                                          currentValue - 1,
                                                );
                                                String
                                                dateString = _formattedMonthYear(
                                                  monthYear:
                                                      monthString[currentValue],
                                                );
                                                DateTime dateTime = DateFormat(
                                                  'MMMM yyyy',
                                                ).parse(dateString);
                                                await fetchPayrollPerMonth(
                                                  dateTime: dateTime,
                                                );
                                              }
                                            },
                                            child: const ChevronIconLeft(
                                              chevronIcon: Icons.arrow_back_ios,
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              monthString[currentValue], // Month and year text
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: ColorUtils.textWhite,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (currentValue !=
                                                  (monthString.length - 1)) {
                                                setState(
                                                  () =>
                                                      currentValue =
                                                          currentValue + 1,
                                                );
                                                String
                                                dateString = _formattedMonthYear(
                                                  monthYear:
                                                      monthString[currentValue],
                                                );
                                                DateTime dateTime = DateFormat(
                                                  'MMMM yyyy',
                                                ).parse(dateString);
                                                await fetchPayrollPerMonth(
                                                  dateTime: dateTime,
                                                );
                                              }
                                            },
                                            child: const ChevronIconRight(
                                              chevronIcon:
                                                  Icons.arrow_forward_ios,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(() {
                                      if ((payrollController
                                                  .payrollApi
                                                  .value
                                                  .result
                                                  ?.isNotEmpty ??
                                              false) &&
                                          (payrollController
                                                  .payrollApi
                                                  .value
                                                  .result
                                                  ?.first
                                                  .paySlipUrl
                                                  ?.trim()
                                                  .isNotEmpty ??
                                              false)) {
                                        return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(23).w,
                                          onTap: () async {
                                            String dateString =
                                                _formattedMonthYear(
                                                  monthYear:
                                                      monthString[currentValue],
                                                );
                                            DateTime dateTime = DateFormat(
                                              'MMMM yyyy',
                                            ).parse(dateString);
                                            await payrollController
                                                .downloadPaySlip(
                                                  monthYr: dateTime,
                                                );
                                          },
                                          child: Container(
                                            padding:
                                                EdgeInsets.symmetric(
                                                  horizontal:
                                                      payrollController
                                                              .paySlipDownloading
                                                              .value
                                                          ? 15
                                                          : 20,
                                                  vertical: 10,
                                                ).w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.foregroundBlack,
                                              borderRadius:
                                                  BorderRadius.circular(23).w,
                                            ),
                                            child:
                                                payrollController
                                                        .paySlipDownloading
                                                        .value
                                                    ? Center(
                                                      child: SizedBox(
                                                        width: 15.h,
                                                        height: 15.h,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 3.h,
                                                            ),
                                                      ),
                                                    )
                                                    : Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/images/attach_icon.svg",
                                                          width: 15.h,
                                                        ),
                                                        SizedBox(width: 12.h),
                                                        Text(
                                                          "Download",
                                                          style: GoogleFonts.poppins(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11.h,
                                                            color:
                                                                ColorUtils
                                                                    .textWhite,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GetX<PayrollController>(
                                builder: (PayrollController controller) {
                                  List<Earnings> earnings =
                                      controller.salaryData.value.earnings ??
                                      [];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: ColorUtils.backgroundBlack,
                                      borderRadius: BorderRadius.circular(15).r,
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor:
                                            ColorUtils.backgroundBlack,
                                        splashColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        collapsedIconColor: Colors.white,
                                        iconColor: Colors.white,
                                        tilePadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ).h,
                                        childrenPadding:
                                            const EdgeInsets.only(
                                              left: 15,
                                              right: 60,
                                            ).h,
                                        trailing: SizedBox(
                                          width: 25.h,
                                          height: 25.h,
                                          child: const FittedBox(
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                    right: 15,
                                                  ).h,
                                              child: Container(
                                                height: 60.h,
                                                width: 60.h,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF907EF9,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ).r,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                        20,
                                                      ).h,
                                                  child: SvgPicture.asset(
                                                    "assets/images/arrow_angled_down.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Earnings',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontSize: 11.h,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5.h),
                                            // const Spacer(),
                                            Text(
                                              '${controller.salaryData.value.currency ?? "--"} ${controller.salaryData.value.totalErnings?.toStringAsFixed(2) ?? "--"}',
                                              style: GoogleFonts.poppins(
                                                color: ColorUtils.textWhite,
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          for (
                                            int i = 0;
                                            i < earnings.length;
                                            i++
                                          )
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 15,
                                                      ).h,
                                                  child: Container(
                                                    height: 40.w,
                                                    width: 60.w,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    earnings[i].componentName ??
                                                        '--',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      color: ColorUtils
                                                          .textWhite
                                                          .withOpacity(0.5),
                                                      fontSize: 11.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5.h),
                                                // const Spacer(),
                                                Text(
                                                  '${controller.salaryData.value.currency ?? "--"} ${earnings[i].amount?.toStringAsFixed(2) ?? "--"}',
                                                  style: GoogleFonts.poppins(
                                                    color: ColorUtils.textWhite,
                                                    fontSize: 11.h,
                                                    fontWeight: FontWeight.w500,
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
                              SizedBox(height: 10.h),
                              GetX<PayrollController>(
                                builder: (PayrollController controller) {
                                  List<Earnings> deductions =
                                      controller.salaryData.value.deductions ??
                                      [];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: ColorUtils.backgroundBlack,
                                      borderRadius: BorderRadius.circular(15).r,
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor:
                                            ColorUtils.backgroundBlack,
                                        splashColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        collapsedIconColor: Colors.white,
                                        iconColor: Colors.white,
                                        tilePadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ).h,
                                        childrenPadding:
                                            const EdgeInsets.only(
                                              left: 15,
                                              right: 60,
                                            ).h,
                                        trailing: SizedBox(
                                          width: 25.h,
                                          height: 25.h,
                                          child: const FittedBox(
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                    right: 15,
                                                  ).h,
                                              child: Container(
                                                height: 60.h,
                                                width: 60.h,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF3C71FC,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ).h,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                        20,
                                                      ).h,
                                                  child: SvgPicture.asset(
                                                    "assets/images/arrow_angled_up.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Deductions',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5.h),
                                            // const Spacer(),
                                            Text(
                                              '${controller.salaryData.value.currency ?? "--"} ${controller.salaryData.value.totalDeductions?.toStringAsFixed(2) ?? "--"}',
                                              style: GoogleFonts.poppins(
                                                color: ColorUtils.textWhite,
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          for (
                                            int i = 0;
                                            i < deductions.length;
                                            i++
                                          )
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 15,
                                                      ).h,
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 60.h,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    deductions[i]
                                                            .componentName ??
                                                        '--',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      color: ColorUtils
                                                          .textWhite
                                                          .withOpacity(0.5),
                                                      fontSize: 11.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                // const Spacer(),
                                                Text(
                                                  '${controller.salaryData.value.currency ?? "--"} ${deductions[i].amount?.toStringAsFixed(2) ?? "--"}',
                                                  style: GoogleFonts.poppins(
                                                    color: ColorUtils.textWhite,
                                                    fontSize: 11.h,
                                                    fontWeight: FontWeight.w500,
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
                              SizedBox(height: 10.h),
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 20).w,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Row(
                              //         children: [
                              //           Padding(
                              //             padding: const EdgeInsets.only(right: 15).w,
                              //             child: Container(
                              //               height: 60.w,
                              //               width: 60.w,
                              //               decoration: BoxDecoration(
                              //                   color: const Color(0xFF50D3FC),
                              //                   borderRadius: BorderRadius.circular(100).w),
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(20).w,
                              //                 child: SvgPicture.asset(
                              //                   "assets/images/ballot.svg",
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           Text(
                              //             'Variable Payment',
                              //             style: GoogleFonts.poppins(
                              //               color: ColorUtils.textWhite,
                              //               fontSize: 12.sp,
                              //               fontWeight: FontWeight.w500,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       Text(
                              //         'AED 320.00',
                              //         style: GoogleFonts.poppins(
                              //           color: ColorUtils.textWhite,
                              //           fontSize: 14.sp,
                              //           fontWeight: FontWeight.w600,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // GetX<PayrollController>(
                              //   builder: (PayrollController controller) {
                              //     return Padding(
                              //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 10, top: 10, left: 15, right: 20).w,
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(right: 8).w,
                              //                 child: Container(
                              //                   height: 60.w,
                              //                   width: 60.w,
                              //                   decoration: BoxDecoration(
                              //                       color: const Color(0xFF8E97EA),
                              //                       borderRadius: BorderRadius.circular(100).w),
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.all(20).w,
                              //                     child: SvgPicture.asset(
                              //                       "assets/images/ballot.svg",
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               Text(
                              //                 'Earnings',
                              //                 style: GoogleFonts.poppins(
                              //                   color: ColorUtils.textWhite,
                              //                   fontSize: 12.sp,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           Text(
                              //             '${controller.salaryData.value.currency ?? '--'} ${controller.salaryData.value.totalAdditionsAdjustment?.toStringAsFixed(2) ?? '--'}',
                              //             style: GoogleFonts.poppins(
                              //               color: ColorUtils.textWhite,
                              //               fontSize: 14.sp,
                              //               fontWeight: FontWeight.w600,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              // ),
                            ],
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

  String _formattedMonthYear({required String monthYear}) {
    List<String> splitList = monthYear.split(" ");
    String month = _selectMonth(month: splitList.first);
    return "$month ${splitList.last}";
  }

  String _selectMonth({required String month}) {
    switch (month) {
      case 'Jan':
        return 'January';
      case 'Feb':
        return 'February';
      case 'Mar':
        return 'March';
      case 'Apr':
        return 'April';
      case 'May':
        return 'May';
      case 'Jun':
        return 'June';
      case 'Jul':
        return 'July';
      case 'Aug':
        return 'August';
      case 'Sep':
        return 'September';
      case 'Oct':
        return 'October';
      case 'Nov':
        return 'November';
      case 'Dec':
        return 'December';
      default:
        return '';
    }
  }
}
