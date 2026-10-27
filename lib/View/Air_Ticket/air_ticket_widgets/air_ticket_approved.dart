
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/air_ticket_bottomSheet.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import '../../../models/manager/air_ticket_list_api_model.dart';
import '../../../utils/color_utils.dart';
import '../AirTicketHome.dart';
import '../air_ticket_controller/air_ticket_controller.dart';

class AirTicketApproved extends StatelessWidget {
  final AirTicketData airTicketData;
  const AirTicketApproved({super.key, required this.airTicketData});

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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) {
              return AirTicketBottomSheet(
                  requestCardType: RequestCardType.approved,
                airTicketData: airTicketData,
              );
            },
        );
      },
      child: Container(
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
                        color: ColorUtils.workEntryHead,
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
                      color: ColorUtils.workEntryHead,
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
                      color: ColorUtils.workEntryHead,
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
            ],
          ),
        ),
      ),
    );
  }
}

class DottedHorizontalLinePainter extends CustomPainter {
  final Color color;
  final double dotWidth;
  final double spaceWidth;

  DottedHorizontalLinePainter({
    required this.color,
    this.dotWidth = 4,
    this.spaceWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = size.height;

    double y = 0;
    while (y < size.width) {
      canvas.drawLine(Offset(y, 0), Offset(y + dotWidth, 0), paint);
      y += dotWidth + spaceWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

String? calculateDuration(String departure, String arrival) {
  if (departure.isEmpty || arrival.isEmpty) return null;

  DateFormat format = DateFormat("HH:mm");

  DateTime dep = format.parse(departure);
  DateTime arr = format.parse(arrival);

  if (arr.isBefore(dep)) {
    arr = arr.add(Duration(days: 1));
  }

  return formatDuration(arr.difference(dep));
}

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;

  String hrLabel = hours == 1 ? 'hr' : 'hrs';
  String minLabel = minutes == 1 ? 'min' : 'mins';

  return "$hours$hrLabel $minutes$minLabel";
}