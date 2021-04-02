
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/FiltroMotorista.dart';

class ControllerFiltros extends BlocBase{
  BehaviorSubject<FiltroMotorista> controllerFiltro = new BehaviorSubject<FiltroMotorista>();
  Stream<FiltroMotorista> get outFiltro => controllerFiltro.stream;
  Sink<FiltroMotorista> get inFiltro => controllerFiltro.sink;
  FiltroMotorista filtroMotorista;

  BehaviorSubject<double> controllerZoom = new BehaviorSubject<double>();
  Stream<double> get outZoom => controllerZoom.stream;
  Sink<double> get inZoom => controllerZoom.sink;
  double Zoom;

  BehaviorSubject<bool> controllerHide = new BehaviorSubject<bool>();
  Stream<bool> get outHide => controllerHide.stream;
  Sink<bool> get inHide => controllerHide.sink;
  bool hide;

  BehaviorSubject<bool> controllerPreenchimento = new BehaviorSubject<bool>();
  Stream<bool> get outPreenchimento => controllerPreenchimento.stream;
  Sink<bool> get inPreenchimento => controllerPreenchimento.sink;
  bool Preenchimento;

  BehaviorSubject<bool> controllerDesembarque = new BehaviorSubject<bool>();
  Stream<bool> get outDesembarque => controllerDesembarque.stream;
  Sink<bool> get inDesembarque => controllerDesembarque.sink;


  BehaviorSubject<bool> controllerRequisicaoChegou = new BehaviorSubject<bool>();
  Stream<bool> get outRequisicaoChegou=> controllerRequisicaoChegou.stream;
  Sink<bool> get inRequisicaoChegou => controllerRequisicaoChegou.sink;
  bool RequisicaoChegou;

  ControllerFiltros(){
    inHide.add(false);
    inZoom.add(0);
    inPreenchimento.add(false);
    FiltroMotorista filtro = FiltroMotorista(
      documento_veiculo: false,
        viagem: true,
        favorito: Helper.localUser.id,
        entregas: false,
        mtbom: false,
        bom: false,
        isOnline: false,

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
    controllerZoom.close();
    controllerFiltro.close();
    controllerHide.close();
    controllerRequisicaoChegou.close();
    controllerPreenchimento.close();
    controllerDesembarque.close();
  }

}