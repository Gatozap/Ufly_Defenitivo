import 'dart:convert';

import 'package:ufly/Helpers/Helper.dart';

import 'Carro.dart';

class Motorista{
  String foto;
  String nome;
  String id;
  String id_usuario;
  String nome_usuario;
  String id_carro;
   List favoritos;
  double rating;
  double rating_total;
  double rating_quantidade;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  List<Carro> carro;
  bool agua;
  bool wifi;
  bool viagem;
  bool entrega;
  bool balas;

   bool isOnline;


  Motorista.Empty();
  Motorista({this.foto, this.nome, this.rating, this.rating_total, this.rating_quantidade,this.carro, this.agua, this.wifi, this.id_carro,   this.created_at,
    this.updated_at,
    this.deleted_at,
    this.viagem ,
    this.entrega ,
      this.balas,  this.isOnline, this.id, this.nome_usuario, this.id_usuario, this.favoritos});


  @override
  String toString() {
    return 'Motorista{foto: $foto,rating_total: $rating_total, rating_quantidade: $rating_quantidade, nome: $nome, id: $id, id_usuario: $id_usuario, nome_usuario: $nome_usuario, id_carro: $id_carro, favoritos: $favoritos, rating: $rating,  created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, carro: $carro, agua: $agua, wifi: $wifi, viagem: $viagem, entrega: $entrega, balas: $balas,  isOnline: $isOnline}';
  }

  Motorista.fromJson(j)
      : this.foto = j['foto'] == null? null: j['foto'],
        this.nome = j['nome'] == null? null: j['nome'],

         this.viagem = j['viagem'],
 this.        entrega = j['entrega'],
 this. id_carro = j['id_carro'] == null? null: j['id_carro'],
 this.       favoritos= j['favoritos'] == null ? null : Helper().jsonToList(j["favoritos"]),

 this.       rating = j['rating'] == null? 5.0: j['rating'],
this.       rating_quantidade = j['rating_quantidade']== null? 1.0: j['rating_quantidade'],
this.       rating_total = j['rating_total'] == null? 5.0: j['rating_total'],
 this.        id_usuario = j['id_usuario'] == null? null: j['id_usuario'],
 this. nome_usuario = j['nome_usuario'] == null? null: j['nome_usuario'],
 this. id = j['id'] == null? null: j['id'],
        this.created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
  this.updated_at = j['updated_at'] == null
  ? null
      : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
  this.deleted_at = j['deleted_at'] == null
  ? null
      : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
       this. agua = j['agua'],
       this. wifi = j['wifi'],
       this. balas = j['balas'],
        this.carro = j['carro'] == null ? null : getCarros(json.decode(j['carro'])),

       this. isOnline = j['isOnline']== null? false: j['isOnline'];

  Map<String, dynamic> toJson() => {
        'foto': foto ==null? null: this.foto,
        'nome': nome == null? null: this.nome,
        'rating': rating ,
    'rating_total': rating_total ,
    'rating_quantidade': rating_quantidade ,


        'agua': agua,
        'wifi': wifi,
         'viagem': viagem,
         'entrega': entrega,
    'id_carro': id_carro == null? null: this.id_carro,
    'id': id == null? null: this.id,
  'created_at' :
  this.created_at != null ? this.created_at.millisecondsSinceEpoch : null,
  'updated_at' :
  this.updated_at != null ? this.updated_at.millisecondsSinceEpoch : null,
  'deleted_at' :
  this.deleted_at != null ? this.deleted_at.millisecondsSinceEpoch : null,
    'id_usuario': id_usuario == null? null: this.id_usuario,
    'nome_usuario': nome_usuario == null? null: this.nome_usuario,
        'balas': balas,

    "favoritos": this.favoritos == null ? null : this.favoritos,
        'isOnline': isOnline == null? null: this.isOnline,
  'carro' : this.carro == null ? null : json.encode(this.carro),
      };
  static getCarros(decoded) {
    List<Carro> carros = [];
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      carros.add(Carro.fromJson(i));
    }
    return carros;
  }
}