import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_details_response.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

class CustomerController extends GetxController {
  DateTime selectedDate = DateTime.now();
  RxBool isloading = false.obs;
  // RxBool isError = false.obs;
  RxList<CustomerData> customerList = <CustomerData>[].obs;
  int pendingCount = 0;
  int completedCount = 0;

  Future<void> fetchCustomerList({required String search}
  ) async {
    pendingCount = 0;
    completedCount = 0;
    isloading.value = true;
    // isError.value = false;

    try {
      final authController = Get.find<UserAuthController>();
      final profileController = Get.find<UserProfileController>();

      final String empId =
          authController.userData.value.userData?.employeeId ?? '';

      final String compId =
          profileController.userData.value.result.companyId?.toString() ?? '';


      final resp = await ApiServices.getCustomerList(companyId:compId ,search: search,empId: empId);

      if (resp['status']?.toString() == '200') {
        final workData = CustomerModelResponse.fromJson(resp);

        customerList.value = workData.data?.isNotEmpty == true
            ? workData.data ?? []
            : [];
        // pendingCount = customerList.where(
        //   (item) =>
        //       item.instances?.isNotEmpty == true &&
        //       item.instances!.first.workStatus == 'assigned',
        // ).length;

        // completedCount = customerList.where(
        //   (item) =>
        //       item.instances?.isNotEmpty == true &&
        //       item.instances!.first.workStatus != 'assigned',
        // ).length;
      } else {
        // isError.value = true;
        customerList.clear();
      }
    } catch (e, stackTrace) {
      // isError.value = true;
      customerList.clear();

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isloading.value = false;
    }
  }

  RxBool isDetailsloading = false.obs;
  Rx<CustomerDetailsResponse?> customerDetail = Rx(null);

  Future<void> fetchCustomerDetail({required String id}) async {
    // pendingCount = 0;
    // completedCount = 0;
    isDetailsloading.value = true;

    try {
      final resp = await ApiServices.getCustomerDetail(id: id);

      if (resp['status']?.toString() == '200') {
        customerDetail.value = CustomerDetailsResponse.fromJson(resp);
      } else {
        customerDetail.value = null;
      }
    } catch (e, stackTrace) {
      customerDetail.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isDetailsloading.value = false;
    }
  }
}