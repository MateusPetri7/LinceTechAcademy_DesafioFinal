/// A model class representing a vehicle.
class VehicleModel {
  /// The unique identifier for the vehicle.
  String? id;
  /// The type of the vehicle.
  String? type;
  /// The brand of the vehicle.
  String? brand;
  /// The model name of the vehicle.
  String? model;
  /// The license plate number of the vehicle.
  String? plate;
  /// The year the vehicle was manufactured.
  int? yearManufacture;
  /// The daily rental cost of the vehicle.
  double? dailyRentalCost;
  /// A list of paths to photos of the vehicle.
  List<String>? photosTheVehicle;

  /// Creates a [VehicleModel] instance with the given properties.
  ///
  /// All parameters are optional.
  VehicleModel(
      {this.id,
      this.type,
      this.brand,
      this.model,
      this.plate,
      this.yearManufacture,
      this.dailyRentalCost,
      this.photosTheVehicle});
}
