import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Viagens/motoristas_list_item.dart';

import '../HomePage.dart';
import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class MotoristaProximoPage extends StatefulWidget {
  MotoristaProximoPage({Key key}) : super(key: key);

  @override
  _MotoristaProximoPageState createState() {
    return _MotoristaProximoPageState();
  }
}

class _MotoristaProximoPageState extends State<MotoristaProximoPage> {
  final PagesController pc = new PagesController(0);
  PageController pageController;
  PagesController pg;
  MotoristaController mt;
  void onTap(int index) {
    pc.inPageController.add(index);
  }

  var page0;
  var page1;
  var page2;
  var page3;
  var page4;
  int page = 0;
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
    if(mt == null){
      mt = MotoristaController();
    }
    // TODO: implement build
    return StreamBuilder<List<Motorista>>(
        stream: mt.outMotoristas,
        builder: (context, AsyncSnapshot<List<Motorista>> snapshot) {
          print('aqui snapshot ${snapshot.data}');
          if(snapshot.data == null){
            return Container();
          }
          if(snapshot.data.length == 0){
            return Container(child: hTextMal('Sem carros disponiveis', context));
          }
          return Scaffold(
            appBar: myAppBar('Motoristas', context,
                size: 200,
                backgroundcolor: Color.fromRGBO(255, 184, 0, 30),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: getLargura(context) * .025),
                    child: Container(
                      child: Image.asset('assets/menu.png'),
                    ),
                  )
                ]),
            body: Container(
                    width: getLargura(context),
                    height: getAltura(context),
                    child: ListView.builder(
                      shrinkWrap: true,

                      itemBuilder: (context, index) {
                                Motorista motorista = snapshot.data[index];
                        return MotoristasListItem(motorista);
                      },
                      itemCount: snapshot.data.length,

                    ),

                ),


            backgroundColor: Color.fromRGBO(255, 190, 0, 10),

          );
        });
  }
}
