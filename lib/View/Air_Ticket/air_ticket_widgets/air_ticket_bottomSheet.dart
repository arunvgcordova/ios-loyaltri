
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loyaltri_minimal/models/manager/air_ticket_list_api_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../AirTicketHome.dart';
import '../air_ticket_controller/air_ticket_controller.dart';
import 'air_ticket_approved.dart';

class AirTicketBottomSheet extends StatelessWidget {
  final RequestCardType requestCardType;
  final AirTicketData airTicketData;
  const AirTicketBottomSheet({super.key, required this.requestCardType, required this.airTicketData});

  @override
  Widget build(BuildContext context) {
    String createdDate = '--';
    String requestDate = '--';
    String requestType = Get.find<AirTicketController>().getTicketTypeName(Get.find<AirTicketController>().getDartTicketType(airTicketData.reqType)) ?? '--';
    String duration = '--';
    try {
      String inputDate = airTicketData.createdOn ?? '';
      DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mm a").parse(inputDate);
      createdDate = DateFormat("dd MMM yyyy").format(parsedDate);
    } catch(e) {}
    try {
      String inputDate = airTicketData.reqDate ?? '';
      DateTime dateTime = DateTime.parse(inputDate);
      requestDate = DateFormat('dd MMM yyyy').format(dateTime);
    } catch(e) {}
    try {
      String departureTime = airTicketData.ticketData?.departureTime ?? '';
      String arrivalTime = airTicketData.ticketData?.arrivalTime ?? '';
      duration = calculateDuration(departureTime, arrivalTime) ?? '--';
    } catch(e) {}
    return SafeArea(
      child: KeyboardAvoider(
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: requestCardType == RequestCardType.pending ? ColorUtils.backgroundBlack : ColorUtils.foregroundBlack,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30).r,
                  topRight: Radius.circular(30).r,
                )),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8).h,
                  child: Column(
                    children: [
                      Container(
                        height: 5.h,
                        width: 75.h,
                        decoration: BoxDecoration(
                            color: ColorUtils.textWhite.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(50).r,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
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
                                height: 20.h,
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
                                  color: requestCardType == RequestCardType.pending ? ColorUtils.foregroundBlack : ColorUtils.backgroundBlack,
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
                      SizedBox(height: 15.h),
                      if(requestCardType == RequestCardType.approved)
                        Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.textWhite,
                          borderRadius: BorderRadius.circular(8).r,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0).h,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0).h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF405E7B),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth: ScreenUtil().screenWidth / 2,
                                      ),
                                      child: Text(
                                        requestType,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.h,
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                                          size: 15.h,
                                        ),
                                        SizedBox(width: 4.h),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: Text(
                                            createdDate,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.workEntryHead,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0).h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 3.h),
                                          Flexible(
                                            child: Text(
                                              airTicketData.ticketData?.airLineName ?? '--',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w600,
                                                color: ColorUtils.workEntryHead,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8.h,
                                            height: 8.h,
                                            decoration: BoxDecoration(
                                              color: requestStatusColor(airTicketData.reqStatusLabel ?? ''),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          Flexible(
                                            child: Text(
                                              airTicketData.reqStatusLabel ?? '--',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.h,
                                                fontWeight: FontWeight.w500,
                                                color: requestStatusColor(airTicketData.reqStatusLabel ?? ''),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Container(
                                    width: 9.h,
                                    height: 17.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(34.h),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomPaint(
                                      size: Size(200, 1),
                                      painter: DottedHorizontalLinePainter(color: ColorUtils.workEntryHead.withValues(alpha: 0.6)),
                                    ),
                                  ),
                                  Container(
                                    width: 9.h,
                                    height: 17.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(34.h),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0).h,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        airTicketData.fromLocation ?? '--',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Image.asset(
                                      'assets/images/air_ticket/aeroplance_grey.png',
                                      height: 17.h,
                                    ),
                                    SizedBox(width: 10.h),
                                    Expanded(
                                      child: Text(
                                        airTicketData.toLocation ?? '--',
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.workEntryHead,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0).h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   'Dubai, UAE',
                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: GoogleFonts.poppins(
                                          //     fontSize: 10.h,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                          //   ),
                                          // ),
                                          Text(
                                            airTicketData.ticketData?.departureTime ?? '--',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.h,
                                              fontWeight: FontWeight.w500,
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    if(airTicketData.ticketData?.arrivalTime != null && airTicketData.ticketData?.departureTime != null)
                                      Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEAEAEA),
                                          borderRadius: BorderRadius.circular(90).r,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                          horizontal: 8.h,
                                        ),
                                        child: Text(
                                          airTicketData.ticketData?.duration ?? duration,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 9.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.workEntryHead,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // Text(
                                          //   'Cochin, India',
                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: GoogleFonts.poppins(
                                          //     fontSize: 10.h,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                          //   ),
                                          // ),
                                          Text(
                                            airTicketData.ticketData?.arrivalTime ?? '--',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.h,
                                              fontWeight: FontWeight.w500,
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0).h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Date: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            requestDate,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.workEntryHead,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20.h),
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              airTicketData.ticketType == '1' ? 'One way' : airTicketData.ticketType == '2' ? 'Two way' : '--',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.h,
                                                fontWeight: FontWeight.w400,
                                                color: ColorUtils.workEntryHead,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ' | ',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.2),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${airTicketData.passengerData?.length ?? '0'} Passenger",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.h,
                                                fontWeight: FontWeight.w400,
                                                color: ColorUtils.workEntryHead,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomPaint(
                                      size: Size(200, 1),
                                      painter: DottedHorizontalLinePainter(color: ColorUtils.workEntryHead.withValues(alpha: 0.1)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              for(int i = 0; i < (airTicketData.passengerData?.length ?? 0); i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5).h,
                                  child: PassengerPersonWidget(passengerData: airTicketData.passengerData?[i]),
                                ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomPaint(
                                      size: Size(200, 1),
                                      painter: DottedHorizontalLinePainter(color: ColorUtils.workEntryHead.withValues(alpha: 0.1)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Passenger',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                            ),
                                          ),
                                          Text(
                                            getPassengerSummary(airTicketData.passengerData?.map((e) => e.toJson()).toList() ?? []),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.workEntryHead,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.end,
                                    //   children: [
                                    //     Text(
                                    //       'Price',
                                    //       overflow: TextOverflow.ellipsis,
                                    //       maxLines: 1,
                                    //       style: GoogleFonts.poppins(
                                    //         fontSize: 10.h,
                                    //         fontWeight: FontWeight.w400,
                                    //         color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       'AED 2300.00',
                                    //       overflow: TextOverflow.ellipsis,
                                    //       maxLines: 1,
                                    //       style: GoogleFonts.poppins(
                                    //         fontSize: 11.h,
                                    //         fontWeight: FontWeight.w400,
                                    //         color: ColorUtils.workEntryHead,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      )
                      else if(requestCardType == RequestCardType.pending)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8.h,
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: requestStatusColor(airTicketData.reqStatusLabel ?? ''),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 5.h),
                                      Flexible(
                                        child: Text(
                                          airTicketData.reqStatusLabel ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11.h,
                                            fontWeight: FontWeight.w400,
                                            color: requestStatusColor(airTicketData.reqStatusLabel ?? ''),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 40.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Created On : ',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    Text(
                                      createdDate,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    requestType,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w600,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                ),
                                if(requestType != 'Encashment')
                                  SizedBox(width: 40.h),
                                if(requestType != 'Encashment')
                                  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Request Date : ',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    Text(
                                      requestDate,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            if(requestType == 'Company Booking')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'From: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            airTicketData.fromLocation ?? '--',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5.h),
                                  Flexible(
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'To: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            airTicketData.toLocation ?? '--',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11.h,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            if(requestType == 'Company Booking')
                              SizedBox(height: 10.h),
                            if(requestType == 'Company Booking')
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${airTicketData.ticketType == '1' ? 'One way' : airTicketData.ticketType == '2' ? 'Two way' : '--'} | ${airTicketData.passengerData?.length ?? '0'} Passenger',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Container(
                              padding: EdgeInsets.only(top: 18.h),
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.all(Radius.circular(12).r),
                                // border: Border.all(
                                //   color: ColorUtils.workEntryHead.withValues(
                                //     alpha: 0.1,
                                //   ),
                                // ),
                              ),
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12).r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12).r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  fillColor: ColorUtils.foregroundBlack,
                                  filled: true,
                                  label: Text(
                                    "Reason",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.h,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                  hintText: airTicketData.reqDescription,
                                  hintStyle: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.h,
                                    color: ColorUtils.textWhite,
                                  ),
                                  contentPadding: EdgeInsets.all(15.h),
                                ),
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: ColorUtils.workEntryHead,
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 15.h),
                      if(requestCardType == RequestCardType.approved)
                        InkWell(
                          borderRadius: BorderRadius.circular(37).r,
                          onTap: () async {
                            await Get.find<AirTicketController>().downloadMultipleFiles(airTicketData.ticketData?.ticketAttachment ?? []);
                          },
                            child: GetX<AirTicketController>(
                              builder: (AirTicketController controller) {
                                return LoyaltriBlueTextButton(text: controller.fileDownloading.value ? "Downloading..." : "Download Ticket");
                              }
                            ),
                        ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  String getPassengerSummary(List<Map<String, dynamic>> data) {
    int adults = 0;
    int children = 0;
    int infants = 0;

    for (var passenger in data) {
      String type = passenger["passengerType"]?.toString().toLowerCase() ?? '';
      if (type == "adult") {
        adults++;
      } else if (type == "child") {
        children++;
      } else if (type == "infant") {
        infants++;
      }
    }

    List<String> parts = [];
    if (adults > 0) parts.add("$adults Adult${adults > 1 ? 's' : ''}");
    if (children > 0) parts.add("$children Child${children > 1 ? 'ren' : ''}");
    if (infants > 0) parts.add("$infants Infant${infants > 1 ? 's' : ''}");

    return parts.join(", ");
  }

}

class PassengerPersonWidget extends StatelessWidget {
  final PassengerData? passengerData;
  const PassengerPersonWidget({super.key, this.passengerData});

  @override
  Widget build(BuildContext context) {
    String age = '-';
    try {
      DateTime dateOfBirth = DateTime.parse(passengerData?.dateOfBirth ?? '');
      int difference = DateTime.now().year - dateOfBirth.year;
      age = difference.toString();
    } catch(e) {}
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000).r,
                child: CachedNetworkImage(
                  imageUrl: '',
                  height: 30.h,
                  width: 30.h,
                  alignment: Alignment.center,
                  placeholder: (context, url) {
                    return Container(
                      width: 30.h,
                      height: 30.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 18.h,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      width: 30.h,
                      height: 30.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 18.h,
                        ),
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8.h),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passengerData?.name ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.h,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                      ),
                    ),
                    Text(
                      passengerData?.email ?? '--',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.h,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${passengerData?.gender ?? '--'}, $age',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 11.h,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
              ),
            ),
            Text(
              'Adult',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 11.h,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



