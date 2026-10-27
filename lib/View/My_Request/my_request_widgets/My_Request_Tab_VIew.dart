
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_widgets/My_Excuse_Tab_Button.dart';
import '../../../utils/color_utils.dart';

class MyRequestTabView extends StatefulWidget {
  final Function(int) onTabClick;
  const MyRequestTabView({super.key, required this.onTabClick});

  @override
  State<MyRequestTabView> createState() => _MyRequestTabViewState();
}

class _MyRequestTabViewState extends State<MyRequestTabView> {
  ValueNotifier<int> currentTab = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        // width: 290.w,
        height: 38.h,
        padding: const EdgeInsets.all(2).h,
        decoration: BoxDecoration(
          color: ColorUtils.backgroundBlack,
          borderRadius: BorderRadius.circular(20).r,
          border: Border.all(
            color: const Color(0xFFDEDEDE).withValues(alpha: 0.12),
            width: 1.h,
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(
              valueListenable: currentTab,
              builder: (BuildContext context, value, Widget? child) {
                return MyRequestTabButton(
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
                return MyRequestTabButton(
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
                return MyRequestTabButton(
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
                return MyRequestTabButton(
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
    );
  }
}
