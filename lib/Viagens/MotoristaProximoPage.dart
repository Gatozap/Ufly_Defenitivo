import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufly/Ativos/AtivosController.dart';
import 'package:ufly/Ativos/AtivosListController.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/Localizacao.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';

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
  Localizacao l;
  PageController pageController;
  PagesController pg;
  AtivosController alc;
  OfertaCorridaController ofertacorridaController;
  MotoristaController mt;
  RequisicaoCorridaController requisicaoController;

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
    bg.BackgroundGeolocation.start();
    ResponsivePixelHandler.init(
      baseWidth: 360, //The width used by the designer in the model designed
    );
    if (mt == null) {
      mt = MotoristaController();
    }
    if (ofertacorridaController == null) {
      ofertacorridaController = OfertaCorridaController();
    }
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
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
          return WillPopScope(
            onWillPop: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(

                      title: hTextAbel('Deseja voltar a tela de principal?', context,
                          size: 20, weight: FontWeight.bold),
                      actions: <Widget>[
                        MaterialButton(
                          child: hTextAbel('Cancelar', context, size: 20),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MaterialButton(
                          child: hTextAbel('Sim', context, size: 20),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Consumer<Position>(builder: (context, position, widget) {
                                      return HomePage();
                                    })));
                          },
                        )
                      ],
                    );
                  });
            },

            child: Scaffold(
              appBar: myAppBar(
                'Motoristas',
                context,
                size: 50,
                backgroundcolor: Color.fromRGBO(255, 184, 0, 30),
              ),
              drawer: CustomDrawerWidget(),
              body: StreamBuilder<List<OfertaCorrida>>(
                  stream: ofertacorridaController.outOfertaCorrida,
                  builder: (context,
                      AsyncSnapshot<List<OfertaCorrida>> ofertaCorrida) {
                    if (ofertaCorrida.data == null) {
                      return Center(
                          child: Container(
                              child: hTextAbel(
                                  'Nenhum motorista disponível', context,
                                  size: 30)));
                    }
                    if (ofertaCorrida.data.length == 0) {
                      return Center(
                          child: Container(
                              child: hTextAbel(
                                  'Nenhum motorista disponível', context,
                                  size: 30)));
                    }
                    return StreamBuilder<List<Requisicao>>(
                        stream: requisicaoController.outRequisicoes,
                        builder: (context,
                            AsyncSnapshot<List<Requisicao>> requisicao) {
                          if (requisicao.data == null) {
                            return Container();
                          }
                          if (requisicao.data.length == 0) {
                            return Container();
                          }
                          print('aqui req ${requisicao.data}');
                          return Container(
                            width: getLargura(context),
                            height: getAltura(context),
                            child: StreamBuilder<List<CarroAtivo>>(
                                stream: alc.outAtivos,
                                builder: (context,
                                    AsyncSnapshot<List<CarroAtivo>> snap) {
                                  if (snap.data == null) {
                                    return Container();
                                  }
                                  if (snap.data.length == 0) {
                                    return Container();
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Motorista motorista =
                                          snapshot.data[index];

                                      for (OfertaCorrida oferta
                                          in ofertaCorrida.data) {
                                        for (Requisicao requisicao
                                            in requisicao.data) {
                                          if (oferta.requisicao ==
                                              requisicao.id) {
                                            if (requisicao.user.contains(
                                                Helper.localUser.id)) {
                                              for (CarroAtivo a in snap.data) {
                                                return a.isAtivo ==
                                                        motorista.isOnline
                                                    ? MotoristasListItem(
                                                        motorista)
                                                    : Container();
                                              }
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        }
                                      }
                                    },
                                    itemCount: snapshot.data.length,
                                  );
                                }),
                          );
                        });
                  }),
              backgroundColor: Color.fromRGBO(255, 190, 0, 10),
            ),
          );
        });
  }
}
