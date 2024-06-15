class ClientModel {
  String? id;
  String? name;
  String? telephone;
  String? city;
  String? state;
  ///Mudar para companyRegistrationNumber
  String? tin;

  ClientModel(
      {this.id, this.name, this.telephone, this.city, this.state, this.tin});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      name: json['razao_social'],
      telephone: json['ddd_telefone_1'],
      city: json['municipio'],
      state: json['uf'],
      tin: json['cnpj'],
    );
  }
}
