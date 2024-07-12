/// A model class representing a vehicle model.
class VehicleModelModel {
  /// The unique code of the vehicle model.
  final String code;

  /// The name of the vehicle model.
  final String name;

  /// Creates a [VehicleModelModel] instance with the given properties.
  ///
  /// Both [code] and [name] are required.
  VehicleModelModel({required this.code, required this.name});

  /// Creates a [VehicleModelModel] instance from a JSON object.
  ///
  /// The JSON object must contain the following keys:
  /// - 'code': The unique code of the vehicle model.
  /// - 'name': The name of the vehicle model.
  factory VehicleModelModel.fromJson(Map<String, dynamic> json) {
    return VehicleModelModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
