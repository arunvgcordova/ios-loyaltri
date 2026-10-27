import 'dart:ui';

class WorkExpenseModel {
  final int id;
  final String title;
  final Color color;

  const WorkExpenseModel(
      {required this.id, required this.title, required this.color});
}

List<WorkExpenseModel> workExpenseList = [
  const WorkExpenseModel(id: 0, color: Color(0xFFF8A24E), title: "Pending"),
  const WorkExpenseModel(id: 1, color: Color(0xFFD40000), title: "Rejected"),
  const WorkExpenseModel(id: 2, color: Color(0xFF50BC61), title: "Approved"),
];

class WorkExpenseSubmitModel {
  final int companyId;
  final int employeId;
  final int categoryId;
  final String discription;
  final num amount;
  final String expenseDate;
  final String saleryMonthYear;
  final String? reference;
  final int createdBy;

  const WorkExpenseSubmitModel({
    required this.companyId,
    required this.employeId,
    required this.categoryId,
    required this.discription,
    required this.amount,
    required this.expenseDate,
    required this.saleryMonthYear,
    this.reference,
    required this.createdBy,
  });
}