import 'Localizacao.dart';

class CarroAtivo {
  String user_id;
  bool isAtivo;
  String user_nome;

  Localizacao localizacao;

  CarroAtivo(
      {

        this.isAtivo = true,
         this.user_nome,
         this.user_id,
      this.localizacao});

  Map<String, dynamic> toJson() {
    return {

      'isAtivo': this.isAtivo,
         'user_id': this.user_id,
      'user_nome': this.user_nome,
      "localizacao": this.localizacao == null? null: this.localizacao.toJson(),
    };
  }

  factory CarroAtivo.fromJson( json) {
    return CarroAtivo(
      user_nome: json['user_nome'],
      isAtivo: json['isAtivo'],
      user_id: json['user_id'],
      localizacao: json['localizacao'] == null? null: Localizacao.fromJson(json["localizacao"]),
    );
  }
}
