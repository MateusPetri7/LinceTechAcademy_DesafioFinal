/// A model class representing a rent.
class RentModel {
  /// The unique identifier of the rent.
  String? id;

  /// The state where the rent is being accomplished.
  String? rentState;

  /// The unique identifier for the client involved in the rent.
  String? clientId;

  /// The unique identifier for the vehicle involved in the rent.
  String? vehicleId;

  /// The start date of the rent period.
  DateTime? startDate;

  /// The end date of the rent period.
  DateTime? endDate;

  /// The number of days the vehicle is rented.
  int? numberOfDays;

  /// The total amount payable for the rent.
  double? totalAmountPayable;

  /// The percentage of the commission for the manager.
  String? percentageManagerCommission;

  /// The value of the manager's commission.
  double? managerCommissionValue;

  /// Creates a [RentModel] instance with the given properties.
  ///
  /// All parameters are optional.
  RentModel(
      {this.id,
      this.rentState,
      this.clientId,
      this.vehicleId,
      this.startDate,
      this.endDate,
      this.numberOfDays,
      this.totalAmountPayable,
      this.percentageManagerCommission,
      this.managerCommissionValue});
}
