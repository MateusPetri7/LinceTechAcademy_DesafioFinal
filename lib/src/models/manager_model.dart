/// A model class representing a manager.
class ManagerModel {
  /// The unique identifier for the manager.
  String? id;

  /// The name of the manager.
  String? name;

  /// The individual taxpayer registry number (e.g., CPF for
  /// Brazilian individuals).
  String? individualTaxpayerRegistry;
  /// The state where the manager is located.
  String? state;
  /// The telephone number of the manager.
  String? telephone;
  /// The commission percentage that the manager receives.
  String? commissionPercentage;

  /// Creates a [ManagerModel] instance with the given properties.
  ///
  /// All parameters are optional.
  ManagerModel(
      {this.id,
      this.name,
      this.individualTaxpayerRegistry,
      this.state,
      this.telephone,
      this.commissionPercentage});
}
