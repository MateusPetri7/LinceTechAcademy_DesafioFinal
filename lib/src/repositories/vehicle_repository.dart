import 'dart:convert';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_model_model.dart';
import '../services/exceptions.dart';
import '../services/http_client.dart';

abstract class IVehicleRepository {
  Future<List<VehicleBrandModel>> getVehicleBrands(String type);

  Future<List<VehicleModelModel>> getVehicleModels(String brandCode);
}

class VehicleRepository implements IVehicleRepository {
  final IHttpClient client;

  VehicleRepository({required this.client});

  @override
  Future<List<VehicleBrandModel>> getVehicleBrands(String type) async {
    final response = await client.get(
      url: 'https://fipe.parallelum.com.br/api/v2/$type/brands',
    );

    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => VehicleBrandModel.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      throw NotFoundException('Página não encontrada.');
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException('Erro do servidor interno.');
    } else {
      throw Exception('Não foi possível encontrar as informações do veículo');
    }
  }

  @override
  Future<List<VehicleModelModel>> getVehicleModels(String brandCode) async {
    final response = await client.get(
      url:
          'https://fipe.parallelum.com.br/api/v2/cars/brands/$brandCode/models',
    );

    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => VehicleModelModel.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      throw NotFoundException('Página não encontrada.');
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException('Erro do servidor interno.');
    } else {
      throw Exception('Não foi possível encontrar as informações do veículo');
    }
  }
}
