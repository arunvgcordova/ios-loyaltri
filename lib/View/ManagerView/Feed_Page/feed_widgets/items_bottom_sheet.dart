import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/models/all_comany_list_model.dart';
import 'package:loyaltri_minimal/models/manager/feed_data_list_model.dart';

import '../../../../controller/ui_controller/home_controller.dart';
import '../../../../controller/ui_controller/page_controller.dart';
import '../../../../utils/color_utils.dart';

class ItemsBottomSheet extends StatelessWidget {
  final PostSettings postSettings;
  const ItemsBottomSheet({super.key, required this.postSettings});

  @override
  Widget build(BuildContext context) {
    AppView appView = Get.find<UserPageController>().appView.value;
    final controller = Get.find<FeedViewController>();

    // Get the correct list based on the type
    List<dynamic> items = [];
    if (postSettings == PostSettings.entity) {
      items = controller.allCompanyList.value;
    } else if (postSettings == PostSettings.location) {
      items = controller.locationsList.value;
    } else if (postSettings == PostSettings.category) {
      items = controller.categoryList.value;
    } else if (postSettings == PostSettings.department) {
      items = controller.departmentList.value;
    }

    // Helper to get item title (since different models have different fields)
    String getItemTitle(dynamic item) {
      if (item is CompanyListData) return item.company ?? '';
      if (item is LocationData) return item.location ?? '';
      if (item is CategoryData) return item.category ?? '';
      if (item is DepartmentData) return item.department ?? '';
      return '';
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top handle bar
            Container(
              height: 5.h,
              width: 75.h,
              decoration: BoxDecoration(
                color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.2) : ColorUtils.textWhite.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 13.h),
      
            // Title + Back Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(14).r,
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 48.h,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: appView == AppView.manager ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                      borderRadius: BorderRadius.circular(14).r,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5).h,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                          size: 15.h,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Post Settings',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                    color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                  ),
                ),
                Container(
                  width: 48.h,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14).r,
                  ),
                ),
              ],
            ),
      
            SizedBox(height: 20.h),
      
            // Display dynamic list
            if (items.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'No data available',
                  style: GoogleFonts.poppins(fontSize: 13.h, color: Colors.grey),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final title = getItemTitle(item);
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        if (postSettings == PostSettings.entity) {
                          final company = item as CompanyListData;
                          final exists = controller.selectedCompanies.any((c) => c.companyId == company.companyId);
                          if (exists) {
                            controller.selectedCompanies.removeWhere((c) => c.companyId == company.companyId);
                          } else {
                            controller.selectedCompanies.add(company);
                          }
                        } else if (postSettings == PostSettings.location) {
                          final loc = item as LocationData;
                          final exists = controller.selectedLocations.any((c) => c.locationId == loc.locationId);
                          if (exists) {
                            controller.selectedLocations.removeWhere((c) => c.locationId == loc.locationId);
                          } else {
                            controller.selectedLocations.add(loc);
                          }
                        } else if (postSettings == PostSettings.category) {
                          final cat = item as CategoryData;
                          final exists = controller.selectedCategories.any((c) => c.categoryId == cat.categoryId);
                          if (exists) {
                            controller.selectedCategories.removeWhere((c) => c.categoryId == cat.categoryId);
                          } else {
                            controller.selectedCategories.add(cat);
                          }
                        } else if (postSettings == PostSettings.department) {
                          final dept = item as DepartmentData;
                          final exists = controller.selectedDepartments.any((c) => c.departmentId == dept.departmentId);
                          if (exists) {
                            controller.selectedDepartments.removeWhere((c) => c.departmentId == dept.departmentId);
                          } else {
                            controller.selectedDepartments.add(dept);
                          }
                        }
                      },
                      child: GetX<FeedViewController>(
                        builder: (FeedViewController controller) {
                          bool isContains = false;
                          if (postSettings == PostSettings.entity) {
                            isContains = controller.selectedCompanies.any(
                              (company) =>
                                  company.companyId ==
                                  (item as CompanyListData).companyId,
                            );
                          }
                          if (postSettings == PostSettings.location) {
                            isContains = controller.selectedLocations.any(
                              (location) =>
                                  location.locationId ==
                                  (item as LocationData).locationId,
                            );
                          }
                          if (postSettings == PostSettings.category) {
                            isContains = controller.selectedCategories.any(
                              (category) =>
                                  category.categoryId ==
                                  (item as CategoryData).categoryId,
                            );
                          }
                          if (postSettings == PostSettings.department) {
                            isContains = controller.selectedDepartments.any(
                              (department) =>
                                  department.departmentId ==
                                  (item as DepartmentData).departmentId,
                            );
                          }
                          return Container(
                            height: 40.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 15.h),
                            decoration: BoxDecoration(
                              color: appView == AppView.manager ? Color(0xFFF5F5F5) : ColorUtils.letterTypeUnselected,
                              borderRadius: BorderRadius.circular(8.r),
                              border:
                                  isContains
                                      ? Border.all(color: Color(0xFFBFB2FF), width: 1.h)
                                      : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.6) : ColorUtils.textWhite.withValues(alpha: 0.6),
                                    fontSize: 13.h,
                                  ),
                                ),
                                if (isContains)
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.h),
                                    child: Icon(Icons.done, color: appView == AppView.manager ? Color(0xFFBFB2FF) : ColorUtils.textWhite, size: 20.h),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder:
                      (BuildContext context, int index) => SizedBox(height: 10.h),
                ),
              ),
      
            SizedBox(height: 15.h),
            InkWell(
              borderRadius: BorderRadius.circular(37).r,
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Container(
                width: ScreenUtil().screenWidth,
                height: 50.h,
                decoration: BoxDecoration(
                  color: ColorUtils.secondaryBlue,
                  borderRadius: BorderRadius.circular(37).r,
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.h,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
