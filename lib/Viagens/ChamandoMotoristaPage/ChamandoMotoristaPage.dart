import 'dart:async';

import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ufly/Ativos/AtivosController.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:ufly/Avaliacao/AvaliacaoPage.dart';
import 'package:ufly/Compartilhados/SideBar.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';

import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';
import 'package:ufly/Login/Login.dart';

import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';

import 'package:ufly/Objetos/OfertaCorrida.dart';

import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Perfil/user_list_controller.dart';

import 'package:ufly/Rota/rota_controller.dart';

import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';

import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Viagens/Requisicao/criar_requisicao_controller.dart';

class ChamandoMotoristaPage extends StatefulWidget {
  Motorista motorista;
  Requisicao requisicao;
  OfertaCorrida ofertacorrida;
  ChamandoMotoristaPage(this.motorista, this.requisicao, this.ofertacorrida);

  @override
  _ChamandoMotoristaPageState createState() {
    return _ChamandoMotoristaPageState();
  }
}

class _ChamandoMotoristaPageState extends State<ChamandoMotoristaPage> {
  Completer<GoogleMapController> _controller = Completer();
  List<Polyline> polylines;
  RotaController rc;
  ControllerFiltros cf;
  LatLng _initialPosition;
  LatLng destino;
  LatLng passageiro_latlng;
  LatLng motorista_latlng;
  LatLng parada1;
  List<LatLng> marcasRota = [];
  LatLng parada2;
  LatLng parada3;
  bool motoristaChegou;
  double distanciaKm;
  bool segundaetapa;
  MotoristaController mt;
  RequisicaoCorridaController requisicaoController =
  RequisicaoCorridaController();
  List<Marker> markers;
  AtivosController ac;
  bool finalDaCorrida;
  double distancia;
  double distancia2;
  CriarRequisicaoController criaRc;
  BitmapDescriptor bitmapIcon;
  final GeolocatorService geo = GeolocatorService();
  @override
  void initState() {
    if (criaRc == null) {
      criaRc = CriarRequisicaoController();
    }
    if (finalDaCorrida == null) {
      finalDaCorrida = false;
    }
    if (ac == null) {
      ac = AtivosController();
    }
    if (motoristaChegou == null) {
      motoristaChegou = false;
    }


    if (cf == null) {
      cf = ControllerFiltros();
    }
    if (rc == null) {
      rc = RotaController();
    }
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
    }
    if (mt == null) {
      mt = MotoristaController();
    }
    bg.BackgroundGeolocation.start();
    localizacaoInicial();

