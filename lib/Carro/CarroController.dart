import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Motorista/motorista_controller.dart';

import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';

class CarroController extends BlocBase {

  BehaviorSubject<List<Carro>> carrosController =
  BehaviorSubject<List<Carro>>();
  Stream<List<Carro>> get outCarros => carrosController.stream;
  Sink<List<Carro>> get inCarros => carrosController.sink;
  List<Carro> carros;
  List<Carro> carrosmain;





  CarroController({Motorista motorista}) {
         if(motorista == null){
           motorista = Motorista();
         }
         if(motorista.id == null){
           motorista.id = null;
         }
    carrosRef
        .where("id_motorista", isEqualTo: motorista.id)
        .snapshots()
        .listen((QuerySnapshot snap) {
      carros = new List();

      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {

          Carro p =  Carro.fromJson(ds.data());
          p.id = ds.id;
          carros.add(p);
        }
        carros.sort(
                (Carro a, Carro b) => a.id.compareTo(b.id));
        carrosmain = carros;
        inCarros.add(carros);
      } else {
        inCarros.add(carros);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });

  }
  Future<User> CriarCarros(Carro carro, Motorista motorista) {
    carro.created_at = DateTime.now();
    carro.updated_at = DateTime.now();
    return  carrosRef.add(carro.toJson()).then((v) {
      carro.id = v.id;



      return carrosRef.doc(carro.id).update(carro.toJson()).then((v){

        if (motorista != null) {
          if (motorista.carro == null) {
            motorista.carro = new List<Carro>();
          }

          motorista.carro.add(carro);
          return
            motoristaRef.add(motorista.toJson()).then((v) {
              motorista.id = v.id;
               carro.id_motorista = motorista.id;
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
    }).catchError((err) {
      return null;
    })

      ;
    



  }

  Future<String> updateCarro(Carro carro) async {



    if (carro != null) {
      return carrosRef.doc(carro.id).update(carro.toJson()).then((v) {

        return 'Atualizado com sucesso!';
      }).catchError((err) {
        print('Error: ${err}');
        return 'Error: ${err}';
      });
    } else {
      return Future.delayed(Duration(seconds: 1)).then((v) {
        return 'Erro: Carro Nulo';
      });
    }
  }

  @override
  void dispose() {


    carrosController.close();
    // TODO: implement dispose
  }

  void FilterByCategoria(String selectedCategoria) {}
}
