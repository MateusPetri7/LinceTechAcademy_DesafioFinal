import 'dart:convert';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_model_model.dart';
import '../services/exceptions.dart';
import '../services/http_client.dart';

/// Abstract class defining methods to fetch vehicle brands and models.
abstract class IVehicleRepository {
  /// Fetches a list of vehicle brands based on the specified type.
  ///
  /// Throws a [NotFoundException] if the page is not found (404).
  ///
  /// Throws an [InternalServerErrorException] if there's an internal server error
  /// (500).
  ///
  /// Throws an [Exception] for any other errors encountered during the
  /// HTTP request.
  Future<List<VehicleBrandModel>> getVehicleBrands(String type);

  /// Fetches a list of vehicle models based on the specified brand code.
  ///
  /// Throws a [NotFoundException] if the page is not found (404).
  ///
  /// Throws an [InternalServerErrorException] if there's an internal server error
  /// (500).
  ///
  /// Throws an [Exception] for any other errors encountered during the
  /// HTTP request.
  Future<List<VehicleModelModel>> getVehicleModels(String brandCode);
}

/// Implementation of [IVehicleRepository] using an [HttpClient] instance.
class VehicleRepository implements IVehicleRepository {
  /// Instance of [HttpClient] used for making HTTP requests.
  final HttpClient client;

  /// Constructs a [VehicleRepository] with the required client dependency.
  VehicleRepository({required this.client});

  @override
  Future<List<VehicleBrandModel>> getVehicleBrands(String type) async {
    final response = await client.get(
      url: 'https://fipe.parallelum.com.br/api/v2/$type/brands',
    );

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
