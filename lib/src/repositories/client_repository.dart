import 'dart:convert';
import '../models/client_model.dart';
import '../services/exceptions.dart';
import '../services/http_client.dart';

/// A repository responsible for fetching client data using an HTTP client.
class ClientRepository {
  /// Instance of [HttpClient] used for making HTTP requests.
  final HttpClient client;

  /// Constructs a ClientRepository with the required HTTP client dependency.
  ClientRepository({required this.client});

  /// Fetches client data from an external API using the provided
  /// company registration number.
  ///
  /// Throws a [NotFoundException] if the company registration number
  /// is not found in the external API.
  ///
  /// Throws an [Exception] for any other errors encountered during the
  /// HTTP request or JSON decoding process.
  Future<ClientModel> getClientData(String companyRegistrationNumber) async {
    final response =
        await client.get(url: 'https://brasilapi.com.br/api/cnpj/v1/$companyRegistrationNumber');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return ClientModel.fromJson(body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('CNPJ não encontrado na API Minha Receita');
    } else {
      throw Exception('Não foi possível encontrar o CNPJ');
    }
  }
}
