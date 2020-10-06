import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/User.dart';

import 'package:rxdart/rxdart.dart';

class PerfilController extends BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();

  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;
  User u;



  PerfilController(User user) {
    u = user;
    if(Helper.localUser.data_nascimento != null) {
      Helper.localUser.data_nascimento =
          Helper.localUser.data_nascimento.add(Duration(hours: 3));
    }else{
      Helper.localUser.data_nascimento = DateTime.now();
    }
    if (u != null) {
      if(u.data_nascimento == null){
        u.data_nascimento = DateTime.now();
      }
      u.data_nascimento = u.data_nascimento.add(Duration(hours: 3));
      print("data de nascimento AQUI ${u.data_nascimento.toIso8601String()}");
      inUser.add(u);
      userRef.doc(u.id).snapshots().listen((snap) {
        u = new User.fromJson(snap.data());

        u.data_nascimento = u.data_nascimento.add(Duration(hours: 3));
        print("data de nascimento AQUI ${u.data_nascimento.toIso8601String()}");
        inUser.add(u);
      });
    }
  }

  Future<String> updateUser(User user) async {
    user.data_nascimento = user.data_nascimento.subtract(Duration(hours: 3));


    if (user != null) {
      return userRef.doc(user.id).update(user.toJson()).then((v) {
        inUser.add(user);
        Helper.localUser = user;
        return 'Atualizado com sucesso!';
      }).catchError((err) {
        print('Error: ${err}');
        return 'Error: ${err}';
      });
    } else {
      return Future.delayed(Duration(seconds: 1)).then((v) {
        return 'Erro: Usuário Nulo';
      });
    }
  }

  @override
  void dispose() {
    userController.close();
    // TODO: implement dispose
  }
}
