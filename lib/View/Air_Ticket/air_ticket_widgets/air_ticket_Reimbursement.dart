
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_controller/air_ticket_controller.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/models/manager/air_ticket_list_api_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../AirTicketHome.dart';
import 'air_ticket_bottomSheet.dart';

class AirTicketReimbursement extends StatelessWidget {
  final RequestCardType requestCardType;
  final AirTicketData airTicketData;
  const AirTicketReimbursement({super.key, required this.requestCardType, required this.airTicketData});

  @override
  Widget build(BuildContext context) {
    String createdDate = '--';
    String requestDate = '--';
    String requestType = Get.find<AirTicketController>().getTicketTypeName(Get.find<AirTicketController>().getDartTicketType(airTicketData.reqType)) ?? '--';
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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return AirTicketBottomSheet(
                requestCardType: RequestCardType.pending,
              airTicketData: airTicketData,
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.foregroundBlack,
          borderRadius: BorderRadius.circular(14).r,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0).h,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorUtils.gunMetal,
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
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: requestCardType == RequestCardType.companyBooking ? 10.h : 0.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(requestCardType == RequestCardType.companyBooking)
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                      )
                    else if(requestCardType == RequestCardType.reimbursement)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Amount: ',
                            style: GoogleFonts.poppins(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.textWhite.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            airTicketData.reqAmount ?? '--',
                            style: GoogleFonts.poppins(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Image.asset(
                            'assets/images/air_ticket/air_ticket.png',
                            height: 30.h,
                            fit: BoxFit.fitHeight,
                          )
                        ],
                      )
                    else
                      SizedBox(height: 20.h),
                    if(requestCardType == RequestCardType.companyBooking)
                      SizedBox(width: 5.h),
                    if(requestCardType == RequestCardType.companyBooking)
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                    Padding(
                      padding: EdgeInsets.only(left: 50.h),
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
                          Text(
                            airTicketData.reqStatusLabel ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w500,
                              color: requestStatusColor(airTicketData.reqStatusLabel ?? ''),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if(requestCardType == RequestCardType.companyBooking)
                Padding(
                padding: EdgeInsets.only(
                  bottom: 5.h,
                ),
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
                            color: ColorUtils.textWhite.withValues(alpha: 0.7),
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
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.h),
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
                    )
                  ],
                ),
              ),
              if(requestCardType != RequestCardType.companyBooking)
                Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 3.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requestCardType == RequestCardType.companyBooking ? 'Reason: ' : 'Description: ',
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.textWhite.withValues(alpha: 0.7),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        airTicketData.reqDescription ?? '--',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
        ),
      ),
    );
  }
}
