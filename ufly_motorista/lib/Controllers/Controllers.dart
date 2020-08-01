import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class Controllers implements BlocBase {
  BehaviorSubject<int> solicitacaoController = new BehaviorSubject<int>();

  Stream<int> get outSolicitacao => solicitacaoController.stream;

  Sink<int> get inSolicitacao => solicitacaoController.sink;

  int solicitacao;

  BehaviorSubject<int> contadorController = new BehaviorSubject<int>();

  Stream<int> get outContador => contadorController.stream;

  Sink<int> get inContador => contadorController.sink;

  Timer tempo;
    int contador;
  


  @override
  void dispose() {
    contadorController.close();
    solicitacaoController.close();
    // TODO: implement dispose
  }


}