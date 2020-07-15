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
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
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
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 10),
              child: Text(
                'uFly',
                style: TextStyle(fontFamily: 'BankGothic', fontSize: 50),
              ),
            )),
            Container(
              width: 234,
              height: 160,
              child: Image.asset('assets/login_layout.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 25, left: 25),
              child: TextFormField(
                controller: controllerEmail,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
              padding: const EdgeInsets.only(top: 15.0, right: 25, left: 25),
              child: TextFormField(
                controller: controllerSenha,
                obscureText: _obscureText,
                
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(

                  labelText: 'Password',
                        
                      suffixIcon: IconButton(icon: Icon(_obscureText == false? MdiIcons.eye: MdiIcons.eyeOff, ), onPressed: (){
                        _toggle;
                      },),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
              padding: const EdgeInsets.only(top: 15.0, right: 25, left: 25),
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
              padding: const EdgeInsets.only(top: 15.0, right: 25, left: 25),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          HomePage(

                          )));
                },
                child: Container(
                    height: 70,
                    width: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(255, 184, 0, 100),
                    ),
                    child: Center(child: hTextAbel('Login', context, size: 100))),
              ),
            ),
            sb, sb,
            hTextAbel('Ou conecte com', context, size: 60),
            sb,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,left: 5,
                  ),
                  child: Container(
                      height: 50,
                      width: 150,
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
                  padding: const EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                         color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/botom_google.png',
                        fit: BoxFit.fitWidth,
                      )),
                ),sb,

              ],
            ),sb,sb,
            Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[Center(
              child: IconButton(icon: Icon(MdiIcons.instagram, size: 40,),onPressed: (){

              }, )
            ), IconButton(icon: Icon(MdiIcons.shareVariant, size: 40, ),onPressed: (){

            }, ),],)
          ],
        ),
      )),
    );
  }
}
