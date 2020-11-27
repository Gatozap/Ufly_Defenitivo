import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Ativo.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/Localizacao.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class AtivosController extends BlocBase {
  BehaviorSubject<List<CarroAtivo>> ativosController =
  BehaviorSubject<List<CarroAtivo>>();
  Stream<List<CarroAtivo>> get outAtivos => ativosController.stream;
  Sink<List<CarroAtivo>> get inAtivos => ativosController.sink;
  Map<String, DatabaseReference> corridasRef;

  BehaviorSubject<Map> localizacoesController = BehaviorSubject<Map>();
  Stream<Map> get outLocalizacoes => localizacoesController.stream;
  Sink<Map> get inLocalozacoes => localizacoesController.sink;
  List<CarroAtivo> ativos;
  AtivosController() {
    carrosAtivosRef.onValue.listen((v) {
      ativos = new List();
      print("AQUI D ${v.snapshot.value}");
      v.snapshot.value.forEach((k,d){
        print("AQUI V${d}");
        CarroAtivo ca = CarroAtivo.fromJson(d);
        if(ca.isAtivo) {
          ativos.add(ca);
        }
      });
      inAtivos.add(ativos);
    });
  }

  @override
  void dispose() {
    ativosController.close();
  }

  Map localizacoes;
  void PegarLocalizacoes() {
    if (localizacoes == null) {
      localizacoes = Map();
    }
    corridasRef.forEach((k, dr) {
      List positions = new List();
      dr.onValue.listen((points) {
        positions = new List();
        if (points.snapshot.value.toString() != 'null') {
          var pts = points.snapshot.value;
          pts.forEach((k, v) {
            positions.add(v);
          });
          positions.sort((var a, var b) {
            return a['timestamp'].compareTo(b['timestamp']);
          });
        }
        try {
          localizacoes[k] = positions.last != null ? positions.last : null;
        }catch(err){
          print('Error $err');
        }
        inLocalozacoes.add(localizacoes);
      });
    });
  }
}
