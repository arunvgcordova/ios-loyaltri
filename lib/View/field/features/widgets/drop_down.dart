import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? icon;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour2,
        borderRadius: BorderRadius.all(Radius.circular(15.h)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: ColourUtils.textWhite,
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              isDense: true,
              hint: Text(
                hint ?? "",
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                  color: ColourUtils.textWhite.withValues(alpha: 0.4),
                ),
              ),
              value: value,
              dropdownColor: ColourUtils.cardBackground,
              style: GoogleFonts.inter(
                color: ColourUtils.textMain,
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                prefixIcon: icon != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          svgWidget(
                            height: 20.h,
                            width: 20.h,
                            icon: icon ?? '',
                            color: ColourUtils.textWhite.withValues(alpha: 0.4),
                          ),
                        ],
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ColourUtils.textWhite.withValues(alpha: 0.1),
                    width: 1.h,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ColourUtils.primary,
                    width: 1.h,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ColourUtils.overdue,
                    width: 1.h,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ColourUtils.overdue,
                    width: 1.h,
                  ),
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: ColourUtils.textMuted,
                size: 22.h,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
              validator: validator,
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomDropdownField extends StatelessWidget {
//   final String label;
//   final String? value;
//   final String? hint;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;
//   final String? icon;
//   final String? Function(String?)? validator;

//   const CustomDropdownField({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     this.icon,
//     this.hint,
//     this.validator,
//   });

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
//               label,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textWhite,
//                 fontSize: 14.h,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.h),
//               decoration: BoxDecoration(
//                 color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                 borderRadius: BorderRadius.circular(10.r),
//                 border: Border.all(
//                   color: ColourUtils.textWhite.withValues(alpha: 0.1),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   // Icon(icon, color: ColourUtils.textMuted, size: 20.h),
//                   icon == null
//                       ? SizedBox()
//                       : svgWidget(
//                           height: 20.h,
//                           width: 20.h,
//                           icon: icon ?? '',
//                           color: ColourUtils.textWhite.withValues(alpha: 0.4),
//                         ),
//                   SizedBox(width: 5.w),
//                   Expanded(
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButtonFormField<String>(
//                         isDense: true,
//                         hint: Text(
//                           hint ?? "",
//                           style: TextStyle(
//                             fontSize: 14.h,
//                             fontWeight: FontWeight.w400,
//                             color: ColourUtils.textWhite.withValues(alpha: 0.4),
//                           ),
//                         ),
//                         value: value,
//                         dropdownColor: ColourUtils.cardBackground,
//                         style: GoogleFonts.inter(
//                           color: ColourUtils.textMain,
//                           fontSize: 14.h,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(vertical: 14.h),
//                           border: InputBorder.none,
//                         ),
//                         icon: Icon(
//                           Icons.keyboard_arrow_down,
//                           color: ColourUtils.textMuted,
//                           size: 22.h,
//                         ),
//                         items: items.map((item) {
//                           return DropdownMenuItem<String>(
//                             value: item,
//                             child: Text(item),
//                           );
//                         }).toList(),
//                         onChanged: onChanged,
//                         validator: validator,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomSearchDropdownField<T> extends StatelessWidget {
//   final String label;
//   final String? hint;
//   final Future<List<T>> Function(String, LoadProps?)? items;
//   final ValueChanged<T?> onChanged;
//   final String? icon;
//   final String? Function(T?)? validator;
//   final String Function(T)? itemAsString;
//   final bool Function(T, T)? compareFn;

//   const CustomSearchDropdownField({
//     super.key,
//     required this.label,
//     required this.items,
//     required this.onChanged,
//     this.icon,
//     this.hint,
//     this.validator,
//     required this.itemAsString, this.compareFn,
//   });

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
//             SizedBox(
//               height: 56.h,
//               child: DropdownSearch<T>(
//                 items: items,
//                 itemAsString: itemAsString,

//                 compareFn: compareFn,
//                 // selectedItem: value,
//                 onSelected: onChanged,
//                 suffixProps: DropdownSuffixProps(
//                   dropdownButtonProps: DropdownButtonProps(
//                     iconClosed: Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       size: 25.h,
//                       color: ColourUtils.textWhite.withValues(alpha: 0.4),
//                     ),
//                   ),
//                 ),
//                 popupProps: PopupProps.menu(
//                   searchDelay: Duration(milliseconds: 50),
//                   showSearchBox: true,
//                   searchFieldProps: TextFieldProps(
//                     style: TextStyle(
//                       color: ColourUtils.textWhite,
//                       fontSize: 14.h,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 10.w,
//                         vertical: 5.h,
//                       ),
//                       hintText: 'Search...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),

//                   // itemBuilder: (context, item, isDisabled, isSelected) {
//                   //   return Padding(
//                   //     padding: EdgeInsets.symmetric(
//                   //       horizontal: 12.w,
//                   //       vertical: 10.h,
//                   //     ),
//                   //     child: Text(
//                   //       item.,
//                   //       style: TextStyle(
//                   //         color: ColourUtils.textWhite, // Your text color
//                   //         fontSize: 14.h,
//                   //       ),
//                   //     ),
//                   //   );
//                   // },
//                   menuProps: MenuProps(
//                     backgroundColor: ColourUtils.cardBackground,

//                   ),
//                 ),
//                 decoratorProps: DropDownDecoratorProps(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
//                     isDense: true,
//                     hintText: hint,
//                     hintStyle: TextStyle(
//                       fontSize: 14.h,
//                       fontWeight: FontWeight.w400,
//                       color: ColourUtils.textWhite.withValues(alpha: 0.4),
//                     ),
//                     prefixIconConstraints: BoxConstraints(maxWidth: 50.h),
//                     prefixIcon: icon != null
//                         ? Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               svgWidget(
//                                 height: 20.h,
//                                 width: 50.h,
//                                 icon: icon!,
//                                 color: ColourUtils.textWhite.withValues(
//                                   alpha: 0.4,
//                                 ),
//                               ),
//                             ],
//                           )
//                         : SizedBox(width: 10.h),

//                     // border: InputBorder.none,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.h),
//                       borderSide: BorderSide(
//                         color: ColourUtils.textWhite.withValues(alpha: 0.1),
//                         width: 1.h,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.h),
//                       borderSide: BorderSide(
//                         color: ColourUtils.primary,
//                         width: 1.h,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.h),
//                       borderSide: BorderSide(
//                         color: ColourUtils.overdue,
//                         width: 1.h,
//                       ),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.h),
//                       borderSide: BorderSide(
//                         color: ColourUtils.overdue,
//                         width: 1.h,
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(vertical: 18.h),
//                   ),
//                 ),
//                 // dropdownBuilder: (context, selectedItem) {
//                 //   return Text(
//                 //     selectedItem ?? '',
//                 //     style: GoogleFonts.inter(
//                 //       color: ColourUtils.textMain,
//                 //       fontSize: 14.h,
//                 //       fontWeight: FontWeight.w400,
//                 //     ),
//                 //   );
//                 // },
//                 validator: validator,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomeDropdownSearch<T> extends StatelessWidget {
  final String label;
  final String hintText;

  final Future<List<T>> Function() items;

  final String Function(T item) itemAsString;

  final void Function(T?)? onSelected;

  final String? Function(T?)? validator;

  final T? selectedItem;

  final Widget? prefixIcon;

  final bool showSearchBox;

  final bool Function(T, T)? compareFn;

  final Widget? bottomWidget;

  const CustomeDropdownSearch({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.itemAsString,
    this.onSelected,
    this.validator,
    this.selectedItem,
    this.prefixIcon,
    this.showSearchBox = true,
    this.compareFn,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour2,
        borderRadius: BorderRadius.circular(15.h),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: ColourUtils.textWhite,
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownSearch<T>(
              selectedItem: selectedItem,
              compareFn: compareFn,
              items: (filter, loadProps) async => await items(),
              itemAsString: itemAsString,
              onSelected: onSelected,
              validator: validator,
              autoValidateMode: AutovalidateMode.onUserInteraction,

              suffixProps: DropdownSuffixProps(
                dropdownButtonProps: DropdownButtonProps(
                  iconClosed: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 25.h,
                    color: ColourUtils.textWhite.withValues(alpha: 0.4),
                  ),
                ),
              ),

              popupProps: PopupProps.menu(
                searchDelay: const Duration(milliseconds: 500),
                showSearchBox: showSearchBox,

                searchFieldProps: TextFieldProps(
                  style: TextStyle(
                    color: ColourUtils.textWhite,
                    fontSize: 14.h,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                  ),
                ),

                menuProps: MenuProps(
                  backgroundColor: ColourUtils.cardBackground,
                ),

                itemBuilder: (context, item, isDisabled, isSelected) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      itemAsString(item),
                      style: TextStyle(
                        color: ColourUtils.textWhite,
                        fontSize: 14.h,
                      ),
                    ),
                  );
                },
              ),

              dropdownBuilder: (context, item) {
                return Text(
                  item == null ? "" : itemAsString(item),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },

              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
                  isDense: true,

                  hintText: hintText,

                  hintStyle: TextStyle(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w400,
                    color: ColourUtils.textWhite.withValues(alpha: 0.4),
                  ),

                  prefixIconConstraints: BoxConstraints(maxWidth: 50.h),

                  prefixIcon:
                      prefixIcon ??
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          svgWidget(
                            icon: "search",
                            width: 50.h,
                            height: 20.h,
                            color: ColourUtils.textWhite.withValues(alpha: 0.4),
                          ),
                        ],
                      ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                    borderSide: BorderSide(
                      color: ColourUtils.textWhite.withValues(alpha: 0.1),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                    borderSide: BorderSide(color: ColourUtils.primary),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                    borderSide: BorderSide(color: ColourUtils.overdue),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                    borderSide: BorderSide(color: ColourUtils.overdue),
                  ),

                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                ),
              ),
            ),
            if (bottomWidget != null) bottomWidget!,
          ],
        ),
      ),
    );
  }
}


