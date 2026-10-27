import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class CalenderWidget extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateChanged;

  const CalenderWidget({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
  });

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  late DateTime selectedDate;

  DateTime get firstDate => widget.firstDate ?? DateTime(2020);

  DateTime get lastDate => widget.lastDate ?? DateTime(2100);

  @override
  void initState() {
    super.initState();

    selectedDate = widget.initialDate ?? DateTime.now();

    // Keep selectedDate within the allowed range
    if (selectedDate.isBefore(firstDate)) {
      selectedDate = firstDate;
    }

    if (selectedDate.isAfter(lastDate)) {
      selectedDate = lastDate;
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool get isFirstDate => _isSameDate(selectedDate, firstDate);

  bool get isLastDate => _isSameDate(selectedDate, lastDate);

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });

      widget.onDateChanged?.call(selectedDate);
    }
  }

  void _previousDay() {
    if (isFirstDate) return;

    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));

      if (selectedDate.isBefore(firstDate)) {
        selectedDate = firstDate;
      }
    });

    widget.onDateChanged?.call(selectedDate);
  }

  void _nextDay() {
    if (isLastDate) return;

    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));

      if (selectedDate.isAfter(lastDate)) {
        selectedDate = lastDate;
      }
    });

    widget.onDateChanged?.call(selectedDate);
  }

  String get formattedDate =>
      DateFormat('EEEE, dd MMM yyyy').format(selectedDate);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
          color: ColourUtils.bgColour4,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: ColourUtils.border,
            width: 1.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: isFirstDate ? null : _previousDay,
                child: Icon(
                  Icons.chevron_left_outlined,
                  size: 25.h,
                  color: isFirstDate
                      ? ColourUtils.textWhite.withOpacity(0.4)
                      : ColourUtils.textWhite,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      svgWidget(
                        height: 20.h,
                        width: 20.h,
                        icon: 'calendar',
                        color: ColourUtils.fontColour1,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: isLastDate ? null : _nextDay,
                child: Icon(
                  Icons.chevron_right_outlined,
                  size: 25.h,
                  color: isLastDate
                      ? ColourUtils.textWhite.withOpacity(0.4)
                      : ColourUtils.textWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CalenderWidget extends StatefulWidget {
//   final DateTime? initialDate;
//   final DateTime? lastDate;
//   final Function(DateTime)? onDateChanged;

//   const CalenderWidget({
//     super.key,
//     this.initialDate,
//     this.onDateChanged, this.lastDate,
//   });

//   @override
//   State<CalenderWidget> createState() => _CalenderWidgetState();
// }

// class _CalenderWidgetState extends State<CalenderWidget> {
//   late DateTime selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     selectedDate = widget.initialDate ?? DateTime.now();
//   }

//   Future<void> _selectDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate:widget.lastDate ?? DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         selectedDate = pickedDate;
//       });

//       widget.onDateChanged?.call(selectedDate);
//     }
//   }

//   void _previousDay() {
//     setState(() {
//       selectedDate = selectedDate.subtract(const Duration(days: 1));
//     });

//     widget.onDateChanged?.call(selectedDate);
//   }

//   void _nextDay() {
//     setState(() {
//       selectedDate = selectedDate.add(const Duration(days: 1));
//     });

//     widget.onDateChanged?.call(selectedDate);
//   }

//   String get formattedDate =>
//       DateFormat('EEEE, dd MMM yyyy').format(selectedDate);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Container(
//         height: 55.h,
//         decoration: BoxDecoration(
//           color: ColourUtils.bgColour4,
//           borderRadius: BorderRadius.circular(12.h),
//           border: Border.all(
//             color: ColourUtils.border,
//             width: 1.w,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: _previousDay,
//                 child: Icon(
//                   Icons.chevron_left_outlined,
//                   size: 25.h,
//                   color: ColourUtils.textWhite,
//                 ),
//               ),

//               Expanded(
//                 child: GestureDetector(
//                   onTap: _selectDate,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       svgWidget(
//                         height: 20.h,
//                         width: 20.h,
//                         icon: 'calendar',
//                         color: ColourUtils.fontColour1,
//                       ),

//                       SizedBox(width: 10.w),

//                       Text(
//                         formattedDate,
//                         style: GoogleFonts.inter(
//                           color: ColourUtils.textWhite,
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               GestureDetector(
//                 onTap: _nextDay,
//                 child: Icon(
//                   Icons.chevron_right_outlined,
//                   size: 25.h,
//                   color: ColourUtils.textWhite,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
// import 'package:loyaltri_minimal/View/field/core/utils.dart';

// class CalenderWidget extends StatefulWidget {
//   const CalenderWidget({super.key});

//   @override
//   State<CalenderWidget> createState() => _CalenderWidgetState();
// }

// class _CalenderWidgetState extends State<CalenderWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Container(
//         height: 55.h,
//         decoration: BoxDecoration(
//           color: ColourUtils.bgColour4,
//           borderRadius: BorderRadius.circular(12.h),
//           border: Border.all(color: ColourUtils.border, width: 1.w),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.h),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.chevron_left_outlined,
//                 size: 25.h,
//                 color: ColourUtils.textWhite,
//               ),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Icon(Icons.calendar_month_outlined, size: 20.h),
//                     svgWidget(
//                       height: 20.h,
//                       width: 20.h,
//                       icon: 'calendar',
//                       color: ColourUtils.fontColour1,
//                     ),
//                     SizedBox(width: 10.h),
//                     Text(
//                       "Wednesday, 10 Sep 2024",
//                       style: GoogleFonts.inter(
//                         color: ColourUtils.textWhite,
//                         fontSize: 14.h,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Icon(
//                 Icons.chevron_right_outlined,
//                 size: 25.h,
//                 color: ColourUtils.textWhite,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
