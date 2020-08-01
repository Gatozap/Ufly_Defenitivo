class Passageiro{
  String nome;
  bool sexo;
  int viagens;
  bool daCarteira;
  double lat;
  double lng;
  String foto;

  Passageiro({
      this.nome, this.sexo, this.viagens, this.daCarteira, this.lat, this.lng, this.foto});

  @override
  String toString() {
    return 'Passageiro{nome: $nome, sexo: $sexo,foto:$foto, viagens: $viagens, daCarteira: $daCarteira, lat: $lat, lng: $lng}';
  }

  Passageiro.fromJson(Map<String, dynamic> json)
      : nome = json['nome'],
        sexo = json['sexo'],
        foto = json['foto'],
        viagens = json['viagens'],
        daCarteira = json['daCarteira'],
        lat = json['lat'],
        lng = json['lng'];

  Map<String, dynamic> toJson() => {

    'nome': nome,
    'foto': foto,
        'sexo': sexo,
        'viagens': viagens,
        'daCarteira': daCarteira,
        'lat': lat,
        'lng': lng,
      };
}