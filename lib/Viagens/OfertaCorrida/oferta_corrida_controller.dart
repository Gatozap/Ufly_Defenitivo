import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';

import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';

class OfertaCorridaController extends BlocBase {


  BehaviorSubject<List<OfertaCorrida>> ofertacorridaController =
  BehaviorSubject<List<OfertaCorrida>>();

  Stream<List<OfertaCorrida>> get outOfertaCorrida =>
      ofertacorridaController.stream;

  Sink<List<OfertaCorrida>> get inOfertaCorrida => ofertacorridaController.sink;
  List<OfertaCorrida> ofertacorridas;
  List<OfertaCorrida> ofertacorridasmain;


  OfertaCorridaController() {
    ofertacorridaRef
        .snapshots()
        .listen((QuerySnapshot snap) {
      ofertacorridas = new List();
      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {
          OfertaCorrida p = OfertaCorrida.fromJson(ds.data());
          p.id = ds.id;
          ofertacorridas.add(p);
        }
        ofertacorridas.sort(
                (OfertaCorrida a, OfertaCorrida b) => a.id.compareTo(b.id));
        ofertacorridasmain = ofertacorridas;
        inOfertaCorrida.add(ofertacorridas);
      } else {
        inOfertaCorrida.add(ofertacorridas);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }


  @override
  void dispose() {
    ofertacorridaController.close();

    // TODO: implement dispose
  }

}


