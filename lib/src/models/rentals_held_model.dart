class RentalsHeldModel {
  String? id;
  String? clientId;
  DateTime? startDate;
  DateTime? endDate;
  int? numberOfDays;
  double? totalAmountPayable;

  RentalsHeldModel(
      {this.id,
      this.clientId,
      this.startDate,
      this.endDate,
      this.numberOfDays,
      this.totalAmountPayable});
}
