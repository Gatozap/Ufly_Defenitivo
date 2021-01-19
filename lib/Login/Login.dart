import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Helpers/References.dart';


import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:ufly/HomePage.dart';

import 'package:ufly/Login/CadastroPage/CadastroPage.dart';
import 'package:ufly/Login/CadastroPage/cadastro_completo.dart';
import 'package:ufly/Login/LoginController.dart';
import 'package:ufly/Objetos/User.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  LoginController lc = new LoginController();
  var controllerEmail = new TextEditingController();
  var controllerSenha = new TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  bool logedIn = false;
  ProgressDialog pr;
  bool _obscureText = true;


  void showLoading(context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();
  }

  @override
  void initState() {
    if (lc == null) {
      lc = LoginController();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsivePixelHandler.init(
      baseWidth: 360,
      //The width used by the designer in the model designed
    );
    LoginController lc;
    if (lc == null) {
      lc = LoginController();
    }
    return Scaffold(

      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(
        child: Container(
          height: getAltura(context),
            width: getLargura(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
              
                
                Container(
                  
                  child: Center(
                      child: Padding(
                    padding:

                    EdgeInsets.only(top: ResponsivePixelHandler.toPixel(22, context),),
                    child: Text(
                      'uFly',
                      style: TextStyle(fontFamily: 'BankGothic', fontSize: ResponsivePixelHandler.toPixel(50, context),),
                    ),

                  )
                  ),
                ),
                Container(
                  width: getLargura(context)*.7,
                  height: getAltura(context)*.250,
                  child: Image.asset('assets/login_layout.png'),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: ResponsivePixelHandler.toPixel(8, context), right: ResponsivePixelHandler.toPixel(28, context), left:  ResponsivePixelHandler.toPixel(28, context)),
                  child: TextFormField(
                    controller: controllerEmail,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      contentPadding: EdgeInsets.fromLTRB( ResponsivePixelHandler.toPixel(20, context), ResponsivePixelHandler.toPixel(15, context),  ResponsivePixelHandler.toPixel(20, context), ResponsivePixelHandler.toPixel(10, context)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.0),
                          borderSide: BorderSide(color: Colors.blue)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.0),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top:  ResponsivePixelHandler.toPixel(10, context), right: ResponsivePixelHandler.toPixel(28, context), left:  ResponsivePixelHandler.toPixel(28, context)),
                  child: StreamBuilder<bool>(
                    stream: lc.outHide,
                    builder: (context, snapshot) {
                if(lc.hide == null){
                lc.hide = true;
                }
                      return TextFormField(
                        controller: controllerSenha,
                        obscureText: lc.hide,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon:  IconButton(
                                  icon: Icon(
                                    lc.hide == true
                                        ? MdiIcons.eye
                                        : MdiIcons.eyeOff,
                                  ),
                                  onPressed: () {
                                    lc.hide = ! lc.hide;
                                    lc.inHide.add(snapshot.data);

                                  },
                                ),
                          contentPadding: EdgeInsets.fromLTRB( ResponsivePixelHandler.toPixel(20, context), ResponsivePixelHandler.toPixel(15, context),  ResponsivePixelHandler.toPixel(20, context), ResponsivePixelHandler.toPixel(10, context)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      );
                    }
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: ResponsivePixelHandler.toPixel(20, context), right:  ResponsivePixelHandler.toPixel(28, context), left:  ResponsivePixelHandler.toPixel(28, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      hTextAbel('Esqueci a senha', context, size: 20),
                      sb,
                      GestureDetector(onTap: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => CadastroPage()));
                      },child: hTextAbel('Cadastrar-se', context, size: 20))
                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top:ResponsivePixelHandler.toPixel(20, context), right: ResponsivePixelHandler.toPixel(28, context), left: ResponsivePixelHandler.toPixel(28, context)),
                  child: GestureDetector(
                    onTap: () {
                      _auth
                          .signInWithEmailAndPassword(
                          email: controllerEmail.text,
                          password: controllerSenha.text)
                          .then((user) {
                        dToast('Efetuando login... Aguarde');
                        if (user != null) {
                          userRef.doc(user.user.uid).get().then((value) {
                            print('aqui o value ${value.toString()}');
                            if (value != null) {
                              User u = User.fromJson(value.data());
                              Helper.localUser = u;
                              SharedPreferences.getInstance().then((sp){
                                sp.setString('User', controllerEmail.text);
                                sp.setString('UserSenha', controllerSenha.text);

                              });


                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Helper.localUser.isMotorista == true? Consumer<Position>(
                                          builder: (context, position, widget) {
                                            return CorridaPage();
                                          }
                                      ): Consumer<Position>(
                                          builder: (context, position, widget) {
                                            return HomePage();
                                          }
                                      )));
                            }
                          }).catchError((err) {
                            dToastTop('E-mail ou senha inválidas');
                            print('Login Error 1: ${err.toString()}');
                            return false;
                          });
                        }
                      }).catchError((err) {
                        dToastTop('E-mail ou senha inválidas');
                        print('Login Error 2: ${err.toString()}');

                        return false;
                      });;
                    },
                    child: Container(
                        height: getAltura(context)*.090,
                        width: getLargura(context)*.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(255, 184, 0, 30),
                        ),
                        child:
                            Center(child: hTextAbel('Entrar', context, size: 31))),
                  ),
                ),
                sb,

                hTextAbel('Ou conecte com', context, size: 25),
                sb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(
                        top:ResponsivePixelHandler.toPixel(5, context),
                        left: ResponsivePixelHandler.toPixel(15, context),
                      ),
                      child: Container(
                          height: getAltura(context)*.080,
                          width: getLargura(context)*.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/botom_face.png',
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                    sb,
                    Padding(
                      padding:  EdgeInsets.only(
                        top:ResponsivePixelHandler.toPixel(5, context),
                        left: ResponsivePixelHandler.toPixel(15, context),
                      ),
                      child: Container(
                          height: getAltura(context)*.080,
                          width: getLargura(context)*.4,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/botom_google.png',
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                    sb,
                  ],
                ),
                sb,

               /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: IconButton(
                      icon: Icon(
                        MdiIcons.instagram,
                        size: getAltura(context)*.060,
                      ),
                      onPressed: () {},
                    )),sb,sb,
                    Center(
                      child: IconButton(
                        icon: Icon(
                          MdiIcons.shareVariant,
                          size: getAltura(context)*.060,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )*/
              ],
            )),
      ),
    );
  }
}
