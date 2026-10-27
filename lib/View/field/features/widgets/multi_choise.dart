import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';

class MultiChoiseWidget extends StatefulWidget {
  const MultiChoiseWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    this.initialSelectedItems = const [],
    this.onChanged,
    this.onTap,
    this.validator,
  });

  final String label;
  final String hint;
  final VoidCallback? onTap;

  /// Validator for the selected items
  final String? Function(List<String>?)? validator;

  final List<String> items;
  final List<String> initialSelectedItems;
  final ValueChanged<List<String>>? onChanged;

  @override
  State<MultiChoiseWidget> createState() => _MultiChoiseWidgetState();
}

class _MultiChoiseWidgetState extends State<MultiChoiseWidget> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List<String>.from(widget.initialSelectedItems);
  }

  @override
  void didUpdateWidget(covariant MultiChoiseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelectedItems != widget.initialSelectedItems) {
      selectedItems = List<String>.from(widget.initialSelectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: selectedItems,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
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
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),

                Column(
                  children: List.generate(widget.items.length, (index) {
                    final material = widget.items[index];
                    final isSelected = selectedItems.contains(material);

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColourUtils.textWhite.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.h),
                          ),
                          border: Border.all(
                            color: isSelected
                                ? ColourUtils.primary
                                : ColourUtils.textWhite.withValues(alpha: 0.1),
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.h),
                          ),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedItems.remove(material);
                              } else {
                                selectedItems.add(material);
                              }
                            });

                            // Notify FormField
                            field.didChange(List<String>.from(selectedItems));

                            // Notify parent
                            widget.onChanged?.call(
                              List<String>.from(selectedItems),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    material,
                                    style: GoogleFonts.inter(
                                      color: ColourUtils.textWhite,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_sharp
                                      : Icons.circle_outlined,
                                  color: isSelected
                                      ? ColourUtils.primary
                                      : ColourUtils.textWhite.withValues(
                                          alpha: 0.3,
                                        ),
                                  size: 20.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 4.w),
                    child: Text(
                      field.errorText!,
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class MultiChoiseWidget extends StatefulWidget {
//   const MultiChoiseWidget({
//     super.key,
//     required this.label,
//     required this.hint,
//     required this.items,
//     this.initialSelectedItems = const [],
//     this.onChanged,
//     this.onTap,
//     this.validator,
//   });

//   final String label;
//   final String hint;
//   final VoidCallback? onTap;
//   final String? Function(String?)? validator;
//   final List<String> items;
//   final List<String> initialSelectedItems;
//   final ValueChanged<List<String>>? onChanged;

//   @override
//   State<MultiChoiseWidget> createState() => _MultiChoiseWidgetState();
// }

// class _MultiChoiseWidgetState extends State<MultiChoiseWidget> {
//   late List<String> selectedItems;

//   @override
//   void initState() {
//     super.initState();
//     selectedItems = List<String>.from(widget.initialSelectedItems);
//   }

//   @override
//   void didUpdateWidget(covariant MultiChoiseWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.initialSelectedItems != widget.initialSelectedItems) {
//       selectedItems = List<String>.from(widget.initialSelectedItems);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10.h),
//       decoration: BoxDecoration(
//         color: ColourUtils.bgColour2,
//         borderRadius: BorderRadius.all(Radius.circular(15.h)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.label,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textWhite,
//                 fontSize: 14.h,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Column(
//               children: List.generate(widget.items.length, (index) {
//                 final material = widget.items[index];
//                 final isSelected = selectedItems.contains(material);
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 5.h),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                       borderRadius: BorderRadius.all(Radius.circular(12.h)),
//                       border: Border.all(
//                         color: isSelected
//                             ? ColourUtils.primary
//                             : ColourUtils.textWhite.withValues(alpha: 0.1),
//                       ),
//                     ),
//                     child: InkWell(
//                       borderRadius: BorderRadius.all(Radius.circular(12.h)),
//                       onTap: () {
//                         setState(() {
//                           if (isSelected) {
//                             selectedItems.remove(material);
//                           } else {
//                             selectedItems.add(material);
//                           }
//                         });
//                         if (widget.onChanged != null) {
//                           widget.onChanged!(selectedItems);
//                         }
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.all(15.h),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 material,
//                                 style: GoogleFonts.inter(
//                                   color: ColourUtils.textWhite,
//                                   fontSize: 14.h,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             Icon(
//                               isSelected
//                                   ? Icons.check_circle_sharp
//                                   : Icons.circle_outlined,
//                               color: isSelected
//                                   ? ColourUtils.primary
//                                   : ColourUtils.textWhite.withValues(alpha: 0.3),
//                               size: 20.h,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';



// class MultiChoiseWidget extends StatelessWidget {
//   const MultiChoiseWidget(
//      {
//     super.key,
//     required this.label,
//     required this.hint,
//     required this.items,
//     this.onTap,
//     this.validator,
//   });
//   final String label;
//   final String hint;
//   final VoidCallback? onTap;
//   final String? Function(String?)? validator;
//   final List<String> items;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColourUtils.bgColour2,
//         borderRadius: BorderRadius.all(Radius.circular(15.h)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textWhite,
//                 fontSize: 14.h,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Column(
//               children: List.generate(items.length, (index) {
//                 final material = items[index];
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 5.h),
//                   child: Container(
//                     // height: 56.h,
//                     decoration: BoxDecoration(
//                       color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                       borderRadius: BorderRadius.all(Radius.circular(12.h)),
//                       border: Border.all(
//                         color: ColourUtils.textWhite.withValues(alpha: 0.1),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(15.h),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               // "sdijaidasdkjaiodojdaios as jdoisajodsj dsajdoisa joidj sjdiajd  sajdi",
//                               material,
//                               style: GoogleFonts.inter(
//                                 color: ColourUtils.textWhite,
//                                 fontSize: 14.h,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),

//                           Icon(Icons.check_circle_sharp,color: ColourUtils.primary,size: 20.h,)
                          
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
