import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/View/field/features/form/controller/work_form_controller.dart';
import 'package:loyaltri_minimal/View/field/features/form/widget/otp_widget.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/attachment.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/drop_down.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/location_search_textfield.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/multi_choise.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/text_field.dart';
import 'package:loyaltri_minimal/View/field/features/work_completed/work_completed_screen.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';
import '../../core/colour_utils.dart';
import '../widgets/signature_pad.dart';

class WorkFormScreen extends StatefulWidget {
  const WorkFormScreen({
    super.key,
    required this.workTypeId,
    required this.workDetail,
    required this.selectedDate,
    required this.workid,
    required this.workInstanceId,
  });

  final String workTypeId;
  final String workid;
  final WorkData? workDetail;
  final DateTime selectedDate;
  final int? workInstanceId;

  @override
  State<WorkFormScreen> createState() => _WorkFormScreenState();
}

class _WorkFormScreenState extends State<WorkFormScreen> {
  late WorkFormController controller;

  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> textControllers = {};
  final Map<String, dynamic> formValues = {};
  double? _selectedLat;
  double? _selectedLng;
  bool _isUploadingAttachments = false;

  // String _selectedCustomer = 'Arun';
  // final List<String> _customers = ['Arun', 'Aneesh', 'Nithin', 'Aju'];

  // String _installationType = 'Split AC Installation';
  // final List<String> _installationTypes = [
  //   'Split AC Installation',
  //   'Window AC Installation',
  //   'Central AC Service',
  //   'Duct Inspection',
  // ];

  final _serialController = TextEditingController();
  final _pressureController = TextEditingController();
  final _dateController = TextEditingController(text: '2026-06-11');

