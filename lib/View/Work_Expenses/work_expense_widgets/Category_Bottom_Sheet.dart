
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import '../../../controller/work_expence_controller.dart';
import '../../../models/expense_category_model.dart';
import '../../../utils/color_utils.dart';


class CategoryBottomSheet extends StatelessWidget {
  final Function(Category) selectedCategory;
  const CategoryBottomSheet({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: ScreenUtil().screenWidth,
          // height: 320.w,
          decoration: BoxDecoration(
            color: ColorUtils.backgroundBlack,
            borderRadius: BorderRadius.circular(20).w,
            border: Border.all(
              width: 1.w,
              color: const Color(0xFF404040),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Choose Category",
                    style: GoogleFonts.poppins(
                      color: ColorUtils.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 12.w),
                  Obx(() {
                    WorkExpenseController workExpenseController = Get.find<WorkExpenseController>();
                    HomeController homeController = Get.find<HomeController>();
                    List<Category> categoryList = workExpenseController.workExpenseCategoryList;
                    if((homeController.isLoading.value && categoryList.isEmpty) || workExpenseController.expCatLoading.value) {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: 200.w,
                        ),
                        child: Center(
                          child: SpinKitThreeInOut(
                            color: ColorUtils.primaryBlue,
                            size: 28.h,
                          ),
                        ),
                      );
                    }
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: 500.w,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for(int i = 0; i < categoryList.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10).w,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    selectedCategory(categoryList[i]);
                                  },
                                  child: Container(
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F1E23),
                                      borderRadius: BorderRadius.circular(8).w,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10).w,
                                          child: Text(
                                            categoryList[i].categoryName ?? '--',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                    // return ListView.builder(
                    //   itemCount: categoryList.length,
                    //   itemBuilder: (context, index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(bottom: 10).w,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           Navigator.of(context).pop();
                    //           selectedCategory(categoryList[index].categoryName ?? '--');
                    //         },
                    //         child: Container(
                    //           height: 40.w,
                    //           decoration: BoxDecoration(
                    //             color: const Color(0xFF1F1E23),
                    //             borderRadius: BorderRadius.circular(8).w,
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 10).w,
                    //                 child: Text(
                    //                   categoryList[index].categoryName ?? '--',
                    //                   style: GoogleFonts.poppins(
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 14.sp,
                    //                     color: ColorUtils.textWhite,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
