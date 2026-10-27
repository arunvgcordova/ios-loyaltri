import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/customer_form/controller/customer_form_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/attachment.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/drop_down.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/filled_button.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/location_search_textfield.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/multi_choise.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/text_field.dart';
import '../../core/colour_utils.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, dynamic> formValues = {};
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController mobileCtr = TextEditingController();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController locationCtr = TextEditingController();
  String? locationName;
  Map<String, dynamic>? location;
  bool _isUploadingAttachments = false;
  final ValueNotifier<bool> _isFetchingLocation = ValueNotifier<bool>(false);
  double? _selectedLat;
  double? _selectedLng;
  late CustomerFormController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(CustomerFormController());
    controller.getcustomerTemplate();
  }

  @override
  void dispose() {
    nameCtr.dispose();
    mobileCtr.dispose();
    emailCtr.dispose();
    locationCtr.dispose();
    _isFetchingLocation.dispose();
    for (var c in textControllers.values) {
      c.dispose();
    }
    Get.delete<CustomerFormController>();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    if (_isFetchingLocation.value) return;
    _isFetchingLocation.value = true;

    final locData = await controller.getCurrentDeviceLocation();
    if (locData != null) {
      final double lat = locData["lat"];
      final double lng = locData["lng"];
      final String addr = locData["address"];

      _selectedLat = lat;
      _selectedLng = lng;
      locationName = addr;
      locationCtr.text = addr;
      location = {
        "lat": lat,
        "lng": lng,
      };
      _isFetchingLocation.value = false;
    } else {
      _isFetchingLocation.value = false;
      if (mounted) {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message:
              'Failed to determine your location. Please check GPS and try again.',
        );
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
      appBar: AppBarWidget(title: 'Add Customer'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: RefreshIndicator(
            onRefresh: () async {
              controller.getcustomerTemplate();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetX<CustomerFormController>(
                    builder: (controller) {
                      if (controller.isloading.value) {
                        return SizedBox(
                          height: 500.h,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (controller.customerTemplateData.value ==
                          null) {
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
                                CustomTextField(
                                  controller: nameCtr,
                                  label: "Name",
                                  hint: 'Enter name',
                                  keyboardType: TextInputType.text,
                                  validator: (v) => v?.isEmpty == true
                                      ? 'This field is required.'
                                      : null,
                                  onChanged: (value) {},
                                ),
                                CustomTextField(
                                  controller: mobileCtr,
                                  label: "Phone Number",
                                  hint: 'Enter number',
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v?.isEmpty == true
                                      ? 'This field is required.'
                                      : null,
                                  onChanged: (value) {},
                                ),
                                CustomTextField(
                                  controller: emailCtr,
                                  label: "Email",
                                  hint: 'Enter email',
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {},
                                ),
                                LocationAutocompleteTextField(
                                  controller: locationCtr,
                                  label: 'Location Name',
                                  hint: 'Enter Location',
                                  icon: 'gps',
                                  labelTrailing: ValueListenableBuilder<bool>(
                                    valueListenable: _isFetchingLocation,
                                    builder: (context, isFetching, child) {
                                      return GestureDetector(
                                        onTap: _useCurrentLocation,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.h,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6A4BFC),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isFetching)
                                                SizedBox(
                                                  height: 12.h,
                                                  width: 12.h,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                              else
                                                svgWidget(
                                                  icon: 'gps',
                                                  height: 14.h,
                                                  width: 14.h,
                                                  color: Colors.white,
                                                ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                'Use current location',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  validator: (v) => v!.isEmpty
                                      ? 'Please enter site address'
                                      : null,
                                  onSelectionCleared: () {
                                    locationName = null;
                                    location = null;
                                    _selectedLat = null;
                                    _selectedLng = null;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    locationName = suggestion["description"];
                                    final lat = double.tryParse(
                                      suggestion['lat']?.toString() ?? '',
                                    );
                                    final lng = double.tryParse(
                                      (suggestion['lng'] ??
                                                  suggestion['lon'])
                                              ?.toString() ??
                                          '',
                                    );
                                    locationCtr.text =
                                        suggestion["description"] ?? '';
                                    location = {
                                      "lat": lat,
                                      "lng": lng,
                                    };
                                    _selectedLat = lat;
                                    _selectedLng = lng;
                                  },
                                ),
                                
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    controller
                                            .customerTemplateData
                                            .value
                                            ?.data
                                            ?.length ??
                                        0,
                                    (index) {
                                      final field = controller
                                          .customerTemplateData
                                          .value
                                          ?.data?[index];

                                      final key =
                                          field?.fieldKey ?? "field_$index";
                                      if (field?.fieldType == "text") {
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
                                      } else if (field?.fieldType == "number") {
                                        return CustomTextField(
                                          controller: getController(key),
                                          label: field?.fieldLabel ?? "",
                                          hint: field?.placeholder ?? "",
                                          keyboardType: TextInputType.number,
                                          validator: field?.isRequired == true
                                              ? (v) => v!.isEmpty
                                                    ? 'This field is required.'
                                                    : null
                                              : null,
                                          onChanged: (value) {
                                            saveValue(key, value);
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
                                              ? (v) => v!.isEmpty
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
                                              ? (v) => v!.isEmpty
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
                                              ? (v) => v!.isEmpty
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
                                          validator: (v) => v!.isEmpty
                                              ? 'Please enter site address'
                                              : null,
                                          onSelectionCleared: () {
                                            saveValue(key, null);
                                            saveValue("location", null);
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            saveValue(
                                              key,
                                              suggestion["description"],
                                            );

                                            // print("dsdsads --- ${suggestion}");

                                            final lat = double.tryParse(
                                              suggestion['lat']?.toString() ??
                                                  '',
                                            );
                                            final lng = double.tryParse(
                                              (suggestion['lng'] ??
                                                          suggestion['lon'])
                                                      ?.toString() ??
                                                  '',
                                            );

                                            saveValue("location", {
                                              "lat": lat,
                                              "lng": lng,
                                            });
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
                                                _isUploadingAttachments =
                                                    isUploading;
                                              },
                                        );
                                      }else if (field?.fieldType == "image") {
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
                                                _isUploadingAttachments =
                                                    isUploading;
                                              },
                                        );
                                      }else if (field?.fieldType == "video") {
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
                                                _isUploadingAttachments =
                                                    isUploading;
                                              },
                                        );
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
                                // SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                          // _buildFooterActions(),
                          _buildFormActions(),
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

  Widget _buildFormActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(color: ColourUtils.bgColour3),
      child: Row(
        children: [
          FillButtonWidget(
            label: 'Submit',
            function: () {
              if (_isUploadingAttachments) {
                AttendanceCommonWidgets().showSnackBar(
                  context: context,
                  backgroundColor: Colors.orange,
                  message: 'Please wait for attachments to finish uploading.',
                );
                return;
              }
              AttendanceCommonWidgets().printF("Data ------------------------- $formValues ");
              if (_formKey.currentState!.validate()) {
                controller.addCustomer(context: context, data: formValues,name: nameCtr.text,number: mobileCtr.text,email:emailCtr.text,locationName: locationName,location: location);
              }
            },
          ),
        ],
      ),
    );
  }
}
