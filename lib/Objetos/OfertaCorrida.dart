import 'package:google_maps_flutter/google_maps_flutter.dart';

class OfertaCorrida {
  String motorista;
  String requisicao;
  String id;
  String id_usuario;
  DateTime data;
  String forma_pagamento;

  double preco ;

  OfertaCorrida({this.motorista, this.requisicao, this.id, this.data,this.forma_pagamento, this.id_usuario,
      this.preco});

  @override
  String toString() {
    return 'OfertaCorrida{motorista: $motorista, requisicao: $requisicao,id_usuario:$id_usuario ,forma_pagamento: $forma_pagamento,id: $id, data: $data, preco: $preco}';
  }

  OfertaCorrida.fromJson( json)
      : motorista = json['motorista'],
        requisicao = json['requisicao'],
        id = json['id'],
        id_usuario = json['id_usuario'],
        forma_pagamento = json['forma_pagamento'],
        data = json['data']== null? null: DateTime.fromMicrosecondsSinceEpoch(json["data"]),

        preco = json['preco'];

  Map<String, dynamic> toJson() => {
        'motorista': motorista,
        'requisicao': requisicao,
    'forma_pagamento':forma_pagamento,
        'id': id,
    'id_usuario': id_usuario,
        'data': this.data == null? null: this.data.millisecondsSinceEpoch,

        'preco': preco,
      };


}