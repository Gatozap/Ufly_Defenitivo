import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufly/Ativos/AtivosController.dart';
import 'package:ufly/Ativos/AtivosListController.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/Localizacao.dart';
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
  Localizacao l;
  PageController pageController;
  PagesController pg;
  AtivosController alc;

  MotoristaController mt;
  void onTap(int index) {
    pc.inPageController.add(index);
  }

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
    if (mt == null) {
      mt = MotoristaController();
    }
    if (alc == null) {
      alc = AtivosController();
    }

    // TODO: implement build
    return StreamBuilder<List<Motorista>>(
        stream: mt.outMotoristas,
        builder: (context, AsyncSnapshot<List<Motorista>> snapshot) {

          if (snapshot.data == null) {
            return Container();
          }
          if (snapshot.data.length == 0) {
            return Container(
                child: hTextMal('Sem carros disponiveis', context));
          }
          return Scaffold(
            appBar: myAppBar(
              'Motoristas',
              context,
              size: 200,
              backgroundcolor: Color.fromRGBO(255, 184, 0, 30),
            ),
            drawer: CustomDrawerWidget(),
            body: Container(
              width: getLargura(context),
              height: getAltura(context),
              child: StreamBuilder<List<CarroAtivo>>(
                  stream: alc.outAtivos,
                  builder: (context, AsyncSnapshot<List<CarroAtivo>> snap) {

                    if (snap.data == null) {
                      return Container();
                    }
                    if (snap.data.length == 0) {
                      return Container(
                          child: hTextMal('0', context));
                    }
                    return  ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Motorista motorista = snapshot.data[index];

                                     for(CarroAtivo a in snap.data) {

                                       return a.isAtivo == motorista.isOnline? MotoristasListItem(motorista): Container();
                                     }
                      },
                      itemCount: snapshot.data.length,
                    );
                  }),
            ),
            backgroundColor: Color.fromRGBO(255, 190, 0, 10),
          );
        });
  }
}
