import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loyaltri_minimal/models/work_entry_list_api_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/color_utils.dart';

class WorkEntryContainerWidget extends StatefulWidget {
  final WorkEntryDetail workEntryDetail;
  const WorkEntryContainerWidget({super.key, required this.workEntryDetail});

  @override
  State<WorkEntryContainerWidget> createState() =>
      _WorkEntryContainerWidgetState();
}

class _WorkEntryContainerWidgetState extends State<WorkEntryContainerWidget> {
  TextEditingController _workNameController = TextEditingController();
  TextEditingController _unitsDoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? location;

  @override
  void initState() {
    _workNameController =
        TextEditingController(text: widget.workEntryDetail.workName);
    _unitsDoneController =
        TextEditingController(text: widget.workEntryDetail.unitCount);
    _descriptionController =
        TextEditingController(text: widget.workEntryDetail.description);
    getLocName();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkEntryContainerWidget oldWidget) {
    _workNameController =
        TextEditingController(text: widget.workEntryDetail.workName);
    _unitsDoneController =
        TextEditingController(text: widget.workEntryDetail.unitCount);
    _descriptionController =
        TextEditingController(text: widget.workEntryDetail.description);
    super.didUpdateWidget(oldWidget);
  }

  Future getLocName() async {
    try {
      var values = jsonDecode(widget.workEntryDetail.location.toString());
      List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(values['latitude']), double.parse(values['longitude']));
      location =
          "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country} - ${placemarks[0].postalCode}";
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5).w,
      child: GestureDetector(
        onTap: () {
          showWorkSheet(mainContext: context);
        },
        child: Container(
          height: 70.w,
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12).w,
            color: ColorUtils.backgroundBlack,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 3, child: Container()),
                Text(
                  '${widget.workEntryDetail.unitCount} units',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: const Color(0xFF747474)),
                ),
                Flexible(flex: 1, child: Container()),
                // SizedBox(
                //   width: ScreenUtil().screenWidth * 0.7,
                //   child: Text(
                //     workEntryDetail.description ?? "",
                //     style: GoogleFonts.inter(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 16.sp,
                //       color: ColorUtils.textWhite,
                //     ),
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: ScreenUtil().screenWidth * 0.7,
                      child: Text(
                        widget.workEntryDetail.workName ?? "",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: ColorUtils.textWhite,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(0xFF747474),
                      size: 18.w,
                    ),
                  ],
                ),
                Flexible(flex: 3, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showWorkSheet({required BuildContext mainContext}) async {
    List<String> attachments = widget.workEntryDetail.attachments ?? [];
    return showModalBottomSheet(
      backgroundColor: ColorUtils.backgroundBlack,
      context: context,
      isScrollControlled: true,
      barrierColor: ColorUtils.workEntryHead,
      isDismissible: false,
      useSafeArea: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return KeyboardAvoider(
          child: SafeArea(
            child: StatefulBuilder(
              builder:
                  (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  width: ScreenUtil().screenWidth,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(15).w,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              // await locationFetchController.resetLoc();
                              // filePath.value = null;
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 48.w,
                              width: 48.w,
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(14).w,
                                border: Border.all(
                                  width: 1.w,
                                  color: const Color(0xFF3F4450),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: 18.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 4),
                          Image.asset(
                            "assets/images/workentry-3d.webp",
                            width: 26.w,
                          ),
                          const Spacer(),
                          Text(
                            "Work Entry",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                          const Spacer(flex: 8),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20).w,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat("dd MMM, yyyy | EEE").format(
                                  DateTime.parse(widget.workEntryDetail.date ??
                                      DateTime.now().toString())),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withOpacity(0.54),
                              ),
                            ),
                          ],
                        ),
                      ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 4).w,
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(12).r,
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13, top: 10).h,
                                      child: Text(
                                        "Work Name",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.h,
                                          color: const Color(0xFFAAAAAA),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13).h,
                                      child: SizedBox(
                                        height: 35.h,
                                        child: TextFormField(
                                          controller: _workNameController,
                                          cursorColor: Colors.grey,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: "Enter Work Name",
                                            hintStyle: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withOpacity(0.2),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.h,
                                            ),
                                            border: InputBorder.none,
                                            // contentPadding: const EdgeInsets.only(
                                            //     left: 10, bottom: 0, top: 0)
                                            //     .h,
                                          ),
                                          style: GoogleFonts.inter(
                                            color: ColorUtils.textWhite,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4).w,
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(12).r,
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13, top: 10).h,
                                      child: Text(
                                        "Units Done",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          color: const Color(0xFFAAAAAA),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13).h,
                                      child: SizedBox(
                                        height: 35.h,
                                        child: TextFormField(
                                          controller: _unitsDoneController,
                                          cursorColor: Colors.grey,
                                          keyboardType: TextInputType.number,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: "Enter Count",
                                            hintStyle: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withOpacity(0.2),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.h,
                                            ),
                                            border: InputBorder.none,
                                            // contentPadding: const EdgeInsets.only(
                                            //     left: 10, bottom: 0, top: 0)
                                            //     .h,
                                          ),
                                          style: GoogleFonts.inter(
                                            color: ColorUtils.textWhite,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 4, bottom: 4).w,
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              constraints: BoxConstraints(minHeight: 70.w),
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(12).w,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.w),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Description",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: const Color(0xFFAAAAAA),
                                      ),
                                    ),
                                    SizedBox(height: 4.w),
                                    TextFormField(
                                      readOnly: true,
                                      controller: _descriptionController,
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Description (Optional)",
                                        hintStyle: GoogleFonts.inter(
                                          color: ColorUtils.textWhite.withOpacity(0.2),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (location != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8).w,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/add_location.webp",
                                    width: 35.w,
                                  ),
                                  SizedBox(width: 10.w),
                                  SizedBox(
                                    width: ScreenUtil().screenWidth * 0.7,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        location ?? "",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: const Color(0xFF5185D8),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if(attachments.isNotEmpty)
                            Container(
                              height: 200.w,
                              child: ListView.separated(
                                itemCount: attachments.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 9).w,
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          await launchUrl(Uri.parse(attachments[index]));
                                        } catch(e) {}
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).w,
                                        decoration: BoxDecoration(
                                          color: ColorUtils.foregroundBlack,
                                          borderRadius: BorderRadius.circular(12).w,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: attachments[index],
                                          errorWidget: (context, url, error) => Container(),
                                          placeholder: (context, url) => Container(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5.w),
                              ),
                            ),
                                        ],
                                        ),
                    ),
                                    ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
