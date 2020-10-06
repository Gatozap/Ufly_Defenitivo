import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Objetos/Carro.dart';

import 'package:ufly/Viagens/SuasViagensList.dart';

class SuasViagensPage extends StatefulWidget {


  @override
  _SuasViagensPageState createState() {
    return _SuasViagensPageState();
  }
}

class _SuasViagensPageState extends State<SuasViagensPage> {
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
      appBar: myAppBar('Suas Viagens', context,
          size: 75,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: getLargura(context) * .025),
              child: Container(
                child: Image.asset('assets/menu.png'),
              ),
            )
          ]),
      body: Container()


      /*StreamBuilder(
        stream: mt.outMotorista,
        builder: (context, snapshot) {
          return Container(
            width: getLargura(context),
            height: getAltura(context),
            child: ListView.builder(
              shrinkWrap: true,

              itemBuilder: (context, index) {

                return SuasViagemList(motoristas[index]);
              },
              itemCount: motoristas.length,

            ),

          );
        }
      )*/
    );
  }

}
