import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Ativos/AtivosController.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:ufly/Avaliacao/AvaliacaoPage.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';

import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Objetos/User.dart';
import 'package:ufly/Perfil/user_controller.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Viagens/Requisicao/criar_requisicao_controller.dart';

class InicioDeViagemPage extends StatefulWidget {
  Motorista motorista;
  Requisicao requisicao;
  InicioDeViagemPage(this.motorista, this.requisicao) ;

  @override
  _InicioDeViagemPageState createState() {
    return _InicioDeViagemPageState();
  }
}

class _InicioDeViagemPageState extends State<InicioDeViagemPage> {
  RequisicaoCorridaController requisicaoController =
      RequisicaoCorridaController();
  LatLng passageiro_latlng;
  LatLng initialPosition;
  LatLng destino;
  CriarRequisicaoController criaRc;
  List<LatLng> marcasRota = [];
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controllerGoogle;
  List<Polyline> polylines;
  RotaController rc;
  LatLng parada1;
  LatLng parada2;
  UserController userController;
  LatLng parada3;
  BitmapDescriptor bitmapIcon;
  LatLng motorista_latlng;
  List<Marker> markers;
  AtivosController ac;
  MotoristaController mt;
  double distanciaKm;
  bool segundaetapa = false;
  bool final_corrida = false;
  double distancia;
  double distancia2;
  final GeolocatorService geo = GeolocatorService();
  OfertaCorridaController ofertaCorridaController;
  @override
  void initState() {
    rotaPassageiro(widget.requisicao);

    Timer(Duration(seconds: 5), () {
      centerView();
    });
    segundaetapa = false;
    final_corrida = false;
    if (ac == null) {
      ac = AtivosController();
    }
    if(criaRc == null){
      criaRc = CriarRequisicaoController();
    }
    if (ofertaCorridaController == null) {
      ofertaCorridaController = OfertaCorridaController();
    }
    if (rc == null) {
      rc = RotaController();
    }
    if (userController == null) {
      userController = UserController();
    }
    bg.BackgroundGeolocation.start();
    localizacaoInicial();

    geo.getCurrentLocation().listen((position) {
      telaCentralizada(position);
    });

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
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
    }
    var map =


