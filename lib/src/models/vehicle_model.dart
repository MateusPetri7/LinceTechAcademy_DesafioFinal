class VehicleModel {
  String? id;
  String? type;
  String? brand;
  String? model;
  String? plate;
  int? yearManufacture;
  double? dailyRentalCost;
  List<String>? photosTheVehicle;

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
