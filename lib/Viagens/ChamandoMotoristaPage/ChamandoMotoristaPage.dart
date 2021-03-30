import 'dart:async';

import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ufly/Avaliacao/AvaliacaoPage.dart';


import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ufly/Ativos/AtivosController.dart';


import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;


import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';



import 'package:ufly/Motorista/motorista_controller.dart';

import 'package:ufly/Objetos/CarroAtivo.dart';

import 'package:ufly/Objetos/OfertaCorrida.dart';


import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';

import 'package:ufly/Rota/rota_controller.dart';

import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';


import 'package:ufly/Helpers/Helper.dart';

class ChamandoMotoristaPage extends StatefulWidget {
  ChamandoMotoristaPage({Key key}) : super(key: key);

  @override
  _ChamandoMotoristaPageState createState() {
    return _ChamandoMotoristaPageState();
  }
}

class _ChamandoMotoristaPageState extends State<ChamandoMotoristaPage> {
  Completer<GoogleMapController> _controller = Completer();
  List<Polyline> polylines;
  RotaController rc;
  OfertaCorridaController ofertaCorridaController;
  LatLng _initialPosition;
  LatLng destino;
  LatLng passageiro_latlng;
  LatLng motorista_latlng;
  LatLng parada1;
  LatLng parada2;
  LatLng parada3;
  RequisicaoCorridaController requisicaoController =
      RequisicaoCorridaController();
  List<Marker> markers;
  AtivosController ac;
  MotoristaController mt;
  double distancia;
  final GeolocatorService geo = GeolocatorService();
  @override
  void initState() {
    if (ac == null) {
      ac = AtivosController();
    }
    if(ofertaCorridaController == null){
      ofertaCorridaController = OfertaCorridaController();
    }
    if (rc == null) {
      rc = RotaController();
    }
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
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
    if (mt == null) {
      mt = MotoristaController();
    }
    // TODO: implement build
    var map = StreamBuilder<List<Requisicao>>(
        stream: requisicaoController.outRequisicoes,
        builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
          for (var req in requisicao.data) {
            rotaPassageiro(req);
            Timer(Duration(seconds: 5), () {
              centerView();
            });
            return StreamBuilder(
                stream: rc.outPolyMotorista,
                builder: (context, snapMotorista) {
                  return StreamBuilder(
                    stream: rc.outPolyPassageiro,
                    builder: (context, snapPassageiro) {
                      polylines =
                          getPolys(snapMotorista.data, snapPassageiro.data);

                      return StreamBuilder<LatLng>(
                          stream: rc.outLocalizacao,
                          builder: (context, localizacao) {
                            if (localizacao.data == null) {
                              return StreamBuilder<Position>(
                                  stream: localizacaoInicial(),
                                  builder: (context, snapshot) {
                                    print(
                                        'aqui position ${snapPassageiro.data}');
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
                                  if (snapshot.data != null) {
                                    for(CarroAtivo ca in ac.ativos) {
                                      if (parada1 == null) {
                                        markers = getMarkers(passageiro_latlng,
                                            destino, LatLng(ca.localizacao.latitude, ca.localizacao.longitude));
                                      } else {
                                        markers = getMarkers(passageiro_latlng,
                                            destino, LatLng(ca.localizacao.latitude, ca.localizacao.longitude),
                                            ways: snapshot.data);
                                      }
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
                                      destino == null ? null : centerView();
                                      geo
                                          .getCurrentLocation()
                                          .listen((position) {
                                        telaCentralizada(position);
                                      });
                                    },
                                  );
                                });
                          });
                    },
                  );
                });
          }
        });
    return Scaffold(

      body: SlidingUpPanel(
        renderPanelSheet: false,
        minHeight: 60,
        maxHeight: getAltura(context) * .25,
        borderRadius: BorderRadius.circular(20),
        collapsed: Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24),
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20.0,
                              color: Colors.grey,
                            ),
                          ]),
                      width: getLargura(context) - 48,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          sb,
                          sb,
                          Container(
                            child: Container(
                                width: getLargura(context) * .4,
                                color: Colors.grey,
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
        panel: viagemWidget(),
        body: StreamBuilder<List<Requisicao>>(
            stream: requisicaoController.outRequisicoes,
            builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
              for (var req in requisicao.data) {
                return Container(
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
                           rotaPassageiro(req);

                            Timer(Duration(seconds: 5), () {
                              centerView();
                            });
                          },
                          child: Icon(Icons.zoom_out_map, color: Colors.black),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                          top: getAltura(context) * .060,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            height: getAltura(context) * .150,
                            width: getLargura(context) * .80,
                            child: Row(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: getAltura(context) * .030,
                                          left: getLargura(context) * .110),
                                      child: Icon(
                                        FontAwesomeIcons.mapMarkedAlt,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    StreamBuilder<double>(
                                      stream: rc.outDistancia,
                                      builder: (context, snapshot) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .020,
                                              left: getLargura(context) * .080),
                                          child: hTextMal('${snapshot.data.toStringAsFixed(2)}km', context,
                                              color: Colors.white, size: 20),
                                        );
                                      }
                                    ),
                                  ],
                                ),
                                StreamBuilder<String>(
                                  stream: rc.outLocalizacaoNome,
                                  builder: (context, snapshot) {
                                    return Expanded(
                                      child: Container(
                                        width: getLargura(context) * .52,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: getLargura(context) * .050),
                                          child: hTextMal(
                                              '${snapshot.data}',
                                              context,
                                              size: 15,
                                              color: Colors.white,
                                              weight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget viagemWidget(){
    return     Container(
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
                      backgroundColor: Colors.blue,
                      radius: 30,
                      backgroundImage:
                      AssetImage('assets/julio.png'),
                    ),
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
                      hTextAbel('Júlio', context,
                          size: 20, color: Colors.black),
                      Row(
                        children: <Widget>[
                          hTextAbel('5,0', context,
                              size: 20, color: Colors.black),
                          Container(
                            child: Image.asset(
                                'assets/estrela.png'),
                          ),
                        ],
                      ),
                      Row(children: <Widget>[ hTextAbel('Da sua carteira', context, size: 20, ),sb, Image.asset('assets/carteira.png') ],)
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: getLargura(context)*.150, bottom: getAltura(context)*.040),
                child: Container(child: Image.asset('assets/fechar.png')),
              )
            ],
          ),
          sb,
          Container(

            width: getLargura(context) * .70,
            height: getAltura(context) * .080,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                hTextMal('3 min', context,
                    size: 20,
                    color: Colors.black,
                    weight: FontWeight.bold),
                sb,  sb,
                Image.asset('assets/km.png'),
                sb,sb,
                hTextMal('2.1 Km', context,
                    size: 20,
                    color: Colors.black,
                    weight: FontWeight.bold),
              ],

            ),

          )
        ],
      ),
    );
  }

  Future<void> telaCentralizada(position) async {
    final GoogleMapController controller = await _controller.future;
    List<LatLng> marcaInicial = [];
    marcaInicial.add(LatLng(position.latitude, position.longitude));
    rc.inMarkers.add(marcaInicial);
    print('localizacao ${marcaInicial}');
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: Helper.localUser.zoom,
    )));
    atualizarLocalizacaoNomes();
  }

  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      print('localizacao ${v.latitude}');

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

  List<Marker> getMarkers(LatLng data, LatLng d, LatLng motorista, {ways}) {
    List<Marker> markers = [];
    MarkerId markerId = MarkerId('id');
    MarkerId markerId2 = MarkerId('id2');
    MarkerId markerId3 = MarkerId('id3');
    try {
      markers.add(Marker(
          infoWindow: InfoWindow(title: 'Passageiro'),
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: data));
    } catch (err) {
      print(err.toString());
    }
    try {
      markers.add(Marker(
          markerId: markerId2,
          infoWindow: InfoWindow(title: 'Destino'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: LatLng(d.latitude, d.longitude)));
    } catch (err) {
      print(err.toString());
    }
    try {
      markers.add(Marker(
          markerId: markerId3,
          infoWindow: InfoWindow(title: 'Motorista'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: motorista));
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
    for (CarroAtivo ca in ac.ativos) {
      List<Placemark> mark = await Geolocator().placemarkFromCoordinates(
          ca.localizacao.latitude, ca.localizacao.longitude);
      distancia = calculateDistance(
          passageiro_latlng.latitude,
          passageiro_latlng.longitude,
          ca.localizacao.latitude,
          ca.localizacao.longitude);
      print('aqui a soma ${distancia.toStringAsFixed(2)}');
      rc.inDistancia.add(distancia);
      if(distancia <0.2){
        dToast('Seu motorista chegou, não esqueça de usar mascara, cinto de seguranção e alcool em gel');
      }
      Placemark place = mark[0];
      String nomeLocalizacao = place.thoroughfare;

      rc.inLocalizacaoNome.add(nomeLocalizacao);
    }
  }

  rotaPassageiro(requisicaoController) async {
    List<LatLng> marcasWays = [];
    passageiro_latlng = LatLng(
        requisicaoController.origem.lat, requisicaoController.origem.lng);

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
    for (CarroAtivo ca in ac.ativos) {
      motorista_latlng =
          LatLng(ca.localizacao.latitude, ca.localizacao.longitude);
      rc.CalcularRotaMotorista(motorista_latlng, passageiro_latlng);
      atualizarLocalizacaoNomes();
    }
    if (requisicaoController.primeiraParada_lat == null) {
      rc.CalcularRotaPassageiro(passageiro_latlng, requisicaoController);
    } else {
      rc.AdicionarParadaPassageiro(requisicaoController, marcasWays);
    }
  }
}
