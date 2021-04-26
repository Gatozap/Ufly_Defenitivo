import 'dart:async';

import 'dart:math';

import 'package:address_search_field/address_search_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:responsive_pixel/responsive_pixel.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart' as ggt;
import 'package:google_maps_flutter/google_maps_flutter.dart';



import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ufly/Ativos/AtivosController.dart';


import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:ufly/CorridaBackground/corrida_controller.dart';


import 'package:ufly/GoogleServices/geolocator_service.dart';

import 'package:ufly/Login/Login.dart';

import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/Endereco.dart';


import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Objetos/Requisicao.dart';

import 'package:ufly/Rota/paradas_list_item.dart';
import 'package:ufly/Objetos/SizeConfig.dart';
import 'package:ufly/Perfil/PerfilController.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Rota/addres_teste.dart';
import 'package:ufly/Viagens/ChamandoMotoristaPage/ChamandoMotoristaPage.dart';
import 'package:ufly/Viagens/MotoristaProximoPage.dart';

import 'package:ufly/Viagens/Requisicao/criar_requisicao_controller.dart';
import 'package:ufly/Viagens/SuasViagensPage.dart';

import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Viagens/FiltroPage.dart';
import 'Compartilhados/SideBar.dart';
import 'Controllers/camera_controller.dart';
import 'CorridaBackground/requisicao_corrida_controller.dart';
import 'Helpers/SqliteDatabase.dart';
import 'Objetos/FiltroMotorista.dart';

