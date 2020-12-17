import 'package:ufly/Objetos/Endereco.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Rota.dart';
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
  String forma_de_pagamento;
  Rota rota;
  var tempo_estimado;
  var distancia;
  List ofertas;
  OfertaCorrida aceito;


  @override
  String toString() {
    return 'Requisicao{id: $id, user: $user,isViagem: $isViagem,forma_de_pagamento: $forma_de_pagamento,user_nome:$user_nome, motoristas_chamados: $motoristas_chamados, created_at: $created_at, valid_until: $valid_until, updated_at: $updated_at, deleted_at: $deleted_at, destino: $destino, origem: $origem, rota: $rota, tempo_estimado: $tempo_estimado, distancia: $distancia, ofertas: $ofertas, aceito: $aceito}';
  }


  Requisicao.fromJson(json)
      : id = json['id'],
        forma_de_pagamento=json['forma_de_pagamento'],
        user_nome = json['user_nome'],
        isViagem = json['isViagem'],
        user = json['user'],
        motoristas_chamados = json['motoristas_chamados'],
        created_at = json['created_at'] == null? null: DateTime.fromMicrosecondsSinceEpoch(json["created_at"]),
        valid_until = json['valid_until']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["valid_until"]),
        updated_at = json['updated_at']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["updated_at"]),
        deleted_at = json['deleted_at']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["deleted_at"]),
        destino = json['destino'] == null? null : Endereco.fromJson(json['destino']),
        origem = json['origem'] == null? null: Endereco.fromJson(json['origem']),
        rota = json['rota'] == null? null: Rota.fromJson(json['rota']),
        tempo_estimado = json['tempo_estimado'],
        distancia = json['distancia'],
        ofertas = json['ofertas'],
        aceito = json['aceito'] == null? null: OfertaCorrida.fromJson(json['aceito']);

  Map<String, dynamic> toJson() => {
    'isViagem': isViagem,
        'id': id,
        'user': user,
    'user_nome': user_nome,
    'forma_de_pagamento': forma_de_pagamento,
        'motoristas_chamados': motoristas_chamados,
        'created_at': this.created_at == null? null: this.created_at.millisecondsSinceEpoch,
        'valid_until': this.valid_until == null? null: this.valid_until.millisecondsSinceEpoch,
        'updated_at': this.updated_at == null? null: this.updated_at.millisecondsSinceEpoch,
        'deleted_at': this.deleted_at == null? null: this.deleted_at.millisecondsSinceEpoch,
        'destino': destino == null? null: this.destino.toJson(),
        'origem': origem == null? null: this.origem.toJson(),
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
      this.origem,
      this.rota,
      this.tempo_estimado,
      this.distancia,
      this.ofertas,
       this.forma_de_pagamento,
      this.aceito});

  encodeOfertas(){
    List perg = new List();
    for(OfertaCorrida p in ofertas){
      perg.add(p.toJson());
    }
    return perg;
  }
  static decodeOfertas(j){
    if(j == null){
      return null;
    }
    List<OfertaCorrida> ofertas= new List();
    for(var v in j){
      ofertas.add(OfertaCorrida.fromJson(v));
    }
    return ofertas;
  }
}