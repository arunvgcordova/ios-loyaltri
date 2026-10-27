import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/features/form/controller/work_form_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/filled_button.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/text_field.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/controller/work_details_controller.dart';

class GeofenceOverrideRequestDialog extends StatefulWidget {
  final int workid;
  final int? workInstanceId;

  const GeofenceOverrideRequestDialog({
    super.key,
    required this.workid,
    this.workInstanceId,
  });

  @override
  State<GeofenceOverrideRequestDialog> createState() => _GeofenceOverrideRequestDialogState();
}

class _GeofenceOverrideRequestDialogState extends State<GeofenceOverrideRequestDialog> {
  late final TextEditingController noteCtr;

  @override
  void initState() {
    super.initState();
    noteCtr = TextEditingController();
  }

  @override
  void dispose() {
    noteCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkDetailController>();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColourUtils.bgColour14,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.h),
            topRight: Radius.circular(15.h),
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Request Geofence Override',
                    style: GoogleFonts.inter(
                      color: ColourUtils.textWhite,
                      fontSize: 16.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_rounded, size: 20.h,color: ColourUtils.textWhite,),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                'This request will be sent to the owner for approval. Override will be allowed only after approval.',
                style: GoogleFonts.inter(
                  color: ColourUtils.textWhite.withValues(alpha: 0.6),
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 15.h),
              CustomTextField(
                controller: noteCtr,
                label: "Reason for override",
                hint: "Explain why geofence verification should be overridden...",
                keyboardType: TextInputType.text,
                validator: (v) => v!.isEmpty ? 'This field is required.' : null,
                onChanged: (value) {},
                maxLines: 4,
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  FillButtonWidget(
                    label: 'Send Request',
                    function: () {
                      if (noteCtr.text.isEmpty) {
                        AttendanceCommonWidgets().showSnackBar(
                          context: context,
                          backgroundColor: Colors.red,
                          message: "Please Enter note",
                        );
                      } else {
                        controller.GeofenceOverrideRequeste(
                          context: context,
                          workId: widget.workid,
                          workInstanceId: widget.workInstanceId ?? 0,
                          note: noteCtr.text,
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: ColourUtils.fontColour1,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
