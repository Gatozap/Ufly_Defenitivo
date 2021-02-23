import 'dart:async';

import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufly/Objetos/Rota.dart';
import 'package:flutter_map/flutter_map.dart' as fm;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_pixel/responsive_pixel.dart';

import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ufly/Ativos/AtivosController.dart';

import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'package:ufly/CorridaBackground/corrida_controller.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';

import 'package:ufly/Helpers/References.dart';

import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Motorista/motorista_controller_edit.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/FiltroMotorista.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/User.dart';

import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Perfil/PerfilController.dart';
import 'package:ufly/Perfil/user_list_controller.dart';
import 'package:ufly/Rota/rota_controller.dart';

import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';

import 'package:flutter_animarker/lat_lng_interpolation.dart';

import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Helpers/Helper.dart';


class CorridaPage extends StatefulWidget {
  CorridaPage();

  @override
  _CorridaPageState createState() => new _CorridaPageState();
}

class _CorridaPageState extends State<CorridaPage> {
  double tempo = 25;

  var controllerPreco = new MoneyMaskedTextController(
      leftSymbol: 'R\$', decimalSeparator: '.', thousandSeparator: ',');
  final GeolocatorService geo = GeolocatorService();

  Completer<GoogleMapController> _controller = Completer();
  RotaController rc;
  final CountdownController controller = CountdownController();
  RequisicaoCorridaController requisicaoController =
      RequisicaoCorridaController();
  var color_green = Colors.green;
  var color_red = Colors.red;

  ControllerFiltros cf;
  MotoristaControllerEdit mt;
  Placemark placemark;
  OfertaCorridaController ofertaCorridaController;
  UserListController usc;
  Requisicao rr;
  String _currentAddress;
  List<Polyline> polylines;
  LatLngInterpolationStream _latLngStream = LatLngInterpolationStream();
  //StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();
  StreamSubscription<Position> positionStream;
  String destinoAddress;
  List<Marker> markers;
  List<LatLng> polylineCoordinates = [];
  MotoristaController motoro;
  static LatLng _initialPosition;
  static LatLng destino;
  static LatLng passageiro_latlng;
  LatLng get initialPosition => _initialPosition;
  PerfilController pf = PerfilController(Helper.localUser);
  String filtro;
  @override
  void initState() {
    bg.BackgroundGeolocation.start();
    localizacaoInicial();

    geo.getCurrentLocation().listen((position) {
      telaCentralizada(position);
    });

    super.initState();
  }

  AtivosController ac;
  var lastRota;
  List<fm.LayerOptions> layers;

  @override
  Widget build(BuildContext context) {
    if (layers == null) {
      layers = [
        new fm.TileLayerOptions(
          urlTemplate:
          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        )
      ];
  

    }
    ResponsivePixelHandler.init(
      baseWidth: 360, //A largura usado pelo designer no modelo desenhado
    );
    localizacaoInicial();
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
    }
    if (corridaController == null) {
      corridaController = CorridaController();
    }
    if (rc == null) {
      rc = RotaController();
    }

    if (ac == null) {
      ac = AtivosController();
    }
    if (ofertaCorridaController == null) {
      ofertaCorridaController = OfertaCorridaController();
    }
    if (mt == null) {
      mt = MotoristaControllerEdit();
    }
    if (motoro == null) {
      motoro = MotoristaController();
    }
    if (cf == null) {
      cf = ControllerFiltros();
    }

