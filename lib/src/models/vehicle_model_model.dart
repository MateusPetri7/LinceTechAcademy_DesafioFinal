class VehicleModelModel {
  final String code;
  final String name;

  VehicleModelModel({required this.code, required this.name});

  factory VehicleModelModel.fromJson(Map<String, dynamic> json) {
    return VehicleModelModel(
      code: json['code'],
      name: json['name'],
    );
  }
}