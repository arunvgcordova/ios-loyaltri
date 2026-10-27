import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/shift_scheduler_controller/shift_scheduler_controller.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_scheme.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_department.dart';

class _FilterItem {
  final String name;
  dynamic id;
  bool isSelected;

  _FilterItem({required this.name, this.id, this.isSelected = false});
}

class _FilterCategory {
  final String title;
  final List<_FilterItem> items;
  final bool multiSelect;

  _FilterCategory({
    required this.title,
    required this.items,
    this.multiSelect = true,
  });
}

class ShiftSchedulerFilterScreen extends StatefulWidget {
  const ShiftSchedulerFilterScreen({super.key});

  @override
  State<ShiftSchedulerFilterScreen> createState() => _ShiftSchedulerFilterScreenState();
}

class _ShiftSchedulerFilterScreenState extends State<ShiftSchedulerFilterScreen> {
  late ShiftSchedulerController controller;
  late List<_FilterCategory> _filters;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ShiftSchedulerController>();

    List<_FilterItem> schemeItems = controller.shiftSchemes.map((scheme) {
      bool isSelected = controller.selectedSchemes.any((s) => s.shiftSchemeId == scheme.shiftSchemeId);
      return _FilterItem(name: scheme.shiftScheme ?? '', id: scheme.shiftSchemeId, isSelected: isSelected);
    }).toList();

    List<_FilterItem> depItems = controller.departments.map((dep) {
      bool isSelected = controller.selectedDepartments.any((d) => d.departmentId == dep.departmentId);
      return _FilterItem(name: dep.department ?? '', id: dep.departmentId, isSelected: isSelected);
    }).toList();
    _filters = [
      // _FilterCategory(
      //   title: "By Status",
      //   items: [
      //     _FilterItem(name: "Unassigned", isSelected: true),
      //     _FilterItem(name: "Assigned"),
      //   ],
      // ),
      _FilterCategory(
        title: "Shift Schemes",
        items: schemeItems,
        multiSelect: true,
      ),
      _FilterCategory(
        title: "Department",
        items: depItems,
        multiSelect: true,
      ),
      // _FilterCategory(
      //   title: "Location",
      //   items: [
      //     _FilterItem(name: "Dubai"),
      //     _FilterItem(name: "Ajman"),
      //     _FilterItem(name: "Sharjah", isSelected: true),
      //     _FilterItem(name: "Abudabi"),
      //   ],
      // ),
      // _FilterCategory(
      //   title: "Category",
      //   items: [
      //     _FilterItem(name: "Sales"),
      //     _FilterItem(name: "Marketing"),
      //   ],
      // ),
    ];
  }

  void _toggleItem(_FilterCategory category, int itemIndex) {
    setState(() {
      if (!category.multiSelect) {
        for (var i = 0; i < category.items.length; i++) {
          category.items[i].isSelected = (i == itemIndex);
        }
      } else {
        // Prevent deselecting the last selected item in Shift Schemes
        if (category.title == "Shift Schemes" &&
            category.items[itemIndex].isSelected) {
          int selectedCount = category.items.where((i) => i.isSelected).length;
          if (selectedCount <= 1) return;
        }
        category.items[itemIndex].isSelected = !category.items[itemIndex].isSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(ScreenUtil().screenWidth, 0),
          child: Container(),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 25.h, left: 20.w, right: 20.w),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 44.h), // Spacer for center alignment
                    Text(
                      "Sort and Filter",
                      style: GoogleFonts.inter(
                        fontSize: 15.h,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.h,
                        width: 44.h,
                        decoration: BoxDecoration(
                          color: ColorUtils.softLavenderBlue.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12).r,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 20.h,
                            color: ColorUtils.secondaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Categories
                Expanded(
                  child: ListView.builder(
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final category = _filters[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 25.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.33.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 9.w,
                              runSpacing: 10.h,
                              children: List.generate(
                                category.items.length,
                                (itemIndex) {
                                  final item = category.items[itemIndex];
                                  return GestureDetector(
                                    onTap: () => _toggleItem(category, itemIndex),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.isSelected ? ColorUtils.secondaryBlue : ColorUtils.textWhite,
                                        borderRadius: BorderRadius.circular(9).r,
                                        border: Border.all(
                                          color: item.isSelected ? ColorUtils.secondaryBlue : ColorUtils.platinum,
                                          width: 1.h,
                                        ),
                                      ),
                                      child: Text(
                                        item.name,
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.42.h,
                                          color: item.isSelected ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: ColorUtils.textWhite
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(17).r,
                onTap: () {
                  var schemeCategory = _filters.firstWhere((c) => c.title == "Shift Schemes");
                  var depCategory = _filters.firstWhere((c) => c.title == "Department");
                  
                  List<ShiftSchemeData> selectedSchemes = [];
                  for (var item in schemeCategory.items.where((i) => i.isSelected)) {
                    var scheme = controller.shiftSchemes.firstWhereOrNull((s) => s.shiftSchemeId == item.id);
                    if (scheme != null) {
                      selectedSchemes.add(scheme);
                    }
                  }

                  List<DepartmentData> selectedDeps = [];
                  for (var item in depCategory.items.where((i) => i.isSelected)) {
                    var dep = controller.departments.firstWhereOrNull((d) => d.departmentId == item.id);
                    if (dep != null) {
                      selectedDeps.add(dep);
                    }
                  }

                  controller.updateFiltersAndFetch(selectedSchemes, selectedDeps);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.secondaryBlue,
                    borderRadius: BorderRadius.circular(17).r,
                  ),
                  child: Center(
                    child: Text(
                      "Show Results",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.h,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
