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

class CadastroCarroController extends BlocBase {

  BehaviorSubject<Carro> carroController = new BehaviorSubject<Carro>();

  Stream<Carro> get outCarro => carroController.stream;
  Sink<Carro> get inCarro => carroController.sink;





  CadastroCarroController({Carro carro}) {
       

    inCarro.add(carro);

  }
  Future<User> CriarCarros(Carro carro, Motorista motorista) async {
    carro.created_at = DateTime.now();
    carro.updated_at = DateTime.now();
    /*if(carro.foto != null){
      if(carro.foto.length != 0){
       await Helper().uploadPicture(carro.foto);
      }
    }
    if(carro.foto_documento != null){
      if(carro.foto_documento.length != 0){
       await Helper().uploadPicture(carro.foto);
      }
    }  */
    return  carrosRef.add(carro.toJson()).then((v) {
      carro.id = v.id;
       carro.id_usuario = Helper.localUser.id;


      return carrosRef.doc(carro.id).update(carro.toJson()).then((v){

        if (motorista != null) {
          if (motorista.carro == null) {
            motorista.carro = [];
          }

          motorista.carro.add(carro);
          return
            motoristaRef.add(motorista.toJson()).then((v) {
              motorista.id = v.id;
              carro.id_motorista = motorista.id;
              carrosRef.doc(carro.id).update(carro.toJson()).then((v){
                motorista.id_carro = carro.id;
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


    carroController.close();
    // TODO: implement dispose
  }

  void FilterByCategoria(String selectedCategoria) {}
}
