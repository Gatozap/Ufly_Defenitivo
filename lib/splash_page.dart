
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/Helpers/Styles.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Login/CadastroPage/CadastroPage.dart';
import 'package:ufly/Login/CadastroPage/cadastro_completo.dart';
import 'package:ufly/Login/Login.dart';
import 'package:ufly/Objetos/Requisicao.dart';

import 'Helpers/Helper.dart';

import 'Helpers/References.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;


import 'Objetos/User.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() {
    return _SplashPageState();
  }

}

class _SplashPageState extends State<SplashPage> {
  RequisicaoCorridaController requisicaoController;
  @override
  void initState() {
    if(requisicaoController == null){
      requisicaoController = RequisicaoCorridaController();
    }

    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {

               VerifyUser();

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: corPrimaria,
      body: Center(
        child: Container(
          width: 240,
          height: 240,
          
          child: Center(
              child: Image.asset('assets/logo_ufly.png')),
        ),
      ),
    );
  }

  auth.FirebaseAuth _auth;
  Future<void> VerifyUser() async {
    try {
      _auth = auth.FirebaseAuth.instance;
    } catch (Err) {
      print("ERROR :${Err.toString()}");
    }
    SharedPreferences sp = await SharedPreferences.getInstance();
    String email;
    String senha;
    if (sp != null) {
      email = sp.getString('User');
      senha = sp.getString('UserSenha');
    }
    if (email == null) {
      Navigator.of(context)
          .pushReplacement((MaterialPageRoute(builder: (context) => Login())));
    }
    if (senha == null) {
      Navigator.of(context)
          .pushReplacement((MaterialPageRoute(builder: (context) => Login())));
    }
    if (_auth != null) {
      var user =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      if (user != null) {
        var value = await userRef.doc(user.user.uid).get();
        if (value.data() != null) {
          User u = new User.fromJson(value.data());
          Helper.localUser = u;

          Navigator.of(context).pushReplacement(
              (MaterialPageRoute(builder: (context) => u.isMotorista == true?CorridaPage(): HomePage())));

        } else {
          Navigator.of(context).pushReplacement(
              (MaterialPageRoute(builder: (context) => Login())));
        }
      } else {
        Navigator.of(context)
            .pushReplacement((MaterialPageRoute(builder: (context) => Login())));
      }
    }
  }
}
