
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/feed_data_list_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

import '../../../../controller/userAuthentication.dart';
import '../../../../models/all_comany_list_model.dart';

class FeedViewController extends GetxController {
  RxString feedText = ''.obs;
  RxString selectedImgPath = ''.obs;
  int currentPage = 1;

  RxBool feedLoading = false.obs;
  RxBool feedMoreLoading = false.obs;
  RxBool feedLoaded = false.obs;
  RxBool feedError = false.obs;
  RxBool stopLoading = false.obs;
  RxBool showFieldValidation = false.obs;
  int lastLength = 0;
  RxList<FeedData> feedDataList = <FeedData>[].obs;

  Future<void> fetchFeedListUser({bool? loadMore}) async {
    feedLoading.value = true;
    feedLoaded.value = false;
    feedError.value = false;
    try {
      if(loadMore != null && loadMore) {
        feedMoreLoading.value = true;
        currentPage += 1;
      } else {
        stopLoading.value = false;
        currentPage = 1;
      }
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String cmpId = Get.find<UserPageController>().appView.value == AppView.manager
          ? Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? ''
          : Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      Map<String, dynamic> resp = await ApiServices.getFeedDataList(empId: empId, compId: cmpId, page: currentPage);

      AttendanceCommonWidgets().printF("-------feed resp---------$resp");

      if(resp['status']?.toString() == "200") {
        FeedListDataApi feedListDataApi = FeedListDataApi.fromJson(resp);
        if(loadMore != null && loadMore) {
          feedDataList.value.addAll(feedListDataApi.result ?? []);
        } else {
          feedDataList.value = feedListDataApi.result ?? [];
        }
        feedLoaded.value = true;
        if(loadMore != null && loadMore) {
          if(feedDataList.length == lastLength) {
            stopLoading.value = true;
          }
          lastLength = feedDataList.length;
        }
      }
    } catch(e) {
      feedError.value = true;
      AttendanceCommonWidgets().printF("------------feed error--------");
    } finally {
      feedLoading.value = false;
      feedMoreLoading.value = false;
    }
  }

  Future<void> likeAFeed({required String feedId}) async {
    try {
      int feedIndex = feedDataList.value.indexWhere((feed) => feed.feedsId == feedId);
      if(feedDataList.value[feedIndex].isSignedInEmployeeLiked == 0) {
        feedDataList.value[feedIndex].likesCount = (int.parse(feedDataList.value[feedIndex].likesCount ?? "0") + 1).toString();
        feedDataList.value[feedIndex].isSignedInEmployeeLiked = 1;
      } else if(feedDataList.value[feedIndex].isSignedInEmployeeLiked == 1) {
        feedDataList.value[feedIndex].likesCount = (int.parse(feedDataList.value[feedIndex].likesCount ?? "0") - 1).toString();
        feedDataList.value[feedIndex].isSignedInEmployeeLiked = 0;
      }
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String cmpId = Get.find<UserPageController>().appView.value == AppView.manager
          ? Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? ''
          : Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      Map<String, dynamic> resp = await ApiServices.likeFeedApi(feedId: feedId, compId: cmpId, empId: empId);
      if(resp['result']?['insertedId'] == null) {
        if(feedDataList.value[feedIndex].isSignedInEmployeeLiked == 0) {
          feedDataList.value[feedIndex].likesCount = (int.parse(feedDataList.value[feedIndex].likesCount ?? "0") + 1).toString();
          feedDataList.value[feedIndex].isSignedInEmployeeLiked = 1;
        } else if(feedDataList.value[feedIndex].isSignedInEmployeeLiked == 1) {
          feedDataList.value[feedIndex].likesCount = (int.parse(feedDataList.value[feedIndex].likesCount ?? "0") - 1).toString();
          feedDataList.value[feedIndex].isSignedInEmployeeLiked = 0;
        }
      }
      feedDataList.refresh();
    } catch(e) {}
  }

  RxBool feedCommenting = false.obs;

