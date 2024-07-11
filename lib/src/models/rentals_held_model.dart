/// A model class representing a rental held.
class RentalsHeldModel {
  /// The unique identifier of the rental held.
  String? id;
  /// The unique identifier for the client involved in the rental held.
  String? clientId;
  /// The unique identifier for the vehicle involved in the rental held.
  String? vehicleId;
  /// The start date of the rental period.
  DateTime? startDate;
  /// The end date of the rental period.
  DateTime? endDate;
  /// The number of days the vehicle is rented.
  int? numberOfDays;
  /// The total amount payable for the rental held.
  double? totalAmountPayable;

  /// Creates a [RentalsHeldModel] instance with the given properties.
  ///
  /// All parameters are optional.
  RentalsHeldModel(
      {this.id,
      this.clientId,
      this.vehicleId,
      this.startDate,
      this.endDate,
      this.numberOfDays,
      this.totalAmountPayable});
}
