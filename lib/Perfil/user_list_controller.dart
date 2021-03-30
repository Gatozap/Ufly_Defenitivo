import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Motorista/motorista_controller.dart';



import 'package:ufly/Objetos/Requisicao.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';

class UserListController extends BlocBase {

  BehaviorSubject<List<User>> usersController =
  BehaviorSubject<List<User>>();
  Stream<List<User>> get outUsers => usersController.stream;
  Sink<List<User>> get inUsers => usersController.sink;
  List<User> users;
  List<User> usersmain;





  UserListController({Requisicao requisicao}) {
    if(requisicao == null){
      requisicao = Requisicao();
    }
    if(requisicao.id == null){
      requisicao.id = null;
    }
    userRef
        .where("id", isEqualTo: requisicao.user)
        .snapshots()
        .listen((QuerySnapshot snap) {
      users = [];

      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {

          User p =  User.fromJson(ds.data());
          p.id = ds.id;
          users.add(p);
        }
        users.sort((User a, User b) => a.id.compareTo(b.id));
        usersmain = users;
        inUsers.add(users);
      } else {
        inUsers.add(users);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });

  }


  Future<String> updateUser(User user) async {



    if (user != null) {
      return userRef.doc(user.id).update(user.toJson()).then((v) {

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


    usersController.close();
    // TODO: implement dispose
  }

  void FilterByCategoria(String selectedCategoria) {}
}