    geo.getCurrentLocation().listen((position) {
      telaCentralizada(position);
    });
    atualizarLocalizacaoNomes();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsivePixelHandler.init(
      baseWidth: 360, //A largura usado pelo designer no modelo desenhado
    );
    // TODO: implement build
    var map = StreamBuilder<List<Requisicao>>(
        stream: requisicaoController.outRequisicoes,
        // ignore: missing_return
        builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
          print('aqui chamando');
          for (var req in requisicao.data) {
            rotaPassageiro(widget.requisicao);
            Timer(Duration(seconds: 5), () {
              centerView();
            });
            // ignore: missing_return
            return StreamBuilder(
                stream: rc.outPolyMotorista,
                // ignore: missing_return
                builder: (context, snapMotorista) {
                  return StreamBuilder(
                    stream: rc.outPolyPassageiro,
                    builder: (context, snapPassageiro) {
                      polylines =
                          getPolys(snapMotorista.data, snapPassageiro.data);

                      // ignore: missing_return
                      return StreamBuilder<LatLng>(
                          stream: rc.outLocalizacao,
                          builder: (context, localizacao) {
                            if (localizacao.data == null) {
                              return StreamBuilder<Position>(
                                  stream: localizacaoInicial(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return localizacaoInicial();
                                    }
                                    return GoogleMap(
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: false,
                                      //polylines: polylines.toSet(),
                                      mapType: MapType.normal,
                                      zoomGesturesEnabled: true,
                                      zoomControlsEnabled: false,
                                      rotateGesturesEnabled: false,
                                      initialCameraPosition: CameraPosition(
                                          target: _initialPosition,
                                          zoom: Helper.localUser.zoom),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                        centerView();
                                      },
                                    );
                                  });
                            }

                            return StreamBuilder(
                                stream: rc.outWays,
                                builder: (context, snapshot) {
                                  return StreamBuilder(
                                      stream: rc.outMarkers,
                                      builder: (context, snap) {
                                        if (snapshot.data != null) {
                                          if (parada1 == null) {
                                            markers = getMarkers(
                                              snap.data,
                                            );
                                          } else {
                                            markers = getMarkers(snap.data,
                                                ways: snapshot.data);
                                          }
                                        }

                                        return GoogleMap(
                                          myLocationEnabled: true,
                                          myLocationButtonEnabled: false,
                                          trafficEnabled: true,
                                          polylines: polylines.toSet(),
                                          markers: destino != null
                                              ? markers.toSet()
                                              : null,
                                          mapType: MapType.terrain,
                                          zoomGesturesEnabled: true,
                                          zoomControlsEnabled: false,
                                          rotateGesturesEnabled: false,
                                          initialCameraPosition: CameraPosition(
                                              target: localizacao.data,
                                              zoom: Helper.localUser.zoom),
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            _controller.complete(controller);
                                            destino == null
                                                ? null
                                                : centerView();
                                            geo
                                                .getCurrentLocation()
                                                .listen((position) {
                                              telaCentralizada(position);
                                            });
                                          },
                                        );
                                      });
                                });
                          });
                    },
                  );
                });
          }
        });



                      return StreamBuilder<bool>(
                          stream: cf.outDesembarque,
                          builder: (context, desembar) {

                            if (desembar.data == null) {
                              return Container();
                            }

                            else if (desembar.data == true &&
                                finalDaCorrida == true) {
                              return
                                AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        child: hTextAbel(
                                            'Você chegou ao seu destino', context,
                                            size: 25),
                                      ),
                                      sb,
                                      Container(
                                        alignment: Alignment.center,
                                        child: hTextAbel(
                                            'Valor: R\$ ${widget.requisicao.aceito.preco
                                                .toStringAsFixed(2)}', context,
                                            size: 25),
                                      ), sb,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //req.deleted_at = DateTime.now();
                                              // criaRc.UpdateRequisicao(req);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AvaliacaoPage(widget.motorista,widget.requisicao,widget.ofertacorrida,)));

                                            },
                                            child: Container(
                                              height: getAltura(context) * .070,
                                              width: getLargura(context) * .4,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    10),
                                                color: Color(0xFFf6aa3c),
                                              ),
                                              child: Container(
                                                  height: getAltura(context) * .125,
                                                  width: getLargura(context) * .85,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                    color: Color.fromRGBO(
                                                        255, 184, 0, 30),
                                                  ),
                                                  child: Center(
                                                      child: hTextAbel(
                                                          'Avaliar ', context,
                                                          size: 25))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                            };

                            return
                              Scaffold(
                                      body: SlidingUpPanel(
                                        renderPanelSheet: false,
                                        minHeight: 60,
                                        maxHeight: getAltura(context) * .25,
                                        borderRadius: BorderRadius.circular(20),
                                        collapsed: Container(
                                          margin: const EdgeInsets.only(
                                              left: 24.0, right: 24),
                                          child: Row(
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 30.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  24.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  24.0)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 20.0,
                                                              color: Colors.grey,
                                                            ),
                                                          ]),
                                                      width: getLargura(context) -
                                                          48,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          sb,
                                                          sb,
                                                          Container(
                                                            child: Container(
                                                                width:
                                                                getLargura(
                                                                    context) *
                                                                    .4,
                                                                color: Colors
                                                                    .grey,
                                                                height: 3),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        panel: viagemWidget(widget.ofertacorrida,widget.requisicao,
                                            widget.motorista, desembar.data),
                                        body: Container(
                                          height: getAltura(context),
                                          width: getLargura(context),
                                          child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: <Widget>[
                                              map,
                                              Positioned(
                                                right: getLargura(context) * .060,
                                                bottom: getAltura(context) * .350,
                                                child: FloatingActionButton(
                                                  heroTag: '2',
                                                  onPressed: () {
                                                  /*  Timer(Duration(seconds: 1), () {
                                            centerView();
                                          });*/
                                                    doLogout(context);

                                                  },
                                                  child: Icon(Icons.zoom_out_map,
                                                      color: Colors.black),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                              Positioned(
                                                right: getLargura(context) * .060,
                                                bottom: getAltura(context) * .200,
                                                child: FloatingActionButton(
                                                  heroTag: '1',
                                                  onPressed: () {
                                                    /*  Timer(Duration(seconds: 1), () {
                                            centerView();
                                          });*/

                                                    setState(() {finalDaCorrida = true;});

                                                  },
                                                  child: Icon(Icons.close_fullscreen_sharp,
                                                      color: Colors.black),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                              Positioned(
                                                  top: getAltura(context) * .060,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      color: Colors.black,
                                                    ),
                                                    height: getAltura(context) *
                                                        .150,
                                                    width: getLargura(context) *
                                                        .82,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top:
                                                                  getAltura(
                                                                      context) *
                                                                      .030,
                                                                  left: getLargura(
                                                                      context) *
                                                                      .110),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .mapMarkedAlt,
                                                                color: Colors
                                                                    .white,
                                                                size: 25,
                                                              ),
                                                            ),
                                                            StreamBuilder<double>(
                                                                stream: rc
                                                                    .outDistancia,
                                                                builder:
                                                                    (context,
                                                                    snapshot) {
                                                                  distanciaKm =
                                                                      snapshot
                                                                          .data;
                                                                  return Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        top: getAltura(
                                                                            context) *
                                                                            .020,
                                                                        left: getLargura(
                                                                            context) *
                                                                            .080),
                                                                    child: hTextMal(
                                                                        '${snapshot
                                                                            .data
                                                                            .toStringAsFixed(
                                                                            3)}km',
                                                                        context,
                                                                        color:
                                                                        Colors
                                                                            .white,
                                                                        size: 18),
                                                                  );
                                                                })
                                                          ],
                                                        ),
                                                        StreamBuilder<String>(
                                                            stream: rc
                                                                .outLocalizacaoNome,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Expanded(
                                                                child: Container(
                                                                  width: getLargura(
                                                                      context) *
                                                                      .52,
                                                                  child: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        left: getLargura(
                                                                            context) *
                                                                            .050,
                                                                        right: getLargura(
                                                                            context) *
                                                                            .010),
                                                                    child: hTextMal(
                                                                        desembar ==
                                                                            false
                                                                            ? 'Embarque: ${widget.requisicao
                                                                            .origem
                                                                            .endereco}'
                                                                            : 'Desembarque: ${widget.requisicao
                                                                            .destino
                                                                            .endereco}',
                                                                        context,
                                                                        size: 16,
                                                                        color:
                                                                        Colors
                                                                            .white,
                                                                        weight: FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              );
                                                            })
                                                      ],
                                                    ),
                                                  )),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );


                          });


  }

  Widget viagemWidget(ofertacorrida,requisicao,motorista, desembarque) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: getAltura(context) * .250,
      width: getLargura(context) * .90,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: getAltura(context) * .030,
                        left: getLargura(context) * .070),
                    child: CircleAvatar(
                        backgroundImage: motorista.foto == null
                            ? AssetImage('assets/logo_drawer.png')
                            : CachedNetworkImageProvider(motorista.foto),
                        radius: 40),
                  ),
                  sb,
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: getAltura(context) * .035,
                    left: getLargura(context) * .025),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      hTextAbel('${motorista.nome}', context,
                          size: 20, color: Colors.black),
                      Row(
                        children: <Widget>[
                          hTextAbel('${motorista.rating.toStringAsFixed(1)}', context,
                              size: 20, color: Colors.black),
                          Container(
                            child: Image.asset('assets/estrela.png'),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          hTextAbel(
                            'Da sua carteira',
                            context,
                            size: 20,
                          ),
                          sb,
                          Image.asset('assets/carteira.png')
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: getLargura(context) * .150,
                    bottom: getAltura(context) * .040),
                child: Container(child: Image.asset('assets/fechar.png')),
              )
            ],
          ),
          desembarque == true
              ? GestureDetector(
            onTap: (){
    WidgetsBinding
        .instance
        .addPostFrameCallback((_) {
      Navigator.of(context)
          .push((MaterialPageRoute(builder: (context) =>
          AvaliacaoPage(ofertacorrida, requisicao, motorista))));
    });
            },
            child: Container(
              child: hTextAbel('seu motorista chegou', context),
            ),
          )
              : Container(
            child: hTextAbel('Seu motorista esta chegando', context),
          )
        ],
      ),
    );
  }

  Future<void> telaCentralizada(position) async {
    final GoogleMapController controller = await _controller.future;
    marcasRota.add(
        LatLng(position.localizacao.latitude, position.localizacao.longitude));
    rc.inMarkers.add(marcasRota);

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:
      LatLng(position.localizacao.latitude, position.localizacao.longitude),
      zoom: Helper.localUser.zoom,
    )));
    atualizarLocalizacaoNomes();
  }

  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      for (CarroAtivo ca in ac.ativos) {
        telaCentralizada(ca);
      }
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
      _initialPosition = LatLng(v.latitude, v.longitude);
    });
  }

  centerView() async {
    final GoogleMapController controller = await _controller.future;
    await controller.getVisibleRegion();
    var left = min(passageiro_latlng.latitude, destino.latitude);
    var right = max(passageiro_latlng.latitude, destino.latitude);
    var top = max(passageiro_latlng.longitude, destino.longitude);
    var bottom = min(passageiro_latlng.longitude, destino.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 150);
    controller.animateCamera(cameraUpdate);
  }

  List<Marker> getMarkers(data, {ways}) {
    List<Marker> markers = [];
    if (data == null) {
      return markers;
    }

    try {
      markers.removeWhere((m) => m.markerId.value == 'posicao');

      for (int i = 0; i < data.length; i++) {
        markers.add(Marker(
            infoWindow: InfoWindow(
                title: i == 0
                    ? 'Passageiro'
                    : i == 1
                    ? 'Destino'
                    : 'Motorista'),
            markerId: MarkerId(i < 2 ? 'marcas${i}' : 'posicao'),
            icon: i == 0
                ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet)
                : i == 1
                ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen)
                : BitmapDescriptor.fromAsset('assets/marker.png'),
            position: data[i]));
      }
    } catch (err) {
      print(err.toString());
    }

    try {
      for (int i = 0; i < ways.length; i++) {
        MarkerId markerWay = MarkerId("way${i + 1}");
        markers.add(Marker(
          infoWindow: InfoWindow(title: 'Parada nº ${i + 1}'),
          markerId: markerWay,
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: ways[i],
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    return markers;
  }

  List<Polyline> getPolys(motorista, data) {
    List<Polyline> poly = [];

    if (data == null) {
      return poly;
    }
    if (motorista == null) {
      return poly;
    }
    try {
      for (int i = 0; i < motorista.length; i++) {
        PolylineId id2 = PolylineId("poly${i}");
        poly.add(Polyline(
          width: 10,
          polylineId: id2,
          color: Colors.blue,
          points: motorista[i],
          consumeTapEvents: true,
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    try {
      for (int i = 0; i < data.length; i++) {
        PolylineId id = PolylineId("polypassageiro${i}");
        poly.add(Polyline(
          width: 10,
          polylineId: id,
          color: Colors.deepPurple,
          points: data[i],
          consumeTapEvents: true,
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    return poly;
  }

  atualizarLocalizacaoNomes() async {
    if (segundaetapa == null) {
      segundaetapa = false;
    }
    cf.inDesembarque.add(segundaetapa);
    for (CarroAtivo ca in ac.ativos) {
      List<Placemark> mark = await Geolocator().placemarkFromCoordinates(
          ca.localizacao.latitude, ca.localizacao.longitude);
      Placemark place = mark[0];

      distancia = calculateDistance(
          passageiro_latlng.latitude,
          passageiro_latlng.longitude,
          ca.localizacao.latitude,
          ca.localizacao.longitude);

      rc.inDistancia.add(distancia);
      if (distancia < 0.1) {
        segundaetapa = true;
        cf.inDesembarque.add(segundaetapa);
        distancia2 = calculateDistance(destino.latitude, destino.longitude,
            ca.localizacao.latitude, ca.localizacao.longitude);
        rc.inDistancia.add(distancia2);
      }
      if (segundaetapa) {
        if (distancia2 < 0.1) {
          finalDaCorrida = true;
        }
      }
    }
  }

  rotaPassageiro(requisicaoController) async {
    List<LatLng> marcasWays = [];
    passageiro_latlng = LatLng(
        requisicaoController.origem.lat, requisicaoController.origem.lng);
    String embarque = requisicaoController.origem.endereco;
    String desembarque = requisicaoController.destino.endereco;
    if (segundaetapa == false) {
      rc.inLocalizacaoNome.add(embarque);
    } else {
      rc.inLocalizacaoNome.add(desembarque);
    }
    if (requisicaoController.primeiraParada_lat != null) {
      parada1 = LatLng(requisicaoController.primeiraParada_lat,
          requisicaoController.primeiraParada_lng);

      marcasWays.add(parada1);
    }
    if (requisicaoController.segundaParada_lat != null) {
      parada2 = LatLng(requisicaoController.segundaParada_lat,
          requisicaoController.segundaParada_lng);

      marcasWays.add(parada2);
    }
    if (requisicaoController.terceiraParada_lat != null) {
      parada3 = LatLng(requisicaoController.terceiraParada_lat,
          requisicaoController.terceiraParada_lng);
      marcasWays.add(parada3);
    }

    rc.inWays.add(marcasWays);

    destino = LatLng(
        requisicaoController.destino.lat, requisicaoController.destino.lng);
    marcasRota.add(passageiro_latlng);
    marcasRota.add(destino);
    for (CarroAtivo ca in ac.ativos) {
      motorista_latlng =
          LatLng(ca.localizacao.latitude, ca.localizacao.longitude);
      rc.CalcularRotaMotorista(motorista_latlng, passageiro_latlng);
    }

    if (requisicaoController.primeiraParada_lat == null) {
      rc.CalcularRotaPassageiro(passageiro_latlng, requisicaoController);
    } else {
      rc.AdicionarParadaPassageiro(requisicaoController, marcasWays);
    }
    rc.inMarkers.add(marcasRota);
  }
}
doLogout(context) async {

  Helper.fbmsg.unsubscribeFromTopic(Helper.localUser.id);
  await FirebaseAuth.instance.signOut();

  Helper.localUser = null;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  });


}