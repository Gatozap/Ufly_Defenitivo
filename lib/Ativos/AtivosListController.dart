import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';

import 'package:ufly/Helpers/References.dart';

class AtivosListController extends BlocBase {
  List<CarroAtivo> ativos;
  BehaviorSubject<List<CarroAtivo>> ativosController =
      BehaviorSubject<List<CarroAtivo>>();
  Stream<List<CarroAtivo>> get outAtivos => ativosController.stream;
  Sink<List<CarroAtivo>> get inAtivos => ativosController.sink;


  AtivosListController() {
    carrosAtivosRef.once().then((v) {
      ativos = new List();
      v.value.forEach((k, d) {
        CarroAtivo ca = CarroAtivo.fromJson(d);

          ativos.add(ca);

      });
      ativos.sort((a, b){
        DateTime tempDatea = DateTime.now().subtract(Duration(days: 3000));
        DateTime tempDateb = DateTime.now().subtract(Duration(days: 3000));
        if(a.localizacao != null){
          tempDatea = a.localizacao.timestamp;
        }
        if(b.localizacao != null){
          tempDateb = b.localizacao.timestamp;
        }
        return tempDateb.compareTo(tempDatea);
      });
      inAtivos.add(ativos);
    });
  }

  @override
  void dispose() {
    ativosController.close();
  }
}
