import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ControllerFiltros implements BlocBase {
  BehaviorSubject<bool> boolController = new BehaviorSubject<bool>();

  Stream<bool> get outBool => boolController.stream;

  Sink<bool> get inBool => boolController.sink;

  bool viagem;
  bool entregas;
  bool mtbom;
  bool bom;
  bool ruim;
  bool pessimo;
  bool reset;
  bool dinheiro;
   bool cartao;
  bool carros;
  bool moto;
  bool todas;
  bool basico;
  bool luxo;
  bool portaMalasGrande;
  bool seisPassageiros;
  bool motoristaMulher;
  bool chofer;
  






  @override
  void dispose() {
    boolController.close();

  }

}