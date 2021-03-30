import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Motorista/motorista_controller.dart';

import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';

class RequisicaoCorridaController extends BlocBase {

  BehaviorSubject<List<Requisicao>> RequisicaoController =
  BehaviorSubject<List<Requisicao>>();
  Stream<List<Requisicao>> get outRequisicoes => RequisicaoController.stream;
  Sink<List<Requisicao>> get inRequisicoes => RequisicaoController.sink;
  List<Requisicao> requisicoes;
  List<Requisicao> requisicoesmain;





 RequisicaoCorridaController()  {
    print('aqui essa porra 1 ${requisicoes}');
    requisicaoRef
        .snapshots()
        .listen((QuerySnapshot snap) {
      print('aqui essa porra 2 ${snap.docs.toString()}');
      List<Requisicao> requisicoes =  [];
      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {

          Requisicao r =  Requisicao.fromJson(ds.data());
          print('aqui essa porra 3 ${ds.id}');
          r.id = ds.id;
          requisicoes.add(r);
          print('aqui essa porra 4 ${requisicoes}');
        }
        requisicoes.sort(
                (Requisicao a, Requisicao b)  => a.id.compareTo(b.id));
        requisicoesmain = requisicoes;
        inRequisicoes.add(requisicoes);
      } else {
        inRequisicoes.add(requisicoes);
      }
    }).onError((err) {
      print('Erro das Requisicao: ${err.toString()}');
    });

  }




  @override
  void dispose() {


    RequisicaoController.close();
    // TODO: implement dispose
  }


}
