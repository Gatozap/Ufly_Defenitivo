import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufly/Ajuda/AjudaPage.dart';
import 'package:ufly/Configuracao/ConfiguracaoPage.dart';

import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Login/Login.dart';
import 'package:ufly/Viagens/SuasViagensPage.dart';

class CustomDrawerWidget extends StatefulWidget {
  @override
  CustomDrawerWidgetState createState() {
    return new CustomDrawerWidgetState();
  }
}

class CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomRight,
        colors: <Color>[
          Color.fromRGBO(0, 168, 180, 100),
          Colors.indigo,
        ],
      ),
    );
    return Drawer(
        child: Stack(children: <Widget>[
      Scrollbar(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          height: getAltura(context),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .1, left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logo_drawer.png'),
                    ),
                  ],
                ),
                sb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Equipe uFly',
                      style: TextStyle(
                          fontFamily: 'malgun',
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      hTextAbel('5,0', context),
                      sb,
                      Container(
                        child: Image.asset('assets/estrela.png'),
                      )
                    ]),
                sb,
                Divider(),
                sb,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/home.png'),
                      ),
                      menuButton(context, 'Início', true, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/map.png'),
                      ),
                      menuButton(context, 'Suas Viagens', true, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SuasViagensPage()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/dirija.png'),
                      ),
                      menuButton(context, 'Dirija na Ufly', true, () {
                        /* Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EstatisticaPage(user: Helper.localUser)));*/
                      }),
                    ],
                  ),
                ),
                /*menuButton(context, 'Cadastrar Novos Carros', Icons.directions_car, true, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CadastrarNovoCarroPage(
                          carro: widget.carro, campanha: widget.campanha,
                      )));
                }),*/

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/ajuda.png'),
                      ),
                      menuButton(context, 'Ajuda', true, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AjudaPage()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/configuracao.png'),
                      ),
                      menuButton(context, 'Configurações', true, () {

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConfiguracaoPage()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: getLargura(context) * .45, left: 10, ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 38,
                          child: Image.asset('assets/sair.png'),
                        ),
                        menuButton(context, 'Sair', true, () {}),
                        Padding(
                          padding:  EdgeInsets.only(right:8.0),
                          child: hTextAbel('v0.000.001', context),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }

  separator(context) {
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 2,
        color: Colors.grey[200]);
  }

  Widget menuButton(context, text, isLogout, onPress,
      {color, size, estiloTexto}) {
    return Container(
        width: MediaQuery.of(context).size.width * .4,
        child: MaterialButton(
          onPressed: onPress,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),

              SizedBox(
                width: 10,
              ),
              Container(
                  child: Expanded(
                      child: hTextAbel(
                text,
                context,
                size: size == null ? 60 : size,
              )))
              //Icon(Icons.arrow_forward_ios)
            ],
          ),
        ));
  }

  doLogout(context) async {
    Helper.fbmsg.unsubscribeFromTopic(Helper.localUser.id);
    await FirebaseAuth.instance.signOut();
    Helper.localUser = null;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
