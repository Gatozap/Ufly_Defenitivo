import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Objetos/Motorista.dart';

class MotoristaController implements BlocBase {
  BehaviorSubject<Motorista> motoristaController = new BehaviorSubject<Motorista>();

  Stream<Motorista> get outMotorista => motoristaController.stream;

  Sink<Motorista> get inMotorista => motoristaController.sink;

  Motorista motorista;


  @override
  void dispose() {
    // TODO: implement dispose
  }


}

