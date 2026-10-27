import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/add_work_log/controller/add_work_controller.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/attachment.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/drop_down.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/location_search_textfield.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/text_field.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_type_response.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../core/colour_utils.dart';
import '../../core/utils.dart';

class AddWorkScreen extends StatefulWidget {
  const AddWorkScreen({super.key});

  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  int? _workTypeId;
  int? _customerId;
  CustomerData? _selectedCustomer;
  final RxnString _selectedCustomerLocation = RxnString();
  String _selectedLocationType = 'customer'; // 'customer' | 'current' | 'search'
  String _priority = 'Medium'; // Low, Medium, High
  DateTime? _selectedDate;
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _otpEnable = false;
  bool _geofenceRequired = false;
  List<String> _uploadedAttachmentPaths = [];
  bool _isUploadingAttachments = false;
  double? _selectedLat;
  double? _selectedLng;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  final RxBool _canStartWork = false.obs;

  void _updateCanStartWork() {
    _canStartWork.value = _checkCanStartWork();
  }

  bool _checkCanStartWork() {
    if (_selectedDate == null || _selectedStartTime == null) return false;
    final now = DateTime.now();
    final isToday = _selectedDate!.year == now.year &&
        _selectedDate!.month == now.month &&
        _selectedDate!.day == now.day;
    if (!isToday) return false;

    final selectedStartDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedStartTime!.hour,
      _selectedStartTime!.minute,
    );

    if (selectedStartDateTime.isAfter(now)) return false;

    // If GPS is required, user must have selected current location
    if (_geofenceRequired && _selectedLocationType != 'current') {
      return false;
    }

