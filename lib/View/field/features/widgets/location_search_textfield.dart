import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/add_work_log/controller/add_work_controller.dart';

class LocationAutocompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? icon;
  final String? Function(String?)? validator;
  final void Function(Map<String, dynamic>)? onSuggestionSelected;
  final VoidCallback? onSelectionCleared;
  final VoidCallback? onChangeTap;
  final Widget? labelTrailing;
  final String? selectionErrorMessage;

  const LocationAutocompleteTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.validator,
    this.onSuggestionSelected,
    this.onSelectionCleared,
    this.onChangeTap,
    this.labelTrailing,
    this.selectionErrorMessage,
  });

  @override
  State<LocationAutocompleteTextField> createState() =>
      _LocationAutocompleteTextFieldState();
}

class _LocationAutocompleteTextFieldState
    extends State<LocationAutocompleteTextField> {
  List<dynamic> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();

  bool _isSelected = false;
  String? _selectedLocationText;

  @override
  void initState() {
    super.initState();

    final initialText = widget.controller.text.trim();
    if (initialText.isNotEmpty) {
      _isSelected = true;
      _selectedLocationText = initialText;
    }

    widget.controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(LocationAutocompleteTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);

      final text = widget.controller.text.trim();
      if (text.isNotEmpty) {
        _isSelected = true;
        _selectedLocationText = text;
      } else {
        _isSelected = false;
        _selectedLocationText = null;
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _suggestions = [];
          });
        }
      });
    }
  }

  void _invalidateSelection() {
    if (_isSelected || _selectedLocationText != null) {
      setState(() {
        _isSelected = false;
        _selectedLocationText = null;
      });
      widget.onSelectionCleared?.call();
    }
  }

  void _onControllerChanged() {
    final text = widget.controller.text.trim();

    if (text.isEmpty) {
      _invalidateSelection();
      return;
    }

    // If text already matches the currently selected location, nothing to do
    if (_isSelected && text == _selectedLocationText) {
      return;
    }

    if (_focusNode.hasFocus) {
      // User is typing/editing in the field
      _invalidateSelection();
    } else {
      // Programmatic update from outside (e.g., GPS button, customer selection)
      setState(() {
        _isSelected = true;
        _selectedLocationText = text;
      });
    }
  }

  void _onChanged(String query) {
    _invalidateSelection();

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSuggestions(query);
    });
  }

  AddWorkLogController _getWorkLogController() {
    if (Get.isRegistered<AddWorkLogController>()) {
      return Get.find<AddWorkLogController>();
    }
    return Get.put(AddWorkLogController());
  }

  Future<Map<String, double>?> _fetchPlaceDetails(String placeId) async {
    try {
      final controller = _getWorkLogController();
      return await controller.fetchPlaceDetails(placeId);
    } catch (e) {
      debugPrint("fetchPlaceDetails error: $e");
      return null;
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.trim().length < 3) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<dynamic> predictions = [];
    try {
      final controller = _getWorkLogController();
      predictions = await controller.fetchPlacesAutocomplete(query);
    } catch (e) {
      debugPrint("fetchPlacesAutocomplete error: $e");
    }

    if (mounted && _focusNode.hasFocus) {
      setState(() {
        _suggestions = predictions;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validate(String? value) {
    final text = value?.trim() ?? '';

    // First validate custom empty/format validator if passed
    if (widget.validator != null) {
      final customError = widget.validator!(value);
      if (customError != null) {
        return customError;
      }
    }

    // If text is empty and passed custom validator (or validator was null)
    if (text.isEmpty) {
      return null;
    }

    // If user has typed or modified text without selecting from search suggestions,
    // coordinates cannot be obtained, so enforce selecting from suggestions.
    if (!_isSelected ||
        _selectedLocationText == null ||
        text != _selectedLocationText) {
      return widget.selectionErrorMessage ??
          'Please select a location from search suggestions';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                if (widget.labelTrailing != null) widget.labelTrailing!,
              ],
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              validator: _validate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: GoogleFonts.inter(
                color: ColourUtils.textMain,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.inter(
                  color: ColourUtils.textWhite.withValues(alpha: .4),
                ),
                errorStyle: GoogleFonts.inter(
                  color: ColourUtils.overdue,
                  fontSize: 12.sp,
                ),
                errorMaxLines: 2,
                prefixIcon: widget.icon != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          svgWidget(
                            icon: widget.icon!,
                            height: 20.h,
                            width: 20.w,
                            color: ColourUtils.textWhite.withValues(alpha: .4),
                          ),
                        ],
                      )
                    : null,
                suffixIcon: _isLoading
                    ? Padding(
                        padding: EdgeInsets.all(12.r),
                        child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              ColourUtils.primary,
                            ),
                          ),
                        ),
                      )
                    : (widget.onChangeTap != null
                        ? GestureDetector(
                            onTap: widget.onChangeTap,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/manager_view/fine_edit_pencil.svg',
                                    height: 16.h,
                                    colorFilter: const ColorFilter.mode(
                                      ColourUtils.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Text(
                                    'Change',
                                    style: GoogleFonts.inter(
                                      color: ColourUtils.textWhite,
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : (widget.controller.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: ColourUtils.textWhite
                                      .withValues(alpha: .6),
                                  size: 18.r,
                                ),
                                onPressed: () {
                                  widget.controller.clear();
                                  _invalidateSelection();
                                  setState(() {
                                    _suggestions = [];
                                  });
                                },
                              )
                            : null)),
                filled: true,
                fillColor: ColourUtils.textWhite.withValues(alpha: .05),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: ColourUtils.textWhite.withValues(alpha: .1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: ColourUtils.primary,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: ColourUtils.overdue,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: ColourUtils.overdue,
                  ),
                ),
              ),
            ),
            if (_suggestions.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: ColourUtils.bgColour2,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ColourUtils.textWhite.withValues(alpha: .1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: ColourUtils.textWhite.withValues(alpha: .1),
                  ),
                  itemBuilder: (context, index) {
                    final item = _suggestions[index];

                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: ColourUtils.primary,
                        size: 20.r,
                      ),
                      title: Text(
                        item["description"] ?? "",
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite,
                          fontSize: 13.sp,
                        ),
                      ),
                      onTap: () async {
                        final displayName = item["description"] ?? "";
                        final placeId = item["place_id"] ?? "";

                        setState(() {
                          _isLoading = true;
                          _suggestions = [];
                        });

                        final latLng = await _fetchPlaceDetails(placeId);

                        setState(() {
                          _isLoading = false;
                        });

                        if (latLng != null) {
                          setState(() {
                            _isSelected = true;
                            _selectedLocationText = displayName;
                            widget.controller.text = displayName;
                          });

                          widget.onSuggestionSelected?.call({
                            "lat": latLng["lat"],
                            "lng": latLng["lng"],
                            "lon": latLng["lng"],
                            "description": displayName,
                            "locationName": displayName,
                            "place_id": placeId,
                          });
                        } else {
                          _invalidateSelection();
                          if (context.mounted) {
                            AttendanceCommonWidgets().showSnackBar(
                              context: context,
                              backgroundColor: Colors.red,
                              message:
                                  'Failed to get location coordinates. Please try again.',
                            );
                          }
                        }

                        if (context.mounted) {
                          FocusScope.of(context).unfocus();
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
    );
  }
}
