
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/OldMyRequest/model/myRequestListApiModel.dart';

import '../../../services/api_services.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../my_request_models/filter_model.dart';

class MyRequestController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<MyRequestListApiModel> wFHRequestApi = MyRequestListApiModel().obs;
  Rx<MyRequestListApiModel> letterRequestApi = MyRequestListApiModel().obs;
  RxList<RequestData> allRequestList = <RequestData>[].obs;
  RxList<RequestData> wFHRequestList = <RequestData>[].obs;
  RxList<RequestData> letterRequestList = <RequestData>[].obs;
  List<String> supportedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'tiff',
    'tif',
    'heic',
    'heif',
    'svg',
  ];

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void initialValues() {
    isLoading.value = false;
    isError.value = false;
    dataLoaded.value = false;
    wFHRequestApi.value = MyRequestListApiModel();
    letterRequestApi.value = MyRequestListApiModel();
    allRequestList.value = [];
  }

  Future fetchRequestList({required String empId, required String compId}) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> wfhResp =
          await ApiServices.getWFHRequestList(empId: empId, compId: compId);
      Map<String, dynamic> lResp =
          await ApiServices.getLetterRequestList(empId: empId, compId: compId);

      if (wfhResp['status'] == 200 && lResp['status'] == 200) {
        initialValues();
        wFHRequestApi.value = MyRequestListApiModel.fromJson(wfhResp);
        wFHRequestList.value = wFHRequestApi.value.result ?? [];
        if (wFHRequestList.isNotEmpty) {
          wFHRequestList.sort((a, b) => DateTime.parse(b.fromDate!)
              .compareTo(DateTime.parse(a.fromDate!)));
        }
        letterRequestApi.value = MyRequestListApiModel.fromJson(lResp);
        letterRequestList.value = letterRequestApi.value.result ?? [];
        if (letterRequestList.isNotEmpty) {
          letterRequestList.sort((a, b) => DateTime.parse(b.fromDate!)
              .compareTo(DateTime.parse(a.fromDate!)));
        }
        allReqList();
        dataLoaded.value = true;
      }
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------my request error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  void allReqList() {
    allRequestList.value = [];
    List<RequestData> allData = [];
    allData.addAll(wFHRequestApi.value.result ?? []);
    allData.addAll(letterRequestApi.value.result ?? []);
    allData.sort((a, b) =>
        DateTime.parse(b.fromDate!).compareTo(DateTime.parse(a.fromDate!)));
    allRequestList.value = allData;
  }

  void filterList({required RequestFilter filter, required int tabIndex}) {
    if (tabIndex == 0) {
      allReqList();
      List<RequestData> resList =
          filterPerList(filter: filter, reqList: allRequestList.value);
      allRequestList.value = resList;
    }
    if (tabIndex == 1) {
      List<RequestData> resList = filterPerList(
          filter: filter, reqList: wFHRequestApi.value.result ?? []);
      wFHRequestList.value = resList;
    }
    if (tabIndex == 2) {
      List<RequestData> resList = filterPerList(
          filter: filter, reqList: letterRequestApi.value.result ?? []);
      letterRequestList.value = resList;
    }
  }

  List<RequestData> filterPerList(
      {required RequestFilter filter, required List<RequestData> reqList}) {
    if (filter.approved &&
        filter.pending &&
        filter.rejected &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
                .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1)));
      }).toList();
    } else if (filter.approved &&
        filter.pending &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1))) &&
            req.requestStatusName!.toLowerCase() == 'pending' &&
            req.requestStatusName!.toLowerCase() == 'approved';
      }).toList();
    } else if (filter.approved &&
        filter.rejected &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1))) &&
            req.requestStatusName!.toLowerCase() == 'rejected' &&
            req.requestStatusName!.toLowerCase() == 'approved';
      }).toList();
    } else if (filter.pending &&
        filter.rejected &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1))) &&
            req.requestStatusName!.toLowerCase() == 'rejected' &&
            req.requestStatusName!.toLowerCase() == 'pending';
      }).toList();
    } else if (filter.approved &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1))) &&
            req.requestStatusName!.toLowerCase() == 'approved';
      }).toList();
    } else if (filter.pending &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1))) &&
            req.requestStatusName!.toLowerCase() == 'pending';
      }).toList();
    } else if (filter.rejected &&
        filter.fromDate != null &&
        filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1))) &&
            req.requestStatusName!.toLowerCase() == 'rejected';
      }).toList();
    } else if (filter.fromDate != null && filter.toDate != null) {
      return reqList.where((req) {
        final reqDate = DateTime.parse(req.fromDate!);
        final fromDate = DateTime(filter.fromDate!.year, filter.fromDate!.month,
            filter.fromDate!.day);
        final toDate = DateTime(filter.toDate!.year, filter.toDate!.month,
            filter.toDate!.day, 23, 59, 59, 999);

        return reqDate
            .isAfter(fromDate.subtract(const Duration(milliseconds: 1))) &&
            reqDate.isBefore(toDate.add(const Duration(milliseconds: 1)));
      }).toList();
    } else if (filter.approved && filter.pending && filter.rejected) {
      return reqList
          .where((req) =>
              req.requestStatusName!.toLowerCase() == 'approved' &&
              req.requestStatusName!.toLowerCase() == 'pending' &&
              req.requestStatusName!.toLowerCase() == 'rejected')
          .toList();
    } else if (filter.approved && filter.pending) {
      return reqList
          .where((req) =>
              req.requestStatusName!.toLowerCase() == 'approved' &&
              req.requestStatusName!.toLowerCase() == 'pending')
          .toList();
    } else if (filter.approved && filter.rejected) {
      return reqList
          .where((req) =>
              req.requestStatusName!.toLowerCase() == 'approved' &&
              req.requestStatusName!.toLowerCase() == 'rejected')
          .toList();
    } else if (filter.pending && filter.rejected) {
      return reqList
          .where((req) =>
              req.requestStatusName!.toLowerCase() == 'pending' &&
              req.requestStatusName!.toLowerCase() == 'rejected')
          .toList();
    } else if (filter.rejected) {
      return reqList
          .where((req) => req.requestStatusName!.toLowerCase() == 'rejected')
          .toList();
    } else if (filter.approved) {
      return reqList
          .where((req) => req.requestStatusName!.toLowerCase() == 'approved')
          .toList();
    } else if (filter.pending) {
      return reqList
          .where((req) => req.requestStatusName!.toLowerCase() == 'pending')
          .toList();
    } else {
      return reqList;
    }
  }
}

class MyRequestFilterController extends GetxController {
  Rx<bool> isFilterEnabled = false.obs;
  Rx<bool> approved = false.obs;
  Rx<bool> pending = false.obs;
  Rx<bool> rejected = false.obs;
  Rx<String> fromDate = "From Date".obs;
  Rx<String> toDate = "To Date".obs;
  Rx<DateTime?> fromDateTime = Rx<DateTime?>(null);
  Rx<DateTime?> toDateTime = Rx<DateTime?>(null);

  void resetFilter() {
    isFilterEnabled.value = false;
    approved.value = false;
    pending.value = false;
    rejected.value = false;
    fromDate.value = "From Date";
    toDate.value = "To Date";
    fromDateTime.value = null;
    toDateTime.value = null;
  }

  void dateFilter({required String from, required String to, required DateTime fromDateTimeValue, required DateTime toDateTimeValue}) {
    fromDate.value = from;
    toDate.value = to;
    fromDateTime.value = fromDateTimeValue;
    toDateTime.value = toDateTimeValue;
  }

  void approvedFilter(bool value) => approved.value = value;
  void pendingFilter(bool value) => pending.value = value;
  void rejectedFilter(bool value) => rejected.value = value;
  void apply(bool value) => isFilterEnabled.value = value;
}