// class AppDropdownSearch<T> extends StatelessWidget {
//   final Future<List<T>> Function() fetchItems;
//   final String Function(T item) itemAsString;
//   final void Function(T?)? onChanged;
//   final T? selectedItem;
//   final String hintText;
//   final String? Function(T?)? validator;
//   final bool Function(T, T)? compareFn;

//   const AppDropdownSearch({
//     super.key,
//     required this.fetchItems,
//     required this.itemAsString,
//     this.onChanged,
//     this.selectedItem,
//     this.hintText = "Select",
//     this.validator,
//     this.compareFn,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownSearch<T>(
//       items: (filter, loadProps) async {
//         return await fetchItems();
//       },
//       selectedItem: selectedItem,
//       itemAsString: itemAsString,
//       compareFn: compareFn,
//       onSelected: onChanged,
//       autoValidateMode: AutovalidateMode.onUserInteraction,
//       validator: validator,

//       suffixProps: DropdownSuffixProps(
//         dropdownButtonProps: DropdownButtonProps(
//           iconClosed: Icon(
//             Icons.keyboard_arrow_down_rounded,
//             size: 25.h,
//             color: ColourUtils.textWhite.withValues(alpha: 0.4),
//           ),
//         ),
//       ),

//       popupProps: PopupProps.menu(
//         cacheItems: false,
//         searchDelay: const Duration(milliseconds: 300),
//         showSearchBox: true,
//         searchFieldProps: TextFieldProps(
//           style: TextStyle(
//             color: ColourUtils.textWhite,
//             fontSize: 14.h,
//             fontWeight: FontWeight.w400,
//           ),
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 10.w,
//               vertical: 5.h,
//             ),
//             hintText: "Search...",
//             border: const OutlineInputBorder(),
//           ),
//         ),
//         itemBuilder: (context, item, isDisabled, isSelected) {
//           return Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 12.w,
//               vertical: 10.h,
//             ),
//             child: Text(
//               itemAsString(item),
//               style: TextStyle(
//                 color: ColourUtils.textWhite,
//                 fontSize: 14.h,
//               ),
//             ),
//           );
//         },
//         menuProps: MenuProps(
//           backgroundColor: ColourUtils.cardBackground,
//         ),
//       ),