    StreamBuilder<List<Requisicao>>(
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
                                          target: initialPosition,
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


            if (final_corrida == true) {
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
                              widget.requisicao.deleted_at = DateTime.now();
                              criaRc.UpdateRequisicao(widget.requisicao);
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CorridaPage()));
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
                                          'Encerrar ', context,
                                          size: 25))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
            };
            return Scaffold(
              body:
              SlidingUpPanel(
                renderPanelSheet: false,
                minHeight: 60,
                panel: FinalizarCorrida(),
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
                body: Container(
                  height: getAltura(context),
                  width: getLargura(context),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      map,
                      botaoNavegar(),
                      botaoFinalCorrida(),
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
                                                final_corrida ==
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

  }
  botaoFinalCorrida(){
    return     Positioned(
      right: getLargura(context) * .060,
      bottom: getAltura(context) * .200,
      child: FloatingActionButton(
        heroTag: '2',
        onPressed: () {
          print('aqui o final ${final_corrida}');
          setState(() {final_corrida = true;});

        },
        child: Icon(
            Icons.close_fullscreen_sharp,
            color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }
  botaoNavegar(){
    return     Positioned(
      right: getLargura(context) * .060,
      bottom: getAltura(context) * .350,
      child: FloatingActionButton(
        heroTag: '2',
        onPressed: () {
centerView();
        },
        child: Icon(
            Icons.zoom_out_map,
            color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }
  BitmapDescriptor customIcon;

  List<Marker> getMarkers(data, {ways}) {
    print('aqui assests ${bitmapIcon.toString()}');

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
                        : 'Minha Posição'),
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
  List<Marker> getMarkers2(inicio, destino,motorista,{ way} ) {
    List<Marker> markers = [];
    if (destino == null) {
      return markers;
    }
    if (inicio == null) {
      return markers;
    }

    try {
      markers.add(Marker(
          infoWindow: InfoWindow(title: 'Embarque'),
          markerId: MarkerId('id${0}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue),
          position: inicio));
    }
    catch (err) {
      print(err.toString());
    }
    try {

      markers.add(Marker(
          infoWindow: InfoWindow(title: 'Desembarque'),
          markerId: MarkerId('id${69}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen),
          position: destino));

    }
    catch (err) {
      print(err.toString());
    }
    try {
      markers.add(Marker(
          infoWindow: InfoWindow(title: 'Minha Posição'),
          markerId: MarkerId('id${10}'),
          icon: BitmapDescriptor.fromAsset('assets/marker.png'),
          position: initialPosition));
    }
    catch (err) {
      print(err.toString());
    }
    try {

      for(int i = 0; i < way.length; i++) {

        markers.add(Marker(
            infoWindow:
            InfoWindow(title: 'Parada nº ${i+1}'),
            markerId: MarkerId('id${i+1}'),

            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            position: way[i]));
      }
    }
    catch (err) {
      print('err.toString() ${err.toString()}');
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

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 130);
    controller.animateCamera(cameraUpdate);
  }

  atualizarLocalizacaoNomes(position) async {

    List<Placemark> mark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    print('aq1ui latlng ${position.latitude} e ${position.longitude}');

    distancia = calculateDistance(passageiro_latlng.latitude,
        passageiro_latlng.longitude, position.latitude, position.longitude);
    print('aqui a soma ${distancia.toStringAsFixed(2)}');
    rc.inDistancia.add(distancia);

    if(distancia <0.4){
      segundaetapa = true;

      distancia2 = calculateDistance(
          destino.latitude,
          destino.longitude,
          position.latitude,
          position.longitude);
      rc.inDistancia.add(distancia2);
      return dToastPassageiro('Você chegou no embarque');

    }
    if(segundaetapa) {

      if (distancia2 < 0.4) {
        final_corrida = true;

      }
    }
    Placemark place = mark[0];
    String nomeLocalizacao = place.thoroughfare;

    rc.inLocalizacaoNome.add(nomeLocalizacao);
  }


  Future<void> telaCentralizada(position) async {
    final GoogleMapController controller = await _controller.future;

    marcasRota.add(LatLng(position.latitude, position.longitude));
    rc.inMarkers.add(marcasRota);
    print('localizacao ${marcasRota}');
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: Helper.localUser.zoom,
    )));
    atualizarLocalizacaoNomes(position);
  }

  Widget FinalizarCorrida() {
    if (mt == null) {
      mt = MotoristaController();
    }
    if (ofertaCorridaController == null) {
      ofertaCorridaController = OfertaCorridaController();
    }
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
    }
    return
      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: getAltura(context) * .250,
      width: getLargura(context) * .90,
      child:
               StreamBuilder<List<OfertaCorrida>>(
                  stream: ofertaCorridaController.outOfertaCorrida,
                  // ignore: missing_return
                  builder: (context,
                      AsyncSnapshot<List<OfertaCorrida>> ofertaCorrida) {
                    if (ofertaCorrida.data == null) {
                      return Container();
                    }
                    if (ofertaCorrida.data.length == 0) {
                      return Container();
                    }
                    for (OfertaCorrida oferta in ofertaCorrida.data) {
                      return StreamBuilder<List<User>>(
                          stream: userController.outUsers,
                          // ignore: missing_return
                          builder: (context, AsyncSnapshot<List<User>> user) {
                            for (var us in user.data) {
                              if (us.id == widget.requisicao.aceito.id_usuario) {
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: getAltura(context) *
                                                        .050,
                                                    left: getLargura(context) *
                                                        .070),
                                                child: us.foto == null
                                                    ? CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage: AssetImage(
                                                            'assets/logo_drawer.png'),
                                                      )
                                                    : CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                                us.foto),
                                                      )),
                                            sb,
                                          ],
                                        ),sb,
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .035,
                                              left: getLargura(context) * .025),
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                hTextAbel('${us.nome}', context,
                                                    size: 25,
                                                    color: Colors.black),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .035,
                                              left: getLargura(context) * .150),
                                          child: Container(
                                              alignment: Alignment.topRight,
                                              child: hTextAbel(
                                                  'R\$ ${oferta.preco.toStringAsFixed(2)}',
                                                  context,
                                                  size: 25,
                                                  color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                    sb,
                                     GestureDetector(
                                       onTap: () =>
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: hTextAbel(
                                                              'Deseja finalizar essa corrida?',
                                                              context,
                                                              size: 20),
                                                        ),
                                                        sb,
                                                        sb,
                                                        GestureDetector(

                                                          child: Container(
                                                            height: getAltura(context) * .050,
                                                            width: getLargura(context) * .5,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Color(0xFFf6aa3c),
                                                            ),
                                                            child: Container(
                                                                height: getAltura(context) * .125,
                                                                width: getLargura(context) * .85,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Color.fromRGBO(255, 184, 0, 30),
                                                                ),
                                                                child: Center(
                                                                    child:
                                                                    hTextAbel('OK', context, size: 20))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                        }),


                                    child:    GestureDetector(
                                      onTap:(){

                            },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                        width: getLargura(context) * .70,
                                        height: getAltura(context) * .070,
                                        child: Center(
                                            child: hTextMal(
                                                'Finalizar Corrida', context,
                                                size: 20,
                                                color: Colors.white,
                                                weight: FontWeight.bold)),
                                      ),
                                    ),
                                    )
                                  ],
                                );
                              }
                            }
                          });
                    }
                  })

    );
  }

  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      print('localizacao ${v.latitude}');
      telaCentralizada(v);
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
      initialPosition = LatLng(v.latitude, v.longitude);
    });
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
    if (requisicaoController.primeiraParada_lat == null) {
      rc.CalcularRotaPassageiro(passageiro_latlng, requisicaoController);
    } else {
      rc.AdicionarParadaPassageiro(requisicaoController, marcasWays);
    }
    destino = LatLng(
        requisicaoController.destino.lat, requisicaoController.destino.lng);
    marcasRota.add(passageiro_latlng);
    marcasRota.add(destino);


    for (CarroAtivo ca in ac.ativos) {
      motorista_latlng =
          LatLng(ca.localizacao.latitude, ca.localizacao.longitude);
      rc.CalcularRotaMotorista(motorista_latlng, passageiro_latlng);
      atualizarLocalizacaoNomes(ca);
    }
    rc.inMarkers.add(marcasRota);
  }
}
