import 'dart:convert';
import '../models/vehicle_model.dart';
import '../services/exceptions.dart';
import '../services/http_client.dart';

abstract class IVehicleRepository {
  Future<VehicleModel> getVehicleBrands();

  Future<VehicleModel> getVehicleModels();
}

class VehicleRepository implements IVehicleRepository {
  final IHttpClient client;

  VehicleRepository({required this.client});

  @override
  Future<VehicleModel> getVehicleBrands() async {
    final response = await client.get(
        url: 'https://fipe.parallelum.com.br/api/v2/cars/brands');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(response.body);
      return VehicleModel.fromJson(body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Página não encontrada.');
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException('Erro do servidor interno.');
    } else {
      throw Exception('Não foi possível encontrar as informações do veículo');
    }
  }

  @override
  Future<VehicleModel> getVehicleModels() async {
    final response = await client.get(
        url: 'https://fipe.parallelum.com.br/api/v2/cars/brands/23/models');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return VehicleModel.fromJson(body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Página não encontrada.');
    } else if (response.statusCode == 500) {
      throw InternalServerErrorException('Erro do servidor interno.');
    } else {
      throw Exception('Não foi possível encontrar as informações do veículo');
    }
  }
}
