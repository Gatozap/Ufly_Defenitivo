import 'package:ufly/Objetos/Endereco.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Rota.dart';
import 'package:ufly/Helpers/Helper.dart';
class Requisicao{
  String id;
  String user;
  String user_nome;
  String foto;
  bool isViagem;
  List motoristas_chamados;
  DateTime created_at,valid_until, updated_at,deleted_at;
  Endereco destino;
  Endereco origem;
  var primeiraParada_lat;
  var primeiraParada_lng;
  var segundaParada_lat;
  var segundaParada_lng;
  var terceiraParada_lat;
  var terceiraParada_lng;
  String forma_de_pagamento;
  Rota rota;
  var tempo_estimado;
  var distancia;
  List ofertas;
  OfertaCorrida aceito;


  @override
  String toString() {
    return 'Requisicao{id: $id, user: $user, user_nome: $user_nome, foto: $foto, isViagem: $isViagem, motoristas_chamados: $motoristas_chamados, created_at: $created_at, valid_until: $valid_until, updated_at: $updated_at, deleted_at: $deleted_at, destino: $destino, origem: $origem, primeiraParada_lat: $primeiraParada_lat, primeiraParada_lng: $primeiraParada_lng, segundaParada_lat: $segundaParada_lat, segundaParada_lng: $segundaParada_lng, terceiraParada_lat: $terceiraParada_lat, terceiraParada_lng: $terceiraParada_lng, forma_de_pagamento: $forma_de_pagamento, rota: $rota, tempo_estimado: $tempo_estimado, distancia: $distancia, ofertas: $ofertas, aceito: $aceito}';
  }

  Requisicao.fromJson(json)
      : id = json['id'] == null? null: json['id'],
        forma_de_pagamento = json['forma_de_pagamento'],
        user_nome = json['user_nome'],
        isViagem = json['isViagem'] == null? true : json['isViagem'],
        user = json['user'],
        motoristas_chamados = json['motoristas_chamados'] == null? null : Helper().jsonToList(json['motoristas_chamados']),
        created_at = json['created_at'] == null? null: DateTime.fromMicrosecondsSinceEpoch(json["created_at"]),
        valid_until = json['valid_until']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["valid_until"]),
        updated_at = json['updated_at']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["updated_at"]),
        deleted_at = json['deleted_at']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["deleted_at"]),
        destino = json['destino'] == null? null : Endereco.fromJson(json['destino']),
        primeiraParada_lat = json['primeiraParada_lat'] == null? null:  double.parse(json['primeiraParada_lat'].toString()),
        segundaParada_lat = json['segundaParada_lat']==null? null:  double.parse(json['segundaParada_lat'].toString()),
        terceiraParada_lat =json['terceiraParada_lat']==null? null:  double.parse(json['terceiraParada_lat'].toString()),
        primeiraParada_lng = json['primeiraParada_lng'] == null? null:  double.parse(json['primeiraParada_lng'].toString()),
        segundaParada_lng = json['segundaParada_lng'] == null? null:  double.parse(json['segundaParada_lng'].toString()),
        terceiraParada_lng =json['terceiraParada_lng'] == null? null:  double.parse(json['terceiraParada_lng'].toString()),
        origem = json['origem'] == null? null: Endereco.fromJson(json['origem']),
        rota = json['rota'] == null? null: Rota.fromJson(json['rota']),
        tempo_estimado = json['tempo_estimado'],
        distancia = json['distancia'],
        ofertas = json['ofertas'],
        aceito = json['aceito'] == null? null: OfertaCorrida.fromJson(json['aceito']);

  Map<String, dynamic> toJson() => {
    'isViagem': isViagem == null? true: this.isViagem,
        'id': id  == null? null: this.id,
        'user': user  == null? null: this.user,
    'user_nome': user_nome,
    'forma_de_pagamento': forma_de_pagamento,
        'motoristas_chamados': motoristas_chamados== null ? null : this.motoristas_chamados,
        'created_at': this.created_at == null? null: this.created_at.millisecondsSinceEpoch,
        'valid_until': this.valid_until == null? null: this.valid_until.millisecondsSinceEpoch,
        'updated_at': this.updated_at == null? null: this.updated_at.millisecondsSinceEpoch,
        'deleted_at': this.deleted_at == null? null: this.deleted_at.millisecondsSinceEpoch,
        'destino': destino == null? null: this.destino.toJson(),
        'origem': origem == null? null: this.origem.toJson(),
    'primeiraParada_lat': this.primeiraParada_lat == null ? null : this.primeiraParada_lat,
    'segundaParada_lat': this.segundaParada_lat == null ? null : this.segundaParada_lat,
    'terceiraParada_lat': this.terceiraParada_lat == null ? null : this.terceiraParada_lat,
    'primeiraParada_lng': this.primeiraParada_lng == null ? null : this.primeiraParada_lng,
    'segundaParada_lng': this.segundaParada_lng == null ? null : this.segundaParada_lng,
    'terceiraParada_lng': this.terceiraParada_lng == null ? null : this.terceiraParada_lng,
        'rota': rota == null? null: rota.toJson(),
        'tempo_estimado': tempo_estimado,
        'distancia': distancia,
        'ofertas': ofertas,
        'aceito': aceito == null? null: aceito.toJson(),
      };

  Requisicao(
     { this.id,
      this.user,
       this.user_nome,
       this.isViagem,
      this.motoristas_chamados,
      this.created_at,
      this.valid_until,
      this.updated_at,
      this.deleted_at,
      this.destino,
       this.primeiraParada_lat, this.segundaParada_lat, this.terceiraParada_lat,
       this.primeiraParada_lng, this.segundaParada_lng, this.terceiraParada_lng,
      this.origem,
      this.rota,
      this.tempo_estimado,
      this.distancia,
      this.ofertas,
       this.forma_de_pagamento,
      this.aceito});

  encodeOfertas(){
    List perg = [];
    for(OfertaCorrida p in ofertas){
      perg.add(p.toJson());
    }
    return perg;
  }
  static decodeOfertas(j){
    if(j == null){
      return null;
    }
    List<OfertaCorrida> ofertas=[];
    for(var v in j){
      ofertas.add(OfertaCorrida.fromJson(v));
    }
    return ofertas;
  }
}