import 'dart:convert';
import '../models/client_model.dart';
import '../services/exceptions.dart';
import '../services/http_client.dart';

abstract class IClientRepository {
  Future<ClientModel> getClientData(String tin);
}

class ClientRepository implements IClientRepository {
  final IHttpClient client;

  ClientRepository({required this.client});
  @override
  Future<ClientModel> getClientData(String tin) async {
    final response = await client.get(
      url: 'https://brasilapi.com.br/api/cnpj/v1/$tin'
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return ClientModel.fromJson(body);
    } else if (response.statusCode == 404){
      throw NotFoundException('CNPJ não encontrado na API Minha Receita');
    } else {
      throw Exception('Não foi possível encontrar o CNPJ');
    }
  }
}