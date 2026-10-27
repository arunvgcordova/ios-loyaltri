
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_controller/air_ticket_controller.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/air_ticket_Reimbursement.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/air_ticket_approved.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/air_ticket_widgets/air_ticket_tabView.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import '../../models/manager/air_ticket_list_api_model.dart';
import '../../services/attachment_service.dart';
import '../../utils/color_utils.dart';
import 'air_ticket_widgets/air_ticket_createSheet.dart';

enum RequestCardType {reimbursement, companyBooking, encashment, approved, pending, rejected}

class AirTicketHome extends StatefulWidget {
  const AirTicketHome({super.key});

  @override
  State<AirTicketHome> createState() => _AirTicketHomeState();
}

class _AirTicketHomeState extends State<AirTicketHome> {
  AirTicketController airTicketController = Get.find<AirTicketController>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    await airTicketController.fetchAirTicketCreatedList(context: context);
    context.loaderOverlay.hide();
    await airTicketController.fetchAirTicketDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).h,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14).r,
                      child: Material(
                        color: ColorUtils.foregroundBlack,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 48.h,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.backgroundBlack,
                              borderRadius: BorderRadius.circular(14).r,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5).h,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorUtils.textWhite,
                                  size: 18.h,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14).r,
                      child: Material(
                        color: ColorUtils.secondaryBlue,
                        child: InkWell(
                          onTap: () {
                            airTicketController.selectedFieldNumber.value = 0;
                            // showModalBottomSheet(
                            //   context: context,
                            //   backgroundColor: Colors.transparent,
                            //   barrierColor: ColorUtils.workEntryHead,
                            //   isScrollControlled: true,
                            //   useSafeArea: true,
                            //   builder: (context) {
                            //     airTicketController.airTicketCreateData.value = AirTicketCreatingModel();
                            //     AttachmentService().selectedFiles.value = [];
                            //     return AirTicketCreateSheet();
                            //   },
                            // );
                            airTicketController.airTicketCreateData.value = AirTicketCreatingModel();
                            AttachmentService().selectedFiles.value = [];
                            Navigator.of(context).push(
                              newSlideNavigation(AirTicketCreateSheet()),
                            );
                          },
                          child: Container(
                            width: 48.h,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryBlue,
                              borderRadius: BorderRadius.circular(14).r,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: ColorUtils.textWhite,
                                size: 25.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 8).h,
                child: AirTicketTabView(
                  onTabClick: (int tabIndex) {
                    airTicketController.currentTabIndex = tabIndex;
                    airTicketController.filterByStatus();
                  },
                ),
              ),
              SizedBox(height: 5.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await airTicketController.fetchAirTicketCreatedList(context: context);
                  },
                  child: GetX<AirTicketController>(
                    builder: (AirTicketController controller) {
                      List<AirTicketData> airTicketList = controller.airTicketList.value;
                      if(controller.airTicketListLoading.value) {
                        return LayoutBuilder(
                            builder: (context, constraints) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Center(
                                    child: Text(
                                      "Loading...",
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                        fontSize: 12.h,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      } else if(airTicketList.isNotEmpty) {
                        return ListView.separated(
                            itemCount: airTicketList.length,
                            padding: EdgeInsets.only(
                              left: 10.h,
                              right: 10.h,
                              top: 5.h,
                              bottom: 10.h,
                            ),
                            itemBuilder: (context, index) {
                              String reqType = airTicketList[index].reqType?.toString() ?? '';
                              if(airTicketList[index].reqStatusLabel?.toString().toLowerCase() == 'approved' && reqType == 'companyBooking') {
                                return AirTicketApproved(
                                    airTicketData: airTicketList[index],
                                );
                              } else {
                                return AirTicketReimbursement(
                                    requestCardType: controller.getDartTicketType(reqType) ?? RequestCardType.reimbursement,
                                  airTicketData: airTicketList[index],
                                );
                              }
                            },
                            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.h));
                      } else {
                        return LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: IntrinsicHeight(
                                    child: Center(
                                      child: Text(
                                        "No Data Found",
                                        style: GoogleFonts.inter(
                                          color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                          fontSize: 12.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
