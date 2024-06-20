class VehicleBrandModel {
  final String code;
  final String name;

  VehicleBrandModel({required this.code, required this.name});

  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) {
    return VehicleBrandModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
