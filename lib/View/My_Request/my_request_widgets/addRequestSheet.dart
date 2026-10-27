
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/My_Request/controller/my_request_controller.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/request_creation.dart';

import '../../../models/special_reuest_type_model.dart';
import '../../../utils/color_utils.dart';
import '../My_request.dart';

class AddRequestSheet extends StatefulWidget {
  const AddRequestSheet({super.key});

  @override
  State<AddRequestSheet> createState() => _AddRequestSheetState();
}

class _AddRequestSheetState extends State<AddRequestSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 15.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(14).r,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 48.h,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.backgroundBlack,
                      borderRadius: BorderRadius.circular(14).r,
                      border: Border.all(
                        color: ColorUtils.charcoalBlue,
                        width: 1.h,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: ColorUtils.textWhite,
                        size: 22.h,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Add New Request',
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                  ),
                ),
                Container(
                  width: 48.h,
                  height: 48.h,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          Expanded(
              child: GetX<MyRequestControllerNew>(
                builder: (MyRequestControllerNew controller) {
                  return ListView.builder(
                    itemCount: controller.moduleReqList.value.length,
                    padding: EdgeInsets.only(
                      left: 15.h,
                      right: 15.h,
                      top: 12.h,
                    ),
                    itemBuilder: (context, index) {
                      ModuleListData requestType = controller.moduleReqList.value[index];
                      return NewReqCategoryView(title: requestType.requestModule ?? '--', reqList: requestType.requestList ?? []);
                          },
                  );
                }
              ),
          ),
          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 15.h,
          //     ),
          //     children: [
          //       SizedBox(height: 12.h),
          //       for(int i = 0; i < RequestDoc.requests.length; i++)
          //         if(RequestDoc.requests[i].name == 'HR')
          //           NewReqCategoryView(title: RequestDoc.requests[i].name, reqList: RequestDoc.hrRequests)
          //         else if(RequestDoc.requests[i].name == 'Finance')
          //           NewReqCategoryView(title: RequestDoc.requests[i].name, reqList: RequestDoc.financeRequests)
          //         else if(RequestDoc.requests[i].name == 'Other')
          //           NewReqCategoryView(title: RequestDoc.requests[i].name, reqList: RequestDoc.otherRequests),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class NewReqCategoryView extends StatelessWidget {
  final String title;
  final List<RequestList> reqList;
  const NewReqCategoryView({super.key, required this.title, required this.reqList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.foregroundBlack,
          borderRadius: BorderRadius.circular(10).r,
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 17.h,
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.h,
                      color: ColorUtils.textWhite.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            for(int j = 0; j < reqList.length; j++)
              Padding(
                padding: EdgeInsets.only(
                  left: 8.h,
                  right: 8.h,
                  bottom: (reqList.length - 1) != j ? 8.h : 0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8).r,
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.of(context).push(
                        newSlideNavigation(RequestCreation(requestItem: reqList[j])),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 13.h,
                      horizontal: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorUtils.letterTypeUnselected,
                      borderRadius: BorderRadius.circular(8).r,
                    ),
                    child: Row(
                      children: [
                        Text(
                          reqList[j].specialRequestType ?? '--',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}


class RequestDoc {
  final RequestCategory category;
  final String name;
  RequestDoc({required this.category, required this.name});

  static List<RequestDoc> requests = [
    RequestDoc(
        category: RequestCategory.hr,
        name: 'HR',
    ),
    RequestDoc(
        category: RequestCategory.finance,
        name: 'Finance',
    ),
    RequestDoc(
        category: RequestCategory.other,
        name: 'Other',
    ),
  ];

  static List<RequestItem> hrRequests = [
    RequestItem.letter,
    RequestItem.remote,
    RequestItem.shiftSwap,
    RequestItem.attendance,
    RequestItem.resignation
  ];

  static List<RequestItem> financeRequests = [
    RequestItem.salaryAdvance,
    RequestItem.loan
  ];

  static List<RequestItem> otherRequests = [
    RequestItem.it,
    RequestItem.workPlaceRelated,
    RequestItem.other
  ];

  static String getRequestName(RequestItem type) {
    switch(type) {
      case RequestItem.letter : return 'Letter Request';
      case RequestItem.remote : return 'Remote/On duty Request';
      case RequestItem.shiftSwap : return 'Shift Swap Request';
      case RequestItem.attendance : return 'Attendance Request';
      case RequestItem.resignation : return 'Resignation';
      case RequestItem.salaryAdvance : return 'Salary Advance';
      case RequestItem.loan : return 'Loan Request';
      case RequestItem.it : return 'IT Request';
      case RequestItem.workPlaceRelated : return 'Work Place Related';
      case RequestItem.other : return 'Other';
    }
  }
}
