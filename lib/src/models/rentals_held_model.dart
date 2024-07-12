/// A model class representing a rental held.
class RentalsHeldModel {
  /// The unique identifier of the rental held.
  String? id;

  /// The state where the rental is being accomplished.
  String? rentalState;

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

  /// The percentage of the commission for the manager.
  String? percentageManagerCommission;

  /// The value of the manager's commission.
  double? managerCommissionValue;

  /// Creates a [RentalsHeldModel] instance with the given properties.
  ///
  /// All parameters are optional.
  RentalsHeldModel(
      {this.id,
      this.rentalState,
      this.clientId,
      this.vehicleId,
      this.startDate,
      this.endDate,
      this.numberOfDays,
      this.totalAmountPayable,
      this.percentageManagerCommission,
      this.managerCommissionValue});
}
