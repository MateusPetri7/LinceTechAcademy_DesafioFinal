/// A model class representing a vehicle brand.
class VehicleBrandModel {
  /// The unique code of the vehicle brand.
  final String code;

  /// The name of the vehicle brand.
  final String name;

  /// Creates a [VehicleBrandModel] instance with the given properties.
  ///
  /// Both [code] and [name] are required.
  VehicleBrandModel({required this.code, required this.name});

  /// Creates a [VehicleBrandModel] instance from a JSON object.
  ///
  /// The JSON object must contain the following keys:
  /// - 'code': The unique code of the vehicle brand.
  /// - 'name': The name of the vehicle brand.
  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) {
    return VehicleBrandModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
