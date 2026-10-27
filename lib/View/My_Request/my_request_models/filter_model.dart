class RequestFilter {
  final bool approved;
  final bool pending;
  final bool rejected;
  final DateTime? fromDate;
  final DateTime? toDate;

  const RequestFilter(
      {required this.approved,
      required this.pending,
      required this.rejected,
      this.fromDate,
      this.toDate});
}
