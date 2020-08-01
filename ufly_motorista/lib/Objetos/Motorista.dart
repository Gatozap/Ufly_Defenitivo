import 'Carro.dart';

class Motorista{
  String foto;
  String nome;
  double rating;
  Carro carro;
  bool agua;
  bool wifi;
  bool balas;
  double preco;
   bool isOnline;
  DateTime tempo;
  Motorista({this.foto, this.nome, this.rating, this.carro, this.agua, this.wifi,
      this.balas, this.preco, this.isOnline, this.tempo});

  @override
  String toString() {
    return 'Motorista{foto: $foto,tempo, $tempo nome: $nome, rating: $rating, carro: $carro, agua: $agua, wifi: $wifi, balas: $balas, preco: $preco, isOnline: $isOnline}';
  }

  Motorista.fromJson(Map<String, dynamic> json)
      : foto = json['foto'],
        nome = json['nome'],

        tempo = json['tempo'],
        rating = json['rating'],
        carro = json['carro']== null? Carro.fromJson(json['carro']): null,
        agua = json['agua'],
        wifi = json['wifi'],
        balas = json['balas'],
        preco = json['preco'],
        isOnline = json['isOnline'];

  Map<String, dynamic> toJson() => {
        'foto': foto,
        'nome': nome,
        'rating': rating,
        'carro': carro,  'tempo': tempo,
        'agua': agua,
        'wifi': wifi,
        'balas': balas,
        'preco': preco,
        'isOnline': isOnline,
      };
  
}