  // OTP Fields
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  String _generatedOtp = '';
  bool _isOtpVerified = false;
  bool _hasOtpError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = Get.put(WorkFormController());
    controller.fetchWorkFormDetail(
      id: widget.workTypeId,
      workInstanceId: widget.workInstanceId.toString(),
    );
  }

  @override
  void dispose() {
    Get.delete<WorkFormController>();
    _serialController.dispose();
    _pressureController.dispose();
    _dateController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _generateOtp() {
    setState(() {
      // Simulate generating a 4-digit OTP
      _generatedOtp = '4826';
      _isOtpVerified = false;
      _hasOtpError = false;
      for (var controller in _otpControllers) {
        controller.clear();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.sms_outlined, color: Colors.white),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'Simulated SMS: Your verification OTP is $_generatedOtp',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: ColourUtils.primary,
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'AUTOFILL',
          textColor: Colors.white,
          onPressed: () {
            for (int i = 0; i < 4; i++) {
              _otpControllers[i].text = _generatedOtp[i];
            }
            _checkOtp();
          },
        ),
      ),
    );
  }

  void _checkOtp() {
    String enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length == 4) {
      if (enteredOtp == _generatedOtp) {
        setState(() {
          _isOtpVerified = true;
          _hasOtpError = false;
        });
        FocusScope.of(context).unfocus();
      } else {
        setState(() {
          _isOtpVerified = false;
          _hasOtpError = true;
        });
      }
    } else {
      setState(() {
        _isOtpVerified = false;
        _hasOtpError = false;
      });
    }
  }

  void _submitForm() async {
    if (controller.isSubmitting.value) return;

    if (_isUploadingAttachments) {
      AttendanceCommonWidgets().showSnackBar(
        context: context,
        backgroundColor: Colors.orange,
        message: 'Please wait for attachments to finish uploading.',
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // if(controller.workFromDetail.value?.data?.isOtpRequired == true){
      //   if (controller.OtpOverrideDetail.value?.data?.otpOverride?.status ==
      //         null ||
      //     controller.OtpOverrideDetail.value?.data?.otpOverride?.status ==
      //         "pending") {
      //   AttendanceCommonWidgets().showSnackBar(
      //     context: context,
      //     message: 'Please Complete OTP.',
      //     backgroundColor: Colors.redAccent,
      //   );
      //   return;
      // }
      // }

      if (controller.workFromDetail.value?.data?.isOtpRequired == true) {
        final bool isOtpVerified = controller.isOtpVerified.value;
        final bool isOverrideApproved =
            controller.OtpOverrideDetail.value?.data?.otpOverride?.status ==
            "approved";

        if (!isOtpVerified && !isOverrideApproved) {
          AttendanceCommonWidgets().showSnackBar(
            context: context,
            message: 'Please Complete OTP.',
            backgroundColor: Colors.redAccent,
          );
          return;
        }
      }

      final bool success = await controller.submitWork(
        context: context,
        workId: int.tryParse(widget.workid) ?? 0,
        workInstanceId: widget.workInstanceId == null
            ? controller.getWorkInstanceId(
                widget.workDetail?.instances,
                widget.selectedDate,
              )
            : widget.workInstanceId ?? 0,
        data: formValues,
      );

      if (success) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => WorkCompletedScreen(workid: widget.workid),
            ),
          );
        } else {
          Get.to(() => WorkCompletedScreen(workid: widget.workid));
        }
      }
    }
  }

  TextEditingController getController(String key, {String? initialValue}) {
    if (!textControllers.containsKey(key)) {
      textControllers[key] = TextEditingController(text: initialValue ?? '');

      if (initialValue != null && initialValue.isNotEmpty) {
        formValues[key] = initialValue;
      }
    }

    return textControllers[key]!;
  }

  void saveValue(String key, dynamic value) {
    formValues[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourUtils.background,
      appBar: AppBarWidget(title: 'Work Type Form'),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: RefreshIndicator(
            onRefresh: () async {
              controller.fetchWorkFormDetail(
                id: widget.workTypeId,
                workInstanceId: widget.workInstanceId.toString(),
              );
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetX<WorkFormController>(
                    builder: (controller) {
                      if (controller.isloading.value) {
                        return SizedBox(
                          height: 500.h,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (controller.workFromDetail.value == null) {
                        return SizedBox(
                          height: 500.h,
                          child: Center(
                            child: Text(
                              'No form found',
                              style: GoogleFonts.inter(
                                color: ColourUtils.textMuted,
                                fontSize: 14.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Installation Visit Report',
                                  style: GoogleFonts.inter(
                                    color: ColourUtils.textWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.h,
                                  ),
                                ),
                                Text(
                                  'Fill out the form to submit your work',
                                  style: GoogleFonts.inter(
                                    color: ColourUtils.textWhite.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    controller
                                            .workFromDetail
                                            .value
                                            ?.data
                                            ?.templateFields
                                            ?.length ??
                                        0,
                                    (index) {
                                      final field = controller
                                          .workFromDetail
                                          .value
                                          ?.data
                                          ?.templateFields?[index];

                                      final key =
                                          field?.fieldKey ?? "field_$index";
                                      if (field?.fieldType == "text") {
                                        return CustomTextField(
                                          controller: getController(key),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          keyboardType: TextInputType.text,
                                          validator: field?.isRequired == true
                                              ? (v) => v?.isEmpty == true
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                          onChanged: (value) {
                                            saveValue(key, value);
                                          },
                                        );
                                      } else if (field?.fieldType == "number") {
                                        return CustomTextField(
                                          controller: getController(key),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          keyboardType: TextInputType.number,
                                          validator: field?.isRequired == true
                                              ? (v) => v?.isEmpty == true
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                          onChanged: (value) {
                                            saveValue(key, value);
                                          },
                                        );
                                      } else if (field?.fieldType ==
                                          "customer") {
                                        return CustomeDropdownSearch<
                                          CustomerData
                                        >(
                                          label: "Customer",
                                          hintText: "Select a customer",
                                          items: () async {
                                            return await controller
                                                .fetchCustomerList();
                                          },
                                          itemAsString: (item) =>
                                              item.name ?? "",
                                          compareFn: (a, b) =>
                                              a.dynamicFields?.name ==
                                              b.dynamicFields?.name,
                                          onSelected: (value) {
                                            saveValue(
                                              key,
                                              value?.id.toString(),
                                            );
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return "Please select customer";
                                            }
                                            return null;
                                          },
                                        );
                                      } else if (field?.fieldType == "date") {
                                        return CustomTextField(
                                          controller: getController(
                                            key,
                                            initialValue: DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(DateTime.now()),
                                          ),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          icon: 'calendar',
                                          isSuffix: true,
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime?
                                            date = await showDatePicker(
                                              context: context,
                                              // initialDate: DateTime(2026, 6, 12),
                                              initialDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                              ),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2030),
                                            );
                                            if (date != null) {
                                              // setState(() {
                                              getController(key).text = date
                                                  .toString()
                                                  .split(' ')[0];
                                              // });
                                              saveValue(
                                                key,
                                                date.toString().split(' ')[0],
                                              );
                                            }
                                          },
                                          validator: field?.isRequired == true
                                              ? (v) => v?.isEmpty == true
                                                    ? 'Please select date'
                                                    : null
                                              : null,
                                        );
                                      } else if (field?.fieldType == "time") {
                                        return CustomTextField(
                                          controller: getController(
                                            key,
                                            initialValue: "9:00 AM",
                                          ),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          icon: 'clock',
                                          isSuffix: true,
                                          readOnly: true,
                                          onTap: () async {
                                            TimeOfDay? time =
                                                await showTimePicker(
                                                  context: context,
                                                  initialTime: const TimeOfDay(
                                                    hour: 9,
                                                    minute: 0,
                                                  ),
                                                );
                                            if (time != null) {
                                              // setState(() {
                                              getController(key).text = time
                                                  .format(context);
                                              saveValue(
                                                key,
                                                time.format(context),
                                              );
                                              // });
                                            }
                                          },
                                          validator: field?.isRequired == true
                                              ? (v) => v?.isEmpty == true
                                                    ? 'Please select time'
                                                    : null
                                              : null,
                                        );
                                      } else if (field?.fieldType ==
                                          "dropdown") {
                                        return CustomDropdownField(
                                          label: field?.fieldLabel ?? "",
                                          // value: field?.values?.first ?? "",
                                          value: formValues[key],
                                          hint: field?.placeholder ?? "",
                                          // icon: 'gps',
                                          items: field?.values ?? [],
                                          onChanged: (value) {
                                            saveValue(key, value);
                                          },
                                          validator: field?.isRequired == true
                                              ? (v) => v == null || v.isEmpty
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                        );
                                      } else if (field?.fieldType ==
                                          "dropdown-multi") {
                                        return MultiChoiseWidget(
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          items: field?.values ?? [],
                                          initialSelectedItems:
                                              List<String>.from(
                                                formValues[key] ?? [],
                                              ),
                                          onChanged: (values) {
                                            saveValue(key, values);
                                          },
                                          validator: field?.isRequired == true
                                              ? (v) => v!.isEmpty
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                        );
                                      } else if (field?.fieldType == "email") {
                                        return CustomTextField(
                                          controller: getController(key),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          keyboardType: TextInputType.text,
                                          validator: field?.isRequired == true
                                              ? (v) => v!.isEmpty
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                          onChanged: (value) {
                                            saveValue(key, value);
                                          },
                                        );
                                      } else if (field?.fieldType ==
                                          "location") {
                                        return LocationAutocompleteTextField(
                                          controller: getController(key),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          icon: 'gps',
                                          validator: field?.isRequired == true
                                              ? (v) => v!.isEmpty
                                                    ? 'Please enter site address'
                                                    : null
                                              : null,
                                          onSelectionCleared: () {
                                            saveValue(key, null);
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            saveValue(
                                              key,
                                              suggestion["description"],
                                            );
                                            // final lat = double.tryParse(
                                            //   suggestion['lat']?.toString() ??
                                            //       '',
                                            // );
                                            // final lng = double.tryParse(
                                            //   (suggestion['lng'] ??
                                            //               suggestion['lon'])
                                            //           ?.toString() ??
                                            //       '',
                                            // );

                                            // saveValue(key, {
                                            //   "lat": lat,
                                            //   "lng": lng,
                                            // });

                                            // print("dsdsads --- ${suggestion}");
                                            // setState(() {
                                            //   _selectedLat = double.tryParse(
                                            //     suggestion['lat']?.toString() ?? '',
                                            //   );
                                            //   _selectedLng = double.tryParse(
                                            //     (suggestion['lng'] ?? suggestion['lon'])
                                            //             ?.toString() ??
                                            //         '',
                                            //   );
                                            //   _locationController.text =
                                            //       suggestion["locationName"];
                                            // });
                                          },
                                        );
                                      } else if (field?.fieldType == "file") {
                                        return CustomAttachmentWidget(
                                          type: field?.fieldType ?? "file",
                                          title: field?.fieldLabel ?? "",
                                          subtitle1: field?.placeholder ?? "",
                                          // subtitle2: field?.isRequired == true
                                          //     ? 'Required for completion'
                                          //     : '',
                                          subtitle2: 'File size up to 10 MB',
                                          icon: 'camera',
                                          onPathsChanged: (paths) {
                                            saveValue(key, paths);
                                          },
                                          onUploadingStateChanged:
                                              (isUploading) {
                                                setState(() {
                                                  _isUploadingAttachments =
                                                      isUploading;
                                                });
                                              },
                                        );
                                        // return CustomAttachmentWidget(
                                        //   title: field?.fieldLabel ?? "",
                                        //   subtitle1: field?.placeholder ?? "",
                                        //   subtitle2: field?.isRequired == true
                                        //       ? 'Required for completion'
                                        //       : '',
                                        //   icon: 'camera',
                                        // );
                                      } else if (field?.fieldType == "image") {
                                        return CustomAttachmentWidget(
                                          type: field?.fieldType ?? "image",
                                          title: field?.fieldLabel ?? "",
                                          subtitle1: field?.placeholder ?? "",
                                          // subtitle2: field?.isRequired == true
                                          //     ? 'Required for completion'
                                          //     : '',
                                          subtitle2: 'File size up to 10 MB',
                                          icon: 'camera',
                                          onPathsChanged: (paths) {
                                            saveValue(key, paths);
                                          },
                                          onUploadingStateChanged:
                                              (isUploading) {
                                                setState(() {
                                                  _isUploadingAttachments =
                                                      isUploading;
                                                });
                                              },
                                        );
                                        // return CustomAttachmentWidget(
                                        //   title: field?.fieldLabel ?? "",
                                        //   subtitle1: field?.placeholder ?? "",
                                        //   subtitle2: field?.isRequired == true
                                        //       ? 'Required for completion'
                                        //       : '',
                                        //   icon: 'camera',
                                        // );
                                      } else if (field?.fieldType == "video") {
                                        return CustomAttachmentWidget(
                                          type: field?.fieldType ?? "video",
                                          title: field?.fieldLabel ?? "",
                                          subtitle1: field?.placeholder ?? "",
                                          // subtitle2: field?.isRequired == true
                                          //     ? 'Required for completion'
                                          //     : '',
                                          subtitle2: 'File size up to 10 MB',
                                          icon: 'camera',
                                          onPathsChanged: (paths) {
                                            saveValue(key, paths);
                                          },
                                          onUploadingStateChanged:
                                              (isUploading) {
                                                setState(() {
                                                  _isUploadingAttachments =
                                                      isUploading;
                                                });
                                              },
                                        );
                                        // return CustomAttachmentWidget(
                                        //   title: field?.fieldLabel ?? "",
                                        //   subtitle1: field?.placeholder ?? "",
                                        //   subtitle2: field?.isRequired == true
                                        //       ? 'Required for completion'
                                        //       : '',
                                        //   icon: 'camera',
                                        // );
                                      } else if (field?.fieldType ==
                                          "textarea") {
                                        return CustomTextField(
                                          controller: getController(key),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          keyboardType: TextInputType.text,
                                          validator: field?.isRequired == true
                                              ? (v) => v!.isEmpty
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                          onChanged: (value) {
                                            saveValue(key, value);
                                          },
                                          maxLines: 4,
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ),
                                // SIGNATURE BLOCK
                                controller
                                            .workFromDetail
                                            .value
                                            ?.data
                                            ?.isSignatureRequired ==
                                        true
                                    ? const SignaturePad(title: 'Signature')
                                    : SizedBox(),
                                // SizedBox(height: 10.h),

                                // OTP VERIFICATION
                                controller
                                            .workFromDetail
                                            .value
                                            ?.data
                                            ?.isOtpRequired ==
                                        true
                                    ? OtpWidget(
                                        otpData: controller
                                            .OtpOverrideDetail
                                            .value
                                            ?.data
                                            ?.otpOverride,
                                        workInstanceId:
                                            widget.workInstanceId ?? 0,
                                        workId: int.parse(widget.workid),
                                        workTypeId: widget.workTypeId,
                                      )
                                    : SizedBox(),

                                // SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                          _buildFooterActions(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColourUtils.cardBackground,
        border: Border(
          top: BorderSide(color: ColourUtils.border, width: 1.5.h),
        ),
      ),
      child: Obx(() {
        final isSubmitting = controller.isSubmitting.value;

        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46.h,
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: ColourUtils.border,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    foregroundColor: ColourUtils.textMain,
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 46.h,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColourUtils.primary,
                    disabledBackgroundColor: ColourUtils.primary,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: isSubmitting
                      ? Center(
                          child: SizedBox(
                            width: 22.h,
                            height: 22.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          'Submit Work',
                          style: GoogleFonts.inter(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
