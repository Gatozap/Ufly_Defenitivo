import 'package:ufly/Helpers/Helper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:googleapis/admin/directory_v1.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:ufly/Objetos/Favoritos.dart';

import 'AdicionarEnderecoPage.dart';
import 'ConfiguracaoPageList.dart';

class ConfiguracaoPage extends StatefulWidget {
  User u;
  ConfiguracaoPage({this.u});

  @override
  _ConfiguracaoPageState createState() {
    return _ConfiguracaoPageState();
  }
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final h = Favoritos(endereco: 'Rua Londrina número 76', local: 'Casa');

  static final n = Favoritos(
      endereco: 'Rua Cristiano Schimitke número 76', local: 'Trabalho');
  static final m = Favoritos(endereco: 'Avenida Brasil - 908', local: 'Loja');
  List<Favoritos> favoritos = [h, n, m];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(
        'Configurações',
        context,
        size: ScreenUtil.getInstance().setSp(250),
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: getAltura(context) * .015),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo_drawer.png'),
                  ),
                  sb,
                  hTextMal('Equipe uFly', context,
                      size: 60, weight: FontWeight.bold),
                  hTextAbel('+55 (00) 00000-0000', context),
                  hTextAbel('desenvolvedor@ufly.com.br', context),
                  Divider(
                    color: Colors.black54,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: getAltura(context) * .005,
                            left: getLargura(context) * .015),
                        child: IconButton(icon: Icon(Icons.add_circle_outline, size: 40, color: Colors.black,), onPressed: (){
                          
                        },),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: getAltura(context) * .025,
                              left: getLargura(context) * .065),
                          child: hTextMal('Adicionar Favoritos', context,
                              size: 63,
                              weight: FontWeight.bold,
                              color: Colors.black)),


                    ],

                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: getAltura(context) * .010),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: getLargura(context),
                    height: getAltura(context)*.40,
                    child: ListView.builder(

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {

                          return ConfiguracaoPageList(favoritos[index]);

                      },
                      itemCount: favoritos.length,
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: getAltura(context) * .020,
                              left: getLargura(context) * .060),
                          child: hTextMal('Segurança', context,
                              size: 60,
                              weight: FontWeight.bold,
                              color: Color.fromRGBO(180, 180, 180, 20))),
                    ],
                  ),
                  sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: getLargura(context) * .040,
                            top: getAltura(context) * .020,
                            right: getLargura(context) * .020),
                        child: Container(
                            width: getLargura(context) * .150,
                            child: Icon(
                              MdiIcons.accountCheckOutline,
                              color: Colors.black,
                              size: 35,
                            )),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: getAltura(context) * .005),
                              child: Container(
                                  child: hTextMal(
                                      'Gerenciar contatos de confiança',
                                      context,
                                      size: 50,
                                      weight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: getAltura(context) * .005),
                              child: Container(
                                  child: hTextMal(
                                      'Compartilhe seu status de viagem \ncom uma pessoa da sua confiança',
                                      context,
                                      size: 50))),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: getAltura(context) * .020,
                              left: getLargura(context) * .060),
                          child: hTextMal('Privacidade', context,
                              size: 60,
                              weight: FontWeight.bold,
                              color: Color.fromRGBO(180, 180, 180, 20))),
                    ],
                  ),
                  sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: getLargura(context) * .040,
                            top: getAltura(context) * .005,
                            right: getLargura(context) * .020),
                        child: Container(
                            width: getLargura(context) * .150,
                            child: Image.asset('assets/lock.png')),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: getAltura(context) * .005),
                              child: Container(
                                  child: hTextMal(
                                      'Gerenciar privacidade de uso', context,
                                      size: 50, weight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: getAltura(context) * .005),
                              child: Container(
                                  child: hTextMal(
                                      'Controle as informações que você \ncompartilha com a gente.',
                                      context,
                                      size: 50))),
                        ],
                      ),
                    ],
                  ),
                  sb,
                  sb,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Adicionar() {
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AdicionarEnderecoPage()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: getLargura(context) * .020,
                top: getAltura(context) * .020,
                right: getLargura(context) * .020),
            child: Container(
                width: getLargura(context) * .130,
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                  size: 35,
                )),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: getAltura(context) * .030,
                  right: getLargura(context) * .020),
              child: hTextMal('Adicionais mais locais', context,
                  size: 55, weight: FontWeight.bold))
        ],
      ),
    );
  }
}
