import 'dart:ui';

class Endereco {
  int id;
  int id_user;
  String cidade;
  String cep;
  String bairro;
  String endereco;
  String numero;
  String complemento;
  double lat;
  double lng;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  var isValid;
  var color;
  String estado;

  bool isSelected;

  Endereco.Empty();

  Endereco({
    this.id,
    this.id_user,
    this.cidade,
    this.cep,
    this.bairro,
    this.endereco,
    this.numero,
    this.complemento,
    this.lat,
    this.lng,
    this.estado,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  Endereco.fromJson(json) {
    print("ENDERECO DO LOGIN");
    this.id = json['id'] == null ? 0 : int.parse(json['id'].toString());
    this.id_user = json['id_user'] == null ? 0 : int.parse(json['id_user'].toString());
    this.cidade = json['cidade'] == null ? "" : json['cidade'];
    this.cep = json['cep'] == null ? "" : json['cep'];
    this.estado = json['estado'] == null? '':json['estado'];
    this.bairro = json['bairro'] == null ? "" : json['bairro'];
    this.endereco = json['endereco'] == null ? "" : json['endereco'];
    this.numero = json['numero'] == null ? "" : json['numero'];
    this.complemento = json['complemento'] == null ? "" : json['complemento'];
    this.lat = json['lat'] == null ? null : double.parse(json['lat'].toString());
    this.lng = json['lng'] == null ? null : double.parse(json['lng'].toString());
    this.created_at =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    this.updated_at =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
    this.deleted_at =
        json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at']);
  }


  String toQuery(){
    return '$numero, $endereco, $bairro, $cep, $cidade, $estado';
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.id_user;
    data['cidade'] = this.cidade;
    data['cep'] = this.cep;
    data['estado'] = this.estado;
    data['bairro'] = this.bairro;
    data['endereco'] = this.endereco;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['created_at'] = this.created_at== null? '': this.created_at.toIso8601String();
    data['updated_at'] = this.updated_at== null? '': this.updated_at.toIso8601String();
    data['deleted_at'] = this.deleted_at== null? '': this.deleted_at.toIso8601String();
    return data;
  }

  @override
  String toString() {
    return 'Endereco{id: $id, id_user: $id_user, cidade: $cidade, cep: $cep, bairro: $bairro, endereco: $endereco, numero: $numero, complemento: $complemento, lat: $lat, lng: $lng, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, isValid: $isValid, color: $color}';
  }
}
