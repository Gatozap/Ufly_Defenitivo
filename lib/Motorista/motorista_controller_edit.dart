import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Motorista.dart';

class MotoristaControllerEdit extends BlocBase {
  BehaviorSubject<Motorista> _controllerMotorista =
  new BehaviorSubject<Motorista>();

  Stream<Motorista> get outMotorista => _controllerMotorista.stream;

  Sink<Motorista> get inMotorista => _controllerMotorista.sink;
  Motorista motorista;

 
  MotoristaControllerEdit() {

    // Fired whenever a location is recorded

    motoristaRef.where('id_usuario', isEqualTo: Helper.localUser.id)
        .get()
        .then((v) {
      print('aqui carro 232');
      List<Motorista> motoristas = [];
      for (var d in v.docs) {
        print('aqui carro 232');
        Motorista m = Motorista.fromJson(d.data());
        print('aqui carro 232 ${m.toJson()}');

        motoristas.add(m);
      }
      motorista = motoristas[0];
      inMotorista.add(motorista);

    }).catchError((err) {
      print('aqui erro moto 1 ${err}');
      motorista = null;
      inMotorista.add(motorista);
    });
  }

  @override
  void dispose() {
    _controllerMotorista.close(); // TODO: implement dispose
  }
}