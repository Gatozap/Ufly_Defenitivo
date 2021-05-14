import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';

class MotoristaControllerChamado extends BlocBase {
  BehaviorSubject<Motorista> _controllerMotoristaChamado =
  new BehaviorSubject<Motorista>();

  Stream<Motorista> get outMotoristaChamado => _controllerMotoristaChamado.stream;

  Sink<Motorista> get inMotoristaChamado => _controllerMotoristaChamado.sink;
  Motorista motorista;


  MotoristaControllerChamado({Requisicao requisicao}) {

    // Fired whenever a location is recorded

    motoristaRef
        .get()
        .then((v) {

      List<Motorista> motoristas = [];
      for (var d in v.docs) {

        Motorista m = Motorista.fromJson(d.data());


        motoristas.add(m);
      }
      motorista = motoristas[0];
      inMotoristaChamado.add(motorista);

    }).catchError((err) {
      print('aqui erro moto 1 ${err}');
      motorista = null;
      inMotoristaChamado.add(motorista);
    });
  }

  @override
  void dispose() {
    _controllerMotoristaChamado.close(); // TODO: implement dispose
  }
}