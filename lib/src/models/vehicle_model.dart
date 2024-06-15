class VehicleModel {
  String? id;

  String? code;
  String? name;

  String? brand;
  String? model;
  String? plate;
  int? yearManufacture;
  double? dailyRentalCost;
  String? photosTheVehicle;

  VehicleModel(
      {this.id,
      this.code,
      this.name,
      this.brand,
      this.model,
      this.plate,
      this.yearManufacture,
      this.dailyRentalCost,
      this.photosTheVehicle});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
