
import 'dart:math' as math;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_controller/air_ticket_controller.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/air_ticket_textField.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/air_ticket_list_api_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../models/user_profile_api_model.dart';
import '../../CWidgets/date_picker.dart';
import 'air_ticket_container.dart';

class CompanyBookingTicketCreate extends GetView<AirTicketController> {
  const CompanyBookingTicketCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(controller.airTicketDetails.value?.policyIsOneWay == '1')
          GestureDetector(
            onTap: () {
              controller.selectedFieldNumber.value = 7;
              controller.airTicketCreateData.value.ticketType = 1;
              controller.airTicketCreateData.refresh();
            },
            child: Obx(() {
              return AirTicketContainerWidget(
                label: 'One way',
                text: controller.airTicketCreateData.value.ticketType == 1 ? "One way" : null,
                number: 7,
                icon: Container(
                  width: 20.h,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: controller.airTicketCreateData.value.ticketType == 1 ? ColorUtils.secondaryBlue : Color(0xFF414141),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      color: ColorUtils.textWhite,
                      size: 12.h,
                    ),
                  ),
                ),
              );
            }
            ),
          )
        else if(controller.airTicketDetails.value?.policyIsOneWay == '2')
          Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  controller.selectedFieldNumber.value = 7;
                  controller.airTicketCreateData.value.ticketType = 1;
                  controller.airTicketCreateData.refresh();
                },
                child: Obx(() {
                    return AirTicketContainerWidget(
                      label: 'One way',
                      text: controller.airTicketCreateData.value.ticketType == 1 ? "One way" : null,
                      number: 7,
                      icon: Container(
                        width: 20.h,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: controller.airTicketCreateData.value.ticketType == 1 ? ColorUtils.secondaryBlue : Color(0xFF414141),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.done,
                            color: ColorUtils.textWhite,
                            size: 12.h,
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
            SizedBox(width: 10.h),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  controller.selectedFieldNumber.value = 8;
                  controller.airTicketCreateData.value.ticketType = 2;
                  controller.airTicketCreateData.refresh();
                },
                child: Obx(() {
                    return AirTicketContainerWidget(
                      label: 'Two way',
                      text: controller.airTicketCreateData.value.ticketType == 2 ? "Two way" : null,
                      number: 8,
                      icon: Container(
                        width: 20.h,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: controller.airTicketCreateData.value.ticketType == 2 ? ColorUtils.secondaryBlue : Color(0xFF414141),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.done,
                            color: ColorUtils.textWhite,
                            size: 12.h,
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Stack(
          children: [
            TextFieldWidget(
                number: 9,
                label: 'From',
                hintText: 'Type here...',
            ),
            Positioned(
              right: 20.h,
              top: 27.h,
              bottom: 27.h,
              child: Image.asset('assets/images/air_ticket/flight_up.png'),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Stack(
          children: [
            TextFieldWidget(
                number: 10,
                label: 'To',
                hintText: 'Type here...',
            ),
            Positioned(
              right: 20.h,
              top: 27.h,
              bottom: 27.h,
              child: Image.asset('assets/images/air_ticket/flight_down.png'),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        GestureDetector(
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.find<AirTicketController>().selectedFieldNumber.value = 11;
            DateTime? picked = await pickDate(
              context,
              ThemeMode.dark,
              firstDate: DateTime(DateTime.now().year - 1),
              lastDate: DateTime(DateTime.now().year + 1),
            );
            if(picked != null) {
              Get.find<AirTicketController>().airTicketCreateData.value.reqDate = DateFormat("yyyy-MM-dd").format(picked);
              Get.find<AirTicketController>().airTicketCreateData.refresh();
            }
          },
          child: Obx(() {
              return AirTicketContainerWidget(
                label: 'Date of Journey',
                text: controller.airTicketCreateData.value.reqDate,
                number: 11,
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                  size: 20.h,
                ),
              );
            }
          ),
        ),
        // Row(
        //   children: [
        //     Flexible(
        //       child: GestureDetector(
        //         onTap: () async {
        //           FocusManager.instance.primaryFocus?.unfocus();
        //           Get.find<AirTicketController>().selectedFieldNumber.value = 11;
        //           DateTime? picked = await pickDate(
        //             context,
        //             ThemeMode.dark,
        //             firstDate: DateTime(DateTime.now().year),
        //             lastDate: DateTime(
        //               DateTime.now().year,
        //               DateTime.now().month,
        //               DateTime.now().day,
        //             ),
        //           );
        //         },
        //         child: AirTicketContainerWidget(
        //           label: 'Depart',
        //           number: 11,
        //           icon: Icon(
        //             Icons.calendar_today_outlined,
        //             color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
        //             size: 20.h,
        //           ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: 10.h),
        //     Flexible(
        //       child: GestureDetector(
        //         onTap: () async {
        //           FocusManager.instance.primaryFocus?.unfocus();
        //           Get.find<AirTicketController>().selectedFieldNumber.value = 12;
        //           DateTime? picked = await pickDate(
        //             context,
        //             ThemeMode.dark,
        //             firstDate: DateTime(DateTime.now().year),
        //             lastDate: DateTime(
        //               DateTime.now().year,
        //               DateTime.now().month,
        //               DateTime.now().day,
        //             ),
        //           );
        //         },
        //         child: AirTicketContainerWidget(
        //           label: 'Return',
        //           number: 12,
        //           icon: Icon(
        //             Icons.calendar_today_outlined,
        //             color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
        //             size: 20.h,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 15.h),
        Row(
          children: [
            SizedBox(width: 5.h),
            Text(
              "Passenger Details",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13.h,
                color: ColorUtils.textWhite,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: ColorUtils.foregroundBlack,
            borderRadius: BorderRadius.circular(11).r,
          ),
          child: GetX<UserProfileController>(
            builder: (UserProfileController userProfileController) {
              UserProfile user = userProfileController.userData.value.result;
              String name = '--';
              String genderAndAge = '';

              if (user.nickName != null && user.nickName!.isNotEmpty) {
                name = user.nickName!.trim();
              } else if (user.firstName != null && user.firstName!.isNotEmpty) {
                name = user.firstName!.trim();
                if (user.lastName != null && user.lastName!.isNotEmpty) {
                  name += ' ${user.lastName!.trim()}';
                }
              } else if (user.lastName != null && user.lastName!.isNotEmpty) {
                name = user.lastName!.trim();
              }
              if(user.gender != null && (user.gender?.isNotEmpty ?? false)) {
                genderAndAge = user.gender?[0].toString() ?? '';
              }
              try {
                if(user.dateOfBirth != null && (user.dateOfBirth?.isNotEmpty ?? false)) {
                  DateTime dateOfBirth = DateTime.parse(user.dateOfBirth ?? '');
                  int difference = DateTime.now().year - dateOfBirth.year;
                  genderAndAge = '$genderAndAge $difference';
                }
              } catch(e) {}
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 12.h),
                  AttendanceCommonWidgets().cachedNetworkImageWithoutBoarder(
                    user.profilePicture ?? '',
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                        Text(
                          user.email ?? '--',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.h,
                            color: Color(0xFF7E7E7E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        genderAndAge,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.h,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                      Text(
                        "Adult",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.h,
                          color: Color(0xFF7E7E7E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.h),
                ],
              );
            }
          ),
        ),
        SizedBox(height: 10.h),
        // AirTicketContainerWidget(
        //     label: 'Passport No',
        //     number: 13,
        // ),
        TextFieldWidget(
            number: 22,
          label: 'Passport No',
          hintText: 'Type here...',
        ),
        SizedBox(height: 8.h),
        Obx(() {
          List<PassengerData> passengers = controller.airTicketCreateData.value.passengerData ?? [];
          List<String> dropdowns = ['Adult', 'Child', 'Infant'];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int index = 0; index < passengers.length; index++)
                  Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    collapsedIconColor: ColorUtils.workEntryHead,
                    iconColor: ColorUtils.workEntryHead,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    showTrailingIcon: false,
                    initiallyExpanded: passengers[index].isExpanded,
                    onExpansionChanged: (value) {
                      passengers[index].isExpanded = value;
                      controller.airTicketCreateData.refresh();
                    },
                    title: Container(
                      height: 41.h,
                      decoration: BoxDecoration(
                        color: passengers[index].isExpanded ? Colors.transparent : ColorUtils.foregroundBlack,
                        borderRadius: BorderRadius.circular(7).r,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: passengers[index].isExpanded ? 6.h : 10.h),
                          Container(
                            width: 20.h,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.done,
                                color: ColorUtils.textWhite,
                                size: 12.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Expanded(
                            child: Text(
                              "Passenger ${index + 1}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.h),
                          InkWell(
                            onTap: () {
                              // if(int.parse(controller.airTicketDetails.value?.pocilyMaxDependents ?? "0") != passengers.length) {
                              //
                              // }
                              controller.airTicketCreateData.value.passengerData?.removeAt(index);
                              controller.airTicketCreateData.refresh();
                            },
                            child: Image.asset(
                              'assets/images/air_ticket/delete_passenger.png',
                              height: 17.h,
                            ),
                          ),
                          SizedBox(width: 15.h),
                          Container(
                            width: 28.h,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.foregroundBlack,
                              borderRadius: BorderRadius.circular(4).r,
                            ),
                            child: Center(
                              child: AnimatedRotation(
                                turns: passengers[index].isExpanded ? 0.5 : 0.0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: SvgPicture.asset(
                                  "assets/images/manager_view/arrow_up.svg",
                                  height: 7.h,
                                  colorFilter: ColorFilter.mode(ColorUtils.spanishGrey, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                          if(!passengers[index].isExpanded)
                            SizedBox(width: 5.h),
                        ],
                      ),
                    ),
                    children: [
                      TextFieldWidget(
                        number: 14 + (50 * index),
                        label: 'Name',
                        hintText: 'Enter name',
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedFieldNumber.value = 15;
                                passengers[index].gender = "Male";
                                controller.airTicketCreateData.refresh();
                              },
                              child: AirTicketContainerWidget(
                                label: 'Male',
                                text: passengers[index].gender == 'Male' ? 'Male' : null,
                                number: 15,
                                icon: Container(
                                  width: 20.h,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: passengers[index].gender == "Male" ? ColorUtils.secondaryBlue : Color(0xFF414141),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.done,
                                      color: ColorUtils.textWhite,
                                      size: 12.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedFieldNumber.value = 16;
                                passengers[index].gender = "Female";
                                controller.airTicketCreateData.refresh();
                              },
                              child: AirTicketContainerWidget(
                                label: 'Female',
                                text: passengers[index].gender == 'Female' ? 'Female' : null,
                                number: 16,
                                icon: Container(
                                  width: 20.h,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: passengers[index].gender == "Female" ? ColorUtils.secondaryBlue : Color(0xFF414141),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.done,
                                      color: ColorUtils.textWhite,
                                      size: 12.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.selectedFieldNumber.value = 17;
                                DateTime? picked = await pickDate(
                                  context,
                                  ThemeMode.dark,
                                  firstDate: DateTime(DateTime.now().year - 50),
                                  lastDate: DateTime(DateTime.now().year + 3),
                                );
                                if(picked != null) {
                                  passengers[index].dateOfBirth = DateFormat("yyyy-MM-dd").format(picked);
                                  controller.airTicketCreateData.refresh();
                                }
                              },
                              child: AirTicketContainerWidget(
                                label: 'Date of birth',
                                text: passengers[index].dateOfBirth,
                                number: 17,
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                                  size: 20.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Flexible(
                            child: Container(
                              height: 50.h,
                              padding: EdgeInsets.symmetric(horizontal: 15.h),
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(12).r,
                                border: Border.all(
                                  color:
                                  controller.selectedFieldNumber.value == 18
                                      ? ColorUtils.darkGrey
                                      : ColorUtils.foregroundBlack,
                                  width: 0.5.h,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        selectedItemBuilder: (context) {
                                          return dropdowns.map((option) {
                                            return Text(
                                              AttendanceCommonWidgets().capitalizeFirstLetter(passengers[index].passengerType) ?? dropdowns.first,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.h,
                                                color: ColorUtils.textWhite,
                                              ),
                                            );
                                          }).toList();
                                        },
                                        items: dropdowns.map(
                                              (option) => DropdownMenuItem<String>(
                                            value: option,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 15.h),
                                              child: Text(
                                                option,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.h,
                                                  color: ColorUtils.textWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ).toList(),
                                        value: AttendanceCommonWidgets().capitalizeFirstLetter(passengers[index].passengerType) ?? dropdowns.first,
                                        onChanged:
                                            (selectedValue) async {
                                          passengers[index].passengerType = selectedValue?.toLowerCase();
                                          controller.airTicketCreateData.refresh();
                                        },
                                        onMenuStateChange: (isOpen) {
                                          controller.selectedFieldNumber.value = 18;
                                        },
                                        iconStyleData: IconStyleData(
                                          icon: SizedBox.shrink(),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              color: ColorUtils.foregroundBlack,
                                            )
                                        ),
                                        buttonStyleData: ButtonStyleData(
                                          height: 20.h,
                                          padding: EdgeInsets.zero,
                                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: 180 * (math.pi / 180),
                                    child: SvgPicture.asset(
                                      "assets/images/manager_view/arrow_up.svg",
                                      height: 7.h,
                                      colorFilter: ColorFilter.mode(ColorUtils.spanishGrey, BlendMode.srcIn),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Flexible(
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       controller.selectedFieldNumber.value = 18;
                          //     },
                          //     child: AirTicketContainerWidget(
                          //       label: 'Adult',
                          //       number: 18,
                          //       icon: Transform.rotate(
                          //         angle: 180 * (math.pi / 180),
                          //         child: SvgPicture.asset(
                          //           "assets/images/manager_view/arrow_up.svg",
                          //           height: 7.h,
                          //           colorFilter: ColorFilter.mode(ColorUtils.spanishGrey, BlendMode.srcIn),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      TextFieldWidget(
                        number: 19 + (50 * index),
                        label: 'Passport No',
                        hintText: 'Enter passport no',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                if(controller.airTicketDetails.value?.pocilyMaxDependents != '0')
                  if(int.parse(controller.airTicketDetails.value?.pocilyMaxDependents ?? "0") != controller.airTicketCreateData.value.passengerData?.length)
                    InkWell(
                      onTap: () {
                        controller.airTicketCreateData.value.passengerData ??= [];
                        controller.airTicketCreateData.value.passengerData?.add(PassengerData(passengerType: 'Adult'));
                        controller.airTicketCreateData.refresh();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: ColorUtils.textWhite, size: 22.h),
                          SizedBox(width: 3.h),
                          Text(
                            "Add New Passenger",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.h,
                              color: ColorUtils.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            );
          }
        ),
      ],
    );
  }
}
