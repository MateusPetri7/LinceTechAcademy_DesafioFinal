class RentalsHeldModel {
  String? id;
  String? clientId;
  String? vehicleId;
  DateTime? startDate;
  DateTime? endDate;
  int? numberOfDays;
  double? totalAmountPayable;

  RentalsHeldModel(
      {this.id,
      this.clientId,
      this.vehicleId,
      this.startDate,
      this.endDate,
      this.numberOfDays,
      this.totalAmountPayable});
}
