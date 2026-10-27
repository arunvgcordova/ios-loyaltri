
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_models/request_send_model.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/models/special_reuest_type_model.dart';
import 'package:loyaltri_minimal/services/connectivity_service.dart';
import 'package:loyaltri_minimal/services/ui_model_services/work_expense_model.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/manager/employee_shift_model.dart';
import '../../../models/myRequestListApiModel.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../services/api_services.dart';

class MyRequestControllerNew extends GetxController {

  RxList<ModuleListData> moduleReqList = <ModuleListData>[].obs;

  Future<void> fetchRequestTypeList() async {
    try {
      final resp = await ApiServices.getAllSpecialRequestType();
      if(resp['status']?.toString() == '200') {
        SpecialRequestTypeApi specialRequestTypeApi = SpecialRequestTypeApi.fromJson(resp);
        moduleReqList.value = specialRequestTypeApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------req type list error--------');
    }
  }

  RxList<RequestData> requestList = <RequestData>[].obs;
  List<RequestData> requestListCopy = <RequestData>[];
  RxInt tabNotifier = 0.obs;

  Future<void> fetchRequestList() async {
    try {
      requestList.value = [];
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      final resp = await ApiServices.getSpecialRequestByEmployeeId(
          empId: empId,
          compId: compId,
          filter: tabNotifier.value == 0 ? 'All' : tabNotifier.value == 1 ? 'Hr' : tabNotifier.value == 2 ? 'Finance' : tabNotifier.value == 3 ? 'Other' : 'All',
      );
      if(resp['status']?.toString() == '200') {
        SpecialRequestListApi specialRequestListApi = SpecialRequestListApi.fromJson(resp);
        requestList.value = specialRequestListApi.result ?? [];
        requestListCopy = requestList.value;
      }
    } catch(e) {
      debugPrint('-------request list error--------');
    }
  }

  RxBool approved = false.obs;
  RxBool rejected = false.obs;
  RxBool pending = false.obs;
  RxBool isFilterEnabled = false.obs;

  void filterRequests() {
    List<String> filters = [];
    if(approved.value) {
      filters.add('Approved');
    }
    if(rejected.value) {
      filters.add('Rejected');
    }
    if(pending.value) {
      filters.add('Pending');
    }
    if(filters.isEmpty) {
      requestList.value = requestListCopy;
      isFilterEnabled.value = false;
      return;
    } else {
      isFilterEnabled.value = true;
    }
    requestList.value = requestListCopy.where((element) => filters.contains(element.requestStatus)).toList();
  }

  void resetFilter() {
    approved.value = false;
    rejected.value = false;
    pending.value = false;
    isFilterEnabled.value = false;
  }

  RxList<EmployeeShiftData> employeeShift = <EmployeeShiftData>[].obs;
  RxList<String> shiftList = <String>[].obs;

  Future<void> fetchShiftList() async {
    try {
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      final resp = await ApiServices.getAllShiftEmployee(compId: compId);
      if(resp['status']?.toString() == "200") {
        EmployeeShiftModel employeeShiftModel = EmployeeShiftModel.fromJson(resp);
        employeeShift.value = employeeShiftModel.result ?? [];
        shiftList.value = employeeShift.value.map((e) => e.shift ?? '').toList().where((v) => v.isNotEmpty).toList();
        // List<ShiftData> shifts = Get.find<UserProfileController>().userData.value.result.employeeShift ?? [];
        // if(shifts.isNotEmpty) {
        //   final result = shifts.where((element) {
        //     return employeeShift.value.any(
        //           (v) => v.shift == element.shift,
        //     );
        //   }).toList();
        //   if(result.isNotEmpty) {
        //     selectedDropDown1.value = result.first.shift;
        //   }
        // }
      }
    } catch(e) {
      debugPrint('-------shift list error--------');
    }
  }

  RxList<String> resignationReasons = <String>[].obs;

  Future<void> fetchAllResignationReasons() async {
    try {
      final resp = await ApiServices.getAllResignationReasonList();
      if(resp['status']?.toString() == "200") {
        ResignationReasonApi resignationReasonApi = ResignationReasonApi.fromJson(resp);
        resignationReasons.value = resignationReasonApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------resignation reasons error--------');
    }
  }

  RxList<LeaveType> leaveTypes = <LeaveType>[].obs;

  Future<void> fetchLeaveTypes() async {
    try {
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      final resp = await ApiServices.getLeaveTypesWithCompanyId(compId: compId);
      if(resp['status']?.toString() == "200") {
        LeaveTypesApi leaveTypesApi = LeaveTypesApi.fromJson(resp);
        leaveTypes.value = leaveTypesApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------leave types error--------');
    }
  }

  RxList<LoanPolicy> loanPolicies = <LoanPolicy>[].obs;
  RxList<String> loanPolicyNames = <String>[].obs;
  RxList<String> tenureMonths = <String>[].obs;

  Future<void> fetchAllLoanPolicies() async {
    try {
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      final resp = await ApiServices.getAllLoanPolicies(compId: compId);
      if(resp['status']?.toString() == "200") {
        LoanPoliciesApi loanPoliciesApi = LoanPoliciesApi.fromJson(resp);
        loanPolicies.value = loanPoliciesApi.result ?? [];
        loanPolicyNames.value = loanPolicies.value.map((e) => e.loanPolicyName ?? '').toList().where((element) => element.isNotEmpty).toList();
      }
    } catch(e) {
      debugPrint('-------loan types error--------');
    }
  }

  void selectPolicy({required String value}) {
    LoanPolicy loanPolicy = loanPolicies.value.singleWhere((element) => element.loanPolicyName != null && element.loanPolicyName == value);
    selectedLoan.value = loanPolicy;
    String? totalMonths = loanPolicy.minimumJobTenure;
    if(totalMonths == null) return;
    tenureMonths.value = List.generate(int.parse(totalMonths), (index) => (index + 1).toString());
  }

  RxList<String> itRequestTypes = <String>[].obs;

  Future<void> fetchAllItRequestTypes() async {
    try {
      final resp = await ApiServices.getAllITRequestType();
      if(resp['status']?.toString() == "200") {
        ResignationReasonApi itRequestsApi = ResignationReasonApi.fromJson(resp);
        itRequestTypes.value = itRequestsApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------it requests error--------');
    }
  }

  RxList<String> workPlaceRequestTypes = <String>[].obs;

  Future<void> fetchWorkPlaceRequestTypes() async {
    try {
      final resp = await ApiServices.getAllWorkPlaceType();
      if(resp['status']?.toString() == "200") {
        ResignationReasonApi workPlaceRequestApi = ResignationReasonApi.fromJson(resp);
        workPlaceRequestTypes.value = workPlaceRequestApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------it requests error--------');
    }
  }

  List<String> monthString = List.generate(21, (index) {
    DateTime date = DateTime(
      DateTime.now().year,
      DateTime.now().month + index,
    );
    String formattedDate = DateFormat('MMMM yyyy').format(date);
    return formattedDate;
  });

  RxnString selectedFromDate = RxnString();
  RxnString selectedToDate = RxnString();
  RxnString selectedDropDown1 = RxnString();
  RxnString selectedDropDown2 = RxnString();
  RxnString selectedFromTime = RxnString();
  RxnString selectedToTime = RxnString();
  RxnString selectedText1 = RxnString();
  RxnString selectedText2 = RxnString();
  RxnString reasonText = RxnString();
  Rxn<LoanPolicy> selectedLoan = Rxn(null);
  RxList<String> selectedFiles = <String>[].obs;
  RxBool showValidation = false.obs;

  bool validateRequest(String reqId) {
    if (reasonText.value?.trim().isEmpty ?? true) return false;
    if (reqId == '1') {
      if (selectedFromDate.value == null) return false;
      if (selectedToDate.value == null) return false;
    } else if (reqId == '2') {
      if (selectedDropDown2.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '3') {
      if (selectedFromDate.value == null) return false;
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '4') {
      if (selectedFromDate.value == null) return false;
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
      if (selectedFromTime.value == null) return false;
      if (selectedToTime.value == null) return false;
    } else if (reqId == '5') {
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '6') {
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
      if (selectedText1.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '7') {
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
      if (selectedDropDown2.value?.trim().isEmpty ?? true) return false;
      if (selectedText1.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '8') {
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
      if (selectedText1.value?.trim().isEmpty ?? true) return false;
      if (selectedText2.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '9') {
      if (selectedDropDown1.value?.trim().isEmpty ?? true) return false;
      if (selectedText1.value?.trim().isEmpty ?? true) return false;
    } else if (reqId == '10') {
      if (selectedText1.value?.trim().isEmpty ?? true) return false;
    }
    return true;
  }


  void clearReqCreateData() {
    selectedFromDate.value = null;
    selectedToDate.value = null;
    selectedDropDown1.value = null;
    selectedDropDown2.value = null;
    selectedFromTime.value = null;
    selectedToTime.value = null;
    selectedText1.value = null;
    selectedText2.value = null;
    reasonText.value = null;
    selectedLoan.value = null;
    selectedFiles.value = [];
    tenureMonths.value = [];
    showValidation.value = false;
  }

  Future<SpecialRequestTypeApi?> saveRequest(RequestSendModel request) async {
    try {
      bool connection = await ConnectivityService().check();
      if(!connection) return SpecialRequestTypeApi(status: 0, message: 'No Internet Connection');
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      request.employeeId = empId;
      request.companyId = compId;
      if(request.reqId == '1') {
        request.fromDate = selectedFromDate.value;
        request.toDate = selectedToDate.value;
        request.description = reasonText.value;
        Map<String, dynamic> resp = await ApiServices.saveWorkFromHome(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '2') {
        request.description = reasonText.value;
        request.requestType = selectedDropDown2.value;
        Map<String, dynamic> resp = await ApiServices.saveLetterRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '3') {
        request.description = reasonText.value;
        EmployeeShiftData employeeShiftData = employeeShift.value.singleWhere((element) => element.shift == selectedDropDown1.value);
        request.requestType = employeeShiftData.shiftId?.toString();
        request.fromDate = selectedFromDate.value;
        Map<String, dynamic> resp = await ApiServices.saveShiftSwapRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '4') {
        request.description = reasonText.value;
        EmployeeShiftData employeeShiftData = employeeShift.value.singleWhere((element) => element.shift == selectedDropDown1.value);
        request.requestType = employeeShiftData.shiftId?.toString();
        request.fromDate = selectedFromDate.value;
        request.fromTime = selectedFromTime.value;
        request.toTime = selectedToTime.value;
        Map<String, dynamic> resp = await ApiServices.saveAttendanceRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '5') {
        request.description = reasonText.value;
        request.requestType = selectedDropDown1.value;
        Map<String, dynamic> resp = await ApiServices.saveResignationRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      }  else if(request.reqId == '6') {
        request.description = reasonText.value;
        request.dropdown1 = selectedDropDown1.value;
        request.amount = selectedText1.value;
        Map<String, dynamic> resp = await ApiServices.saveSalaryAdvanceRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '7') {
        request.description = reasonText.value;
        request.dropdown1 = selectedLoan.value?.loanPolicyId?.toString() ?? '';
        request.dropdown2 = selectedDropDown2.value;
        request.amount = selectedText1.value;
        request.requestType = selectedText2.value;
        final amount = double.tryParse(request.amount ?? '') ?? 0.0;
        final tenure = int.tryParse(request.dropdown2 ?? '') ?? 0;
        double emiAmount = amount / tenure;
        List<Map<String, dynamic>> tenureAmountList = List.generate(tenure, (index) {
          return {
            "EMI": index + 1,
            "amount": double.parse(emiAmount.toStringAsFixed(2)),
          };
        });
        double totalAmount = tenureAmountList.fold(
          0.0,
              (sum, item) => sum + (item['amount'] as double),
        );
        double balance = amount - totalAmount;
        tenureAmountList.last['amount'] = (tenureAmountList.last['amount'] as double) + balance;
        Map<String, dynamic> resp = await ApiServices.employeeLoanRequestSave(
            requestModel: request,
          tenureAmounts: tenureAmountList
        );
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '8') {
        request.description = reasonText.value;
        request.requestType = selectedDropDown1.value;
        request.text1 = selectedText1.value;
        request.text2 = selectedText2.value;
        request.files = selectedFiles.value;
        Map<String, dynamic> resp = await ApiServices.saveITRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '9') {
        request.description = reasonText.value;
        request.requestType = selectedDropDown1.value;
        request.text1 = selectedText1.value;
        request.files = selectedFiles.value;
        Map<String, dynamic> resp = await ApiServices.saveWorkPlaceRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '10') {
        request.description = reasonText.value;
        request.text1 = selectedText1.value;
        request.files = selectedFiles.value;
        Map<String, dynamic> resp = await ApiServices.saveOtherRequest(requestModel: request);
        if(resp['status'] == 200) {
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      } else if(request.reqId == '11') {
        request.requestType = selectedDropDown1.value;
        request.text1 = selectedText1.value; // Reference
        request.text2 = selectedText2.value; // Amount
        request.fromDate = selectedFromDate.value;
        request.description = reasonText.value;
        request.files = selectedFiles.value;
        List<String> parts = request.requestType?.split('<#>') ?? [];
        String? category = parts.isNotEmpty ? parts.last : null;
        String salaryMonthYear = DateFormat('MMMM yyyy').format(DateTime.now());
        WorkExpenseSubmitModel workExpenseSubmitModel = WorkExpenseSubmitModel(
            companyId: int.parse(request.companyId ?? ''),
            employeId: int.parse(request.employeeId ?? ''),
            categoryId: int.parse(category ?? ''),
            discription: request.description ?? '',
            amount: num.parse(request.text2 ?? ''),
            expenseDate: request.fromDate ?? '',
            saleryMonthYear: salaryMonthYear,
            createdBy: int.parse(request.employeeId ?? ''),
          reference: request.text1
        );
        Map<String, dynamic> resp = await ApiServices.sendWorkExpense(workExpenseData: workExpenseSubmitModel);
        if (resp['status']?.toString() == '200') {
          if ((request.files?.isNotEmpty ?? false) && resp['result']['insertedId'] != null) {
            for(String file in (request.files ?? [])) {
              await ApiServices.sendExpenseAttachment(
                insertedId: resp['result']['insertedId'].toString(),
                selectedFile: file,
              );
            }
          }
          await fetchRequestList();
          return SpecialRequestTypeApi(status: resp['status'], message: resp['message']);
        } else {
          return SpecialRequestTypeApi(status: 0, message: resp['message']);
        }
      }
    } catch(e) {} finally {}
    return null;
  }

  RxList<DocumentType> documentTypes = <DocumentType>[].obs;
  RxList<CountryData> countryStateCityList = <CountryData>[].obs;

  Future<void> initDocAdd() async {
    selectedFromTime.value = 'no';
    try {
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      final resp = await ApiServices.getAllDocumentType(compId: compId);
      if(resp['status']?.toString() == "200") {
        DocumentTypeApi documentTypeApi = DocumentTypeApi.fromJson(resp);
        documentTypes.value = documentTypeApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------document type list error--------');
    }
    try {
      final resp = await ApiServices.getCountryStateCity();
      if(resp['status']?.toString() == "200") {
        CountryStateCityApi documentTypeApi = CountryStateCityApi.fromJson(resp);
        countryStateCityList.value = documentTypeApi.result ?? [];
      }
    } catch(e) {
      debugPrint('-------country list error--------');
    }
  }

  RxBool documentCrating = false.obs;

  Future<DocumentTypeApi> addDocument(String attachment) async {
    documentCrating.value = true;
    try {
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      List<String> docTypeParts = selectedDropDown1.value?.split('<#>') ?? [];
      List<String> countryParts = selectedDropDown2.value?.split('<#>') ?? [];
      String? selectedDocId = docTypeParts.isNotEmpty ? docTypeParts.last : null;
      String? selectedCountryId = countryParts.isNotEmpty ? countryParts.last : null;
      DocumentAdd document = DocumentAdd(
        employeeId: int.tryParse(empId),
        companyId: int.tryParse(compId),
        documentTypeId: int.tryParse(selectedDocId ?? ''),
        filename: selectedText1.value,
        countryId: int.tryParse(selectedCountryId ?? ''),
        issuedOn: selectedFromDate.value,
        validFrom: selectedText2.value,
        expiresOn: selectedToDate.value,
        description: reasonText.value,
        file: attachment,
        validTo: selectedToDate.value,
        isRenewal: selectedFromTime.value == 'yes' ? 1 : 0,
        isUnderWarranty: 0,
      );
      final resp = await ApiServices.employeeDocumentUpload(docData: document);
      if(resp['status']?.toString() == "200") {
        await Get.find<UserProfileController>().fetchEmployeeDocuments();
        return DocumentTypeApi(status: 1, message: resp['message']?.toString());
      } else {
        return DocumentTypeApi(status: 0, message: resp['message']?.toString() ?? 'Something went wrong');
      }
    } catch(e) {
      debugPrint('-------failed to add document--------');
      return DocumentTypeApi(status: 0, message: 'Something went wrong');
    } finally {
      documentCrating.value = false;
    }
  }
}
