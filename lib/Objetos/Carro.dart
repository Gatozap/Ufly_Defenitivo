import 'package:ufly/Objetos/Motorista.dart';

class Carro{
  String foto;
  String modelo;
  String categoria;
  String cor;
  int ano;
  String placa;
  String id;
  String foto_documento;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String id_motorista;
  String nome_motorista;
   Carro.Empty();
  Carro({this.foto, this.modelo, this.created_at, this.foto_documento,this.deleted_at, this.updated_at,this.placa, this.ano,this.categoria, this.id, this.id_motorista, this.nome_motorista, this.cor});

  @override
  String toString() {

    return 'Carro{foto: $foto, modelo: $modelo,created_at: $created_at,foto_documento: $foto_documento, deleted_at: $deleted_at, updated_at: $updated_at, categoria: $categoria,ano: $ano, placa: $placa, cor: $cor,id:$id, id_motorista: $id_motorista, nome_motorista: $nome_motorista}';

  }

  Carro.fromJson(json)
      :  this.foto = json['foto'] == null ? null : json['foto'],
  this.foto_documento = json['foto_documento'] == null? null : json['foto_documento'],
        this.created_at = json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['created_at']),
  this.updated_at = json['updated_at'] == null
  ? null
      : DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
  this.deleted_at = json['deleted_at'] == null
  ? null
      : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']),
  ano = json['ano'] == null? null: json['ano'],
  placa = json['placa'] == null? null: json['placa'],
        modelo = json['modelo'] == null? null: json['modelo'],
        id = json['id'] == null? null: json['id'],
  cor = json['cor'] == null? null: json['cor'],
        id_motorista = json['id_motorista'] == null? null: json['id_motorista'],
        nome_motorista = json['nome_motorista'] == null? null: json['nome_motorista'],
        categoria = json['categoria'] == null? null: json['categoria'];

  Map<String, dynamic> toJson() => {
        'foto': foto ==null? null: this.foto,
        'modelo': modelo == null? null: this.modelo,
    'ano': ano == null? null: this.ano,
    'foto_documento': foto_documento == null? null: this.foto_documento,
    'placa': placa == null? null: this.placa,
         'id': id == null? null: this.id,
    'cor': cor == null? null: this.cor,
    'deleted_at': deleted_at != null ? this.deleted_at.millisecondsSinceEpoch : null,
    'created_at': created_at != null ? this.created_at.millisecondsSinceEpoch : null,
    'updated_at': updated_at!= null ? this.updated_at.millisecondsSinceEpoch : null,
         'id_motorista': id_motorista == null? null: this.id_motorista,
         'nome_motorista': nome_motorista == null? null: this.nome_motorista,
        'categoria': categoria == null? null: this.categoria,
      };
}