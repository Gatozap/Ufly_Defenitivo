import 'package:flutter/material.dart';

import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';

class AjudaPage extends StatefulWidget {
  AjudaPage({Key key}) : super(key: key);

  @override
  _AjudaPageState createState() {
    return _AjudaPageState();
  }
}

Widget menuButton(
  context,
  text,
  isLogout,
  onPress, {
  color,
  size,
}) {
  return Container(
      width: MediaQuery.of(context).size.width * .8,
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
                    child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'malgun',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )))
            //Icon(Icons.arrow_forward_ios)
          ],
        ),
      ));
}

class _AjudaPageState extends State<AjudaPage> {
  @override
  void initState() {
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
      appBar: myAppBar('Ajuda', context,
          showBack: true,
          size: 75,

    ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: getAltura(context)*.040, left: getLargura(context)*.060),
            child: Row(
              children: <Widget>[
                Container(
                  width: getLargura(context)*.075,
                  child: Image.asset('assets/ajuda_alerta.png'),
                ),
                menuButton(
                  context,
                  'Problemas com uma viagem especifica e reembolsos',
                  true,
                  () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: getAltura(context)*.020, left: getLargura(context)*.060),
            child: Row(
              children: <Widget>[
                Container(
                  width: getLargura(context)*.075,
                  child: Image.asset('assets/ajuda_pagamento.png'),
                ),
                menuButton(
                  context,
                  'Opções de conta e pagamento',
                  true,
                  () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: getAltura(context)*.020, left: getLargura(context)*.060),
            child: Row(
              children: <Widget>[
                Container(
                  width: getLargura(context)*.075,
                  child: Image.asset('assets/ajuda_acessibilidade.png'),
                ),
                menuButton(
                  context,
                  'Acessibilidade',
                  true,
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