  Future<FeedListDataApi> addCommentToFeed({
    required String feedsId,
    required String commentText,
  }) async {
    feedCommenting.value = true;
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String cmpId = Get.find<UserPageController>().appView.value == AppView.manager
          ? Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? ''
          : Get.find<UserProfileController>().userData.value.result.companyId ?? '';

      Map<String, dynamic> resp = await ApiServices.saveCommentApi(
        feedsId: feedsId,
        comment: commentText,
        companyId: cmpId,
        employeeId: empId,
      );

      if (resp['status']?.toString() == "200" && resp['result']?['insertedId'] != null) {
        String insertedId = resp['result']['insertedId'].toString();
        String? userName = Get.find<UserProfileController>().userData.value.result.employeeName;
        String? userImage = Get.find<UserProfileController>().userData.value.result.profilePicture;
        String? designation = Get.find<UserProfileController>().userData.value.result.designation;

        Comments newComment = Comments(
          commentsId: insertedId,
          feedsId: feedsId,
          employeeId: empId,
          comment: commentText,
          isActive: "1",
          createdBy: empId,
          createdOn: DateTime.now().toIso8601String(),
          companyId: cmpId,
          userName: userName,
          userImage: userImage,
          designation: designation,
        );

        int index = feedDataList.indexWhere((f) => f.feedsId == feedsId);
        if (index != -1) {
          feedDataList[index].comments ??= [];
          feedDataList[index].comments!.insert(0, newComment);
          int currentCount = int.tryParse(feedDataList[index].commentsCount?.toString() ?? '0') ?? 0;
          feedDataList[index].commentsCount = (currentCount + 1).toString();
          feedDataList.refresh();
        }
        return FeedListDataApi(status: int.tryParse(resp['status']?.toString() ?? '0') ?? 0, message: resp['message']);
      }
    } catch (e) {
      AttendanceCommonWidgets().printF("-----addCommentToFeed error----$e");
      return FeedListDataApi(status: 0, message: e.toString());
    } finally {
      feedCommenting.value = false;
    }
    return FeedListDataApi(status: 0, message: 'Something went wrong.');
  }

  Future<FeedListDataApi> deleteCommentFromFeed({
    required String feedsId,
    required String commentsId,
  }) async {
    try {
      Map<String, dynamic> resp = await ApiServices.deleteCommentApi(
        commentId: commentsId,
      );

      if (resp['status']?.toString() == "200") {
        int index = feedDataList.indexWhere((f) => f.feedsId == feedsId);
        if (index != -1 && feedDataList[index].comments != null) {
          feedDataList[index].comments!.removeWhere((c) => c.commentsId == commentsId);
          int currentCount = int.tryParse(feedDataList[index].commentsCount?.toString() ?? '0') ?? 0;
          if (currentCount > 0) {
            feedDataList[index].commentsCount = (currentCount - 1).toString();
          }
          feedDataList.refresh();
        }
        return FeedListDataApi(
          status: int.tryParse(resp['status']?.toString() ?? '0') ?? 200,
          message: resp['message'] ?? 'Comment has been deleted.',
        );
      } else {
        return FeedListDataApi(
          status: int.tryParse(resp['status']?.toString() ?? '0') ?? 0,
          message: resp['message'] ?? 'Failed to delete comment.',
        );
      }
    } catch (e) {
      AttendanceCommonWidgets().printF("-----deleteCommentFromFeed error----$e");
      return FeedListDataApi(status: 0, message: e.toString());
    }
  }

  RxList<LocationData> locationsList = <LocationData>[].obs;
  RxList<LocationData> selectedLocations = <LocationData>[].obs;
  RxList<CategoryData> categoryList = <CategoryData>[].obs;
  RxList<CategoryData> selectedCategories = <CategoryData>[].obs;
  RxList<DepartmentData> departmentList = <DepartmentData>[].obs;
  RxList<DepartmentData> selectedDepartments = <DepartmentData>[].obs;

  Future<void> fetchSettings({required PostSettings settings}) async {
    try {
      String cmpId = Get.find<UserPageController>().appView.value == AppView.manager
          ? Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? ''
          : Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      final resp = await ApiServices.getSettings(compId: cmpId, type: settings);

      if(resp['status']?.toString() == '200') {
        if(settings == PostSettings.location) {
          AllLocationsApi locationsApi = AllLocationsApi.fromJson(resp);
          locationsList.value = locationsApi.result ?? [];
        }
        if(settings == PostSettings.category) {
          AllCategoryApi categoryApi = AllCategoryApi.fromJson(resp);
          categoryList.value = categoryApi.result ?? [];
        }
        if(settings == PostSettings.department) {
          AllDepartmentApi departmentApi = AllDepartmentApi.fromJson(resp);
          departmentList.value = departmentApi.result ?? [];
        }
      }
    } catch(e) {
      AttendanceCommonWidgets().printF('---------feed settings error----------');
    } finally {}
  }

  RxList<CompanyListData> allCompanyList = <CompanyListData>[].obs;
  RxList<CompanyListData> selectedCompanies = <CompanyListData>[].obs;

  Future fetchAllCompanyList() async {
    try {
      String orgId = Get.find<UserAuthController>().userData.value.userData?.organisationId ?? '';
      Map<String, dynamic> resp = await ApiServices.getCompanyList(organizationId: orgId);

      if (resp['status']?.toString() == "200") {
        AllCompanyListApi allCompanyListApi = AllCompanyListApi.fromJson(resp);
        allCompanyList.value = allCompanyListApi.result ?? [];
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("------user company list error-------${e.toString()}");
    } finally {}
  }

  Rx<PostSettings> selectedSettings = PostSettings.organization.obs;

  void clearSelections({required PostSettings except}) {
    selectedSettings.value = except;
    if (except != PostSettings.entity) selectedCompanies.clear();
    if (except != PostSettings.location) selectedLocations.clear();
    if (except != PostSettings.category) selectedCategories.clear();
    if (except != PostSettings.department) selectedDepartments.clear();
  }
}