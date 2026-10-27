import 'package:get/get.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';

class ApiConstants {
  static String appVersion = "3.1.0";
  static String matomoUrl = "https://log.bmark.in/";
  static String matomoSiteId = "14";

  Map<String, String> apiHeader = {
    'Authorization':
        'Bearer ${Get.find<UserAuthController>().userData.value.userData?.token ?? 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJMT1lBTFRSSSBTRVJWRVIiLCJhdWQiOiJMT1lBTFRSSSBDTElFTlQiLCJzdWIiOiJBVVRIRU5USUNBVElPTiIsImlhdCI6MTcyNDkzMDU5NCwidXNlck5hbWUiOiJhZG1pbiJ9.WftJvLCgEd9lJYfrjbBeKWdfn1g5FT_5HkOiYhJB8ds'}',
    'Content-Type': 'application/json',
  };

  // Map<String, String> apiHeader = {
  //   "API-KEY": "525-777-777",
  //   "Content-Type": "application/json",
  // };

  //============================Test Url=====================================

  // static String apiLink = "local";
  // String domain = "http://192.168.0.11/loyaltri-server"; // test
  // String addPunch = "https://alpha-punch-api.loyaltri.com/api"; // test
  // String payRoll = "https://alpha-payroll-api.loyaltri.com"; // test
  // String feedsMain = "https://alpha-feeds-api.loyaltri.com"; // test
  // String resetLink = "https://alpha.loyaltri.com/setnewpassword";
  // String growth = "https://alpha-growth-api.loyaltri.com/api"; // test

  // static String apiLink = "alpha";
  // String domain = "https://alpha-api.loyaltri.com"; // test
  // String addPunch = "https://alpha-punch-api.loyaltri.com/api"; // test
  // String payRoll = "https://alpha-payroll-api.loyaltri.com"; // test
  // String feedsMain = "https://alpha-feeds-api.loyaltri.com"; // test
  // String resetLink = "https://alpha.loyaltri.com/setnewpassword";
  // String growth = "https://alpha-growth-api.loyaltri.com/api"; // test
  // String loyaltriField = "https://field-dev-api.loyaltri.com/api/app"; // test

  //============================Test Url=====================================

  // static String apiLink = "staging";
  // String domain = "https://staging-api.loyaltri.com"; // test
  // String addPunch = "https://staging-punch-api.loyaltri.com/api"; // test
  // String payRoll = "https://staging-payroll-api.loyaltri.com"; // test
  // String feedsMain = "https://staging-feeds-api.loyaltri.com"; // test
  // String resetLink = "https://staging.loyaltri.com/setnewpassword";
  // String growth = "https://staging-growth-api.loyaltri.com/api"; // test

  //============================Demo Url=====================================

  // static String apiLink = "demo";
  // String domain = "https://demo-api.loyaltri.com"; // test
  // String addPunch = "https://demo-punch-api.loyaltri.com/api"; // test
  // String payRoll = "https://demo-payroll-api.loyaltri.com"; // test
  // String feedsMain = "https://demo-feeds-api.loyaltri.com"; // test
  // String resetLink = "https://demo.loyaltri.com/setnewpassword";
  // String growth = "https://demo-growth-api.loyaltri.com/api"; // test

  // //============================Live Url=====================================

  static String apiLink = "web";
  String domain = "https://web-api.loyaltri.com"; // live
  String addPunch = "https://web-punch-api.loyaltri.com/api"; // live
  String payRoll = "https://web-payroll-api.loyaltri.com"; // live
  String feedsMain = "https://web-feeds-api.loyaltri.com";
  String resetLink = "https://web.loyaltri.com/setnewpassword";
  String growth = "https://web-growth-api.loyaltri.com/api"; // live
  String loyaltriField = "https://field-api.loyaltri.com/api/app"; // live

  // static String apiLink = "dev";
  // String domain = "https://dev-api.loyaltri.com"; // live
  // String addPunch = "https://dev-punch-api.loyaltri.com/api"; // live
  // String payRoll = "https://dev-payroll-api.loyaltri.com"; // live
  // String feedsMain = "https://dev-feeds-api.loyaltri.com"; // test
  // String resetLink = "https://dev.loyaltri.com/setnewpassword";
  // String growth = "https://dev-growth-api.loyaltri.com/api"; // test
  // String loyaltriField = "https://field-dev-api.loyaltri.com/api/app"; // test

  String loginUrl = "/AdminLogin";
  String baseUrl = "/api/main";
  String fileHandler = "/api/fileHandler";
  String faceAuthUrl =
      "http://43.242.212.168:7001/FaceBio/FaceAuthenticate_PNG_PNG";
  // String workEntrySubmit = "https://web-api.loyaltri.com/api/fileHandler";
  // String workEntrySubmit = "https://demo-api.loyaltri.com/api/fileHandler";

  String leaveListAction = "showEmployeeLeaveDetails";
  // String leaveListAction = "getEmployeeLeaveDetailsById";
  String applyLeaveAction = "createEmployeeLeaveApplication";
  String leaveSummaryAction = "getEmployeeLeaveSummaryById";
  String getLeaveTypesWithCompanyId = "getLeaveTypesWithCompanyId";
  String leaveTypeAction = "getEmployeeLeaveType";
  String attendanceListAction = "getFilteredAttandanceDetails";
  String attendanceCycle = "getCurrentCycleMonth";
  String attendanceDetailAction = "getAttendanceLogs";
  String employeeDetailsAction = "getEmployeeById";
  String companyDetailsAction = "getCompanyById";
  String workEntryAction = "getMonthwiseWorkEntry";
  String workEntrySendAction = "saveWorkEntry";
  String forgotPswAction = "forgotPassword";
  String sendCheckInAction = "addEmployeePunch";
  String calendarEventAction = "calender";
  String versionCheckHeader = "mobileAppVesionCheck";
  // String attSummaryAction = "attendanceSummary";
  String attSummaryAction = "getEmployeeWiseAttendanceSummary";
  String punchTypeAction = "getEmployeePunchMethod";
  String checkInAction = "getCheckIn";
  String workExpenseCategory = "getAllWorkExpenseCategroy";
  String submitWorkExpenseAction = "saveEmployeeWorkExpense";
  String workExpenseAttachAction = "EmployeeWorkExpenseFileUpload";
  String workExpenseListAction = "getAllEmployeeMyWorkExpense";
  String payrollAction = "employeeProfileMonthlySalaryApp";
  String genPayPdf = "/genPayPdf";
  String regularizationSubmitAction = "regularizeAttendance";
  String myExcuseReqAction = "getRegularizatonRequestList";
  String myRequestListAction = "getAllSpecialRequest";
  String workFromHomeSubmitAction = "saveSpecialRequest";
  String uploadProfilePicAction = "ProfilePicUpload";
  String addBreakAction = "applyBreak";
  String upcomingShiftsAction = "getUpcomingShiftByEmployeeId";
  String leaveDetailsAction = "getEmployeeLeaveDetailsById";
  String holidayDetailsAction = "showHoliday";
  String leaveCycleAction = "getLeaveParameters";
  String userNotifications = "request";
  String getAllSpecialRequestType = "getAllSpecialRequestType";
  String getSpecialRequestByEmployeeId = "getSpecialRequestByEmployeeId";
  String saveShiftSwapRequest = "saveShiftSwapRequest";
  String saveAttendanceRequest = "saveAttendanceRequest";
  String getAllResignationReasonList = "getAllResignationReasonList";
  String getEmployeeDocuments = "getEmployeeDocuments";
  String getEmployeeAssetsById = "getEmployeeAssetsbyId";
  String saveResignationRequest = "saveResignationRequest";
  String getAllLoanPolicies = "getAllLoanPolicies";
  String getAllITRequestType = "getAllITRequestType";
  String getAllWorkPlaceType = "getAllWorkPlaceType";
  String employeeLoanRequestSave = "employeeLoanRequestSave";
  String saveITRequest = "saveITRequest";
  String saveWorkPlaceRequest = "saveWorkPlaceRequest";
  String saveOtherRequest = "saveOtherRequest";
  String saveSalaryAdvanceRequest = "saveSalaryAdvanceRequest";
  String changePassword = "changePassword";

  // Manager
  String managerAttendanceSummary = "getSuperiorEmployeeWiseAttendanceSummary";
  String getHierarchyEmployeeAttendanceDetails =
      "getHierachyEmployeeAttandanceDetails";
  String getAllShiftAction = "getAllShift";
  String employeeAttendanceDetail = "getEmployeeAttendanceDetailById";
  String editAttendanceSubmit = "employeeAttendanceAction";
  String paidLeaveSubmit = "employeeLeaveFromAttendance";
  String allExcuseList = "getHierarchyRegularizingRequestList";
  String filteredExcuseList =
      "getHierarchyCompletedRegularizingRequestDateList";
  String excuseSubmit = "attendancePardonOrFine";
  String deductionDetailsAction = "getEmployeeAttendanceDeductionById";
  String getEmployeeAttendanceOverTimeById = "getEmployeeAttendanceOverTimeById";
  String punchReqListAction = "getHierarchyPunchRequestList";
  String approveRejectPunch = "rejectOrApprovePunch";
  String overtimeRequestList = "getHierarchyOverTimeRequestList";
  String wfhAndLrAction = "getAllSpecialRequestForApproval";
  String wfhLrApproval = "approveSpecialRequest";
  String letterRequestFileUpload = "LetterRequestFileUpload";
  String employeeLeaveList = "showEmployeeLeaveById";
  String leaveRequestUpdate = "updateEmployeeLeaveApplicationById";
  String updateEmployeeHourLeaveApplicationById = "updateEmployeeHourLeaveApplicationById";
  String deleteLeaveApplication = "deleteEmployeeLeaveApplication";
  String employeeLeaveData = "getEmployeeleaveData";
  String fineAmountCalculate = "calculateAmountWithPolicy";
  String actionCenter = "actionCenter";
  String getAllEmployee = "getAllEmployee";
  String nextSevenDaysLeave = "upComingSevenDaysLeave";
  String getAllFeeds = "getAllFeeds";
  String getAllCompanyList = "getAllCompany";
  String getAllLocation = "getAllLocation";
  String getAllCategory = "getAllCategory";
  String getAllDepartment = "getAllDepartment";
  String saveFeeds = "saveFeeds";
  String feedsFileUpload = "FeedsFileUpload";
  String likeFeed = "saveLikes";
  String saveComments = "saveComments";
  String deleteCommentsById = "deleteCommentsById";
  String locationFilter = "getAllLocation";
  String shiftSchemeFilter = "getAllShiftSchemesByCompanyId";
  String punchTypeFilter = "getPunchType";
  String overtimeSubmission = "rejectOrApproveOverTime";
  String taskDashCount = "taskDashbordCount";
  String taskListData = "getTaskList";
  String getTemplateList = "getTemplateList";
  String getTaskExtraFields = "getTaskExtrafields";
  String taskDetailed = "getTaskById";
  String createNewTask = "createNewTask";
  String updateTaskStatus = "updateTaskStatus";
  String taskDelete = "taskDelete";
  String airTicketList = "getAirTicketRequestByEmployeeId";
  String airTicketDetails = "getAirTicketTypeByEmployeeId";
  String airTicketRequest = "airTicketRequest";
  String getPieceWorkList = "getPieceWorkList";
  String getAllPieceRate = "getAllPieceRate";
  String savePieceRatePayment = "savePieceRatePayment";
  String deletePieceRate = "deletePieceRate";
  String getRegularizingEmployeeDetail = "getRegularizingEmployeeDetail";
  String getToken = "getToken";
  String checkCompanyMonthPayoutList = "checkCompanyMonthPayoutList";
  String employeeDocumentFileUpload = "EmployeeDocumentFileUpload";
  String getAllDocumentType = "getAllDocumentType";
  String getCountryStateCity = "getCountryStateCity";

  // growth
  String visionMission = "/organisation/details";
  String homePercentage = "/rating/get-my-performance";
  String getEvaluationList = "/rating/get-my-evaluation-list";
  String getMoodPulse = "/get-mood-plus-by-employee";
  String saveMoodPulse = "/save-mood-plus";
  String goalsAndSubGoals = "/get-employee-goals";
  String goalComments = "/goal/comment/list";
  String commentGoal = "/goal/comment";
  String goalDetails = "/goal/details";
  String saveGoal = "/goal";
  String deleteGoal = "/goal/remove";
  // String updateGoal = "/goal/:id";
  String updateGoal = "/goal/edit";
  String timePeriod = "/time-period";
  String getSubGoals = "getSubGoals";
  String subGoalTaskList = "/get-task-goals";
  String unlinkTask = "/unlink-goal-from-task";
  String savePerformance = "/rating/save";

  // Shift Scheduler
  String getAllShiftSchemesByCompanyIdWithFilter = "getAllShiftSchemesByCompanyIdWithFilter";
  String getAllEmployeeWithShiftSchemeId = "getAllEmployeeWithShiftSchemeId";
  String saveRosterShiftScheduler = "saveRosterShiftScheduler";

 // <------------------ Loyaltri Field ---------------------> //
  String getWorkLogList = "/work-logs/by-date";
  String getWorkLogDetail = "/work-logs/detail/#id";
  String geCustomerList = "/customers/#company_id?search=#search&emp_id=#emp_id";
  String getCustomerDetail = "/customers/detail/#id";
  String addCustomer = "/customers";
  String customerTemplateForm = "/customer-template-fields/#company_id";
  String getWorkType = "/work-types/#company_id";
  String addWorkLog = "/work-logs";
  String uploadFile = "/customers/#company_id/attachments";
  String syncActivity = "/employee-live-track";
  String syncTrackV2Locations = "/employee-live-track-v2/locations";
  String deleteRoutePoint = "/employee-live-track/route-points/#id";
  String getTimeLineActivity = "/employee-live-track/#employee_id?date=#date";
  String getTrackV2Sessions = "/employee-live-track-v2/employees/#employee_id/sessions";
  String getTrackV2SessionDetail = "/employee-live-track-v2/sessions/#id";
  String getWorkFormDetils = "/work-types/detail/#id";
  String submitWork = "/work-submissions";
  String home = "/home?employee_id=#employee_id&frequency=#frequency";
  String homeCustom = "/home?employee_id=#employee_id&frequency=#frequency&start_date=#start_date&end_date=#end_date";
  String workStatusUpdate = "/work-instances/status";
  String otpOverride = "/override-requests/work-instance/#work_instance_id";
  String otpOverrideRequest = "/override-requests";
  String checkWorkInprogress= "/work-instances/in-progress-all";
  String sendDeviceInfo= "/employee-device-info";
  String checkEmployeWorkStatus= "/employee-live-track/in-work";
  String fetchFieldSettings = "/company-settings/#company_id";
   // <------------------ Loyaltri Field ---------------------> //
}
