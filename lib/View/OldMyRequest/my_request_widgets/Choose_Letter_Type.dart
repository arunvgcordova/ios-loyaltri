
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';
import '../../CWidgets/app_bar.dart';

class ChooseLetterType extends StatefulWidget {
  final String selectedValue;
  final Function(String) setSelectedValue;
  const ChooseLetterType({super.key, required this.selectedValue, required this.setSelectedValue});

  @override
  State<ChooseLetterType> createState() => _ChooseLetterTypeState();
}

class _ChooseLetterTypeState extends State<ChooseLetterType> {
  ValueNotifier<String> selectedType = ValueNotifier("");

  @override
  void initState() {
    selectedType = ValueNotifier(widget.selectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (_) {
          widget.setSelectedValue(selectedType.value);
        },
        child: Scaffold(
          backgroundColor: ColorUtils.workEntryHead,
          extendBody: true,
          body: Padding(
            padding: const EdgeInsets.only(top: 8).w,
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80).w,
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        const CustomAppBar(
                          title: "Select Letter Types",
                          isActionVisible: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0).w,
                          child: InkWell(
                            onTap: () {
                              widget.setSelectedValue(selectedType.value);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: Container(
                        height: ScreenUtil().screenHeight,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 300).w,
                          child: Column(
                            children: [
                              for(int i = 0; i < letterTypes.length; i++)
                                InkWell(
                                  onTap: () {
                                    selectedType.value = letterTypes[i];
                                    widget.setSelectedValue(selectedType.value);
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).pop();
                                  },
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  child: ValueListenableBuilder(
                                    valueListenable: selectedType,
                                    builder: (BuildContext context, value, Widget? child) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0).w,
                                        child: Container(
                                          width: ScreenUtil().screenWidth,
                                          height: 40.w,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(horizontal: 8).w,
                                          decoration: BoxDecoration(
                                            color: value == letterTypes[i] ? ColorUtils.secondaryBlue : ColorUtils.letterTypeUnselected,
                                            borderRadius: BorderRadius.circular(8.0).w,
                                          ),
                                          child: Text(
                                            letterTypes[i],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                              color: value == letterTypes[i] ? ColorUtils.textWhite : ColorUtils.textWhite.withOpacity(0.6),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
            ),
          ),
        ),
      ),
    );
  }
}

List<String> letterTypes = [
  "Relieving Letter",
  "Salary Certificate",
  "Employment Verification Letter",
  "Appointment Letter",
  "Promotion Letter",
  "Transfer Letter",
  "Offer Letter",
];
