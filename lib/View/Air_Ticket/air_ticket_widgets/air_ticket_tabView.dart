import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/services/ui_model_services/leave_tab_model.dart';
import '../../../utils/color_utils.dart';

class AirTicketTabView extends StatefulWidget {
  final Function(int) onTabClick;
  const AirTicketTabView({super.key, required this.onTabClick});

  @override
  State<AirTicketTabView> createState() => _AirTicketTabViewState();
}

class _AirTicketTabViewState extends State<AirTicketTabView> {
  ValueNotifier<int> currentTab = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            // width: 330.w,
            height: 40.h,
            padding: const EdgeInsets.all(3).h,
            decoration: BoxDecoration(
              color: ColorUtils.foregroundBlack,
              borderRadius: BorderRadius.circular(20).r,
              border: Border.all(
                color: const Color(0xFFDEDEDE).withValues(alpha: 0.12),
                width: 1.h,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                  valueListenable: currentTab,
                  builder: (BuildContext context, value, Widget? child) {
                    return MyExcuseTabButton(
                      tabId: 0,
                      onButtonClick: (int clickedTab) {
                        currentTab.value = clickedTab;
                        widget.onTabClick(clickedTab);
                      },
                      tabValue: value,
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: currentTab,
                  builder: (BuildContext context, value, Widget? child) {
                    return MyExcuseTabButton(
                      tabId: 1,
                      onButtonClick: (int clickedTab) {
                        currentTab.value = clickedTab;
                        widget.onTabClick(clickedTab);
                      },
                      tabValue: value,
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: currentTab,
                  builder: (BuildContext context, value, Widget? child) {
                    return MyExcuseTabButton(
                      tabId: 2,
                      onButtonClick: (int clickedTab) {
                        currentTab.value = clickedTab;
                        widget.onTabClick(clickedTab);
                      },
                      tabValue: value,
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: currentTab,
                  builder: (BuildContext context, value, Widget? child) {
                    return MyExcuseTabButton(
                      tabId: 3,
                      onButtonClick: (int clickedTab) {
                        currentTab.value = clickedTab;
                        widget.onTabClick(clickedTab);
                      },
                      tabValue: value,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyExcuseTabButton extends StatelessWidget {
  final int tabId;
  final int tabValue;
  final Function(int) onButtonClick;
  const MyExcuseTabButton(
      {super.key,
        required this.tabId,
        required this.onButtonClick,
        required this.tabValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onButtonClick(airTicketTabItem[tabId].id);
      },
      child: Container(
        // height: 31.h,
        // width: 88.w,
        padding: EdgeInsets.symmetric(horizontal: airTicketTabItem[tabId].id == 0 ? 16 : 14).h,
        decoration: BoxDecoration(
          color: tabValue == tabId
              ? ColorUtils.backgroundBlack
              : ColorUtils.foregroundBlack,
          borderRadius: BorderRadius.circular(22).r,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(airTicketTabItem[tabId].id != 0)
                Container(
                  width: 10.h,
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50).r,
                    color: airTicketTabItem[tabId].color,
                  ),
                ),
              if(airTicketTabItem[tabId].id != 0)
                SizedBox(width: 5.h),
              Text(
                airTicketTabItem[tabId].title,
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