import 'Viagens/Requisicao/requisicao_controller.dart';
import 'home_page_list.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  RotaController rc;
  CriarRequisicaoController criaRc;
  PerfilController pf = PerfilController(Helper.localUser);
  final directionsService = ggt.DirectionsService();
  final GeolocatorService geo = GeolocatorService();
  String a;
  TextEditingController locationController = TextEditingController();
  TextEditingController inicialController = TextEditingController();
  TextEditingController parada1Controller = TextEditingController();
  TextEditingController parada2Controller = TextEditingController();
  TextEditingController parada3Controller = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  CorridaController cc;
  AtivosController alc;
  double lat_parada_um;
  double lng_parada_um;
  double lat_parada_dois;
  double lng_parada_dois;
  double lat_parada_tres;
  double lng_parada_tres;
  Requisicao req;
  double latinicial;
  double lnginicial;
  List<LatLng> marcas = [];
  Placemark origem_nome;
   String forma_de_pagamento;
  ControllerFiltros cf;
  FiltroMotorista fm;
  LatLng coord;
  Placemark placemark;
  RequisicaoController requisicaoController;
  RequisicaoCorridaController reqc;

  AtivosController ac;
  List<Polyline> polylines;
  List<Marker> markers;
  static LatLng _initialPosition;
  static LatLng destino;
  static LatLng lat_lng_de_parada_um;
  static LatLng lat_lng_de_parada_dois;
  static LatLng lat_lng_de_parada_tres;
  LatLng get initialPosition => _initialPosition;
  String _currentAddress;
  String filtro;
  String destinoAddress;
  String endereco_paradaUm;
  String endereco_paradaDois;
  String endereco_paradaTres;
  MotoristaController mt;
  Position position;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    bg.BackgroundGeolocation.start();
    if (ac == null) {
      ac = AtivosController();
    }
    if(mt == null){
      mt = MotoristaController();
    }
    if(reqc == null){
      reqc = RequisicaoCorridaController();
    }

    localizacaoInicial();
      geo.getCurrentLocation().listen((position) {
        telaCentralizada(position);
      });

    if (rc == null) {
      rc = RotaController();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsFlutterBinding.ensureInitialized();
    final geoMethods = GeoMethods(
      googleApiKey: 'AIzaSyCO3UUS_NWIOibg5Yt_BbbKmSfvsjCErLA',
      language: 'pt-BR',
      countryCode: 'bra',
      country: 'Brasil',
      city: '${filtro}',
    );
    textFieldParaPesquisarPontos(){
      return    RouteSearchBox(
          geoMethods: geoMethods,
          originCtrl: inicialController,
          destinationCtrl: locationController,

          builder: (
              BuildContext context,
              originBuilder,
              destinationBuilder, {
                getDirections,
                relocate,
                waypointBuilder,
                waypointsMgr,
              }) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: getAltura(context) * .050,
                      bottom: getAltura(context) * .010),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      width: getLargura(context) * .80,
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                localizacaoInicial();
                                inicialController.text =
                                    _currentAddress;
                              },
                              icon: Icon(Icons.my_location,
                                  color: Colors.black)),
                          prefixIcon: Icon(Icons.location_on,
                              color: Colors.black),
                          labelText: 'Onde estou?',
                          contentPadding: EdgeInsets.fromLTRB(
                              getAltura(context) * .025,
                              getLargura(context) * .020,
                              getAltura(context) * .025,
                              getLargura(context) * .020),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Colors.white)),
                        ),
                        controller: inicialController,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  originBuilder.buildDefault(
                                      builder:
                                      AddressDialogBuilder(),
                                      onDone: (address) {})
                            // false = user must tap button, true = tap outside dialog

                          );
                        },
                      ),
                    ),
                  ),
                ),

               /* parada2Controller.text.isEmpty? Container() :
                Padding(
                  padding: EdgeInsets.only(
                      top: getAltura(context) * .010,
                      bottom: getAltura(context) * .010),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      width: getLargura(context) * .80,
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: IconButton(
                              onPressed: () {
                                parada1Controller.clear();
                              },
                              icon: parada1Controller.text.isEmpty?Icon(Icons.location_on_outlined,
                                  color: Colors.black,size: 30):Icon(Icons.close,
                                  color: Colors.red,size: 30)),

                          labelText: 'Parada nº um',
                          contentPadding: EdgeInsets.fromLTRB(
                              getAltura(context) * .025,
                              getLargura(context) * .020,
                              getAltura(context) * .025,
                              getLargura(context) * .020),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Colors.white)),
                        ),
                        controller: parada1Controller,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AddressSearchBuilder(
                                  geoMethods: geoMethods,
                                  controller: parada1Controller,
                                  builder: (
                                      BuildContext context,
                                      AsyncSnapshot<List<Address>> snapshot, {
                                        TextEditingController controller,
                                        Future<void> Function() searchAddress,
                                        Future<Address> Function(Address address) getGeometry,
                                      }) {
                                    return AddressSearchDialog(
                                      snapshot: snapshot,
                                      controller: controller,
                                      searchAddress: searchAddress,
                                      getGeometry: getGeometry,
                                      onDone: (Address address) async {
                                        print('aqui o snapshot ${snapshot.data[0].reference.toString()}');
                                        parada1Controller.text = controller.text;

                                        List<Placemark> Parada1Posicao =
                                            await Geolocator().placemarkFromAddress(parada1Controller.text);
                                        double lat = Parada1Posicao[0].position.latitude;
                                        double lng = Parada1Posicao[0].position.longitude;
                                          lat_parada_um = lat;
                                          lng_parada_um = lng;


                                        LatLng posicaoParada1 = LatLng(lat, lng);
                                        endereco_paradaUm = snapshot.data[0].reference.toString();

                                             lat_lng_de_parada_um = posicaoParada1;
                                            marcas.add(lat_lng_de_parada_um);
                                              rc.inWays.add(marcas);
                                        rc.AdicionarParada(lat_lng_de_parada_um);

                                      }
                                    );
                                  },
                                ),
                            // false = user must tap button, true = tap outside dialog

                          );
                        },
                      ),
                    ),
                  ),
                ),

                parada1Controller.text.isEmpty?Container():
                Padding(
                  padding: EdgeInsets.only(
                      top: getAltura(context) * .010,
                      bottom: getAltura(context) * .010),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      width: getLargura(context) * .80,
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: IconButton(
                              onPressed: () {
                                parada2Controller.clear();
                              },
                              icon:  parada2Controller.text.isEmpty?Icon(Icons.location_on_outlined,
                                  color: Colors.black,size: 30):Icon(Icons.close,
                                  color: Colors.red,size: 30)),
                          labelText: 'Parada nº dois',
                          contentPadding: EdgeInsets.fromLTRB(
                              getAltura(context) * .025,
                              getLargura(context) * .020,
                              getAltura(context) * .025,
                              getLargura(context) * .020),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Colors.white)),
                        ),
                        controller: parada2Controller,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  AddressSearchBuilder(
                                    geoMethods: geoMethods,
                                    controller: parada2Controller,
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<List<Address>> snapshot, {
                                          TextEditingController controller,
                                          Future<void> Function() searchAddress,
                                          Future<Address> Function(Address address) getGeometry,
                                        }) {
                                      return AddressSearchDialog(
                                          snapshot: snapshot,
                                          controller: controller,
                                          searchAddress: searchAddress,
                                          getGeometry: getGeometry,
                                          onDone: (Address address) async {
                                            parada2Controller.text =
                                                controller.text;
                                            endereco_paradaDois = snapshot.data[0].reference.toString();
                                            parada1Controller.text = controller.text;

                                            List<Placemark> Parada2Posicao =
                                                await Geolocator().placemarkFromAddress(parada2Controller.text);
                                            double lat = Parada2Posicao[0].position.latitude;
                                            double lng = Parada2Posicao[0].position.longitude;
                                            lat_parada_dois = lat;
                                            lng_parada_dois = lng;
                                            lat_lng_de_parada_dois = address.coords;

                                            marcas.add(lat_lng_de_parada_dois);
                                            rc.inWays.add(marcas);
                                            rc.AdicionarParada(lat_lng_de_parada_dois);

                                          }
                                      );
                                    },
                                  )
                            // false = user must tap button, true = tap outside dialog

                          );
                        },
                      ),
                    ),
                  ),
                ),
                parada2Controller.text.isEmpty?Container():
                Padding(
                  padding: EdgeInsets.only(
                      top: getAltura(context) * .010,
                      bottom: getAltura(context) * .010),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      width: getLargura(context) * .80,
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: IconButton(
                              onPressed: () {
                                parada3Controller.clear();
                              },
                              icon:  parada3Controller.text.isEmpty?Icon(Icons.location_on_outlined,
                                  color: Colors.black,size: 30):Icon(Icons.close,
                                  color: Colors.red,size: 30)),
                          labelText: 'Parada nº três',
                          contentPadding: EdgeInsets.fromLTRB(
                              getAltura(context) * .025,
                              getLargura(context) * .020,
                              getAltura(context) * .025,
                              getLargura(context) * .020),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Colors.white)),
                        ),
                        controller: parada3Controller,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  AddressSearchBuilder(
                                    geoMethods: geoMethods,
                                    controller: parada3Controller,
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<List<Address>> snapshot, {
                                          TextEditingController controller,
                                          Future<void> Function() searchAddress,
                                          Future<Address> Function(Address address) getGeometry,
                                        }) {
                                      return AddressSearchDialog(
                                          snapshot: snapshot,
                                          controller: controller,
                                          searchAddress: searchAddress,
                                          getGeometry: getGeometry,
                                          onDone: (Address address) async {
                                            parada3Controller
                                                .text =
                                                controller.text;
                                            List<Placemark> Parada3Posicao =
                                                await Geolocator().placemarkFromAddress(parada3Controller.text);
                                            double lat = Parada3Posicao[0].position.latitude;
                                            double lng = Parada3Posicao[0].position.longitude;
                                            lat_parada_tres = lat;
                                            lng_parada_tres = lng;
                                            endereco_paradaTres = snapshot.data[0].reference.toString();
                                                  lat_lng_de_parada_tres = address.coords;
                                            marcas.add(lat_lng_de_parada_tres);
                                            rc.inWays.add(marcas);
                                              rc.AdicionarParada(lat_lng_de_parada_tres);

                                          }
                                      );
                                    },
                                  )
                            // false = user must tap button, true = tap outside dialog

                          );
                        },
                      ),
                    ),
                  ),
                ),
                //ParadasListItem(filtro: filtro),*/
                Padding(
                  padding: EdgeInsets.only(
                      top: getAltura(context) * .010,
                      bottom: getAltura(context) * .010),
                  child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        width: getLargura(context) * .80,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.location_on,
                                color: Colors.black),
                            labelText: 'Onde vamos?',
                            contentPadding: EdgeInsets.fromLTRB(
                                getAltura(context) * .025,
                                getLargura(context) * .020,
                                getAltura(context) * .025,
                                getLargura(context) * .020),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(25.0),
                                borderSide:
                                BorderSide(color: Colors.white)),
                          ),
                          controller: locationController,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    destinationBuilder.buildDefault(
                                        builder:
                                        AddressDialogBuilder(),
                                        onDone: (address) {

                                          requisicao(
                                              inicialController.text,
                                              locationController
                                                  .text);
                                        
                                          Timer(Duration(seconds: 3),
                                                  () {
                                                centerView();
                                              });
                                        }));
                          },
                        ),

                      )),
                ),

              ],
            );
          });
    }
    SizeConfig().init(context);

    ResponsivePixelHandler.init(
      baseWidth: 360, //A largura usado pelo designer no modelo desenhado
    );
    if (alc == null) {
      alc = AtivosController();
    }
    if (criaRc == null) {
      criaRc = CriarRequisicaoController();
    }
    if (requisicaoController == null) {
      requisicaoController = RequisicaoController();
    }
    if(reqc == null){
      reqc = RequisicaoCorridaController();
    }
    if (cf == null) {
      cf = ControllerFiltros();
    }
    var map = StreamBuilder(
      stream: rc.outPoly,
      builder: (context, snap) {
        polylines = getPolys(snap.data);
              
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
                      return StreamBuilder(
                          stream: pf.outUser,
                          builder: (context, user) {
                            return GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              mapType: MapType.normal,
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: _initialPosition,
                                  zoom: Helper.localUser.zoom),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            );
                          });
                    });
              }


             
              return StreamBuilder(
                  stream: pf.outUser,
                  builder: (context, user) {
                    return StreamBuilder(
                        stream: rc.outWays,
                        builder: (context,  snapshot) {

                             markers = getMarkers(_initialPosition, destino, snapshot.data);

                          return
                            GoogleMap(

                            myLocationEnabled: true,
                            compassEnabled: true,
                            myLocationButtonEnabled: false,
                            polylines: polylines.toSet(),
                            markers: destino != null ? markers.toSet() : null,
                            mapType: MapType.normal,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: localizacao.data,
                                zoom: Helper.localUser.zoom,),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          );
                        });
                  });
            });
      },
    );


              return StreamBuilder<List<Requisicao>>(
                  stream: reqc.outRequisicoes,
                  builder: (context,
                      AsyncSnapshot<List<Requisicao>> requisicao) {


                    if (requisicao.data == null) {

                      return Scaffold(

                        // drawer: CustomDrawerWidget(),
                        body: SlidingUpPanel(
                          panel: _floatingPanel(),
                          renderPanelSheet: false,
                          maxHeight: getAltura(context) * .40,
                          borderRadius: BorderRadius.circular(20),
                          collapsed: Container(
                            margin: const EdgeInsets.only(
                                left: 24.0, right: 24),
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(24.0),
                                                topRight: Radius.circular(
                                                    24.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 20.0,
                                                color: Colors.grey,
                                              ),
                                            ]),
                                        width: getLargura(context) - 48,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            sb,
                                            sb,
                                            Container(
                                              child: Container(
                                                  width: getLargura(context) *
                                                      .4,
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
                            height: SizeConfig.safeBlockVertical,
                            width: SizeConfig.safeBlockHorizontal,
                            color: Colors.white,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context),
                                  width: getLargura(context),
                                  child: map,
                                ),
                                textFieldParaPesquisarPontos(),
                                sb,
                                Positioned(
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
                                ),
                                Positioned(
                                  right: getLargura(context) * .060,
                                  bottom: getAltura(context) * .150,
                                  child: FloatingActionButton(
                                    heroTag: '1',
                                    onPressed: () {
                                      Geolocator()
                                          .getCurrentPosition(
                                          desiredAccuracy: LocationAccuracy
                                              .high)
                                          .then((v) async {
                                        telaCentralizada(v);
                                      });
                                    },
                                    child: Icon(
                                        Icons.my_location, color: Colors.black),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SideBar(),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else
                      for (var req in requisicao.data) {
                        if (req.aceito == null) {

                          return Scaffold(

                            // drawer: CustomDrawerWidget(),
                            body: SlidingUpPanel(
                              panel: _floatingPanel(),
                              renderPanelSheet: false,
                              maxHeight: getAltura(context) * .40,
                              borderRadius: BorderRadius.circular(20),
                              collapsed: Container(
                                margin: const EdgeInsets.only(left: 24.0,
                                    right: 24),
                                child: Row(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        24.0),
                                                    topRight: Radius.circular(
                                                        24.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 20.0,
                                                    color: Colors.grey,
                                                  ),
                                                ]),
                                            width: getLargura(context) - 48,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                sb,
                                                sb,
                                                Container(
                                                  child: Container(
                                                      width: getLargura(
                                                          context) * .4,
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
                                height: SizeConfig.safeBlockVertical,
                                width: SizeConfig.safeBlockHorizontal,
                                color: Colors.white,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context),
                                      width: getLargura(context),
                                      child: map,
                                    ),
                                    textFieldParaPesquisarPontos(),
                                    sb,
                                    Positioned(
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
                                    ),
                                    Positioned(
                                      right: getLargura(context) * .060,
                                      bottom: getAltura(context) * .150,
                                      child: FloatingActionButton(
                                        heroTag: '1',
                                        onPressed: () {
                                          Geolocator()
                                              .getCurrentPosition(
                                              desiredAccuracy: LocationAccuracy
                                                  .high)
                                              .then((v) async {
                                            telaCentralizada(v);
                                          });
                                        },
                                        child: Icon(Icons.my_location,
                                            color: Colors.black),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    SideBar(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (req.aceito.id_usuario == Helper.localUser.id && req.deleted_at ==null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChamandoMotoristaPage()));
                          });
                        }
                      }
                    {
                      return Scaffold(

                        // drawer: CustomDrawerWidget(),
                        body: SlidingUpPanel(
                          panel: _floatingPanel(),
                          renderPanelSheet: false,
                          maxHeight: getAltura(context) * .40,
                          borderRadius: BorderRadius.circular(20),
                          collapsed: Container(
                            margin: const EdgeInsets.only(
                                left: 24.0, right: 24),
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(24.0),
                                                topRight: Radius.circular(
                                                    24.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 20.0,
                                                color: Colors.grey,
                                              ),
                                            ]),
                                        width: getLargura(context) - 48,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            sb,
                                            sb,
                                            Container(
                                              child: Container(
                                                  width: getLargura(context) *
                                                      .4,
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
                            height: SizeConfig.safeBlockVertical,
                            width: SizeConfig.safeBlockHorizontal,
                            color: Colors.white,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context),
                                  width: getLargura(context),
                                  child: map,
                                ),
                                textFieldParaPesquisarPontos(),
                                sb,
                                Positioned(
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
                                ),
                                Positioned(
                                  right: getLargura(context) * .060,
                                  bottom: getAltura(context) * .150,
                                  child: FloatingActionButton(
                                    heroTag: '1',
                                    onPressed: () {
                                      Geolocator()
                                          .getCurrentPosition(
                                          desiredAccuracy: LocationAccuracy
                                              .high)
                                          .then((v) async {
                                        telaCentralizada(v);
                                      });
                                    },
                                    child: Icon(
                                        Icons.my_location, color: Colors.black),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SideBar(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
              );


  }

  Endereco endereco_origem;
  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      telaCentralizada(v);

      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));

      _initialPosition = LatLng(v.latitude, v.longitude);


        List<Placemark> mark = await Geolocator()
            .placemarkFromCoordinates(v.latitude, v.longitude);

        Placemark place = mark[0];
        filtro = '${place.subAdministrativeArea}';
        _currentAddress =
            '${place.name.isNotEmpty ? place.name + ', ' : ''}${place.thoroughfare.isNotEmpty ? place.thoroughfare + ', ' : ''}${place.subLocality.isNotEmpty ? place.subLocality + ', ' : ''}${place.locality.isNotEmpty ? place.locality: ''}';

    
    });
  }

  Future<void> telaCentralizada(Position position) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: Helper.localUser.zoom)));
  }

  centerView() async {
    final GoogleMapController controller = await _controller.future;

    await controller.getVisibleRegion();

    var left = min(_initialPosition.latitude, destino.latitude);
    var right = max(_initialPosition.latitude, destino.latitude);
    var top = max(_initialPosition.longitude, destino.longitude);
    var bottom = min(_initialPosition.longitude, destino.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 160.0);
    controller.animateCamera(cameraUpdate);
  }

  Endereco endereco_destino;

  requisicao(String inicial, String destinoFinal) async {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      List<Placemark> location =
          await Geolocator().placemarkFromAddress(destinoFinal);
      double latitude = location[0].position.latitude;
      double longitude = location[0].position.longitude;
      List<Placemark> inicialPosicao =
          await Geolocator().placemarkFromAddress(inicial);
      double lat = inicialPosicao[0].position.latitude;
      double lng = inicialPosicao[0].position.longitude;

      LatLng inicial_posicao = LatLng(lat, lng);

      _initialPosition = inicial_posicao;

      LatLng destination = LatLng(latitude, longitude);
      dToast('Efetuando calculo de rota');

      rc.CalcularRota(inicial_posicao, destination);

      destino = destination;

      


      endereco_origem = Endereco(
          numero: inicialPosicao[0].name,
          endereco: inicialPosicao[0].thoroughfare,
          bairro: inicialPosicao[0].subLocality,
          cidade: inicialPosicao[0].locality,
          estado: inicialPosicao[0].administrativeArea,
          lat: lat,
          lng: lng,
          cep: inicialPosicao[0].postalCode);

      destinoAddress =
          '${location[0].name.isNotEmpty ? location[0].name + ', ' : ''}${location[0].thoroughfare.isNotEmpty ? location[0].thoroughfare + ', ' : ''}${location[0].subLocality.isNotEmpty ? location[0].subLocality + ', ' : ''}${location[0].locality.isNotEmpty ? location[0].locality + ', ' : ''}${location[0].subAdministrativeArea.isNotEmpty ? location[0].subAdministrativeArea + ', ' : ''}${location[0].postalCode.isNotEmpty ? location[0].postalCode + ', ' : ''}${location[0].administrativeArea.isNotEmpty ? location[0].administrativeArea : ''}';
      endereco_destino = Endereco(
          numero: location[0].name,
          endereco: location[0].thoroughfare,
          bairro: location[0].subLocality,
          cidade: location[0].locality,
          estado: location[0].administrativeArea,
          lat: latitude,
          lng: longitude,
          cep: location[0].postalCode);





    });
  }

  Widget _floatingPanel() {
    MotoristaController mt;
    if (mt == null) {
      mt = MotoristaController();
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder<List<Motorista>>(
              stream: mt.outMotoristas,
              builder: (context, AsyncSnapshot<List<Motorista>> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                if (snapshot.data.length == 0) {
                  return Container(
                      child: hTextMal('Sem carros disponiveis', context));
                }
                return Container(
                  width: getLargura(context),
                  height: getAltura(context) * .38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ProcurarWidget();
                      } else if (index == snapshot.data.length + 1) {
                        return AdicionarAFrotaWidget();
                      } else {
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Helper.localUser.id !=
                                    snapshot.data[index - 1].id_usuario
                                ? FrotaListItem(
                                    snapshot.data[index - 1],
                                  )
                                : Container());
                      }
                    },
                    itemCount: snapshot.data.length + 2,
                  ),
                );
              })
        ]);
  }

  Widget AdicionarAFrotaWidget() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(218, 218, 218, 100),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: getLargura(context) * .020,
            vertical: getAltura(context) * .025),
        height: getLargura(context) * .37,
        width: getLargura(context) * .98,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: getLargura(context) * .2,
              width: getLargura(context) * .2,
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: getAltura(context) * .075,
              ),
            ),
            hTextAbel('Adicionar\na Frota', context,
                color: Colors.black, textaling: TextAlign.center, size: 60)
          ],
        ),
      ),
    );
  }

  Widget ProcurarWidget() {

    return StreamBuilder<Requisicao>(
        stream: requisicaoController.outRequisicao,
        builder: (context, requisicao) {
          return StreamBuilder<FiltroMotorista>(
              stream: cf.outFiltro,
              builder: (context, snap) {
                if (snap.data == null) {
                  return Container();
                }

                return GestureDetector(
                  onTap: () {
                    if (requisicao.data == null ||
                        requisicao.data.user != Helper.localUser.id && requisicao.data.deleted_at == null)
                    {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: hTextAbel(
                                        'Forma de pagamento',
                                        context,
                                        size: 20),
                                  ),sb,
                                  StreamBuilder<FiltroMotorista>(
                                      stream: cf.outFiltro,
                                      builder: (context, snapshot) {

                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:  EdgeInsets.only(left: getLargura(context)*.025),
                                              child: GestureDetector(
                                                onTap: (){
                                                  if(snapshot.data.dinheiro == true){
                                                    snapshot.data.dinheiro = false;
                                                    cf.inFiltro.add(snapshot.data);
                                                  }
                                                  snapshot.data.cartao  = !snapshot.data.cartao;
                                                  if(snapshot.data.cartao == true){
                                                    forma_de_pagamento = 'CARTAO';
                                                  } else{
                                                    forma_de_pagamento = 'DINHEIRO';
                                                  }

                                                  cf.inFiltro.add(snapshot.data);
                                                }  ,
                                                child: Container(

                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Icon(MdiIcons.creditCard, color: Colors.black, size: 40,),
                                                      hTextAbel('Cartão', context, color: Colors.black, size: 20)
                                                    ],
                                                  ),
                                                  width: getLargura(context)*.270,
                                                  height: getAltura(context)*.140,
                                                  decoration: BoxDecoration(

                                                    borderRadius: BorderRadius.circular(30.0),
                                                    color: snapshot.data.cartao == false? Color.fromRGBO(218, 218, 218, 100):  Color.fromRGBO(255, 184, 0, 30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(left:
                                              getLargura(context)*.025),
                                              child: GestureDetector(
                                                onTap: (){

                                                  if(snapshot.data.cartao == true){
                                                    snapshot.data.cartao = false;
                                                    cf.inFiltro.add(snapshot.data);
                                                  }
                                                  snapshot.data.dinheiro  = !snapshot.data.dinheiro;
                                                  if(snapshot.data.dinheiro == true){
                                                    forma_de_pagamento = 'DINHEIRO';
                                                  } else{
                                                    forma_de_pagamento = 'CARTAO';
                                                  }

                                                  cf.inFiltro.add(snapshot.data);
                                                }        ,
                                                child: Container(

                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Container(width: 40,height: 25,child: Image.asset('assets/dinheiro.png', fit: BoxFit.fill,)),
                                                      hTextAbel('Dinheiro', context, color: Colors.black, size: 20)
                                                    ],
                                                  ),
                                                  width: getLargura(context)*.270,
                                                  height: getAltura(context)*.140,
                                                  decoration: BoxDecoration(

                                                    borderRadius: BorderRadius.circular(30.0),
                                                    color: snapshot.data.dinheiro == false? Color.fromRGBO(218, 218, 218, 100):  Color.fromRGBO(255, 184, 0, 30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          
                                          ],
                                        );
                                      }
                                  ),sb,sb,
                                  StreamBuilder<FiltroMotorista>(
                                      stream: cf.outFiltro,
                                      builder: (context, snap) {
                                        if (snap.data == null) {
                                          return Container();
                                        }
                                        FiltroMotorista ff = snap.data;

                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              height: getAltura(context) * .070,

                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      FiltroMotorista f = await cf.outFiltro.first;
                                                      f.viagem = true;

                                                      cf.inFiltro.add(f);

                                                    },
                                                    child: hTextAbel('Viagens', context,
                                                        size: 25,
                                                        weight: FontWeight.bold,
                                                        color: ff.viagem == true
                                                            ? Color.fromRGBO(255, 184, 0, 30)
                                                            : Colors.black),
                                                  ),
                                                  sb,
                                                  hText('|', context, size: 25),
                                                  sb,
                                                  GestureDetector(
                                                    onTap: () async {
                                                      FiltroMotorista f = await cf.outFiltro.first;
                                                      f.viagem = false;

                                                      cf.inFiltro.add(f);

                                                    },
                                                    child: hTextAbel(
                                                      'Entregas',
                                                      context,
                                                      size: 25,
                                                      weight: FontWeight.bold,
                                                      color: ff.viagem == false
                                                          ? Color.fromRGBO(255, 184, 0, 30)
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        );
                                      }),
                                  sb, GestureDetector(
                                    onTap: () {

                                        if (forma_de_pagamento.isEmpty) {
                                          return dToast(
                                              'preencha a forma de pagamento');
                                        } else if(destino != null){
                                          requisitarMotoristas(
                                              requisicao.data, snap.data.viagem,
                                              forma_de_pagamento);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MotoristaProximoPage()));
                                          });
                                        }

                                    },
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
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color:
                                            Color.fromRGBO(255, 184, 0, 30),
                                          ),
                                          child: Center(
                                              child: hTextAbel(
                                                  'Solicitar Motorista', context,
                                                  size: 20))),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });

                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: hTextAbel(
                                        'Você já solicitou motorista,\no que deseja fazer?',
                                        context,
                                        size: 20),
                                  ),
                                  sb,
                                  GestureDetector(
                                    onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MotoristaProximoPage()));
                            });
                                    },
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Color.fromRGBO(255, 184, 0, 30),
                                          ),
                                          child: Center(
                                              child: hTextAbel(
                                                  'Motoristas', context,
                                                  size: 20))),
                                    ),
                                  ),
                                  sb,
                                  Container(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              Color.fromRGBO(255, 184, 0, 30),
                                        ),
                                        child: Center(
                                            child: hTextAbel(
                                                'Atualizar Viagem', context,
                                                size: 20))),
                                  ),
                                  sb,
                                  Container(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              Color.fromRGBO(255, 184, 0, 30),
                                        ),
                                        child: Center(
                                            child: hTextAbel(
                                                'Deletar Solicitação', context,
                                                size: 20))),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: getLargura(context) * .010,
                        vertical: getAltura(context) * .040),
                    height: getLargura(context) * .050,
                    width: getLargura(context) * .90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: getLargura(context) * .150,
                          height: getLargura(context) * .2,
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: getAltura(context) * .075,
                          ),
                        ),
                        hTextAbel('Procurar', context,
                            color: Colors.white,
                            textaling: TextAlign.center,
                            size: 25)
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void requisitarMotoristas(requiup, filtro, String forma_de_pagamento) {
    double soma = calculateDistance(_initialPosition.latitude,
        _initialPosition.longitude, destino.latitude, destino.longitude);

    Endereco _destino = endereco_destino;
    Endereco inicial = endereco_origem;
    double tempo_estimado;

    for (var i in rc.rota.routes[0].legs) {
      double duracao = (i.duration) / 3600;
      tempo_estimado = duracao;
    }

    List motorista =[];

    for (CarroAtivo ca in ac.ativos) {
      if(ca.isAtivo == true) {

        double distancia = calculateDistance(
            ca.localizacao.latitude,
            ca.localizacao.longitude,
            _initialPosition.latitude,
            _initialPosition.longitude);


        if (isInAlcance(ca, _initialPosition)) {
          motorista.add(ca.user_id);

        }
      }
    }

    if (requiup == null || requiup.user != Helper.localUser.id) {


      Requisicao requisicao2 = Requisicao(
        user: Helper.localUser.id,
        isViagem: filtro,
        foto: Helper.localUser.foto,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
        primeiraParada_lat: lat_parada_um,
        segundaParada_lat: lat_parada_dois,
        terceiraParada_lat: lat_parada_tres,
        primeiraParada_lng: lng_parada_um,
        segundaParada_lng: lng_parada_dois,
        terceiraParada_lng: lng_parada_tres,
        forma_de_pagamento: forma_de_pagamento,
        destino: _destino,
        user_nome: Helper.localUser.nome,
        origem: inicial,
        distancia: soma,
        tempo_estimado: tempo_estimado,
        rota: rc.rota,
        valid_until: DateTime.now().add(Duration(minutes: 5)),
        motoristas_chamados: motorista,
      );




        criaRc.CriarRequisicao(requisicao2);

    } else {


      Requisicao requisicao = Requisicao(
        id: requiup.id,
        isViagem: filtro,
        foto: Helper.localUser.foto,
        forma_de_pagamento: forma_de_pagamento,
        user: Helper.localUser.id,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
        destino: _destino,
        primeiraParada_lat: lat_parada_um,
        segundaParada_lat: lat_parada_dois,
        terceiraParada_lat: lat_parada_tres,
        primeiraParada_lng: lng_parada_um,
        segundaParada_lng: lng_parada_dois,
        terceiraParada_lng: lng_parada_tres,
        user_nome: Helper.localUser.nome,
        origem: inicial,
        distancia: soma,
        tempo_estimado: tempo_estimado,
        rota: rc.rota,
        valid_until: DateTime.now().add(Duration(minutes: 5)),
        motoristas_chamados: motorista,
      );



        criaRc.UpdateRequisicao(requisicao);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(
          MaterialPageRoute(builder: (context) => MotoristaProximoPage()));
    });
  }

  bool isInAlcance(CarroAtivo ca, LatLng origem) {
    double distancia = calculateDistance(ca.localizacao.latitude,
        ca.localizacao.longitude, origem.latitude, origem.longitude);


    return 50 > distancia || ca.isAtivo == true;
  }
}

List<Polyline> getPolys(data) {
  List<Polyline> poly = [];

  if (data == null) {
    return poly;
  }


  try {
    for (int i = 0; i < data.length; i++) {
      PolylineId id = PolylineId("poly${i}");
      poly.add(Polyline(
        width: Helper.localUser.zoom < 10? 7: 5,
        polylineId: id,
        color: Colors.purple,
        points: data[i],
        consumeTapEvents: true,
      ));
    }
  } catch (err) {
    print(err.toString());
  }

  return poly;
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

doLogout(context) async {
  Helper.fbmsg.unsubscribeFromTopic(Helper.localUser.id);
  await FirebaseAuth.instance.signOut();
  Helper.localUser = null;

  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
}

List<Marker> getMarkers(inicio, destino, way, ) {
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
