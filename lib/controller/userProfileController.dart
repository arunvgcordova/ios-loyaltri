

import 'dart:io';

import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/models/all_comany_list_model.dart';
import 'package:loyaltri_minimal/models/notifications_model.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_profile_api_model.dart';
import '../services/api_services.dart';
import '../services/flutter_secure_storage.dart';
import '../services/ui_model_services/home_actions_model.dart';
import 'package:http/http.dart' as http;

class UserProfileController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<File> profileImageLocation = File("").obs;

  late Rx<UserProfileApiModel> userData = userProfileAPI.obs;
  late Rx<UserCompanyDetailsApi> userCompanyData = UserCompanyDetailsApi().obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchUserData({required String empId}) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.getUserProfileDetails(empId: empId);
      userData.value = UserProfileApiModel.fromJson(resp);
      if (userData.value.status == 200) {
        if(userData.value.result.profilePicture != null &&
            userData.value.result.absProfilePicture != null &&
            userData.value.result.profilePicture!.trim().isNotEmpty &&
            userData.value.result.absProfilePicture!.trim().isNotEmpty) {
          String? fileLocation = userData.value.result.absProfilePicture?.split("/").last;
          String? profileImagePath = await downloadProfileImage(userData.value.result.profilePicture ?? '', fileLocation!);
          if(profileImagePath != null) {
            profileImageLocation.value = File(profileImagePath.toString());
          }
        }
        if(userData.value.result.employeeId != null) {
          await SecureStorageUtils().setProfileData(resp);
        }
        // await SharedPrefs().setUserData(resp);
        dataLoaded.value = true;
        await fetchCompanyData(compId: userData.value.result.companyId ?? '');
      } else {
        UserProfileApiModel? profileData = await SecureStorageUtils().getProfileData();
        if(profileData != null) {
          userData.value = profileData;
          if(userData.value.result.profilePicture != null &&
              userData.value.result.absProfilePicture != null &&
              userData.value.result.profilePicture!.trim().isNotEmpty &&
              userData.value.result.absProfilePicture!.trim().isNotEmpty) {
            String? fileLocation = userData.value.result.absProfilePicture?.split("/").last;
            String? profileImagePath = await downloadProfileImage(userData.value.result.profilePicture ?? '', fileLocation!);
            if(profileImagePath != null) {
              profileImageLocation.value = File(profileImagePath.toString());
            }
          }
        }
      }
    } catch(e) {
      isError.value = true;
      UserProfileApiModel? profileData = await SecureStorageUtils().getProfileData();
      if(profileData != null) {
        userData.value = profileData;
        if(userData.value.result.profilePicture != null &&
            userData.value.result.absProfilePicture != null &&
            userData.value.result.profilePicture!.trim().isNotEmpty &&
            userData.value.result.absProfilePicture!.trim().isNotEmpty) {
          String? fileLocation = userData.value.result.absProfilePicture?.split("/").last;
          String? profileImagePath = await downloadProfileImage(userData.value.result.profilePicture ?? '', fileLocation!);
          if(profileImagePath != null) {
            profileImageLocation.value = File(profileImagePath.toString());
          }
        }
      }
      AttendanceCommonWidgets().printF("------user profile error-------${e.toString()}");
    } finally {
      Get.find<UserAuthController>().fieldAccess.value = userData.value.result.isAllowFields == '1';
      homeActions.value = getHomeActions();
      serviceActions.value = getActionList();
      moreActions.value = getMoreActions();
      resetStatus();
    }
  }

  Future fetchCompanyData({required String compId}) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.getUserCompanyDetails(compId: compId);
      userCompanyData.value = UserCompanyDetailsApi.fromJson(resp);
      if (userCompanyData.value.status == 200) {
        // await SharedPrefs().setUserData(resp);
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------user company error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  RxBool companyListLoading = false.obs;
  RxBool companyListLoaded = false.obs;
  RxBool companyListError = false.obs;
  RxList<CompanyListData> allCompanyList = <CompanyListData>[].obs;
  Rx<CompanyListData?> currentCompany = Rx(null);

  Future fetchAllCompanyList() async {
    companyListLoading.value = true;
    companyListLoaded.value = false;
    companyListError.value = false;
    allCompanyList.value = [];
    currentCompany.value = null;
    try {
      String orgId = Get.find<UserAuthController>().userData.value.userData?.organisationId ?? '';
      Map<String, dynamic> resp = await ApiServices.getCompanyList(organizationId: orgId);

      if (resp['status']?.toString() == "200") {
        AllCompanyListApi allCompanyListApi = AllCompanyListApi.fromJson(resp);
        List<int> company = Get.find<UserAuthController>().userData.value.userData?.companyId ?? [];
        for (var compId in company) {
          allCompanyListApi.result?.forEach((comp) {
            if(compId == comp.companyId) {
              allCompanyList.value.add(comp);
            }
          });
        }
        // allCompanyList.value = allCompanyListApi.result ?? [];
        List<CompanyListData> companies = allCompanyList.value.where((comp) => comp.companyId.toString() == userData.value.result.companyId).toList();
        if(companies.isNotEmpty) {
          currentCompany.value = allCompanyList.value.where((comp) => comp.companyId.toString() == (currentCompany.value?.companyId?.toString() ?? userData.value.result.companyId)).toList().first;
        }
        companyListLoaded.value = true;
      }
    } catch(e) {
      companyListError.value = true;
      AttendanceCommonWidgets().printF("------user company list error-------${e.toString()}");
    } finally {
      companyListLoading.value = false;
    }
  }

  RxList<HomeActionsModel> homeActions = <HomeActionsModel>[
    HomeActionsModel(id: 1, title: "Mark Attendance", svgIcon: "assets/images/attendance-3d.webp"),
    HomeActionsModel(id: 2, title: "Request Leave", svgIcon: "assets/images/calendarblue-3d.webp"),
  ].obs;
  RxList<HomeActionsModel> serviceActions = <HomeActionsModel>[
    HomeActionsModel(id: 1, title: "View Leaves", svgIcon: "assets/images/calendarblue-3d.webp"),
    HomeActionsModel(id: 5, title: "My Excuse", svgIcon: "assets/images/Hourglass-3d.webp"),
    HomeActionsModel(id: 6, title: "My Request", svgIcon: "assets/images/my_request.webp"),
    HomeActionsModel(id: 7, title: "My Schedule", svgIcon: "assets/images/my_schedule.webp"),
  ].obs;

  RxList<HomeActionsModel> moreActions = <HomeActionsModel>[
    HomeActionsModel(id: 1, title: "Employee\nLeave", svgIcon: "assets/images/calendarblue-3d.webp"),
    // HomeActionsModel(id: 2, title: "Task", svgIcon: "assets/images/workentry-3d.webp"),
    // HomeActionsModel(id: 3, title: "Employee\nDocument", svgIcon: "assets/images/manager_view/documents_colorImg.png"),
    HomeActionsModel(id: 4, title: "Employee\nRequest", svgIcon: "assets/images/manager_view/request_icon.png"),
    HomeActionsModel(id: 6, title: "Piece\nWork Pay", svgIcon: "assets/images/manager_view/piece_work_icon.png"),
  ].obs;

  List<HomeActionsModel> getMoreActions() {
    String showTask = userData.value.result.taskAccess ?? '0';
    List<HomeActionsModel> moreActions = [
      HomeActionsModel(id: 1, title: "Employee\nLeave", svgIcon: "assets/images/calendarblue-3d.webp"),
      HomeActionsModel(id: 4, title: "Employee\nRequest", svgIcon: "assets/images/manager_view/request_icon.png"),
      if(showTask == "1")
        HomeActionsModel(id: 5, title: "Task", svgIcon: "assets/images/manager_view/task-logo.png"),
      HomeActionsModel(id: 6, title: "Piece\nWork Pay", svgIcon: "assets/images/manager_view/piece_work_icon.png"),
      // HomeActionsModel(id: 7, title: "Shift\nScheduler", svgIcon: "assets/images/shift_scheduler/scheduler_icon.png"),
    ];

    return moreActions;
  }

  List<HomeActionsModel> getHomeActions() {
    String showWorkEntry = userData.value.result.workEntryAccess ?? '0';
    String showTask = userData.value.result.taskAccess ?? '0';
    String showWorkExpense = userData.value.result.expenseReimbursement ?? '0';
    // Growth_Main: 164,
    // Growth_Dashboard: 165,
    // Growth_Strategy_map: 166,
    // Growth_Analytics: 167,
    // Growth_MIS: 168,
    // Growth_Performance_Overview: 169,
    // Growth_Employee_Performance: 170,
    // Growth_MY_performance: 171,
    bool showGrowth = Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false;
    bool isGrowthPermission = Get.find<UserAuthController>().userData.value.userData?.permissions?.any((e) => [164, 165, 166, 167, 168, 169, 170, 171].contains(e)) ?? false;
    bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;
    List<HomeActionsModel> homeActions = [
      if(showGrowth && isGrowthPermission)
        HomeActionsModel(id: 5, title: "View\nGrowth", svgIcon: "assets/images/growth/growth-home-icon.png"),
      HomeActionsModel(id: 2, title: "Request Leave", svgIcon: "assets/images/calendarblue-3d.webp"),
      if(fieldAccess)
        HomeActionsModel(id: 11, title: "Loyaltri\nField", svgIcon: "assets/images/field/png/map.png"),
      if(showTask == "1")
        HomeActionsModel(id: 9, title: "Create\nTask", svgIcon: "assets/images/manager_view/task-logo.png"),
      if(showWorkEntry == "1")
        HomeActionsModel(id: 3, title: "Add\nWork Entry", svgIcon: "assets/images/workentry-3d.webp"),
      if(showWorkExpense == "1")
        HomeActionsModel(id: 4, title: "Add\nWork Expenses", svgIcon: "assets/images/cashgreen3d.webp"),
    ];

    if(homeActions.length == 1) {
      homeActions.insert(0, HomeActionsModel(id: 1, title: "Mark Attendance", svgIcon: "assets/images/attendance-3d.webp"));
    }

    return homeActions;
  }

  List<HomeActionsModel> getActionList() {
    String showWorkEntry = userData.value.result.workEntryAccess ?? '0';
    String showWorkExpense = userData.value.result.expenseReimbursement ?? '0';
    String showPayRoll = userData.value.result.salaryAccess ?? '0';
    String showTask = userData.value.result.taskAccess ?? '0';
    String showAirTicket = userData.value.result.airTicketAccess ?? '0';
    bool showGrowth = Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false;
    bool isGrowthPermission = Get.find<UserAuthController>().userData.value.userData?.permissions?.any((e) => [164, 165, 166, 167, 168, 169, 170, 171].contains(e)) ?? false;
    bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;
    List<HomeActionsModel> serviceActions = [
      HomeActionsModel(id: 1, title: "View\nLeaves", svgIcon: "assets/images/calendarblue-3d.webp"),
      if(showWorkEntry == "1")
        HomeActionsModel(id: 2, title: "View\nWork Entries", svgIcon: "assets/images/workentry-3d.webp"),
      if(showWorkExpense == "1")
        HomeActionsModel(id: 3, title: "View\nWork Expenses", svgIcon: "assets/images/cashgreen3d.webp"),
      if(showPayRoll == "1")
        HomeActionsModel(id: 4, title: "View\nPayroll", svgIcon: "assets/images/cash-3d.webp"),
      HomeActionsModel(id: 5, title: "My\nExcuse", svgIcon: "assets/images/Hourglass-3d.webp"),
      HomeActionsModel(id: 6, title: "My\nRequest", svgIcon: "assets/images/my_request.webp"),
      HomeActionsModel(id: 7, title: "My\nSchedule", svgIcon: "assets/images/my_schedule.webp"),
      if(showAirTicket == "1")
        HomeActionsModel(id: 8, title: "Air\nTicket", svgIcon: "assets/images/air_ticket/aeroplane_icon.png"),
      if(showTask == "1")
        HomeActionsModel(id: 9, title: "Task", svgIcon: "assets/images/manager_view/task-logo.png"),
      if(showGrowth && isGrowthPermission)
        HomeActionsModel(id: 10, title: "Growth", svgIcon: "assets/images/growth/growth-service-icon.png"),
      if(fieldAccess)
        HomeActionsModel(id: 11, title: "Loyaltri\nField", svgIcon: "assets/images/field/png/map.png"),
    ];

    return serviceActions;
  }

  Future<String?> downloadProfileImage(String url, String fileName) async {
    try {
      // Get the temporary directory of the device
      final directory = await getApplicationDocumentsDirectory();

      // Create the full path of the file
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if(await file.exists()) {
        return filePath;
      }

      // Send a GET request to download the image
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Write the bytes to the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        AttendanceCommonWidgets().printF('Image downloaded to $filePath');
        return filePath;
      } else {
        AttendanceCommonWidgets().printF('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      AttendanceCommonWidgets().printF('Error downloading image: $e');
    }
    return null;
  }

  RxBool notificationLoading = false.obs;
  RxBool notificationLoaded = false.obs;
  RxBool notificationError = false.obs;
  RxInt notificationCount = 0.obs;
  RxList<Notifications> notifications = <Notifications>[].obs;

  Future<void> fetchAllNotifications() async {
    notificationLoading.value = true;
    notificationLoaded.value = false;
    notificationError.value = false;
    notificationCount.value = 0;
    notifications.clear();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      Map<String, dynamic> resp = await ApiServices.getUserNotifications(
        compId: Get.find<UserPageController>().appView.value == AppView.manager
            ? currentCompany.value?.companyId?.toString() ?? userData.value.result.companyId ?? ''
            : userData.value.result.companyId ?? '',
        empId: userData.value.result.employeeId ?? '',
      );

      NotificationsApi notificationsApi = NotificationsApi.fromJson(resp);
      List<Notifications> recentNotifications = [];
      List<Notifications> earlierNotifications = [];
      notificationCount.value = notificationsApi.result?.length ?? 0;

      for (Notifications notification in notificationsApi.result ?? []) {
        final createdOn = notification.createdOn;
        if (createdOn == null || createdOn.isEmpty) continue;

        DateTime created;
        try {
          created = DateTime.parse(createdOn).toLocal();
        } catch (_) {
          continue;
        }

        final createdDate = DateTime(created.year, created.month, created.day);
        if (createdDate == today) {
          recentNotifications.add(notification);
        } else {
          earlierNotifications.add(notification);
        }
      }

      recentNotifications.sort((a, b) =>
          DateTime.parse(b.createdOn!).compareTo(DateTime.parse(a.createdOn!)));
      earlierNotifications.sort((a, b) =>
          DateTime.parse(b.createdOn!).compareTo(DateTime.parse(a.createdOn!)));

      if (recentNotifications.isNotEmpty) {
        notifications.add(Notifications(type: 'Recent'));
        notifications.addAll(recentNotifications);
      }

      if (earlierNotifications.isNotEmpty) {
        notifications.add(Notifications(type: 'Earlier'));
        notifications.addAll(earlierNotifications);
      }

      notificationLoaded.value = true;
    } catch (e) {
      notificationError.value = true;
      AttendanceCommonWidgets().printF("----------notifications api error-----------");
    } finally {
      notificationLoading.value = false;
    }
  }

  RxBool documentsLoading = false.obs;
  RxList<EmployeeDocument> employeeDocuments = <EmployeeDocument>[].obs;

  Future<void> fetchEmployeeDocuments() async {
    try {
      employeeDocuments.value = [];
      documentsLoading.value = true;
      String empId = userData.value.result.employeeId ?? '--';
      final resp = await ApiServices.getEmployeeDocuments(empId: empId);
      if(resp['status']?.toString() == '200') {
        EmployeeDocumentsApi employeeDocumentsApi = EmployeeDocumentsApi.fromJson(resp);
        employeeDocuments.value = employeeDocumentsApi.result ?? [];
      }
    } catch(e) {} finally {
      documentsLoading.value = false;
    }
  }

  RxBool assetsLoading = false.obs;
  RxList<EmployeeAsset> employeeAssets = <EmployeeAsset>[].obs;

  Future<void> fetchEmployeeAssets() async {
    try {
      employeeAssets.value = [];
      assetsLoading.value = true;
      String empId = userData.value.result.employeeId ?? '--';
      final resp = await ApiServices.getEmployeeAssetsById(empId: empId);
      if(resp['status']?.toString() == 'true') {
        EmployeeAssetsApi employeeAssetsApi = EmployeeAssetsApi.fromJson(resp);
        employeeAssets.value = employeeAssetsApi.data ?? [];
      }
    } catch(e) {} finally {
      assetsLoading.value = false;
    }
  }
}