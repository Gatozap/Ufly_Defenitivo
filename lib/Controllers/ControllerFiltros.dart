
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/FiltroMotorista.dart';

class ControllerFiltros extends BlocBase{
  BehaviorSubject<FiltroMotorista> controllerFiltro = new BehaviorSubject<FiltroMotorista>();
  Stream<FiltroMotorista> get outFiltro => controllerFiltro.stream;
  Sink<FiltroMotorista> get inFiltro => controllerFiltro.sink;
  FiltroMotorista filtroMotorista;

  ControllerFiltros(){
    FiltroMotorista filtro = FiltroMotorista(
      documento_veiculo: false,
        viagem: true,
        favorito: Helper.localUser.id,
        entregas: false,
        mtbom: false,
        bom: false,
        isOnline: false,
        isOffline: false,
        ruim: false,
        pessimo: false,
        reset: false,
        dinheiro: false,
        cartao: false,
        isCarro: false,
        isMoto: false,
        todas: false,
        basico: false,
        luxo: false,
        portaMalasGrande: false,
        seisPassageiros: false,
        motoristaMulher: false,
        chofer: false,

    );
    inFiltro.add(filtro);
  }

  @override
  void dispose() {
    controllerFiltro.close();
  }

}