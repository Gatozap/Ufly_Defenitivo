import 'package:google_maps_flutter/google_maps_flutter.dart';

class OfertaCorrida {
  String motorista;
  String requisicao;
  String id;
  String id_usuario;
  DateTime data;
  String motivo_cancelamento;

  double preco ;

  OfertaCorrida({this.motorista, this.motivo_cancelamento,this.requisicao, this.id, this.data, this.id_usuario,
      this.preco});

  @override
  String toString() {
    return 'OfertaCorrida{motorista: $motorista, requisicao: $requisicao,id_usuario:$id_usuario ,id: $id,motivo_cancelamento:$motivo_cancelamento, data: $data, preco: $preco}';
  }

  OfertaCorrida.fromJson( json)
      : motorista = json['motorista'],
        requisicao = json['requisicao'],
        id = json['id'],
        motivo_cancelamento = json['motivo_cancelamento'],
        id_usuario = json['id_usuario'],

        data = json['data']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["data"]),

        preco = json['preco'];

  Map<String, dynamic> toJson() => {
        'motorista': motorista,
        'requisicao': requisicao,
'motivo_cancelamento': motivo_cancelamento,
        'id': id,
    'id_usuario': id_usuario,
        'data': this.data == null? null: this.data.millisecondsSinceEpoch,

        'preco': preco,
      };


}