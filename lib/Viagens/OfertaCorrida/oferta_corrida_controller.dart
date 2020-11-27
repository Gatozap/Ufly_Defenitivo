
import 'package:bloc_pattern/bloc_pattern.dart';


import 'package:rxdart/subjects.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';

class OfertaCorridaController extends BlocBase {
  BehaviorSubject<OfertaCorrida> ofertaCorridaController = new BehaviorSubject<OfertaCorrida>();

  Stream<OfertaCorrida> get outOfertaCorrida => ofertaCorridaController.stream;
  Sink<OfertaCorrida> get inOfertaCorrida => ofertaCorridaController.sink;

  OfertaCorridaController(OfertaCorrida pp) {
    inOfertaCorrida.add(pp);
  }

  @override
  void dispose() {
    ofertaCorridaController.close();
  }
}