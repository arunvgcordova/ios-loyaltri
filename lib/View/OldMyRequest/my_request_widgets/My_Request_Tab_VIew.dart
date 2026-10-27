
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/color_utils.dart';
import 'My_Excuse_Tab_Button.dart';

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
    return Row(
      children: [
        Container(
          // width: 290.w,
          height: 38.w,
          padding: const EdgeInsets.all(3).w,
          decoration: BoxDecoration(
            color: ColorUtils.backgroundBlack,
            borderRadius: BorderRadius.circular(20).w,
            border: Border.all(
              color: const Color(0xFFDEDEDE).withOpacity(0.12),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ],
            ),
        ),
      ],
    );
  }
}
