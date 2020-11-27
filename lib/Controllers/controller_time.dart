import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class ControllerTime implements BlocBase {

  BehaviorSubject<int> _controllerContagem = new BehaviorSubject<int>();

  Stream<int> get outContagem => _controllerContagem.stream;

  Sink<int> get inContagem => _controllerContagem.sink;

  BehaviorSubject<Timer> _controllerTimer = new BehaviorSubject<Timer>();

  Stream<Timer> get outTimer=> _controllerTimer.stream;

  Sink<Timer> get inTimer => _controllerTimer.sink;




  @override
  void dispose() {
    _controllerContagem.close();
    _controllerTimer.close();
  }

  ControllerTime(int contagem, Timer tempo){
   inContagem.add(contagem);
   inTimer.add(tempo);
  }
}