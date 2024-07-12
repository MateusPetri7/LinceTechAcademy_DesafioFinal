/// A model class representing a client.
class ClientModel {
  /// The unique identifier for the client.
  String? id;

  /// The name of the client.
  String? name;

  /// The telephone number of the client.
  String? telephone;

  /// The city where the client is located.
  String? city;

  /// The state where the client is located.
  String? state;

  /// The company registration number (e.g., CNPJ for Brazilian companies).
  String? companyRegistrationNumber;

  /// The identifier for the manager associated with the client.
  String? managerId;

  /// Creates a [ClientModel] instance with the given properties.
  ///
  /// All parameters are optional.
  ClientModel(
      {this.id,
      this.name,
      this.telephone,
      this.city,
      this.state,
      this.companyRegistrationNumber,
      this.managerId});

  /// Creates a [ClientModel] instance from a JSON object.
  ///
  /// The JSON object must contain the following keys:
  /// - 'razao_social': The name of the client.
  /// - 'ddd_telefone_1': The telephone number of the client.
  /// - 'municipio': The city where the client is located.
  /// - 'uf': The state where the client is located.
  /// - 'cnpj': The company registration number of the client.
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      name: json['razao_social'],
      telephone: json['ddd_telefone_1'],
      city: json['municipio'],
      state: json['uf'],
      companyRegistrationNumber: json['cnpj'],
    );
  }
}
