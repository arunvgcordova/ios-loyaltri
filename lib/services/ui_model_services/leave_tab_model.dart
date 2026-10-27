
import 'dart:ui';

import '../../utils/color_utils.dart';

class LeaveTabModel {
  final int id;
  final Color color;
  final String title;

  const LeaveTabModel({required this.id, required this.color, required this.title});
}

List<LeaveTabModel> leaveTabItem = [
  const LeaveTabModel(id: 0, color: Color(0xFF50BC61), title: "Approved"),
  const LeaveTabModel(id: 1, color: Color(0xFFF8A24E), title: "Pending"),
  const LeaveTabModel(id: 2, color: Color(0xFFD40000), title: "Rejected"),
];

List<LeaveTabModel> workExpenseTabItem = [
  const LeaveTabModel(id: 0, color: Color(0xFFF8A24E), title: "Pending"),
  const LeaveTabModel(id: 1, color: Color(0xFF50BC61), title: "Approved"),
  const LeaveTabModel(id: 2, color: Color(0xFFD40000), title: "Rejected"),
];

List<LeaveTabModel> myExcuseTabItem = [
  const LeaveTabModel(id: 0, color: ColorUtils.textWhite, title: "All"),
  const LeaveTabModel(id: 1, color: Color(0xFFF8A24E), title: "Pending"),
  const LeaveTabModel(id: 2, color: Color(0xFF50BC61), title: "Pardoned"),
  const LeaveTabModel(id: 3, color: Color(0xFFD40000), title: "Applied Fine"),
];

List<LeaveTabModel> airTicketTabItem = [
  const LeaveTabModel(id: 0, color: ColorUtils.textWhite, title: "All"),
  const LeaveTabModel(id: 1, color: Color(0xFFFFCD82), title: "Pending"),
  const LeaveTabModel(id: 2, color: Color(0xFF50BC61), title: "Approved"),
  const LeaveTabModel(id: 3, color: Color(0xFFD40000), title: "Rejected"),
];

List<LeaveTabModel> myRequestTabItem = [
  const LeaveTabModel(id: 0, color: ColorUtils.textWhite, title: "All"),
  const LeaveTabModel(id: 1, color: Color(0xFFF8A24E), title: "HR"),
  const LeaveTabModel(id: 2, color: Color(0xFF50BC61), title: "Finance"),
  const LeaveTabModel(id: 3, color: Color(0xFF50BC61), title: "Other"),
];

// List<LeaveTabModel> myRequestTabItem = [
//   const LeaveTabModel(id: 0, color: ColorUtils.textWhite, title: "All"),
//   const LeaveTabModel(id: 1, color: Color(0xFFF8A24E), title: "Work From Home"),
//   const LeaveTabModel(id: 2, color: Color(0xFF50BC61), title: "Letter Request"),
// ];