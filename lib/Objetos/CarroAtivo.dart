import 'Localizacao.dart';

class CarroAtivo {
  String user_id;
  bool isAtivo;
  String user_nome;
  String carro_id;
  Localizacao localizacao;

  CarroAtivo(      {
          this.carro_id,

        this.isAtivo,
         this.user_nome,
         this.user_id,
      this.localizacao}
      );

  Map<String, dynamic> toJson() {
    return {
      "carro_id": this.carro_id,
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
      carro_id: json["carro_id"],
      localizacao: json['localizacao'] == null? null: Localizacao.fromJson(json["localizacao"]),
    );
  }
}