//       dropdownBuilder: (context, selectedItem) {
//         return Text(
//           selectedItem == null ? "" : itemAsString(selectedItem),
//           style: GoogleFonts.inter(
//             color: ColourUtils.textWhite,
//             fontSize: 14.h,
//             fontWeight: FontWeight.w600,
//           ),
//           overflow: TextOverflow.ellipsis,
//         );
//       },

//       decoratorProps: DropDownDecoratorProps(
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
//           isDense: true,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             fontSize: 14.h,
//             fontWeight: FontWeight.w400,
//             color: ColourUtils.textWhite.withValues(alpha: 0.4),
//           ),
//           prefixIconConstraints: BoxConstraints(maxWidth: 50.h),
//           prefixIcon: SizedBox(width: 15.w),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.h),
//             borderSide: BorderSide(
//               color: ColourUtils.textWhite.withValues(alpha: 0.1),
//               width: 1.h,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.h),
//             borderSide: BorderSide(
//               color: ColourUtils.primary,
//               width: 1.h,
//             ),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.h),
//             borderSide: BorderSide(
//               color: ColourUtils.overdue,
//               width: 1.h,
//             ),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.h),
//             borderSide: BorderSide(
//               color: ColourUtils.overdue,
//               width: 1.h,
//             ),
//           ),
//           contentPadding: EdgeInsets.symmetric(vertical: 18.h),
//         ),
//       ),
//     );
//   }
// }


