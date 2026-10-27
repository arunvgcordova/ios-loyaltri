
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_controller/air_ticket_controller.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/companyBooking_ticket_create.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/encashment_ticket_create.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/reimbursment_ticket_create.dart';
import 'package:loyaltri_minimal/models/manager/air_ticket_list_api_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../controller/userProfileController.dart';
import '../../../services/attachment_service.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../AirTicketHome.dart';

class AirTicketCreateSheet extends StatefulWidget {
  const AirTicketCreateSheet({super.key});

  @override
  State<AirTicketCreateSheet> createState() => _AirTicketCreateSheetState();
}

class _AirTicketCreateSheetState extends State<AirTicketCreateSheet> {

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    await Get.find<AirTicketController>().fetchAirTicketDetails();
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.workEntryHead,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Get.find<AirTicketController>().selectedFieldNumber.value = 0;
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorUtils.workEntryHead,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(30).r,
                    //   topRight: Radius.circular(30).r,
                    // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 8).h,
                  child: Column(
                    children: [
                      SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 48.h,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14).r,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/air_ticket/aeroplane_icon.png",
                                  height: 25.h,
                                ),
                                SizedBox(width: 10.h),
                                Text(
                                  "Air Ticket",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.textWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.h,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 48.h,
                                height: 48.h,
                                padding: EdgeInsets.all(1).h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.charcoalBlue,
                                  borderRadius: BorderRadius.circular(15).r,
                                ),
                                child: Container(
                                  width: 48.h,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(14).r,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      color: ColorUtils.textWhite,
                                      size: 22.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              GetX<AirTicketController>(
                                builder: (AirTicketController controller) {
                                  return Container(
                                    width: ScreenUtil().screenWidth,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(12).r,
                                      border:  Border.all(
                                        color: controller.selectedFieldNumber.value == 1 ? ColorUtils.darkGrey : ColorUtils.foregroundBlack,
                                        width: 0.5.h,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: 15.h),
                                                  Text(
                                                    "Request Type",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13.h,
                                                      fontWeight: FontWeight.w400,
                                                      color: ColorUtils.lightGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              GetX<AirTicketController>(
                                                builder: (AirTicketController controller) {
                                                  List<RequestCardType> dropdowns = [];
                                                  if(controller.airTicketDetails.value?.policyRequestType?.contains('reimbursement') ?? false) {
                                                    dropdowns.add(RequestCardType.reimbursement);
                                                  }
                                                  if(controller.airTicketDetails.value?.policyRequestType?.contains('encashment') ?? false) {
                                                    dropdowns.add(RequestCardType.encashment);
                                                  }
                                                  if(controller.airTicketDetails.value?.policyRequestType?.contains('companyBooking') ?? false) {
                                                    dropdowns.add(RequestCardType.companyBooking);
                                                  }
                                                  return DropdownButtonHideUnderline(
                                                    child: DropdownButton2<RequestCardType>(
                                                      isExpanded: true,
                                                      hint: Text(
                                                        'Select',
                                                        style: GoogleFonts.dmSans(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 13.h,
                                                          color: ColorUtils.textWhite
                                                              .withValues(alpha: 0.5),
                                                          letterSpacing: -0.5,
                                                        ),
                                                      ),
                                                      selectedItemBuilder: (context) {
                                                        return dropdowns.map((option) {
                                                          return Text(
                                                            option == RequestCardType.reimbursement ? 'Reimbursment' : option == RequestCardType.companyBooking ? 'Company Booking' : option == RequestCardType.encashment ? 'Encashment' : 'Select',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.inter(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 13.h,
                                                              color: ColorUtils.textWhite,
                                                            ),
                                                          );
                                                        }).toList();
                                                      },
                                                      items: dropdowns.map(
                                                            (option) => DropdownMenuItem<RequestCardType>(
                                                          value: option,
                                                          child: Text(
                                                            option == RequestCardType.reimbursement ? 'Reimbursment' : option == RequestCardType.companyBooking ? 'Company Booking' : option == RequestCardType.encashment ? 'Encashment' : 'Select',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.inter(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 13.h,
                                                              color: ColorUtils.textWhite,
                                                            ),
                                                          ),
                                                        ),
                                                      ).toList(),
                                                      value: controller.selectedTicketType.value,
                                                      onChanged:
                                                          (selectedValue) async {
                                                        controller.selectedTicketType.value = selectedValue!;
                                                      },
                                                      onMenuStateChange: (isOpen) {
                                                        controller.selectedFieldNumber.value = 1;
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
                                                        padding: EdgeInsets.only(right: 16.h),
                                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                                      ),
                                                      menuItemStyleData: MenuItemStyleData(
                                                        padding: EdgeInsets.only(
                                                          left: 15.h,
                                                          right: 15.h,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Color(0xFF9A9A9A),
                                        ),
                                        SizedBox(width: 10.h),
                                      ],
                                    ),
                                  );
                                }
                              ),
                              SizedBox(height: 15.h),
                              GetX<AirTicketController>(
                                  builder: (AirTicketController controller) {
                                    if(controller.selectedTicketType.value == RequestCardType.reimbursement) {
                                      return ReimbursmentTicketCreate();
                                    } else if(controller.selectedTicketType.value == RequestCardType.companyBooking) {
                                      return CompanyBookingTicketCreate();
                                    } else if(controller.selectedTicketType.value == RequestCardType.encashment) {
                                      return EncashmentTicketCreate();
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  }
                              ),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    // vertical: 15.h,
                    horizontal: 15.h
                ),
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorUtils.workEntryHead.withValues(alpha: 0),
                      ColorUtils.workEntryHead.withValues(alpha: 0.2),
                      ColorUtils.workEntryHead.withValues(alpha: 0.4),
                      ColorUtils.workEntryHead.withValues(alpha: 0.6),
                      ColorUtils.workEntryHead.withValues(alpha: 0.8),
                      ColorUtils.workEntryHead.withValues(alpha: 1),
                    ],
                  ),
                ),
                child: Center(
                    child: GetX<AirTicketController>(
                      builder: (AirTicketController controller) {
                        if(controller.requestingAirTicket.value) {
                          return Container(
                            width: ScreenUtil().screenWidth,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryBlue,
                              borderRadius: BorderRadius.circular(37).r,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 15.h,
                                height: 15.h,
                                child: Center(child: CircularProgressIndicator(color: ColorUtils.textWhite)),
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            borderRadius: BorderRadius.circular(37).r,
                            onTap: () async {
                              if(controller.selectedTicketType.value == RequestCardType.reimbursement && AttachmentService().selectedFiles.value.isEmpty) {
                                Get.snackbar(
                                  'Warning',
                                  'Attachment is required',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                await Get.find<AirTicketController>().requestForAirTicket(context);
                              }
                            },
                              child: LoyaltriBlueTextButton(text: 'Submit'),
                          );
                        }
                      }
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

