

import 'Carro.dart';
import 'User.dart';

class Ativo {
  String id;
  String id_corrida;
  String id_usuario;


  User usuario;
  Carro carro;
  DateTime dataIni;
  DateTime dataFim;
  bool isActive;

  Ativo({this.id, this.id_corrida, this.id_usuario,
      this.usuario, this.carro, this.dataIni, this.dataFim,
      this.isActive});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "id_corrida": this.id_corrida,
      "id_usuario": this.id_usuario,

      "usuario": this.usuario == null? null: this.usuario.toJson(),
      "carro": this.carro == null? null: this.carro.toJson(),
      "dataIni": this.dataIni == null? null: this.dataIni.millisecondsSinceEpoch,
      "dataFim": this.dataFim == null? null: this.dataFim.millisecondsSinceEpoch,
      "isActive": this.isActive,
    };
  }

  factory Ativo.fromJson(Map<String, dynamic> json) {
    return Ativo(id: json["id"],
      id_corrida: json["id_corrida"],
      id_usuario: json["id_usuario"],
      usuario: json["usuario"] == null? null: User.fromJson(json["usuario"]),
      carro: json["carro"] == null? null: Carro.fromJson(json["carro"]),
      dataIni:json["dataIni"] == null? null: DateTime.fromMicrosecondsSinceEpoch(json["dataIni"]),
      dataFim:json["dataFim"] == null? null: DateTime.fromMicrosecondsSinceEpoch(json["dataFim"]),
      isActive: json["isActive"],);
  }




}