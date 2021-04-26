import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';

import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';

class MotoristaController extends BlocBase {





  BehaviorSubject<List<Motorista>> motoristasController =
  BehaviorSubject<List<Motorista>>();
  Stream<List<Motorista>> get outMotoristas => motoristasController.stream;
  Sink<List<Motorista>> get inMotoristas => motoristasController.sink;
  List<Motorista> motoristas;
  List<Motorista> motoristasmain;


  BehaviorSubject<String> favoritoController = BehaviorSubject<String>();
  Stream<String> get outFavorito => favoritoController.stream;
  Sink<String> get inFavorito => favoritoController.sink;
  String favorito;

  void updateFavorito(String fav) {
    favorito = fav;
    inFavorito.add(favorito);
  }



  MotoristaController() {
    motoristaRef
        .snapshots()
        .listen((QuerySnapshot snap) {
      motoristas = [];

      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {

          print('aqui tipo 2 ${ds.data()}');
          print('aqui tipo ${ds.runtimeType}');
          Motorista p =  Motorista.fromJson(ds.data());
          p.id = ds.id;
          motoristas.add(p);
      
        }
        motoristas.sort(
                (Motorista a, Motorista b) => a.id.compareTo(b.id));
        motoristasmain = motoristas;
        inMotoristas.add(motoristas);
      } else {
        inMotoristas.add(motoristas);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });

  }

  Future<User> CriarCarros(Carro carro, Motorista motorista) {
    carro.created_at = DateTime.now();
    carro.updated_at = DateTime.now();
    return carrosRef.add(carro.toJson()).then((v) {
      carro.id = v.id;


      carrosRef.doc(carro.id).update(carro.toJson());


      if (motorista != null) {
        if (motorista.carro == null) {
          motorista.carro = [];
        }

        motorista.carro.add(carro);
        return
          motoristaRef.add(motorista.toJson()).then((v) {
            motorista.id = v.id;

            motoristaRef
                .doc(motorista.id)
                .update(motorista.toJson())
                .then((v) {
              return motorista;
            }).catchError((err) {
              return null;
            });
          }).catchError((err) {
            return null;
          });
      } else {
        return null;
      }
    }).catchError((err) {
      return null;
    });
  }



  @override
  void dispose() {

    motoristasController.close();

    // TODO: implement dispose
  }

  void FilterByCategoria(String selectedCategoria) {}

}

Future<String> updateMotorista(Motorista motorista) async {



  if (motorista != null) {
    return motoristaRef.doc(motorista.id).update(motorista.toJson()).then((v) {


      return 'Atualizado com sucesso!';
    }).catchError((err) {
      print('Error: ${err}');
      return 'Error: ${err}';
    });
  } else {
    return Future.delayed(Duration(seconds: 1)).then((v) {
      return 'Erro: Motorista Nulo';
    });
  }
}
