import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:ufly/Carro/CarroController.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Requisicao.dart';

import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';
import 'OfertaCorrida/oferta_corrida_controller.dart';
import 'Requisicao/criar_requisicao_controller.dart';

class MotoristasListItem extends StatelessWidget {
  CarroController cr;
  MotoristaController mt;
  List motorista_aceitos = [];
  OfertaCorridaController ofertaCorridaController;
  RequisicaoCorridaController requisicaoController =
      RequisicaoCorridaController();
  CriarRequisicaoController criaRc;
  ControllerFiltros cf;

  @override
  Widget build(BuildContext context) {
    ResponsivePixelHandler.init(
      baseWidth: 360, //The width used by the designer in the model designed
    );
    if (criaRc == null) {
      criaRc = CriarRequisicaoController();
    }
    if (motorista.agua == null) {
      motorista.agua = false;
    }
    if (cf == null) {
      cf = ControllerFiltros();
    }
    if (motorista.wifi == null) {
      motorista.wifi = false;
    }
    if (motorista.balas == null) {
      motorista.balas = false;
    }
    if (mt == null) {
      mt = MotoristaController();
    }
    if (cr == null) {
      cr = CarroController(motorista: motorista);
    }
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
    }
    if (ofertaCorridaController == null) {
      ofertaCorridaController = OfertaCorridaController();
    }
    return StreamBuilder<List<Carro>>(
        stream: cr.outCarros,
        builder: (context, snapshot) {
          print('carro ${snapshot.data}');
          if (snapshot.data == null) {
            return Container(child: hTextMal('Sem carros 1 ', context));
          }
          if (snapshot.data.length == 0) {
            return Container(child: hTextMal('Sem carros', context));
          }
          return StreamBuilder<List<Motorista>>(
              stream: mt.outMotoristas,
              builder: (context, AsyncSnapshot<List<Motorista>> snap) {
                print('aqui snapshot ${snap.data}');
                if (snap.data == null) {
                  return Container();
                }
                if (snap.data.length == 0) {
                  return Container(
                      child: hTextMal('Sem motorista disponiveis', context,
                          size: 20));
                }
                return Padding(
                  padding: EdgeInsets.only(
                      top: ResponsivePixelHandler.toPixel(10, context)),
                  child: StreamBuilder<List<Requisicao>>(
                      stream: requisicaoController.outRequisicoes,
                      // ignore: missing_return
                      builder: (context,
                          AsyncSnapshot<List<Requisicao>> requisicao) {
                        if (requisicao.data == null) {
                          return Container();
                        }
                        if (requisicao.data.length == 0) {
                          return Container();
                        }
                        for (var requi in requisicao.data) {
                          print('aqui motorista ${requi.envioPassageiro}');
                          print('aqui motorista ${motorista.id_usuario}');
                          return StreamBuilder<List<OfertaCorrida>>(
                              stream: ofertaCorridaController.outOfertaCorrida,
                              // ignore: missing_return
                              builder: (context,
                                  AsyncSnapshot<List<OfertaCorrida>>
                                      ofertaCorrida) {
                                if (ofertaCorrida.data == null) {
                                  return Container();
                                }
                                if (ofertaCorrida.data.length == 0) {
                                  return Container();
                                }
                                for (OfertaCorrida oferta
                                    in ofertaCorrida.data) {
                                  for (var of in requi.ofertas) {
                                    if (oferta.id == of) {
                                      return Container(
                                        height: getAltura(context) * .40,
                                        width: getLargura(context),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top:
                                                              ResponsivePixelHandler
                                                                  .toPixel(10,
                                                                      context),
                                                          bottom:
                                                              ResponsivePixelHandler
                                                                  .toPixel(5,
                                                                      context)),
                                                      child: Container(
                                                        height:
                                                            getAltura(context) *
                                                                .20,
                                                        width: getLargura(
                                                                context) *
                                                            .55,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: snapshot
                                                                        .data[0]
                                                                        .foto ==
                                                                    null
                                                                ? AssetImage(
                                                                    'assets/logo_drawer.png')
                                                                : CachedNetworkImageProvider(
                                                                    snapshot
                                                                        .data[0]
                                                                        .foto),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              ResponsivePixelHandler
                                                                  .toPixel(5,
                                                                      context)),
                                                      child: Container(
                                                        width: getLargura(
                                                                context) *
                                                            .60,
                                                        height:
                                                            getAltura(context) *
                                                                .090,
                                                        child: ListView.builder(
                                                            itemCount: snapshot
                                                                .data.length,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              Carro carro =
                                                                  snapshot.data[
                                                                      index];

                                                              return Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: ResponsivePixelHandler
                                                                        .toPixel(
                                                                            15,
                                                                            context)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    hTextAbel(
                                                                        carro.modelo ==
                                                                                null
                                                                            ? 'Modelo'
                                                                            : carro
                                                                                .modelo,
                                                                        context,
                                                                        color: Colors
                                                                            .blue,
                                                                        weight: FontWeight
                                                                            .bold,
                                                                        size:
                                                                            20),
                                                                    carro.categoria ==
                                                                            null
                                                                        ? hTextAbel(
                                                                            ' | Categoria',
                                                                            context,
                                                                            color: Colors
                                                                                .black,
                                                                            weight: FontWeight
                                                                                .bold,
                                                                            size:
                                                                                20)
                                                                        : hTextAbel(
                                                                            ' | ${carro.categoria}',
                                                                            context,
                                                                            color:
                                                                                Colors.black,
                                                                            weight: FontWeight.bold,
                                                                            size: 20),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                    sb,
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          motorista.agua
                                                              ? Container(
                                                                  height: getAltura(
                                                                          context) *
                                                                      .090,
                                                                  width: getLargura(
                                                                          context) *
                                                                      .170,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height: getAltura(context) *
                                                                            .050,
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/agua.png',
                                                                        ),
                                                                      ),
                                                                      hTextAbel(
                                                                          'Água',
                                                                          context,
                                                                          size:
                                                                              20)
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                          motorista.balas
                                                              ? Container(
                                                                  height: getAltura(
                                                                          context) *
                                                                      .090,
                                                                  width: getLargura(
                                                                          context) *
                                                                      .170,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height: getAltura(context) *
                                                                            .050,
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/balas.png',
                                                                        ),
                                                                      ),
                                                                      hTextAbel(
                                                                          'Balas',
                                                                          context,
                                                                          size:
                                                                              20)
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                          motorista.wifi
                                                              ? Container(
                                                                  height: getAltura(
                                                                          context) *
                                                                      .090,
                                                                  width: getLargura(
                                                                          context) *
                                                                      .170,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height: getAltura(context) *
                                                                            .050,
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/wifi.png',
                                                                        ),
                                                                      ),
                                                                      hTextAbel(
                                                                          'Wi-fi',
                                                                          context,
                                                                          size:
                                                                              20)
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: ResponsivePixelHandler
                                                                .toPixel(10,
                                                                    context),
                                                          ),
                                                          child: motorista
                                                                      .foto ==
                                                                  null
                                                              ? CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/logo_drawer.png'),
                                                                  minRadius: 35,
                                                                  maxRadius: 45,
                                                                )
                                                              : CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  backgroundImage:
                                                                      CachedNetworkImageProvider(
                                                                          motorista
                                                                              .foto),
                                                                  minRadius: 35,
                                                                  maxRadius: 45,
                                                                )),
                                                      hTextAbel(motorista.nome,
                                                          context,
                                                          size: 20,
                                                          color: Colors.black),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            hTextAbel(
                                                                '${motorista.rating == null ? 0 : motorista.rating.toStringAsFixed(1)}',
                                                                context,
                                                                size: 20),
                                                            Container(
                                                              child: Image.asset(
                                                                  'assets/estrela.png'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      sb,
                                                      hTextAbel(
                                                          'R\$ ${oferta.preco.toStringAsFixed(2)}',
                                                          context,
                                                          size: 25),
                                                      sb,
                                                      sb,
                                                      requi.motorista_aceitou ==
                                                              null
                                                          ? requi.envioPassageiro !=
                                                                  null
                                                              ? requi.envioPassageiro
                                                                      .contains(
                                                                          motorista
                                                                              .id_usuario)
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        try {
                                                                          // ignore: missing_return
                                                                          await requisicaoRef
                                                                              .doc(requi.id)
                                                                              .update({
                                                                            'envioPassageiro':
                                                                                FieldValue.arrayRemove([
                                                                              '${motorista.id_usuario}'
                                                                            ])
                                                                          }).then((v) {
                                                                            print('sucesso ao tirar motorista da lista');
                                                                          });
                                                                        } catch (e) {
                                                                          print(
                                                                              e);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: ResponsivePixelHandler.toPixel(5, context)),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              getAltura(context) * .060,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Padding(padding: EdgeInsets.only(left: ResponsivePixelHandler.toPixel(15, context), right: ResponsivePixelHandler.toPixel(15, context)), child: hTextMal('Cancelar', context, size: 25, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        motorista_aceitos
                                                                            .add(motorista.id_usuario);
                                                                        requi.envioPassageiro =
                                                                            motorista_aceitos;
                                                                        requi.updated_at =
                                                                            DateTime.now();
                                                                        criaRc.UpdateRequisicao(
                                                                            requi);
                                                                        print(
                                                                            'aqui requisicao ${requi.envioPassageiro}');
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: ResponsivePixelHandler.toPixel(5, context)),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: Color.fromRGBO(
                                                                                255,
                                                                                184,
                                                                                0,
                                                                                30),
                                                                          ),
                                                                          height:
                                                                              getAltura(context) * .060,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Padding(padding: EdgeInsets.only(left: ResponsivePixelHandler.toPixel(15, context), right: ResponsivePixelHandler.toPixel(15, context)), child: hTextMal('Solicitar', context, size: 25)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    motorista_aceitos.add(
                                                                        motorista
                                                                            .id_usuario);
                                                                    requi.envioPassageiro =
                                                                        motorista_aceitos;
                                                                    requi.updated_at =
                                                                        DateTime
                                                                            .now();
                                                                    criaRc.UpdateRequisicao(
                                                                        requi);
                                                                    print(
                                                                        'aqui requisicao ${requi.envioPassageiro}');
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: ResponsivePixelHandler.toPixel(
                                                                            5,
                                                                            context)),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            184,
                                                                            0,
                                                                            30),
                                                                      ),
                                                                      height: getAltura(
                                                                              context) *
                                                                          .060,
                                                                      child:
                                                                          Center(
                                                                        child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: ResponsivePixelHandler.toPixel(15, context), right: ResponsivePixelHandler.toPixel(15, context)),
                                                                            child: hTextMal('Solicitar', context, size: 25)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                          : requi.motorista_aceitou
                                                                  .contains((Helper
                                                                      .localUser
                                                                      .id))
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    requi.aceito =          oferta;
                                                                    criaRc.UpdateRequisicao(
                                                                        requi);

                                                                    if (requi.aceito.id_usuario ==  Helper.localUser.id) {
                                                                      if (motorista
                                                                              .id_usuario ==
                                                                          requi
                                                                              .aceito
                                                                              .motorista) {
                                                                        WidgetsBinding
                                                                            .instance
                                                                            .addPostFrameCallback((_) {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => StreamBuilder<List<OfertaCorrida>>(
                                                                                    stream: ofertaCorridaController.outOfertaCorrida,
                                                                                    // ignore: missing_return
                                                                                    builder: (context, AsyncSnapshot<List<OfertaCorrida>> ofertaCorrida) {
                                                                                      for (OfertaCorrida oferta in ofertaCorrida.data) {
                                                                                        if (oferta.id_usuario == Helper.localUser.id) {
                                                                                          if (motorista.id_usuario == requi.aceito.motorista) {
                                                                                            return ChamandoMotoristaPage(motorista, requi, oferta);
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    })),
                                                                          );
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: ResponsivePixelHandler.toPixel(
                                                                            5,
                                                                            context)),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      height: getAltura(
                                                                              context) *
                                                                          .060,
                                                                      child:
                                                                          Center(
                                                                        child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: ResponsivePixelHandler.toPixel(15, context), right: ResponsivePixelHandler.toPixel(15, context)),
                                                                            child: hTextMal('Viagem', context, size: 25, color: Colors.white)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container()
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                }
                              });
                        }
                      }),
                );
              });
        });
  }

  Motorista motorista;
  MotoristasListItem(this.motorista);
}