    return true;
  }

  late AddWorkLogController controller;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => AddWorkLogController());
    controller = Get.find<AddWorkLogController>();
  }

  @override
  void dispose() {
    Get.delete<AddWorkLogController>();
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColourUtils.background,
        appBar: AppBarWidget(title: 'Add Work'),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // WORK TITLE
                  CustomTextField(
                    controller: _titleController,
                    label: 'Work Title',
                    hint: 'e.g., AC Commissioning',
                    validator: (v) =>
                    v!.isEmpty ? 'Please enter work title' : null,
                  ),
                  // FORM TYPE
                  CustomeDropdownSearch<WorkTypeData>(
                    label: "Work Type",
                    hintText: "Select a type",
                    items: () async {
                      return await Get.find<AddWorkLogController>()
                          .fetchWorktype();
                    },
                    itemAsString: (item) => item.name ?? "",
                    compareFn: (a, b) => a.name == b.name,
                    onSelected: (value) {
                      _workTypeId = value?.id;
                      _otpEnable = value?.isGpsRequired ?? false;
                      _geofenceRequired = value?.isGpsRequired ?? false;
                      _updateCanStartWork();
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select work type";
                      }
                      return null;
                    },
                  ),
                  // SELECT CLIENT (SEARCH ICON)
                  CustomeDropdownSearch<CustomerData>(
                    label: "Customer",
                    hintText: "Select a customer",
                    items: () async {
                      return await Get.find<AddWorkLogController>()
                          .fetchCustomerList();
                    },
                    itemAsString: (item) => item.name ?? "",
                    compareFn: (a, b) => a.name == b.name,
                    onSelected: (value) {
                      _selectedCustomer = value;
                      _customerId = value?.id;
                      final locName = value?.locationName ??
                          value?.dynamicFields?.locationName;
                      _selectedCustomerLocation.value = locName;

                      final custLat = value?.location?.lat ??
                          value?.dynamicFields?.location?.lat;
                      final custLng = value?.location?.lng ??
                          value?.dynamicFields?.location?.lng;

                      if (locName != null && locName.isNotEmpty) {
                        _locationController.text = locName;
                      }
                      _selectedLat = custLat;
                      _selectedLng = custLng;
                      _selectedLocationType = 'customer';
                      _updateCanStartWork();
                    },
                    bottomWidget: Obx(() {
                      final loc = _selectedCustomerLocation.value;
                      if (loc == null || loc.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            svgWidget(
                              icon: 'gps',
                              height: 14.h,
                              width: 14.h,
                              color: ColourUtils.textWhite
                                  .withValues(alpha: 0.6),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                loc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: ColourUtils.textWhite
                                      .withValues(alpha: 0.6),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    validator: (value) {
                      if (value == null) {
                        return "Please select customer";
                      }
                      return null;
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColourUtils.bgColour2,
                      borderRadius: BorderRadius.all(Radius.circular(15.h)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PRIORITY SEGMENT CONTROL
                          Text(
                            'Priority Level',
                            style: GoogleFonts.inter(
                              color: ColourUtils.textWhite,
                              fontSize: 13.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _buildPriorityControl(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: _dateController,
                    label: 'Date',
                    labelTrailing: GestureDetector(
                      onTap: () {
                        final now = DateTime.now();
                        _selectedDate = now;
                        _dateController.text =
                            DateFormat('MM/dd/yyyy').format(now);
                        _selectedStartTime = TimeOfDay.fromDateTime(now);
                        _selectedEndTime = TimeOfDay.fromDateTime(
                          now.add(const Duration(hours: 1)),
                        );
                        _startTimeController.text =
                            _selectedStartTime!.format(context);
                        _endTimeController.text =
                            _selectedEndTime!.format(context);
                        _updateCanStartWork();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.h,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A4BFC),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            svgWidget(
                              icon: 'clock',
                              height: 14.h,
                              width: 14.h,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              'Use current date & time',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    hint: 'mm/dd/yyyy',
                    icon: 'calendar',
                    isSuffix: true,
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        _selectedDate = date;
                        _dateController.text =
                            DateFormat('MM/dd/yyyy').format(date);
                        _startTimeController.clear();
                        _endTimeController.clear();
                        _selectedStartTime = null;
                        _selectedEndTime = null;
                        _updateCanStartWork();
                      }
                    },
                    validator: (v) =>
                    v!.isEmpty ? 'Please select date' : null,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _startTimeController,
                          label: 'Start Time',
                          hint: 'Select time',
                          icon: 'clock',
                          isSuffix: true,
                          readOnly: true,
                          onTap: () async {
                            if (_dateController.text.isEmpty ||
                                _selectedDate == null) {
                              AttendanceCommonWidgets().showSnackBar(
                                context: context,
                                message: 'Please select a date first.',
                                backgroundColor: Colors.orangeAccent,
                              );
                              return;
                            }

                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime:
                              _selectedStartTime ??
                                  const TimeOfDay(hour: 9, minute: 0),
                            );
                            if (time != null) {
                              final date = _selectedDate!;
                              final now = DateTime.now();
                              final selectedStartDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                              final currentTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                now.hour,
                                now.minute,
                              );
                              if (selectedStartDateTime.isBefore(currentTime)) {
                                AttendanceCommonWidgets().showSnackBar(
                                  context: context,
                                  message:
                                  'Start time cannot be in the past.',
                                  backgroundColor: Colors.redAccent,
                                );
                                return;
                              }

                              if (_selectedEndTime != null) {
                                final selectedEndDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  _selectedEndTime!.hour,
                                  _selectedEndTime!.minute,
                                );
                                if (selectedStartDateTime.isAfter(
                                  selectedEndDateTime,
                                ) ||
                                    selectedStartDateTime
                                        .isAtSameMomentAs(
                                      selectedEndDateTime,
                                    )) {
                                  AttendanceCommonWidgets().showSnackBar(
                                    context: context,
                                    message:
                                    'Start time must be before end time.',
                                    backgroundColor: Colors.redAccent,
                                  );
                                  return;
                                }
                              }

                              _selectedStartTime = time;
                              _startTimeController.text = time.format(
                                context,
                              );
                              _updateCanStartWork();
                            }
                          },
                          validator: (v) =>
                          v!.isEmpty ? 'Start time' : null,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomTextField(
                          controller: _endTimeController,
                          label: 'End Time',
                          hint: 'Select time',
                          icon: 'clock',
                          isSuffix: true,
                          readOnly: true,
                          onTap: () async {
                            if (_dateController.text.isEmpty ||
                                _selectedDate == null) {
                              AttendanceCommonWidgets().showSnackBar(
                                context: context,
                                message: 'Please select a date first.',
                                backgroundColor: Colors.orangeAccent,
                              );
                              return;
                            }
                            if (_startTimeController.text.isEmpty ||
                                _selectedStartTime == null) {
                              AttendanceCommonWidgets().showSnackBar(
                                context: context,
                                message: 'Please select start time first.',
                                backgroundColor: Colors.orangeAccent,
                              );
                              return;
                            }

                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime:
                              _selectedEndTime ??
                                  const TimeOfDay(hour: 11, minute: 0),
                            );
                            if (time != null) {
                              final date = _selectedDate!;
                              final now = DateTime.now();
                              final selectedEndDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                              if (selectedEndDateTime.isBefore(now)) {
                                AttendanceCommonWidgets().showSnackBar(
                                  context: context,
                                  message:
                                  'End time cannot be in the past.',
                                  backgroundColor: Colors.redAccent,
                                );
                                return;
                              }

                              final selectedStartDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                _selectedStartTime!.hour,
                                _selectedStartTime!.minute,
                              );
                              if (selectedEndDateTime.isBefore(
                                selectedStartDateTime,
                              ) ||
                                  selectedEndDateTime.isAtSameMomentAs(
                                    selectedStartDateTime,
                                  )) {
                                AttendanceCommonWidgets().showSnackBar(
                                  context: context,
                                  message:
                                  'End time must be after start time.',
                                  backgroundColor: Colors.redAccent,
                                );
                                return;
                              }

                              _selectedEndTime = time;
                              _endTimeController.text = time.format(
                                context,
                              );
                              _updateCanStartWork();
                            }
                          },
                          validator: (v) => v!.isEmpty ? 'End time' : null,
                        ),
                      ),
                    ],
                  ),
                  LocationAutocompleteTextField(
                    controller: _locationController,
                    label: 'Work Location',
                    hint: 'e.g., Sector 25, Gurgaon',
                    icon: 'gps',
                    validator: (v) =>
                    v!.isEmpty ? 'Please enter site address' : null,
                    onChangeTap: () {
                      _showChangeLocationBottomSheet(context);
                    },
                    onSelectionCleared: () {
                      _selectedLat = null;
                      _selectedLng = null;
                      _selectedLocationType = '';
                      _updateCanStartWork();
                    },
                    onSuggestionSelected: (suggestion) {
                      _selectedLat = double.tryParse(
                        suggestion['lat']?.toString() ?? '',
                      );
                      _selectedLng = double.tryParse(
                        (suggestion['lng'] ?? suggestion['lon'])
                                ?.toString() ??
                            '',
                      );
                      _locationController.text =
                          suggestion["locationName"] ?? '';
                      _selectedLocationType = 'search';
                      _updateCanStartWork();
                    },
                  ),

                  // INSTRUCTIONS
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Detailed note for the work...',
                    maxLines: 3,
                  ),

                  CustomAttachmentWidget(
                    type: "file",
                    title: 'Supporting Document',
                    subtitle1: 'Tap to upload or browse',
                    subtitle2: 'File size up to 10 MB',
                    icon: 'camera',
                    onPathsChanged: (paths) {
                      setState(() {
                        _uploadedAttachmentPaths = paths;
                      });
                    },
                    onUploadingStateChanged: (isUploading) {
                      setState(() {
                        _isUploadingAttachments = isUploading;
                      });
                    },
                  ),
                  // Bottom Action Buttons
                  _buildFormActions(),
                  // CustomAttachmentWidget(
                  //   title: 'Supporting Document',
                  //   subtitle1: 'Tap to upload or browse',
                  //   subtitle2: 'File size up to 10 MB',
                  //   icon: 'camera',
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeLocationBottomSheet(BuildContext context) {
    final controller = Get.find<AddWorkLogController>();
    final customerLocName = _selectedCustomer?.locationName;
    final customerLat = _selectedCustomer?.location?.lat;
    final customerLng = _selectedCustomer?.location?.lng;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorUtils.backgroundBlack,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      useSafeArea: true,
      builder: (modalContext) {
        String tempLocationType = _selectedLocationType;

        String chosenLocName = _locationController.text;
        double? chosenLat = _selectedLat;
        double? chosenLng = _selectedLng;

        bool isFetchingCurrentLoc = false;
        String? currentLocAddress;
        double? currentLat;
        double? currentLng;

        final TextEditingController searchController = TextEditingController();
        final FocusNode searchFocusNode = FocusNode();
        List<dynamic> searchSuggestions = [];
        bool isSearching = false;
        Timer? searchDebounce;

        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> fetchCurrentLocation() async {
              setModalState(() {
                isFetchingCurrentLoc = true;
                tempLocationType = 'current';
              });

              final locData = await controller.getCurrentDeviceLocation();
              if (locData != null) {
                final double lat = locData["lat"];
                final double lng = locData["lng"];
                final String addr = locData["address"];

                setModalState(() {
                  currentLat = lat;
                  currentLng = lng;
                  currentLocAddress = addr;
                  isFetchingCurrentLoc = false;

                  chosenLocName = addr;
                  chosenLat = lat;
                  chosenLng = lng;
                });
              } else {
                setModalState(() {
                  isFetchingCurrentLoc = false;
                });
              }
            }

            Future<void> fetchSearchSuggestions(String query) async {
              if (query.trim().length < 3) {
                setModalState(() {
                  searchSuggestions = [];
                  isSearching = false;
                });
                return;
              }

              setModalState(() {
                isSearching = true;
              });

              final predictions = await controller.fetchPlacesAutocomplete(query);
              setModalState(() {
                searchSuggestions = predictions;
                isSearching = false;
              });
            }

            Future<Map<String, double>?> fetchPlaceDetails(String placeId) async {
              return await controller.fetchPlaceDetails(placeId);
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Drag Handle Bar
                        Center(
                          child: Container(
                            width: 40.h,
                            height: 4.h,
                            margin: EdgeInsets.only(bottom: 20.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),

                        // Header Row: Title & Close Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Change work location',
                              style: GoogleFonts.inter(
                                color: ColourUtils.textWhite,
                                fontSize: 16.1.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(modalContext),
                              child: Container(
                                width: 38.4.h,
                                height: 38.4.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF1C1D23),
                                  border: Border.all(
                                    color: ColorUtils.charcoalBlue,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: ColourUtils.textWhite,
                                    size: 18.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // OPTION 1: Customer Address Card
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempLocationType = 'customer';
                              chosenLocName = customerLocName ?? '';
                              chosenLat = customerLat;
                              chosenLng = customerLng;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: tempLocationType == 'customer'
                                  ? const Color(0xFF211F26)
                                  : Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: tempLocationType == 'customer'
                                    ? const Color(0xFFC1B4FF)
                                    : const Color(0xFFC1B4FF).withValues(alpha: 0.1),
                                width: 1.h,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/manager_view/task_location_icon.svg',
                                  colorFilter: ColorFilter.mode(const Color(0xFFC1B4FF), BlendMode.srcIn),
                                  height: 22.h,
                                ),
                                SizedBox(width: 14.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Customer address',
                                        style: GoogleFonts.inter(
                                          color: ColourUtils.textWhite,
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        customerLocName != null &&
                                                customerLocName.trim().isNotEmpty
                                            ? customerLocName
                                            : 'No customer address available',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          color: ColourUtils.textWhite
                                              .withValues(alpha: 0.5),
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // OPTION 2: My Current Location Card
                        GestureDetector(
                          onTap: () {
                            if (currentLocAddress != null &&
                                currentLat != null) {
                              setModalState(() {
                                tempLocationType = 'current';
                                chosenLocName = currentLocAddress!;
                                chosenLat = currentLat;
                                chosenLng = currentLng;
                              });
                            } else {
                              fetchCurrentLocation();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: tempLocationType == 'current'
                                  ? const Color(0xFF211F26)
                                  : Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: tempLocationType == 'current'
                                    ? const Color(0xFFC1B4FF)
                                    : const Color(0xFFC1B4FF).withValues(alpha: 0.1),
                                width: 1.h,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/location-att-details.svg',
                                  colorFilter: ColorFilter.mode(const Color(0xFFC1B4FF), BlendMode.srcIn),
                                  height: 22.h,
                                ),
                                SizedBox(width: 14.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'My current location',
                                        style: GoogleFonts.inter(
                                          color: ColourUtils.textWhite,
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        isFetchingCurrentLoc
                                            ? 'Fetching current location...'
                                            : (currentLocAddress ??
                                                'Use this device\'s location'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          color: ColourUtils.textWhite
                                              .withValues(alpha: 0.5),
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isFetchingCurrentLoc)
                                  SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF8C52FF),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // OPTION 3: Search Address Field
                        Container(
                          decoration: BoxDecoration(
                            color: tempLocationType == 'search'
                                ? const Color(0xFF211F26)
                                : Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: tempLocationType == 'search'
                                  ? const Color(0xFFC1B4FF)
                                  : const Color(0xFFC1B4FF).withValues(alpha: 0.1),
                              width: 1.h,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.h,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 56.h,
                                child: TextField(
                                  controller: searchController,
                                  focusNode: searchFocusNode,
                                  style: GoogleFonts.inter(
                                    color: ColourUtils.textWhite,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400
                                  ),
                                  onTap: () {
                                    setModalState(() {
                                      tempLocationType = 'search';
                                    });
                                  },
                                  onChanged: (query) {
                                    setModalState(() {
                                      tempLocationType = 'search';
                                    });
                                    if (searchDebounce?.isActive ?? false) {
                                      searchDebounce!.cancel();
                                    }
                                    searchDebounce = Timer(
                                      const Duration(milliseconds: 500),
                                      () {
                                        fetchSearchSuggestions(query);
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search for an address',
                                    hintStyle: GoogleFonts.inter(
                                      color: ColourUtils.textWhite.withValues(alpha: 0.4),
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w400
                                  ),
                                    prefixIcon:
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.h, left: 4.h),
                                      child: SvgPicture.asset(
                                        'assets/images/field/svg/search.svg',
                                        height: 22.h,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      maxHeight: 22.h,
                                      minHeight: 22.h,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    suffixIcon: isSearching
                                        ? Padding(
                                            padding: EdgeInsets.all(12.r),
                                            child: SizedBox(
                                              width: 16.h,
                                              height: 16.h,
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation(
                                                  Color(0xFF8C52FF),
                                                ),
                                              ),
                                            ),
                                          )
                                        : null,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              if (searchSuggestions.isNotEmpty) ...[
                                Divider(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  height: 1.h,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxHeight: 180.h),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: searchSuggestions.length,
                                    separatorBuilder: (_, __) => Divider(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      height: 1.h,
                                    ),
                                    itemBuilder: (context, idx) {
                                      final item = searchSuggestions[idx];
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          item["description"] ?? "",
                                          style: GoogleFonts.inter(
                                            color: ColourUtils.textWhite,
                                            fontSize: 13.h,
                                          ),
                                        ),
                                        onTap: () async {
                                          final desc = item["description"] ?? "";
                                          final latLng = await fetchPlaceDetails(
                                            item["place_id"],
                                          );
                                          if (latLng != null) {
                                            setModalState(() {
                                              searchController.text = desc;
                                              chosenLocName = desc;
                                              chosenLat = latLng["lat"];
                                              chosenLng = latLng["lng"];
                                              searchSuggestions = [];
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Confirm Location Button
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              _selectedLocationType = tempLocationType;
                              if (chosenLocName.isNotEmpty) {
                                _locationController.text = chosenLocName;
                              }
                              _selectedLat = chosenLat;
                              _selectedLng = chosenLng;
                              _updateCanStartWork();
                              Navigator.pop(modalContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUtils.secondaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Confirm location',
                              style: GoogleFonts.inter(
                                color: ColourUtils.textWhite,
                                fontSize: 14.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityControl() {
    final priorities = ['Low', 'Medium', 'High'];

    return Container(
      decoration: BoxDecoration(
        color: ColourUtils.textWhite.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColourUtils.textWhite.withValues(alpha: 0.1),
          width: 1.h,
        ),
      ),
      child: Row(
        children: priorities.map((p) {
          bool selected = _priority == p;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _priority = p),
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: selected
                      ? ColourUtils.primary
                      : ColourUtils.transparant,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    p,
                    style: GoogleFonts.inter(
                      color: selected
                          ? ColourUtils.textWhite
                          : ColourUtils.textMuted,
                      fontSize: 12.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFormActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),
        // 1. SCHEDULE FOR LATER
        GetX<AddWorkLogController>(
          builder: (AddWorkLogController controller) {
            final isAnyBusy = controller.isAnyLoading;
            final isThisLoading = controller.isScheduling.value;

            return SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isAnyBusy
                    ? null
                    : () {
                        if (_isUploadingAttachments) {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.orange,
                            message: 'Please wait for attachments to finish uploading.',
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          AttendanceCommonWidgets().printF(
                            "Work Titel : ${_titleController.text}\nWork Type : ${_workTypeId}\nCustomer : ${_customerId}\nPriority : ${_priority}\nDate : ${_dateController.text}\nStart Time : ${_startTimeController.text}\nEnd Time : ${_endTimeController.text}\nLocation : ${_locationController.text}\nDescription : ${_descriptionController.text}\n",
                          );
                          controller.addWorkLog(
                            context: context,
                            title: _titleController.text,
                            workTypeId: _workTypeId,
                            customerId: _customerId,
                            priority: _priority,
                            date: _selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                                : _dateController.text,
                            startTime: _startTimeController.text,
                            endTime: _endTimeController.text,
                            location: _locationController.text,
                            latLong: LatLng(lat: _selectedLat, lng: _selectedLng),
                            otpEnable: _otpEnable,
                            geofenceRequired: _geofenceRequired,
                            description: _descriptionController.text,
                            attachment: [_uploadedAttachmentPaths.join(',')],
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1B4FF),
                  foregroundColor: const Color(0xFF201168),
                  disabledBackgroundColor: const Color(0xFFC1B4FF),
                  disabledForegroundColor: const Color(0xFF201168),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: isThisLoading
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                              width: 22.h,
                              height: 22.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF221652),
                                ),
                              ),
                            ),
                        ),
                      ],
                    )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 20.h,
                            color: const Color(0xFF201168),
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            'Schedule for later',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF201168),
                              fontSize: 14.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),

        // 2. START WORK NOW
        Obx(() {
          final canStart = _canStartWork.value;
          final isAnyBusy = controller.isAnyLoading;
          final isThisLoading = controller.isStartingNow.value;
          final isEnabled = canStart && !isAnyBusy;

          return GestureDetector(
            onTap: isEnabled
                ? () async {
                    if (controller.isAnyLoading) return;
                    if (_isUploadingAttachments) {
                      AttendanceCommonWidgets().showSnackBar(
                        context: context,
                        backgroundColor: Colors.orange,
                        message: 'Please wait for attachments to finish uploading.',
                      );
                      return;
                    }
                    if (Get.find<HomeController>().punchTime.value == "") {
                      AttendanceCommonWidgets().showSnackBar(
                        context: context,
                        backgroundColor: Colors.red,
                        message: "Please check in first",
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      AttendanceCommonWidgets().printF(
                        "Work Titel : ${_titleController.text}\nWork Type : ${_workTypeId}\nCustomer : ${_customerId}\nPriority : ${_priority}\nDate : ${_dateController.text}\nStart Time : ${_startTimeController.text}\nEnd Time : ${_endTimeController.text}\nLocation : ${_locationController.text}\nDescription : ${_descriptionController.text}\n",
                      );
                      await controller.startWorkNow(
                        context: context,
                        title: _titleController.text,
                        workTypeId: _workTypeId,
                        customerId: _customerId,
                        priority: _priority,
                        date: _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : _dateController.text,
                        startTime: _startTimeController.text,
                        endTime: _endTimeController.text,
                        location: _locationController.text,
                        latLong: LatLng(lat: _selectedLat, lng: _selectedLng),
                        otpEnable: _otpEnable,
                        geofenceRequired: _geofenceRequired,
                        description: _descriptionController.text,
                        attachment: [_uploadedAttachmentPaths.join(',')],
                      );
                    }
                  }
                : null,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.secondaryBlue,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: isThisLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
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
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              size: 22.h,
                              color: ColorUtils.textWhite,
                            ),
                            SizedBox(width: 8.h),
                            Text(
                              'Start work now',
                              style: GoogleFonts.inter(
                                color: ColorUtils.textWhite,
                                fontSize: 14.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
                if (!canStart || (isAnyBusy && !isThisLoading))
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
