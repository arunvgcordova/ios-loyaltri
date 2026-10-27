import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_tab_button.dart';

import '../../../utils/color_utils.dart';
import 'My_Excuse_Tab_Button.dart';

class MyExcuseTabView extends StatefulWidget {
  final Function(int) onTabClick;
  const MyExcuseTabView({super.key, required this.onTabClick});

  @override
  State<MyExcuseTabView> createState() => _MyExcuseTabViewState();
}

class _MyExcuseTabViewState extends State<MyExcuseTabView> {
  ValueNotifier<int> currentTab = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 330.w,
          // height: 40.w,
          padding: const EdgeInsets.all(3).w,
          decoration: BoxDecoration(
            color: ColorUtils.backgroundBlack,
            borderRadius: BorderRadius.circular(20).w,
            border: Border.all(
              color: const Color(0xFFDEDEDE).withOpacity(0.12),
              width: 1.w,
            ),
          ),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
