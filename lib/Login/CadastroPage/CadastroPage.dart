import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Login/CadastroPage/cadastro_completo.dart';
import 'package:ufly/Login/Login.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../LoginController.dart';
import 'CadastroController.dart';

class CadastroPage extends StatefulWidget {
  User user;

  CadastroPage({Key key, this.user}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  CadastroController cc = CadastroController();
  LoginController lc = new LoginController();
  var controllerEmail = new TextEditingController();
  var controllerSenha = new TextEditingController();
  var controllerRepetirSenha = new TextEditingController();
  var controllerNome = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    if (lc == null) {
      lc = LoginController();
    }
    if (cc == null) {
      cc = CadastroController();
    }
    return Scaffold(
     
      body: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20),
            child:
            Row(
              children: [
                hTextBank('UFLY', context, color: Color.fromRGBO(255, 184, 0, 1), size: 100,),sb,
                Padding(
                  padding:  EdgeInsets.only(left: getLargura(context)*.125),
                  child: hTextMal('AJUDA', context, size: 60, weight: FontWeight.bold),

                ),sb,sb,
                GestureDetector(
                     onTap: () {
                       Navigator.of(context).pushReplacement(
                           MaterialPageRoute(
                               builder: (context) =>
                                   Login()));
                     }
                    ,child: hTextMal('ENTRAR', context, size: 60, weight: FontWeight.bold)),
              ],
            ),
          ),
          cadastroEmail(User.Empty(), cc),

          MaterialButton(
              onPressed: () {
                dToast('Cadastrando...');

                setState(() {
                  isPressed = true;
                });
                if (_formKey.currentState.validate()) {
                  print('Entrou AQUI');
                  cc.outUser.first.then((u) {
                    print('${u.toString()}');
                    cc.registerUser(u).then((value) {

                      if (value == 0) {
                        dToast('Cadastrado com sucesso!');
                        Future.delayed(Duration(seconds: 2)).then((v) {
                          LoginController lc = LoginController();
                          lc.LoginEmail(
                              email: controllerEmail.text,
                              password: controllerSenha.text)
                              .then((v) {
                            if (v) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CadastroCompleto()));
                            } else {
                              dToast(
                                  'Erro ao efetuar Login. Você já é cadastrado(a)?');
                            }
                          }).catchError((err) {});
                        });
                      } else if (value == 1) {
                        dToast(
                            'Erro ao efetuar cadastro: Telefone já cadastrado!');
                      } else {}
                    });
                  });
                }
              },
              
              child: Center(
                child: Container(


                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Colors.indigo[50], width: 1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: getAltura(context) * .1,
                          width: getLargura(context) * .850,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFf6aa3c),
                          ),
                          child: Container(
                              height: getAltura(context)*.125,
                              width: getLargura(context)*.85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(255, 184, 0, 30),
                              ),
                              child:
                              Center(child: hTextAbel('CONTINUAR', context, size: 100))),
                        ),


                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Widget cadastroEmail(User data, CadastroController cc) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(color: Colors.black,),
                  Padding(      padding: EdgeInsets.only(top: getAltura(context) * .025),
                      child: hTextMal('Cadastro de Email', context, size: 100, weight: FontWeight.bold)),sb,

              Center(
                child: Container(
                
                 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                  Padding(
                  padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
                child: TextFormField(
                  autovalidate: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (isPressed) {
                      if (value.isEmpty) {
                        return 'É necessário preencher o Nome';
                      } else {
                        data.nome = value;
                        cc.inUser.add(data);
                      }
                    }
                    return null;
                  },
                  controller: controllerNome,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.020, getAltura(context)*.025, getLargura(context)*.020),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),sb,
        Padding(
          padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            autovalidate: true,
            validator: (value) {
              if (isPressed) {
                if (value.isEmpty) {
                  return 'É necessário preencher o Email';
                } else {
                  if (value.contains('@')) {
                    data.email = value;
                    cc.inUser.add(data);
                  } else {
                    return 'Email precisa ser valido';
                  }
                }
              }
              return null;
            },

            controller: controllerEmail,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'E-mail',
              contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.020, getAltura(context)*.025, getLargura(context)*.020),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  borderSide: BorderSide(color: Colors.black)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ),
        ),sb,
                      Padding(
                        padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
                        child: StreamBuilder<bool>(
                            stream: lc.outHide,
                            builder: (context, snapshot) {
                              if(lc.hide == null){
                                lc.hide = true;
                              }
                              return TextFormField(

                                validator: (value) {
                                  if (isPressed) {
                                    if (value.isEmpty) {
                                      return 'É necessário preencher a Senha';
                                    } else {
                                      if (value.length < 6) {
                                        return 'Senha é muito curta!';
                                      } else {
                                        var s = value.split('/');
                                      }
                                    }
                                  }
                                },
                                controller: controllerSenha,
                                obscureText: lc.hide,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'Senha',
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
                                  contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.030, getAltura(context)*.025, getLargura(context)*.030),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color: Colors.grey)),
                                ),
                              );
                            }
                        ),
                      ),sb,
                      Padding(
                        padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
                        child: StreamBuilder<bool>(
                            stream: lc.outHide,
                            builder: (context, snapshot) {
                              if(lc.hide == null){
                                lc.hide = true;
                              }
                              return TextFormField(
                                validator: (value) {
                                  if (isPressed) {
                                    if (value.isEmpty) {
                                      return 'É necessário preencher a Senha';
                                    } else {
                                      if (value.length < 6) {
                                        return 'Senha é muito curta!';
                                      } else {
                                        if (value == controllerSenha.text) {
                                          data.senha = value;
                                          cc.inUser.add(data);
                                        } else {
                                          return 'Senhas não conferem';
                                        }
                                      }
                                    }
                                  }
                                },

                                obscureText: lc.hide,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'Repetir Senha',
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
                                  contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.030, getAltura(context)*.025, getLargura(context)*.030),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color: Colors.grey)),
                                ),
                              );
                            }
                        ),
                      ),sb,
                      
                    ],
                  ),
                ),
              ),
              /*
              Padding(
                padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.075, left: getLargura(context)*.075),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  validator: (value) {
                    if (isPressed) {
                      if (value.isEmpty) {
                        return 'É necessário preencher o E-mail';
                      } else {
                        if (value.contains('@')) {
                          data.email = value;
                          cc.inUser.add(data);
                        } else {
                          return 'E-mail inválido!';
                        }
                      }
                    }
                  },
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
              ),sb,

              */
            ],
          ),
        ),
      ),
    );
  }
}
