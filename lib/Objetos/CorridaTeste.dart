

import 'package:ufly/Objetos/Localizacao.dart';




class Corrida {
  String id;
  bool isRunning;
  String user;
  String id_corrida;
  String id_carro;
  String points_path;
  var dist;
  List points;

  Corrida({
    this.id,

    this.isRunning,

    this.user,
    this.dist,

    this.id_carro,

    this.points_path,
    this.id_corrida,
    this.points,
  });

  @override
  String toString() {
    return 'Corrida{id: $id, isRunning: $isRunning,  user: $user,  id_corrida: $id_corrida, id_carro: $id_carro, dist: $dist, points: $points}';
  }

  factory Corrida.fromJson(j) {
    return Corrida(
        id: j["id"],

        isRunning: j["isRunning"],


        user: j["user"],
        points_path : j['points_path'],
        id_corrida: j["id_corrida"],
        id_carro: j["id_carro"],
        dist: j["dist"],
        points: j['points'] == null ? null : getLocalizacoes(j['points']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,

        'isRunning': isRunning,
    'points_path': points_path,

        'id_carro': id_carro,
        'id_corrida': id_corrida,
        'dist': dist,
        'user': user,
        'points': EncodePoints(points),
      };

  static getLocalizacoes(decoded) {
    List<Localizacao> localizacoes = [];
    try {
      List points = decoded;
      if (decoded == null) {
        return null;
      }
      for (var v in points) {
        localizacoes.add(Localizacao.fromJson(v));
      }
    } catch (err) {}
    return localizacoes;
  }




  EncodePoints(List points) {
    List pointsJson = [];
    if (points == null) {
      return pointsJson;
    }
    for (Localizacao l in points) {
      pointsJson.add(l.toJson());
    }
    return pointsJson;
  }
}
