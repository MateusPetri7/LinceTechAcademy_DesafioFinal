class ClientModel {
  String? id;
  String name;
  String telephone;
  String city;
  String state;
  String tin;

  ClientModel(
      {this.id,
      required this.name,
      required this.telephone,
      required this.city,
      required this.state,
      required this.tin});
}
