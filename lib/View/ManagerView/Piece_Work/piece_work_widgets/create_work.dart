
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/edit_att_save_button.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_controller/piece_work_controller.dart';
import '../../../../controller/userProfileController.dart';
import '../../../../models/manager/piece_work_model.dart';
import '../../../../utils/color_utils.dart';

class CreatePieceWork extends StatefulWidget {
  final EmployeePiece employeePiece;
  const CreatePieceWork({super.key, required this.employeePiece});

  @override
  State<CreatePieceWork> createState() => _CreatePieceWorkState();
}

class _CreatePieceWorkState extends State<CreatePieceWork> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    Get.find<PieceWorkController>().selectedPiece.value = PieceRate();
    await Get.find<PieceWorkController>().fetchAllPieceRate();
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        PieceWorkController pieceWorkController = Get.find<PieceWorkController>();
        _controller.text = pieceWorkController.selectedPiece.value.code ?? '';
      },
      child: SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Scaffold(
          backgroundColor: ColorUtils.textWhite,
          body: SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 15.h,
              ),
              child: GetX<PieceWorkController>(
                builder: (PieceWorkController pieceWorkController) {
                  final uniqueCode = pieceWorkController.pieceRateList
                      .map((e) => e.code ?? '--')
                      .toSet()
                      .toList();
                  final uniqueUnitName = pieceWorkController.pieceRateList
                      .map((e) => e.unitName ?? '--')
                      .toSet()
                      .toList();
                  final uniqueTypes = pieceWorkController.pieceRateList
                      .map((e) => e.type ?? '--')
                      .toSet()
                      .toList();
                  final uniqueSubType = pieceWorkController.pieceRateList
                      .map((e) => e.subType ?? '--')
                      .toSet()
                      .toList();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 48.h,
                              width: 48.h,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/manager_view/piece_work_icon.png',
                                  height: 24.h,
                                ),
                                SizedBox(width: 5.h),
                                Text(
                                  "Create Work",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.textWhite,
                                  borderRadius: BorderRadius.circular(14).r,
                                  border: Border.all(
                                    width: 1.h,
                                    color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: 20.h,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: Border.all(
                              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                              width: 1.h,
                            ),
                          ),
                          child: Row(
                            children: [
                              // SizedBox(width: 10.h),
                              // SvgPicture.asset(
                              //   'assets/images/manager_view/search_icon_req.svg',
                              //   height: 19.h,
                              // ),
                              SizedBox(width: 10.h),
                              AttendanceCommonWidgets().cachedNetworkImage(
                                widget.employeePiece.employeeImage ?? '--',
                                height: 30.h
                              ),
                              SizedBox(width: 5.h),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.employeePiece.employeeName ?? '--',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.h,
                                        color: ColorUtils.workEntryHead,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' #${widget.employeePiece.employeeCode ?? ''}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.h,
                                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        RawAutocomplete<String>(
                          textEditingController: _controller,
                          focusNode: _focusNode,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return uniqueCode; // show all initially
                            }
                            return uniqueCode.where((option) => option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()));
                          },
                          fieldViewBuilder:
                              (context, textEditingController, focusNode, onFieldSubmitted) {
                            return Container(
                              padding: EdgeInsets.only(top: 18.h),
                              decoration: BoxDecoration(
                                color: ColorUtils.paleLavenderMist,
                                borderRadius: BorderRadius.all(Radius.circular(12).r),
                                border: Border.all(
                                  color: (pieceWorkController.selectedPiece.value.codeValidation != null)
                                      ? Colors.red
                                      : ColorUtils.workEntryHead.withValues(alpha: 0.1),
                                  width: (pieceWorkController.selectedPiece.value.codeValidation != null) ? 1.h : 0.5,
                                ),
                              ),
                              child: TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onChanged: (value) {},
                                onFieldSubmitted: (value) {
                                  if(uniqueCode.contains(value)) {
                                    List<PieceRate> piece = pieceWorkController.pieceRateList.where((p0) => p0.code == value).toList();
                                    if(piece.isNotEmpty) pieceWorkController.selectedPiece.value = piece.first;
                                  } else {
                                    _controller.text = pieceWorkController.selectedPiece.value.code ?? '';
                                  }

                                  if(pieceWorkController.selectedPiece.value.codeValidation != null) {
                                    validation(pieceWorkController);
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12).r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12).r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  fillColor: ColorUtils.paleLavenderMist,
                                  filled: true,
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF9A9A9A),
                                  ),
                                  label: Text(
                                    "Code",
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.h,
                                      color: ColorUtils.obsidianGrey,
                                    ),
                                  ),
                                  hintText: pieceWorkController.selectedPiece.value.code ?? 'Search by Code',
                                  hintStyle: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.h,
                                    color: ColorUtils.workEntryHead.withValues(
                                      alpha: 0.5,
                                    ),
                                    letterSpacing: -0.2,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
                                ),
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: ColorUtils.workEntryHead,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 2,
                                child: SizedBox(
                                  height: 200.h,
                                  width: ScreenUtil().screenWidth * 0.9,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final String option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(
                                          option,
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onTap: () {
                                          onSelected(option);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          onSelected: (String selection) {
                            List<PieceRate> piece = pieceWorkController.pieceRateList.where((p0) => p0.code == selection).toList();
                            if(piece.isNotEmpty) pieceWorkController.selectedPiece.value = piece.first;
                            if(pieceWorkController.selectedPiece.value.codeValidation != null) {
                              validation(pieceWorkController);
                            }
                          },
                        ),
                        if(pieceWorkController.selectedPiece.value.codeValidation != null)
                          validationWidget(pieceWorkController.selectedPiece.value.codeValidation!),
                        SizedBox(height: 10.h),
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: (pieceWorkController.selectedPiece.value.itemValidation != null)
                                ? Border.all(color: Colors.red, width: 1.h)
                            : null,
                          ),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Item Name',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead
                                        .withValues(alpha: 0.5),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                selectedItemBuilder: (context) {
                                  return uniqueUnitName.map((option) {
                                    return Text(
                                      option,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.workEntryHead.withValues(
                                          alpha: 1.0,
                                        ),
                                        letterSpacing: -0.5,
                                      ),
                                    );
                                  }).toList();
                                },
                                items: uniqueUnitName.map(
                                      (option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(
                                      option,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.workEntryHead.withValues(
                                          alpha: 1.0,
                                        ),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                                value: pieceWorkController.selectedPiece.value.unitName,
                                onChanged:
                                    (selectedValue) async {
                                      if(pieceWorkController.selectedPiece.value.unitName == null || pieceWorkController.selectedPiece.value.unitName != selectedValue) {
                                        List<PieceRate> piece = pieceWorkController.pieceRateList.where((p0) => p0.unitName == selectedValue).toList();
                                        if(piece.isNotEmpty) pieceWorkController.selectedPiece.value = piece.first;
                                        _controller.text = pieceWorkController.selectedPiece.value.code ?? '';
                                      }
                                      if(pieceWorkController.selectedPiece.value.itemValidation != null) {
                                        validation(pieceWorkController);
                                      }
                                },
                                iconStyleData: IconStyleData(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF9A9A9A),
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  height: 20.h,
                                  padding: EdgeInsets.only(right: 16.h),
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color: ColorUtils.textWhite,
                                    borderRadius: BorderRadius.circular(8).r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(pieceWorkController.selectedPiece.value.itemValidation != null)
                          validationWidget(pieceWorkController.selectedPiece.value.itemValidation!),
                        SizedBox(height: 10.h),
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: (pieceWorkController.selectedPiece.value.typeValidation != null)
                                ? Border.all(color: Colors.red, width: 1.h)
                                : null,
                          ),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Type',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead
                                        .withValues(alpha: 0.5),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                selectedItemBuilder: (context) {
                                  return uniqueTypes.map((option) {
                                    return Text(
                                      option,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.workEntryHead.withValues(
                                          alpha: 1.0,
                                        ),
                                        letterSpacing: -0.5,
                                      ),
                                    );
                                  }).toList();
                                },
                                items: uniqueTypes.map(
                                      (option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(
                                      option,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.workEntryHead.withValues(
                                          alpha: 1.0,
                                        ),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                                value: pieceWorkController.selectedPiece.value.type,
                                onChanged:
                                    (selectedValue) async {
                                  if(pieceWorkController.selectedPiece.value.type == null || pieceWorkController.selectedPiece.value.type != selectedValue) {
                                    List<PieceRate> piece = pieceWorkController.pieceRateList.where((p0) => p0.type == selectedValue).toList();
                                    if(piece.isNotEmpty) pieceWorkController.selectedPiece.value = piece.first;
                                    _controller.text = pieceWorkController.selectedPiece.value.code ?? '';
                                  }

                                  if(pieceWorkController.selectedPiece.value.typeValidation != null) {
                                    validation(pieceWorkController);
                                  }
                                },
                                iconStyleData: IconStyleData(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF9A9A9A),
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  height: 20.h,
                                  padding: EdgeInsets.only(right: 16.h),
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color: ColorUtils.textWhite,
                                    borderRadius: BorderRadius.circular(8).r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(pieceWorkController.selectedPiece.value.typeValidation != null)
                          validationWidget(pieceWorkController.selectedPiece.value.typeValidation!),
                        SizedBox(height: 10.h),
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: (pieceWorkController.selectedPiece.value.subTypeValidation != null)
                                ? Border.all(color: Colors.red, width: 1.h)
                                : null,
                          ),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Sub Type',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead
                                        .withValues(alpha: 0.5),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                selectedItemBuilder: (context) {
                                  return uniqueSubType.map((option) {
                                    return Text(
                                      option,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.workEntryHead.withValues(
                                          alpha: 1.0,
                                        ),
                                        letterSpacing: -0.5,
                                      ),
                                    );
                                  }).toList();
                                },
                                items: uniqueSubType.map(
                                      (option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(
                                      option,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.workEntryHead.withValues(
                                          alpha: 1.0,
                                        ),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                                value: pieceWorkController.selectedPiece.value.subType,
                                onChanged:
                                    (selectedValue) async {
                                      if(pieceWorkController.selectedPiece.value.subType == null || pieceWorkController.selectedPiece.value.subType != selectedValue) {
                                        List<PieceRate> piece = pieceWorkController.pieceRateList.where((p0) => p0.subType == selectedValue).toList();
                                        if(piece.isNotEmpty) pieceWorkController.selectedPiece.value = piece.first;
                                        _controller.text = pieceWorkController.selectedPiece.value.code ?? '';
                                      }

                                      if(pieceWorkController.selectedPiece.value.subTypeValidation != null) {
                                        validation(pieceWorkController);
                                      }
                                },
                                iconStyleData: IconStyleData(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF9A9A9A),
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  height: 20.h,
                                  padding: EdgeInsets.only(right: 16.h),
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color: ColorUtils.textWhite,
                                    borderRadius: BorderRadius.circular(8).r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(pieceWorkController.selectedPiece.value.subTypeValidation != null)
                          validationWidget(pieceWorkController.selectedPiece.value.subTypeValidation!),
                        SizedBox(height: 10.h),
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 48.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.circular(12).r,
                            border: (pieceWorkController.selectedPiece.value.rateValidation != null)
                                ? Border.all(color: Colors.red, width: 1.h)
                                : null,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-'}${pieceWorkController.selectedPiece.value.ratePerUnit ?? '0'}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.h,
                              color: ColorUtils.workEntryHead.withValues(
                                alpha: 1.0,
                              ),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        if(pieceWorkController.selectedPiece.value.rateValidation != null)
                          validationWidget(pieceWorkController.selectedPiece.value.rateValidation!),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.only(top: 18.h),
                          decoration: BoxDecoration(
                            color: ColorUtils.paleLavenderMist,
                            borderRadius: BorderRadius.all(Radius.circular(12).r),
                            border: (pieceWorkController.selectedPiece.value.unitValidation != null)
                                ? Border.all(color: Colors.red, width: 1.h)
                                : null,
                          ),
                          child: TextFormField(
                            controller: _unitController,
                            onChanged: (value) {
                              _unitController.text = value;
                              if(value.isEmpty) {
                                pieceWorkController.selectedPiece.value.unitCount = null;
                                pieceWorkController.selectedPiece.value.totalAmount = null;
                              } else {
                                pieceWorkController.selectedPiece.value.unitCount = int.parse(value);
                                if(pieceWorkController.selectedPiece.value.ratePerUnit != null) {
                                  pieceWorkController.selectedPiece.value.totalAmount = (double.parse(value) * double.parse(pieceWorkController.selectedPiece.value.ratePerUnit ?? '0.0')).toString();
                                }
                              }
                              pieceWorkController.selectedPiece.refresh();
                            },
                            onTap: () {},
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12).r,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12).r,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              fillColor: ColorUtils.paleLavenderMist,
                              filled: true,
                              label: Text(
                                "Unit",
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.h,
                                  color: ColorUtils.obsidianGrey,
                                ),
                              ),
                              hintText: 'Enter unit',
                              hintStyle: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.h,
                                color: ColorUtils.workEntryHead.withValues(
                                  alpha: 0.5,
                                ),
                                letterSpacing: -0.2,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
                            ),
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.h,
                              color: ColorUtils.workEntryHead,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        if(pieceWorkController.selectedPiece.value.unitValidation != null)
                          validationWidget(pieceWorkController.selectedPiece.value.unitValidation!),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            SizedBox(width: 10.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                  ),
                                ),
                                Text.rich(
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-'} ',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.steelBlue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: pieceWorkController.selectedPiece.value.totalAmount ?? '0',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 75.h,
            decoration: BoxDecoration(
              color: ColorUtils.textWhite,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFB9B8FF).withValues(alpha: 0.18),
                  offset: Offset(0, -18),
                  blurRadius: 31,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12).h,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(37).r,
                      onTap: () async {
                        PieceWorkController pieceWorkController = Get.find<PieceWorkController>();
                        validation(pieceWorkController);
                        if(isValid(pieceWorkController) && !pieceWorkController.pieceWorkSavingMore.value) {
                          bool success = await pieceWorkController.addPieceWork(
                              createFor: widget.employeePiece.employeeId,
                            addMore: true,
                          );
                          if(success) {
                            _controller.clear();
                            _unitController.clear();
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(1).h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(37).r,
                          color: ColorUtils.ashGrey,
                        ),
                        child: GetX<PieceWorkController>(
                          builder: (PieceWorkController pieceWorkController) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36).r,
                                color: ColorUtils.textWhite,
                              ),
                              child: pieceWorkController.pieceWorkSavingMore.value
                                  ? Center(
                                child: SizedBox(
                                  width: 20.h,
                                  height: 20.h,
                                  child: Center(
                                    child: CircularProgressIndicator(color: ColorUtils.secondaryBlue, strokeWidth: 3.h),
                                  ),
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/manager_view/fine_add.svg',
                                    colorFilter: ColorFilter.mode(
                                        ColorUtils.secondaryBlue,
                                        BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 5.h),
                                  Text(
                                    'Add More',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.h,
                                      color: ColorUtils.secondaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(37).r,
                      onTap: () async {
                        PieceWorkController pieceWorkController = Get.find<PieceWorkController>();
                        validation(pieceWorkController);
                        if(isValid(pieceWorkController) && !pieceWorkController.pieceWorkSaving.value) {
                          bool success = await pieceWorkController.addPieceWork(
                              createFor: widget.employeePiece.employeeId,
                            addMore: false,
                          );
                          if(success) {
                            _controller.clear();
                            _unitController.clear();
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: GetX<PieceWorkController>(
                        builder: (PieceWorkController pieceWorkController) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(37).r,
                              color: ColorUtils.secondaryBlue,
                            ),
                            child: pieceWorkController.pieceWorkSaving.value
                                ? Center(
                              child: SizedBox(
                                width: 20.h,
                                height: 20.h,
                                child: Center(
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.h),
                                ),
                              ),
                            )
                                : Text(
                              'Save & Close',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.code == null) {
      pieceWorkController.selectedPiece.value.codeValidation = 'Code is required';
    } else {
      pieceWorkController.selectedPiece.value.codeValidation = null;
    }
    if(pieceWorkController.selectedPiece.value.unitName == null) {
      pieceWorkController.selectedPiece.value.itemValidation = 'Item Name is required';
    } else {
      pieceWorkController.selectedPiece.value.itemValidation = null;
    }
    if(pieceWorkController.selectedPiece.value.type == null) {
      pieceWorkController.selectedPiece.value.typeValidation = 'Type is required';
    } else {
      pieceWorkController.selectedPiece.value.typeValidation = null;
    }
    if(pieceWorkController.selectedPiece.value.subType == null) {
      pieceWorkController.selectedPiece.value.subTypeValidation = 'Sub Type is required';
    } else {
      pieceWorkController.selectedPiece.value.subTypeValidation = null;
    }
    if(pieceWorkController.selectedPiece.value.unitCount == null) {
      pieceWorkController.selectedPiece.value.unitValidation = 'Unit is required';
    } else if(pieceWorkController.selectedPiece.value.unitCount! <= 0) {
      pieceWorkController.selectedPiece.value.unitValidation = 'Units must be greater than 0';
    } else {
      pieceWorkController.selectedPiece.value.unitValidation = null;
    }
    if(pieceWorkController.selectedPiece.value.ratePerUnit == null) {
      pieceWorkController.selectedPiece.value.rateValidation = 'Rate must be greater than 0';
    } else if(double.parse(pieceWorkController.selectedPiece.value.ratePerUnit?.toString() ?? '0.0') <= 0.0) {
      pieceWorkController.selectedPiece.value.rateValidation = 'Rate must be greater than 0';
    } else {
      pieceWorkController.selectedPiece.value.rateValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  bool isValid(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.codeValidation == null &&
        pieceWorkController.selectedPiece.value.itemValidation == null &&
        pieceWorkController.selectedPiece.value.typeValidation == null &&
        pieceWorkController.selectedPiece.value.subTypeValidation == null &&
        pieceWorkController.selectedPiece.value.unitValidation == null &&
        pieceWorkController.selectedPiece.value.rateValidation == null) {
      return true;
    }
    return false;
  }

  void codeValidation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.code == null) {
      pieceWorkController.selectedPiece.value.codeValidation = 'Code is required';
    } else {
      pieceWorkController.selectedPiece.value.codeValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  void itemValidation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.unitName == null) {
      pieceWorkController.selectedPiece.value.itemValidation = 'Item Name is required';
    } else {
      pieceWorkController.selectedPiece.value.itemValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  void typeValidation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.type == null) {
      pieceWorkController.selectedPiece.value.typeValidation = 'Type is required';
    } else {
      pieceWorkController.selectedPiece.value.typeValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  void subTypeValidation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.subType == null) {
      pieceWorkController.selectedPiece.value.subTypeValidation = 'Sub Type is required';
    } else {
      pieceWorkController.selectedPiece.value.subTypeValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  void unitValidation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.unitCount == null) {
      pieceWorkController.selectedPiece.value.unitValidation = 'Unit is required';
    } else if(pieceWorkController.selectedPiece.value.unitCount! <= 0) {
      pieceWorkController.selectedPiece.value.unitValidation = 'Units must be greater than 0';
    } else {
      pieceWorkController.selectedPiece.value.unitValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  void rateValidation(PieceWorkController pieceWorkController) {
    if(pieceWorkController.selectedPiece.value.ratePerUnit == null) {
      pieceWorkController.selectedPiece.value.rateValidation = 'Rate is required';
    } else if(pieceWorkController.selectedPiece.value.unitCount! <= 0) {
      pieceWorkController.selectedPiece.value.rateValidation = 'Rate must be greater than 0';
    } else {
      pieceWorkController.selectedPiece.value.rateValidation = null;
    }
    pieceWorkController.selectedPiece.refresh();
  }

  Widget validationWidget(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        children: [
          SizedBox(width: 5.h),
          Text(
            message,
            style: GoogleFonts.dmSans(
              color: Colors.red,
              fontSize: 13.h,
            ),
          ),
        ],
      ),
    );
  }
}
