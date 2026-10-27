import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_tab_button.dart';

import '../../../utils/color_utils.dart';

class LeaveTabView extends StatefulWidget {
  final Function(int) onTabClick;
  final int? selectedTab;
  const LeaveTabView({super.key, required this.onTabClick, this.selectedTab});

  @override
  State<LeaveTabView> createState() => _LeaveTabViewState();
}

class _LeaveTabViewState extends State<LeaveTabView> {
  late ValueNotifier<int> currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = ValueNotifier(widget.selectedTab ?? 0);
  }

  @override
  void didUpdateWidget(covariant LeaveTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTab != null && widget.selectedTab != currentTab.value) {
      currentTab.value = widget.selectedTab!;
    }
  }

  @override
  void dispose() {
    currentTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 280.w,
          // height: 37.w,
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
                    return LeaveTabButton(
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
                    return LeaveTabButton(
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
                    return LeaveTabButton(
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
        ),
      ],
    );
  }
}
