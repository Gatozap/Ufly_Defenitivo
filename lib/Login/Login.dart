import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Login/LoginController.dart';

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
    LoginController lc;
    if (lc == null) {
      lc = LoginController();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: getAltura(context),
          width: getLargura(context),
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding:  EdgeInsets.only(top: getAltura(context)*.060, bottom: getAltura(context)*.010),
              child: Text(
                'uFly',
                style: TextStyle(fontFamily: 'BankGothic', fontSize: getAltura(context)*.070),
              ),
            )),
            Container(

              width: getLargura(context)*.7,
              height: getAltura(context)*.250,
              child: Image.asset('assets/login_layout.png'),
            ),
            Padding(
              padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
              child: TextFormField(
                controller: controllerEmail,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.020, getAltura(context)*.025, getLargura(context)*.020),
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
              padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
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
                      contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.020, getAltura(context)*.025, getLargura(context)*.020),
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
              padding:  EdgeInsets.only(top:getAltura(context)*.025, right: getLargura(context)*.075, left: getLargura(context)*.075),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  hTextAbel('Esqueci a senha', context, size: 60),
                  sb,
                  hTextAbel('Cadastrar-se', context, size: 60)
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top:getAltura(context)*.025, right: getLargura(context)*.075, left: getLargura(context)*.075),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                    height: getAltura(context)*.090,
                    width: getLargura(context)*.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(255, 184, 0, 30),
                    ),
                    child:
                        Center(child: hTextAbel('Entrar', context, size: 100))),
              ),
            ),
            sb,

            hTextAbel('Ou conecte com', context, size: 60),
            sb,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:  EdgeInsets.only(
                    top:getAltura(context)*.010,
                    left: getLargura(context)*.040,
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
                    top:getAltura(context)*.010,
                    left: getLargura(context)*.040,
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
            sb,
            Row(
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
            )
          ],
        ),
      )),
    );
  }
}
