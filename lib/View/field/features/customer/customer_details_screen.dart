import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/customer/controller/customer_controller.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_details_response.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/filled_button.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/out_line_button.dart';
import '../../core/colour_utils.dart';

class CustomerDetailsScreen extends GetView<CustomerController> {
  const CustomerDetailsScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    controller.fetchCustomerDetail(id: customerId);
    return Scaffold(
      backgroundColor: ColourUtils.background,
      appBar: AppBarWidget(title: 'Customers Details'),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchCustomerDetail(id: customerId);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: GetX<CustomerController>(
            builder: (controller) {
              if (controller.isDetailsloading.value) {
                return SizedBox(
                  height: 500.h,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (controller.customerDetail.value == null) {
                return SizedBox(
                  height: 500.h,
                  child: Center(
                    child: Text(
                      'No customer detail',
                      style: GoogleFonts.inter(
                        color: ColourUtils.textMuted,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  PROFILE CARD
                  _buildProfileHeaderCard(
                    context,
                    controller.customerDetail.value?.data,
                  ),
                  SizedBox(height: 10.h),

                  // DETAILS LIST CONTAINER
                  _buildDetailsContainer(controller.customerDetail.value?.data),
                  SizedBox(height: 24.h),
                ],
              );
            },
          ),
        ),
      ),
      // SingleChildScrollView(
      //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      //   child: Column(
      //     children: [
      //       // PROFILE CARD
      //       _buildProfileHeaderCard(context),
      //       SizedBox(height: 10.h),

      //       // DETAILS LIST CONTAINER
      //       _buildDetailsContainer(),
      //       SizedBox(height: 24.h),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildProfileHeaderCard(BuildContext context, Data? customerData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: ColourUtils.borderColour, width: 1.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Name & Site
              svgWidget(height: 20.h, width: 20.h, icon: 'store'),
              SizedBox(width: 10.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 'Smart Electronics Ltd dsajidiasjjdajdad oi',
                      customerData?.name ?? "",
                      style: GoogleFonts.inter(
                        color: ColourUtils.textWhite,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            // 'CUST-001234 jsadjdsaiudiudaudhashufhfaufuoifdjijofsj',
            customerData?.customerCode ?? "",
            style: GoogleFonts.inter(
              color: ColourUtils.textWhite,
              fontSize: 12.h,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                height: 30.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: customerData?.status == 'active'
                      ? ColourUtils.bgColour7
                      : ColourUtils.bgColour13,
                  borderRadius: BorderRadius.circular(6.h),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: customerData?.status == 'active'
                            ? ColourUtils.fontColour6
                            : ColourUtils.overdue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      customerData?.status == 'active'
                          ? 'Active Customer'
                          : 'Inactive Customer',
                      style: GoogleFonts.inter(
                        color: customerData?.status == 'active'
                            ? ColourUtils.fontColour6
                            : ColourUtils.overdue,
                        fontSize: 12.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              FillButtonWidget(
                label: 'Call',
                icon: 'phone',
                isRound: false,
                function: () {
                  makePhoneCall(customerData?.phone);
             
                },
              ),
              SizedBox(width: 10.h),
              OutLineButtonWidget(label: 'Navigate', icon: 'navigation',function: () {
                     openGoogleMaps(latitude: customerData?.location?.lat ?? 0.0, longitude: customerData?.location?.lng ?? 0.0,context: context);
              },),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContainer(Data? customerData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: ColourUtils.borderColour, width: 1.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Text(
              'Customer Information',
              style: GoogleFonts.inter(
                color: ColourUtils.textWhite,
                fontSize: 16.h,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Divider(color: ColourUtils.border, height: 1),
          _buildDetailRow(
            icon: 'user',
            label: 'Point of Contact',
            // value: 'Rajesh Sharma',
            value: customerData?.dynamicFields?.pointOfContactName ?? "",
          ),
          const Divider(color: ColourUtils.border, height: 1),
          _buildDetailRow(
            icon: 'phone',
            label: 'Contact Number',
            // value: '+91 98765 43210',
            value: customerData?.dynamicFields?.pocContactNumber ?? "",
            isWhite: false,
          ),
          const Divider(color: ColourUtils.border, height: 1),
          _buildDetailRow(
            icon: 'email',
            label: 'Email',
            // value: 'contact@smartelectronics.com',
            value: customerData?.email ?? "",
            isWhite: false,
          ),
          const Divider(color: ColourUtils.border, height: 1),
          _buildDetailRow(
            icon: 'gps',
            label: 'Location',
            // value: 'Plot 45, Industrial Area, Sector 25, Gurgaon',
            value: customerData?.dynamicFields?.locationName ?? "",
            isWhite: false,
          ),
          const Divider(color: ColourUtils.border, height: 1),
          _buildDetailRow(
            icon: 'menu',
            label: 'Notes',
            // value: 'Prefers weekdays follow-ups usually available after 11am.',
            value: customerData?.dynamicFields?.notes ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required String label,
    required String value,
    bool isWhite = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(icon, color: ColourUtils.textMuted, size: 18.sp),
          svgWidget(height: 20.h, width: 20.h, icon: icon),
          SizedBox(width: 14.w),
          Text(
            label,
            style: GoogleFonts.inter(
              color: ColourUtils.textWhite.withValues(alpha: 0.6),
              fontSize: 12.h,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: isWhite
                    ? ColourUtils.textWhite
                    : ColourUtils.fontColour1,
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