    var map = StreamBuilder(
        stream: rc.outPolyMotorista,
        builder: (context, snapMotorista) {
          return StreamBuilder(
            stream: rc.outPolyPassageiro,
            builder: (context, snap) {
              print('snap polyy ${snap.data}');
              polylines =
                  getPolys(snap.data);

              return StreamBuilder<LatLng>(
                  stream: rc.outLocalizacao,
                  builder: (context, localizacao) {
                    print('localizacao ${localizacao.data}');
                    print('aqui position ${_initialPosition}');
                    if (localizacao.data == null) {
                      return StreamBuilder<Position>(
                          stream: localizacaoInicial(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              print('aqui position ${_initialPosition}');
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
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                centerView();
                              },
                            );
                          });
                    }



                    return
                      StreamBuilder<fm.MarkerLayerOptions>(
                          stream: corridaController.outUserLocation,
                          builder: (context, marker) {
                            markers = getMarkers(passageiro_latlng,
                                destino,LatLng(marker.data.markers[0].point.latitude,marker.data.markers[0].point.longitude)  );
                            print('aqui marker usuario ${destino}');
                            return  GoogleMap(
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                trafficEnabled: true,
                                polylines: polylines.toSet(),
                                markers: destino !=null? markers.toSet():null,
                                mapType: MapType.terrain,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: false,
                                rotateGesturesEnabled: false,
                                initialCameraPosition: CameraPosition(
                                    target: localizacao.data,
                                    zoom: Helper.localUser.zoom),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                  destino == null ? null : centerView();
                                  geo.getCurrentLocation().listen((position) {
                                    telaCentralizada(position);
                                  });
                                },
                          );
                              }
                            );

                  });
            },
          );
        });

    return Scaffold(
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('', context, actions: [
        StreamBuilder<bool>(
            stream: cf.outHide,
            builder: (context, snapshot) {
              if (cf.hide == null) {
                cf.hide = false;
              }

              return IconButton(
                icon: Icon(
                  cf.hide == true ? MdiIcons.eyeOff : MdiIcons.eye,
                  color: Colors.blue,
                ),
                onPressed: () {
                  cf.hide = !cf.hide;
                  cf.inHide.add(snapshot.data);
                },
              );
            }),
      ]),
      bottomSheet: StreamBuilder<FiltroMotorista>(
          stream: cf.outFiltro,
          builder: (context, filtro) {
            FiltroMotorista f = filtro.data;
            print('aqui f ${f.isOnline}');
            return Container(
              color: Colors.white,
              child: StreamBuilder<Carro>(
                stream: corridaController.outCarro,
                builder: (context, carro) {
                  return StreamBuilder<Motorista>(
                      stream: mt.outMotorista,
                      builder: (context, motorista) {
                        if (motorista.data == null) {
                          return Container();
                        }
                        if (motorista.data.isOnline == null) {
                          motorista.data.isOnline = filtro.data.isOnline;
                        }
                        print('aqui motorista ${motorista.data}');
                        return StreamBuilder<List<Requisicao>>(
                            stream: requisicaoController.outRequisicoes,
                            builder: (context,
                                AsyncSnapshot<List<Requisicao>> requisicao) {
                              if (requisicao.data == null ||
                                  requisicao.data.isEmpty) {
                                print('aqui req.data ${requisicao.data}');
                                return StreamBuilder<bool>(
                                    stream: corridaController.outStarted,
                                    builder: (context, started) {
                                      print('aqui start ${started.data}');
                                      return Container(
                                      width: getLargura(context),
                                      height: getAltura(context) * .060,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          carro.data == null
                                              ? Expanded(
                                                  child: hText(
                                                      'Não conseguimos encontrar seu carro contate o suporte', context,
                                                      color: Colors.white,
                                                      textaling: TextAlign.center),
                                                )
                                              : started.data
                                              ?GestureDetector(
                                                  onTap: () async {
                                                    layers = [
                                                      new fm.TileLayerOptions(
                                                          urlTemplate:
                                                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                          subdomains: ['a', 'b', 'c']),
                                                    ];
                                                    corridaController
                                                        .finalizarCorrida();

                                                  },
                                                  child: hTextAbel(
                                                      'OFFLINE', context,
                                                      size: 20,
                                                      weight: FontWeight.bold,
                                                      color:
                                                          motorista.data.isOnline ==
                                                                  false
                                                              ? Color.fromRGBO(
                                                                  255, 184, 0, 30)
                                                              : Colors.black),
                                                ):

                                          GestureDetector(
                                            onTap: () async {

                                              corridaController.iniciarCorrida();
                                            },
                                            child: hTextAbel(
                                              'ONLINE',
                                              context,
                                              size: 20,
                                              weight: FontWeight.bold,
                                              color: motorista.data.isOnline == true
                                                  ? Color.fromRGBO(255, 184, 0, 30)
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                );
                              } else {
                                for (Requisicao i in requisicao.data) {
                                  print('aqui req.data323 ${i}');
                                  return StreamBuilder<bool>(
                                      stream: corridaController.outStarted,
                                      builder: (context, started) {
                                        print('aqui start ${started.data}');
                                        return Container(
                                          width: getLargura(context),
                                          height: getAltura(context) * .060,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: i.motoristas_chamados
                                                    .contains(Helper.localUser.id)
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      carro.data == null
                                                          ? Expanded(
                                                              child: hText(
                                                                  'Não conseguimos encontrar seu carro contate o suporte',
                                                                  context,
                                                                  color:
                                                                      Colors.white,
                                                                  textaling:
                                                                      TextAlign
                                                                          .center),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () async {

                                                                corridaController
                                                                    .finalizarCorrida();
                                                              },
                                                              child: hTextAbel(
                                                                  'OFFLINE',
                                                                  context,
                                                                  size: 20,
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: started.data ==
                                                                          false
                                                                      ? Color
                                                                          .fromRGBO(
                                                                              255,
                                                                              184,
                                                                              0,
                                                                              30)
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                      sb,
                                                      sb,
                                                      hTextAbel('|', context,
                                                          size: 20),
                                                      sb,
                                                      sb,
                                                      GestureDetector(
                                                        onTap: () async {
                                                          corridaController
                                                              .iniciarCorrida();
                                                        },
                                                        child: hTextAbel(
                                                          'ONLINE',
                                                          context,
                                                          size: 20,
                                                          weight: FontWeight.bold,
                                                          color:started.data ==
                                                                  true
                                                              ? Color.fromRGBO(
                                                                  255, 184, 0, 30)
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ));
                                    }
                                  );
                                }
                              }
                            });
                      });
                },
              ),
            );
          }),
      body: StreamBuilder<bool>(
          stream: cf.outHide,
          builder: (context, hide) {
            print('aqui hide');
            if (cf.hide == null) {
              cf.hide = false;
            }

            return
                    Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    map,
                    Positioned(
                      bottom: getLargura(context) * .250,
                      right: getAltura(context) * .025,
                      child: FloatingActionButton(
                        onPressed: () {
                          localizacaoInicial();
                        },
                        child: Icon(Icons.my_location, color: Colors.black),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    StreamBuilder<List<Requisicao>>(
                        stream: requisicaoController.outRequisicoes,
                        builder:
                            (context, AsyncSnapshot<List<Requisicao>> requisicao) {
                          print('aqui requisicao ${requisicao.data}');
                          return IgnorePointer(
                            ignoring: cf.hide,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Requisicao req = requisicao.data[index];
                                if(requisicao.data.length == null){
                                  return Container();
                                }
                                else if (req.aceito == null) {
                                  if (req.motoristas_chamados
                                      .contains(Helper.localUser.id)) {
                                    print('aqui bool ${req}');
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: getAltura(context) * .045),
                                        child:
                                            SolicitacaoDoPassageiro(req, cf.hide));
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                              itemCount: requisicao.data.length,
                            ),
                          );
                        }),
                  ],
                );

          }),
    );
  }

  Widget SolicitacaoDoPassageiro(requisicaoController, hide) {
    print('aqui preço ${controllerPreco.text}');
    double preco_recebo = ((double.parse(controllerPreco.text
                .replaceAll(',', '')
                .replaceAll('R\$', ''))) *
            90) /
        100;

    if (usc == null) {
      usc = UserListController(requisicao: requisicaoController);
    }

    return StreamBuilder<List<User>>(
        stream: usc.outUsers,
        builder: (context, AsyncSnapshot<List<User>> user) {
          print('aqui user');
          double preco_outros =
              requisicaoController.tempo_estimado < 2.00 ? 3 : 5;
          double preco_mercado =
              (preco_outros) * requisicaoController.distancia;
          double preco_mercado_liquido = ((preco_mercado) * 75) / 100;
          double preco_minimo = ((preco_mercado) * 85) / 100;
          double preco_minimo_liquido = ((preco_mercado) * 90) / 100;
          print('aqui o hiide ${hide}');
          return Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
                color: Colors.transparent.withOpacity(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    hide == true
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                                rotaPassageiro(requisicaoController);

                              centerView();
                              cf.hide = true;
                              cf.inHide.add(cf.hide);
                            },
                            child: Container(
                              width: getLargura(context) * .5,
                              height: getAltura(context) * .050,
                              child: hTextMal(
                                  requisicaoController.isViagem == true
                                      ? 'Viagem'
                                      : 'Entrega',
                                  context,
                                  size: 25,
                                  textaling: TextAlign.center,
                                  weight: FontWeight.bold,
                                  color: hide == true
                                      ? Colors.transparent.withOpacity(0.0)
                                      : Colors.black),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                color: hide == true
                                    ? Colors.transparent.withOpacity(0.0)
                                    : Colors.white,
                              ),
                            ),
                          ),
                    Container(
                      height: getAltura(context) * .58,
                      width: getLargura(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: hide == true
                            ? Colors.transparent.withOpacity(0.0)
                            : Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: ResponsivePixelHandler.toPixel(
                                        15, context),
                                    bottom: ResponsivePixelHandler.toPixel(
                                        5, context),
                                    left: ResponsivePixelHandler.toPixel(
                                        10, context),
                                    right: ResponsivePixelHandler.toPixel(
                                        10, context)),
                                child: hide == true
                                    ? Container()
                                    : CircleAvatar(
                                        backgroundImage:
                                            user.data[0].foto == null
                                                ? AssetImage(
                                                    'assets/logo_drawer.png')
                                                : CachedNetworkImageProvider(
                                                    user.data[0].foto),
                                        radius: 40),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: ResponsivePixelHandler.toPixel(
                                        15, context),
                                    bottom: ResponsivePixelHandler.toPixel(
                                        5, context),
                                    left: ResponsivePixelHandler.toPixel(
                                        10, context),
                                    right: ResponsivePixelHandler.toPixel(
                                        10, context)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        hTextMal(requisicaoController.user_nome,
                                            context,
                                            size: 20,
                                            weight: FontWeight.bold,
                                            color: hide == true
                                                ? Colors.transparent
                                                    .withOpacity(0.0)
                                                : Colors.black),
                                        sb,
                                        hide == true
                                            ? Container()
                                            : Image.asset('assets/estrela.png'),
                                        sb,
                                        hTextAbel('5,0', context,
                                            size: 20,
                                            color: hide == true
                                                ? Colors.transparent
                                                    .withOpacity(0.0)
                                                : Colors.black),
                                        sb,
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        user.data[0].isMale == true
                                            ? hTextMal('Masculino', context,
                                                size: 20,
                                                color: hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black)
                                            : hTextMal('Feminino', context,
                                                size: 20,
                                                color: hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black),
                                        sb,
                                        hide == true
                                            ? Container()
                                            : Icon(
                                                MdiIcons
                                                    .transitConnectionVariant,
                                                size: 30,
                                                color: Colors.blue,
                                              ),

                                        sb,

                                        //hTextMal('${passageiro.viagens} viagens', context,                                     size: 50)
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        hTextMal(
                                            '${requisicaoController.forma_de_pagamento.toLowerCase()}',
                                            context,
                                            size: 20,
                                            weight: FontWeight.bold,
                                            color: hide == true
                                                ? Colors.transparent
                                                    .withOpacity(0.0)
                                                : Colors.black),
                                        hide = true
                                            ? Container()
                                            : Icon(
                                                Icons.memory,
                                                size: 25,
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              cronometro(context, cf.hide, requisicaoController)
                              /* StreamBuilder<bool>(
                                      stream: cf.outHide,
                                      builder: (context, snapshot) {
                                        return Padding(
                                        padding: EdgeInsets.only(
                                            top: getAltura(context) * .040,
                                            bottom: getAltura(context) * .010,
                                            left: getLargura(context) * .010,
                                            right: getLargura(context) * .050),
                                        child: IconButton(
                                          onPressed: (){
                                            requisicao(requisicaoController);
                                            centerView();
                                            cf.hide = true;
                                            cf.inHide.add(snapshot.data);
            }      ,
                                            icon: Icon(Icons.memory, size: 50)
                                        ),
                                      );
                                    }
                                  )*/
                            ],
                          ),
                          sb,
                          Container(
                            width: getLargura(context),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left:
                                    ResponsivePixelHandler.toPixel(5, context),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                            right: BorderSide(
                                                color: cf.hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black),
                                            bottom: BorderSide(
                                                color: cf.hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black),
                                          )),
                                          width: getLargura(context) * .30,
                                          height: getAltura(context) * .130,
                                          child: Column(
                                            children: <Widget>[
                                              cf.hide == true
                                                  ? Container()
                                                  : hTextMal('Mercado', context,
                                                      size: 20,
                                                      weight: FontWeight.bold,
                                                      color: Colors.black),
                                              sb,
                                              cf.hide == true
                                                  ? Container()
                                                  : hTextMal(
                                                      'R\$ ${preco_mercado.toStringAsFixed(2)}',
                                                      context,
                                                      size: 20,
                                                      color: cf.hide == true
                                                          ? Colors.transparent
                                                              .withOpacity(0.0)
                                                          : Colors.black),
                                              sb,
                                              sb,
                                            ],
                                          )),
                                    ],
                                  ),
                                  cf.hide == true
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  right: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                )),
                                                width:
                                                    getLargura(context) * .30,
                                                height:
                                                    getAltura(context) * .130,
                                                child: Column(
                                                  children: <Widget>[
                                                    hTextMal(
                                                      'Mínimo',
                                                      context,
                                                      size: 20,
                                                      weight: FontWeight.bold,
                                                    ),
                                                    sb,
                                                    hTextMal(
                                                        'R\$ ${preco_minimo.toStringAsFixed(2)}',
                                                        context,
                                                        size: 20,
                                                        color: Colors.black),
                                                    sb,
                                                    sb,
                                                  ],
                                                )),
                                          ],
                                        ),
                                  cf.hide == true
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  bottom: BorderSide(
                                                      color: hide == true
                                                          ? Colors.transparent
                                                              .withOpacity(0.0)
                                                          : Colors.black),
                                                )),
                                                width:
                                                    getLargura(context) * .35,
                                                height:
                                                    getAltura(context) * .130,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    hTextMal(
                                                        'Passageiro', context,
                                                        size: 20,
                                                        weight: FontWeight.bold,
                                                        color: Colors.black),
                                                    sb,
                                                    hide == true
                                                        ? Container()
                                                        : Container(
                                                            width: getLargura(
                                                                    context) *
                                                                .32,
                                                            height: getAltura(
                                                                    context) *
                                                                .060,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  controllerPreco,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              expands: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                fillColor:
                                                                    Colors
                                                                        .black,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                labelText:
                                                                    'Preço',
                                                                hintText:
                                                                    'R\$ ',
                                                                contentPadding: EdgeInsets.fromLTRB(
                                                                    ResponsivePixelHandler
                                                                        .toPixel(
                                                                            15,
                                                                            context),
                                                                    ResponsivePixelHandler
                                                                        .toPixel(5,
                                                                            context),
                                                                    ResponsivePixelHandler
                                                                        .toPixel(
                                                                            15,
                                                                            context),
                                                                    ResponsivePixelHandler
                                                                        .toPixel(
                                                                            5,
                                                                            context)),
                                                              ),
                                                            ),
                                                          ),
                                                    sb,
                                                  ],
                                                )),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          cf.hide == true
                              ? Container()
                              : Container(
                                  width: getLargura(context),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: ResponsivePixelHandler.toPixel(
                                          5, context),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: ResponsivePixelHandler
                                                    .toPixel(5, context),
                                              ),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                    right: BorderSide(
                                                        color: hide == true
                                                            ? Colors.transparent
                                                                .withOpacity(
                                                                    0.0)
                                                            : Colors.black),
                                                  )),
                                                  width:
                                                      getLargura(context) * .30,
                                                  height:
                                                      getAltura(context) * .130,
                                                  child: Column(
                                                    children: <Widget>[
                                                      hide == true
                                                          ? Container()
                                                          : hTextMal('Líquido',
                                                              context,
                                                              size: 20,
                                                              weight: FontWeight
                                                                  .bold,
                                                              color: hide ==
                                                                      true
                                                                  ? Colors
                                                                      .transparent
                                                                      .withOpacity(
                                                                          0.0)
                                                                  : Colors
                                                                      .black),
                                                      hTextMal(
                                                          '(-25%)', context,
                                                          size: 20),
                                                      hTextMal(
                                                          'R\$ ${preco_mercado_liquido.toStringAsFixed(2)}',
                                                          context,
                                                          size: 20,
                                                          color: hide == true
                                                              ? Colors
                                                                  .transparent
                                                                  .withOpacity(
                                                                      0.0)
                                                              : Colors.black),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: ResponsivePixelHandler
                                                    .toPixel(5, context),
                                              ),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                    right: BorderSide(
                                                        color: hide == true
                                                            ? Colors.transparent
                                                                .withOpacity(
                                                                    0.0)
                                                            : Colors.black),
                                                  )),
                                                  width:
                                                      getLargura(context) * .30,
                                                  height:
                                                      getAltura(context) * .130,
                                                  child: Column(
                                                    children: <Widget>[
                                                      hTextMal(
                                                          'Líquido', context,
                                                          size: 20,
                                                          weight:
                                                              FontWeight.bold),
                                                      hTextMal(
                                                          '(-10%)', context,
                                                          size: 20),
                                                      hTextMal(
                                                          'R\$${preco_minimo_liquido.toStringAsFixed(2)}',
                                                          context,
                                                          size: 20),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: ResponsivePixelHandler
                                                    .toPixel(5, context),
                                              ),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border()),
                                                  width:
                                                      getLargura(context) * .35,
                                                  height:
                                                      getAltura(context) * .130,
                                                  child: Column(
                                                    children: <Widget>[
                                                      hTextMal(
                                                          'Recebo', context,
                                                          size: 20,
                                                          weight:
                                                              FontWeight.bold),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Container(
                                                          width: getLargura(
                                                                  context) *
                                                              .30,
                                                          height: getAltura(
                                                                  context) *
                                                              .040,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all()),
                                                          child: Center(
                                                              child: hTextMal(
                                                                  'R\$ ${preco_recebo.toStringAsFixed(2)}',
                                                                  context,
                                                                  size: 20,
                                                                  textaling:
                                                                      TextAlign
                                                                          .center))),
                                                      sb,
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          sb,
                          cf.hide == true
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        try {
                                          await requisicaoRef
                                              .doc(requisicaoController.id)
                                              .update({
                                            'motoristas_chamados':
                                                FieldValue.arrayRemove(
                                                    ['${Helper.localUser.id}'])
                                          }).then((v) {
                                            print(
                                                'sucesso ao tirar motorista da lista');
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                            height: getAltura(context) * .110,
                                            width: getLargura(context) * .355,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: hide == true
                                                  ? Colors.transparent
                                                      .withOpacity(0.0)
                                                  : Color.fromRGBO(
                                                      218, 218, 218, 100),
                                            ),
                                            child: Center(
                                                child: hTextAbel(
                                                    'Rejeitar', context,
                                                    size: 30,
                                                    weight: FontWeight.bold))),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        print('aqui botão ');
                                        double precofinal = double.parse(
                                            controllerPreco.text
                                                .replaceAll(',', '')
                                                .replaceAll('R\$', '')
                                                .replaceAll('.', ''));
                                        print(
                                            'aqui botão ${precofinal.toStringAsFixed(2)}');
                                        if (precofinal != 0.0) {
                                          List<OfertaCorrida> ofertaList =
                                              List();
                                          OfertaCorrida oferta = OfertaCorrida(
                                              requisicao:
                                                  requisicaoController.id,
                                              id_usuario:
                                                  requisicaoController.user,
                                              data: requisicaoController
                                                  .created_at,
                                              motorista: Helper.localUser.id,
                                              preco: double.parse(
                                                  controllerPreco.text
                                                      .replaceAll(',', '.')
                                                      .replaceAll('R\$', '')));
                                          ofertaList.add(oferta);
                                          await ofertacorridaRef
                                              .add(oferta.toJson())
                                              .then((v) {
                                            oferta.id = v.id;
                                            List jumento = new List();
                                            jumento.add(v.id);
                                            requisicaoController.ofertas =
                                                jumento;
                                            ofertacorridaRef
                                                .doc(oferta.id)
                                                .update(oferta.toJson());

                                            Requisicao req = Requisicao(
                                              ofertas: jumento,
                                              motoristas_chamados:
                                                  requisicaoController
                                                      .motoristas_chamados,
                                              valid_until: requisicaoController
                                                  .valid_until,
                                              tempo_estimado:
                                                  requisicaoController
                                                      .tempo_estimado,
                                              rota: requisicaoController.rota,
                                              distancia: requisicaoController
                                                  .distancia,
                                              destino:
                                                  requisicaoController.destino,
                                              created_at: requisicaoController
                                                  .created_at,
                                              id: requisicaoController.id,
                                              aceito:
                                                  requisicaoController.aceito,
                                              deleted_at: requisicaoController
                                                  .deleted_at,
                                              isViagem:
                                                  requisicaoController.isViagem,
                                              origem:
                                                  requisicaoController.origem,
                                              updated_at: requisicaoController
                                                  .updated_at,
                                              user: requisicaoController.user,
                                              user_nome: requisicaoController
                                                  .user_nome,
                                            );

                                            print(
                                                'aqui o for ${req.ofertas} e ${req.toJson()} e 213235423432 ');

                                            return requisicaoRef
                                                .doc(req.id)
                                                .update(req.toJson())
                                                .then((v) {
                                              print('aqui oferta atualizada');
                                              dToast('Você aceitou a viagem');

                                              requisicaoRef.doc(req.id).update({
                                                'motoristas_chamados':
                                                    FieldValue.arrayRemove([
                                                  '${Helper.localUser.id}'
                                                ])
                                              }).then((v) {
                                                print(
                                                    'sucesso ao tirar motorista da lista');
                                              });
                                            });
                                          });
                                        } else {
                                          print('aqui campo vazio');
                                          dToast('Preencha o campo preço');
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            ResponsivePixelHandler.toPixel(
                                                8, context)),
                                        child: Container(
                                            height: getAltura(context) * .110,
                                            width: getLargura(context) * .355,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: hide == true
                                                  ? Colors.transparent
                                                      .withOpacity(0.0)
                                                  : Color.fromRGBO(
                                                      255, 184, 0, 30),
                                            ),
                                            child: Center(
                                                child: hTextAbel(
                                                    'Aceitar', context,
                                                    size: 30,
                                                    weight: FontWeight.bold))),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
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

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
    controller.animateCamera(cameraUpdate);
  }

  Future<void> telaCentralizada(Position position) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: Helper.localUser.zoom, )));
  }
   rotaPassageiro(requisicaoController)async{
     passageiro_latlng = LatLng(requisicaoController.origem.lat, requisicaoController.origem.lng);

     destino= LatLng(requisicaoController.destino.lat,
         requisicaoController.destino.lng);
     print('aqui inital ${_initialPosition} e passageiro ${destino}');
     rc.CalcularRotaMotorista(_initialPosition, destino);

     List<LatLng> rotas = [];


    /* for (int i = 0;
     i < requisicaoController.rota.routes.length;
     i++) {
       print('aqui rotas ${requisicaoController.rota.routes.length}');



            rotas.add(passageiro_latlng);

       for (var l
       in requisicaoController.rota.routes[0].legs) {
         for (var s in l.steps) {
           for (var i in s.intersections) {
             rotas.add(LatLng(i.location[1], i.location[0]));

           }
         }
       }

     }
        destino= LatLng(requisicaoController.destino.lat,
                 requisicaoController.destino.lng);
     rotas.add(destino);

     rc.inPolyPassageiro.add(rotas);
     return rotas;*/
   }

  List<Polyline> getPolys(motorista, {data} ) {
    List<Polyline> poly = new List();

    if (data == null) {
      return poly;
    }
    if (motorista == null) {
      return poly;
    }
    try {
      for (int i = 0; i < data.length; i++) {
        PolylineId id = PolylineId("poly${i}");
        poly.add(Polyline(
          width: 5,
          polylineId: id,
          color: Colors.deepPurpleAccent,
          points: data[i],
          consumeTapEvents: true,
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    try {
      for (int i = 0; i < motorista.length; i++) {
        PolylineId id2 = PolylineId("poly${i}");
        poly.add(Polyline(
          width: 5,
          polylineId: id2,
          color: Colors.blue,
          points: motorista[i],
          consumeTapEvents: true,
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    return poly;
  }

  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      print('aqui porra da localização ${v.latitude}');
      telaCentralizada(v);
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
      _initialPosition = LatLng(v.latitude, v.longitude);
      List<Placemark> mark =
          await Geolocator().placemarkFromCoordinates(v.latitude, v.longitude);

      _currentAddress =
          '${mark[0].name.isNotEmpty ? mark[0].name + ', ' : ''}${mark[0].thoroughfare.isNotEmpty ? mark[0].thoroughfare + ', ' : ''}${mark[0].subLocality.isNotEmpty ? mark[0].subLocality + ', ' : ''}${mark[0].locality.isNotEmpty ? mark[0].locality + ', ' : ''}${mark[0].subAdministrativeArea.isNotEmpty ? mark[0].subAdministrativeArea + ', ' : ''}${mark[0].postalCode.isNotEmpty ? mark[0].postalCode + ', ' : ''}${mark[0].administrativeArea.isNotEmpty ? mark[0].administrativeArea : ''}';
      filtro =
          '${mark[0].subAdministrativeArea.isNotEmpty ? mark[0].subAdministrativeArea : ''}';
    });
  }


}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

void onCameraMove(CameraPosition position, LatLng l) {
  l = position.target;
}

BitmapDescriptor sourceIcon;
List<Marker> getMarkers(LatLng data, LatLng d,LatLng motorista) {
  List<Marker> markers = new List();
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
        infoWindow: InfoWindow(title: 'Destino do Passageiro'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng(d.latitude, d.longitude)));
  } catch (err) {
    print(err.toString());
  }
  try {
    markers.add(Marker(
        markerId: markerId3,
        infoWindow: InfoWindow(title: 'Minha Posição'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: motorista));
  } catch (err) {
    print(err.toString());
  }
  return markers;
}
