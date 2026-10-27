import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/features/customer/widget/customer_card.dart';
import 'package:loyaltri_minimal/View/field/features/customer_form/add_customer_screen.dart';
import 'package:loyaltri_minimal/View/field/features/customer/controller/customer_controller.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';

class CustomerScreen extends GetView<CustomerController> {
  CustomerScreen({super.key});
  final ValueNotifier<String> _searchQuery = ValueNotifier('');
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(CustomerController());
    controller.fetchCustomerList(search: _searchController.text);
    return Scaffold(
      backgroundColor: ColourUtils.background,

      appBar: AppBarWithAddWidget(
        title: 'Customers',
        onAddTap: () async {
          final trackingCtrl = Get.isRegistered<TrackingController>()
                  ? Get.find<TrackingController>()
                  : null;
              final empId = Get.find<UserAuthController>().userData.value.userData?.employeeId;
              final canWork = trackingCtrl?.companySettings.value?.canStaffCreateCustomer(empId) ?? true;
              if (!canWork) {
                AttendanceCommonWidgets().showSnackBar(
                  context: context,
                  backgroundColor: Colors.orange,
                  message: "You do not have permission to create customer.",
                );
                return;
              }
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCustomerScreen()),
          );
          if (result == true) {
            // Refresh your customer list
            controller.fetchCustomerList(search: _searchController.text);
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            // _buildMetricsRow(),
            // SizedBox(height: 12.h),
            TextFormField(
              controller: _searchController,
              onChanged: (value) {
                _searchQuery.value = value;
                controller.fetchCustomerList(search: _searchController.text);
              },
              validator: (value) {},
              style: GoogleFonts.inter(
                color: ColourUtils.textMain,
                fontSize: 14.h,
              ),
              decoration: InputDecoration(
                hintText: 'Search customers',
                hintStyle: GoogleFonts.inter(
                  color: ColourUtils.textMuted,
                  fontSize: 14.h,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: ColourUtils.textMuted,
                  size: 20.h,
                ),
                suffixIcon: ValueListenableBuilder<String>(
                  valueListenable: _searchQuery,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return const SizedBox.shrink();
                    }
            
                    return IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: ColourUtils.textMuted,
                      ),
                      onPressed: ()async {
                        _searchController.clear();
                        _searchQuery.value = '';
                         await controller.fetchCustomerList(search: _searchController.text);
                      },
                    );
                  },
                ),
                filled: true,
                fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: BorderSide(
                    color: ColourUtils.textWhite.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: const BorderSide(
                    color: ColourUtils.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: const BorderSide(
                    color: ColourUtils.overdue,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                  borderSide: const BorderSide(
                    color: ColourUtils.overdue,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: GetX<CustomerController>(
                builder: (controller) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchCustomerList(search: _searchController.text);
                    },
                    child: controller.isloading.value
                        ? ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: ScreenUtil().screenHeight - 300.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          )
                        : controller.customerList.isEmpty
                        ? ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [_buildEmptyState()],
                          )
                        : ListView.builder(
                            // shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.customerList.length,
                            itemBuilder: (context, index) {
                              final item = controller.customerList[index];
                              return CustomerCard(context: context,item: item);
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: ScreenUtil().screenHeight - 300.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: ColourUtils.textMuted,
              size: 48.h,
            ),
            SizedBox(height: 12.h),
            Text(
              'No work logs found',
              style: GoogleFonts.inter(
                color: ColourUtils.textMuted,
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 76.h,

            decoration: BoxDecoration(
              color: ColourUtils.completedBg,
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: ColourUtils.textWhite.withValues(alpha: 0.1),
                width: 1.h,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '10',
                  style: GoogleFonts.inter(
                    color: ColourUtils.fontColour5,
                    fontSize: 18.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'New Today',
                  style: GoogleFonts.inter(
                    color: ColourUtils.fontColour5,
                    fontSize: 12.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            height: 76.h,

            decoration: BoxDecoration(
              color: ColourUtils.bgColour10,
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: ColourUtils.textWhite.withValues(alpha: 0.1),
                width: 1.h,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '32',
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 18.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Added this month',
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 12.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  
}
