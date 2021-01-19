import 'dart:async';
import 'dart:convert';
import 'dart:math';


import 'package:address_search_field/address_search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart' as ggt;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_webservice/places.dart' as gg;

import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ufly/Ajuda/AjudaPage.dart';
import 'package:ufly/Ativos/AtivosController.dart';
import 'package:ufly/Configuracao/ConfiguracaoPage.dart';

import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:ufly/CorridaBackground/corrida_controller.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';

import 'package:ufly/GoogleServices/geolocator_service.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Login/Login.dart';

import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/Endereco.dart';
import 'package:ufly/Objetos/Localizacao.dart';

import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Objetos/Rota.dart';
import 'package:ufly/Objetos/SizeConfig.dart';
import 'package:ufly/Perfil/PerfilController.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Rota/addres_teste.dart';
import 'package:ufly/Viagens/MotoristaProximoPage.dart';

import 'package:ufly/Viagens/Requisicao/criar_requisicao_controller.dart';
import 'package:ufly/Viagens/SuasViagensPage.dart';

import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Viagens/FiltroPage.dart';
import 'Compartilhados/SideBar.dart';
import 'Controllers/camera_controller.dart';
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
  TextEditingController locationController = TextEditingController();
  TextEditingController inicialController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  CorridaController cc;
  AtivosController alc;
  Requisicao req;
  double latinicial;
  double lnginicial;
  Placemark origem_nome;

  ControllerFiltros cf;
  FiltroMotorista fm;
  LatLng coord;
  Placemark placemark;
  RequisicaoController requisicaoController;
  AtivosController ac;
  List<Polyline> polylines;
  List<Marker> markers;
  static LatLng _initialPosition;
  static LatLng destino;
  LatLng get initialPosition => _initialPosition;
  String _currentAddress;
  String filtro;

  String destinoAddress;

  Position position;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    bg.BackgroundGeolocation.start();
    if (ac == null) {
      ac = AtivosController();
    }

    localizacaoInicial();

    Timer(Duration(seconds: 5), () {
      geo.getCurrentLocation().listen((position) {
        telaCentralizada(position);
      });
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
      googleApiKey: 'AIzaSyCW3el7IIcqaKRx_PZ24Ab6P0VJnWhMAx4',
      language: 'pt-BR',
      countryCode: 'bra',
      country: 'Brasil',
      city: '${filtro}',
    );

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
              print('aqui localização ${localizacao.data}');
              if (localizacao.data == null) {
                return StreamBuilder<Position>(
                    stream: localizacaoInicial(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print('aqui position ${snapshot.data}');
                        return localizacaoInicial();
                      }
                      return StreamBuilder(
                          stream: pf.outUser,
                          builder: (context, user) {
                            return  GoogleMap(
                                  onTap: (l) {
                                    print('aqui o L ${l}');
                                    rc.AdicionarParada(l);
                                  },
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

              markers = getMarkers(_initialPosition, destino, null);
              print("AQUI MARKERS ${markers.length}");
              print("AQUI Poly ${polylines.length}");
              return StreamBuilder(
                  stream: pf.outUser,
                  builder: (context, user) {
                    return StreamBuilder(
                        stream: rc.outMarker,
                        builder: (context, snapshot) {


                          return GoogleMap(
                          onTap: (l) {
                            print('aqui o L ${l}');
                            rc.AdicionarParada(l);
                          },
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
                              zoom: Helper.localUser.zoom),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        );
                      }
                    );
                  });
            });
      },
    );
    return Scaffold(
      key: homeScaffoldKey,
      /* appBar:
          myAppBar('', context, color: Colors.transparent, actions: <Widget>[
        StreamBuilder<FiltroMotorista>(
            stream: cf.outFiltro,
            builder: (context, snap) {
              if (snap.data == null) {
                return Container();
              }
              FiltroMotorista ff = snap.data;

              return Padding(
                padding: EdgeInsets.only(right: getLargura(context) * .050),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: getAltura(context) * .070,
                        width: getLargura(context) * .7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                FiltroMotorista f = await cf.outFiltro.first;
                                f.viagem = true;

                                cf.inFiltro.add(f);
                                print('aqui viagem ${f.viagem}');
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
                                print('aqui viagem ${f.viagem}');
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
                    ),

                  ],
                ),
              );
            }),
      ]),*/
      // drawer: CustomDrawerWidget(),
      body: SlidingUpPanel(
        panel: _floatingPanel(),
        renderPanelSheet: false,
        maxHeight: getAltura(context) * .40,
        borderRadius: BorderRadius.circular(20),
        collapsed: Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24),
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
          height: SizeConfig.safeBlockVertical,
          width: SizeConfig.safeBlockHorizontal,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                width: getLargura(context),
                height: getAltura(context),
                child: map,
              ),
              StreamBuilder<bool>(
                  stream: cf.outPreenchimento,
                  builder: (context, preenchimento) {
                    if (cf.Preenchimento == null) {
                      cf.Preenchimento = false;
                    }
                    return RouteSearchBox(
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
                                    /*  TextFormField(
                                onTap: () async {

                                  if(cf.Preenchimento == true){
                                    cf.Preenchimento = false;
                                    cf.inPreenchimento.add(preenchimento.data);

                                  }else {

                                    gg.Prediction p = await PlacesAutocomplete.show(
                                        context: context,

                                        apiKey:
                                        'AIzaSyCW3el7IIcqaKRx_PZ24Ab6P0VJnWhMAx4',
                                        language: 'pt_BR',
                                        components: [
                                          gg.Component(gg.Component.country, 'br')
                                        ],
                                        sessionToken: Uuid().generateV4(),
                                        mode: Mode.overlay,
                                        types: ['address'],
                                        radius: 100000,

                                        strictbounds: false,
                                        location: Location(latinicial, lnginicial));
                                    inicialController.text = p.description;
                                  }
                                },
                                controller: inicialController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        localizacaoInicial();
                                        inicialController.text = _currentAddress;
                                        cf.Preenchimento = true;
                                        cf.inPreenchimento.add(preenchimento.data);

                                      },
                                      icon: Icon(Icons.my_location,
                                          color: Colors.black)),
                                  prefixIcon:
                                      Icon(Icons.location_on, color: Colors.black),
                                  labelText: 'Onde estou?',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      getAltura(context) * .025,
                                      getLargura(context) * .020,
                                      getAltura(context) * .025,
                                      getLargura(context) * .020),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(color: Colors.white)),
                                ),
                              )*/
                                    /*AddressSearchField(

                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        print('clicou');
                                        localizacaoInicial();
                                        inicialController.text = _currentAddress;
                                      },
                                      icon: Icon(Icons.my_location,
                                          color: Colors.black)),
                                  prefixIcon:
                                      Icon(Icons.location_on, color: Colors.black),
                                  labelText: 'Onde estou?',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      getAltura(context) * .025,
                                      getLargura(context) * .020,
                                      getAltura(context) * .025,
                                      getLargura(context) * .020),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(color: Colors.white)),
                                ),
                                controller: inicialController,
                                country: "Brasil",
                                city: '$filtro',
                                hintText: "Pontos",

                                noResultsText: "Nenhum local encontrado...",
                                onDone: (BuildContext dialogContext,
                                    AddressPoint point) async {
                                  Navigator.of(context).pop();
                                },
                                onCleaned: () => print("clean"),
                              )*/
                                  ),
                                ),
                              ),
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
                                                  })
                                          // false = user must tap button, true = tap outside dialog

                                          );
                                      /*showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    destinationBuilder.buildDefault(
                                                        builder:
                                                            AddressDialogBuilder(useButtons: false),

                                                        onDone: (address)async{
                                                                requisicao(locationController.text, inicialController.text);





                                                        })

                                                // false = user must tap button, true = tap outside dialog

                                                ); */
                                    },
                                  ),
                                  /*TextFormField(
                                onTap: () async {
                                      if(cf.Preenchimento == true){
                                        cf.Preenchimento = false;
                                        cf.inPreenchimento.add(preenchimento.data);
                                      } else {
                                        gg.Prediction p = await PlacesAutocomplete
                                            .show(

                                            context: context,
                                            apiKey:
                                            'AIzaSyCW3el7IIcqaKRx_PZ24Ab6P0VJnWhMAx4',
                                            language: 'pt_BR',
                                            components: [
                                              gg.Component(gg.Component.country, 'br')
                                            ],
                                            sessionToken: Uuid().generateV4(),
                                            mode: Mode.overlay,
                                            types: ['address'],
                                            radius: 500000,
                                            strictbounds: false,
                                            location: Location(
                                                latinicial, lnginicial));
                                        locationController.text = p.description;
                                      }
                                },
                                controller: locationController,
                                decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      suffixIcon: IconButton(
                                          onPressed: () async{
                                            cf.Preenchimento = true;
                                            cf.inPreenchimento.add(preenchimento.data);
                                            await requisicao(locationController.text,
                                                inicialController.text);
                    Timer(Duration(seconds: 3), ()
                                            {
                                              centerView();
                                            });
                                          },
                                          icon: Icon(Icons.send,
                                              color: Colors.black)),
                                      prefixIcon:
                                      Icon(Icons.location_on, color: Colors.black),
                                      labelText: 'Onde vamos?',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          getAltura(context) * .025,
                                          getLargura(context) * .020,
                                          getAltura(context) * .025,
                                          getLargura(context) * .020),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: BorderSide(color: Colors.white)),
                                ),
                              ) */

                                  /* AddressSearchField(
                                decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      prefixIcon: Icon(Icons.map, color: Colors.black),
                                      labelText: 'Onde vamos?',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          getAltura(context) * .025,
                                          getLargura(context) * .020,
                                          getAltura(context) * .025,
                                          getLargura(context) * .020),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: BorderSide(color: Colors.white)),
                                ),
                                controller: locationController,
                                country: "Brasil",
                                city: '${filtro}',
                                hintText: "Pontos",
                                noResultsText: "Nenhum local encontrado...",
                                onDone: (BuildContext dialogContext,
                                        AddressPoint point) async {
                                      await requisicao(locationController.text,
                                          inicialController.text);

                                      Navigator.of(context).pop();
                                      Timer(Duration(seconds: 3), () {
                                        centerView();
                                      });
                                },
                                onCleaned: () => print("clean"),
                              ),*/
                                )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      child: Text('Pontos Paradas'),
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                            );
                                          })),
                                  ElevatedButton(
                                    child: Text('Search'),
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddresTeste()));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                  }),
              sb,
              Positioned(
                right: getLargura(context) * .060,
                bottom: getAltura(context) * .350,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {

                    centerView();


                  },
                  child: Icon(Icons.zoom_out_map, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
              ),
              Positioned(
                right: getLargura(context) * .060,
                bottom: getAltura(context) * .150,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Geolocator()
                        .getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high)
                        .then((v) async {
                      telaCentralizada(v);

                    });
                  },
                  child: Icon(Icons.my_location, color: Colors.black),
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

  Endereco endereco_origem;
  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      telaCentralizada(v);

      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));

      _initialPosition = LatLng(v.latitude, v.longitude);
      print('aqui localização ${_initialPosition}');
      Timer(Duration(seconds: 4), () async {
        List<Placemark> mark = await Geolocator()
            .placemarkFromCoordinates(v.latitude, v.longitude);

        Placemark place = mark[0];
        filtro = '${place.subAdministrativeArea}';
        _currentAddress =
            '${place.name.isNotEmpty ? place.name + ', ' : ''}${place.thoroughfare.isNotEmpty ? place.thoroughfare + ', ' : ''}${place.subLocality.isNotEmpty ? place.subLocality + ', ' : ''}${place.locality.isNotEmpty ? place.locality + ', ' : ''}';
        print('aqui place ${_currentAddress}');
        print('aqui place ${place.toString()}');
      });
    });
  }

  Future<void> telaCentralizada(Position position) async {
    final GoogleMapController controller = await _controller.future;
    print('aqui o zoom ${Helper.localUser.zoom.toStringAsFixed(2)}');
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

  requisicao( String inicial, String destinoFinal) async {
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
      print('aqui inicial ${_initialPosition}');
      LatLng destination = LatLng(latitude, longitude);
      dToast('Efetuando calculo de rota');
      rc.CalcularRota(inicial_posicao, destination);

      destino = destination;
      origem_nome = inicialPosicao[0];
      getMarkers(
        inicial_posicao,
        destination, null
      );

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

      double distanciaPercorrida = 0.0;

      double soma = distanciaPercorrida += calculateDistance(
          _initialPosition.latitude,
          _initialPosition.longitude,
          destino.latitude,
          destino.longitude);

      print('aqui o calculo distancia ${soma.toStringAsFixed(2)}');
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
    if (requisicaoController == null) {
      requisicaoController = RequisicaoController();
    }
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
                        requisicao.data.user != Helper.localUser.id) {
                      requisitarMotoristas(requisicao.data, snap.data.viagem);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MotoristaProximoPage()));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MotoristaProximoPage()));
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

  void requisitarMotoristas(requiup, filtro) {
    double soma = calculateDistance(_initialPosition.latitude,
        _initialPosition.longitude, destino.latitude, destino.longitude);
    print('aqui ativos ac.ativos ${ac.ativos}');
    Endereco _destino = endereco_destino;
    Endereco inicial = endereco_origem;
    double tempo_estimado;

    for (var i in rc.rota.routes[0].legs) {
      double duracao = (i.duration) / 3600;
      tempo_estimado = duracao;
    }

    List motorista = new List();

    for (CarroAtivo ca in ac.ativos) {
      print('aqui motorista ativo ${ca.user_id}');
      double distancia = calculateDistance(
          ca.localizacao.latitude,
          ca.localizacao.longitude,
          _initialPosition.latitude,
          _initialPosition.longitude);
      print('aqui motorista ativo ${distancia}');
      if (isInAlcance(ca, _initialPosition)) {
        motorista.add(ca.user_id);
        print('aqui motorista ativo2 ${motorista}');
      }
    }

    if (requiup == null || requiup.user != Helper.localUser.id) {
      print('entrou aqui cria');

      List<Requisicao> requisicoes2 = new List();
      Requisicao requisicao2 = Requisicao(
        user: Helper.localUser.id,
        isViagem: filtro,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
        destino: _destino,
        user_nome: Helper.localUser.nome,
        origem: inicial,
        distancia: soma,
        tempo_estimado: tempo_estimado,
        rota: rc.rota,
        valid_until: DateTime.now().add(Duration(minutes: 5)),
        motoristas_chamados: motorista,
      );

      requisicoes2.add(requisicao2);
      print('requisicao2 ${requisicao2.toJson()}');
      Timer(Duration(seconds: 5), () {
        criaRc.CriarRequisicao(requisicao2);
      });
    } else {
      print('entrou aqui update ${requiup}');
      List<Requisicao> requisicoes = new List();
      Requisicao requisicao = Requisicao(
        id: requiup.id,
        isViagem: filtro,
        user: Helper.localUser.id,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
        destino: _destino,
        user_nome: Helper.localUser.nome,
        origem: inicial,
        distancia: soma,
        tempo_estimado: tempo_estimado,
        rota: rc.rota,
        valid_until: DateTime.now().add(Duration(minutes: 5)),
        motoristas_chamados: motorista,
      );

      requisicoes.add(requisicao);
      Timer(Duration(seconds: 5), () {
        criaRc.UpdateRequisicao(requisicao);
      });
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MotoristaProximoPage()));
  }

  bool isInAlcance(CarroAtivo ca, LatLng origem) {
    double distancia = calculateDistance(ca.localizacao.latitude,
        ca.localizacao.longitude, origem.latitude, origem.longitude);
    print('aqui distancia ${distancia}');

    return 50 > distancia;
  }
}

List<Polyline> getPolys(data) {
  List<Polyline> poly = [];

  if (data == null) {
    return poly;
  }
  print('aqui poly ${data.length}');
  List<Color> cores = [
    Colors.red,
    Colors.blue,                
    Colors.yellow,
    Colors.green,
    Colors.amber,
    Colors.deepOrange,

  ];
  try {
    for (int i = 0; i < data.length; i++) {
      PolylineId id = PolylineId("poly${i}");
      poly.add(Polyline(
        
        polylineId: id,
        color: cores[i],
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

List<Marker> getMarkers(LatLng data, LatLng d,
    way1) {
  List<Marker> markers = [];
  MarkerId markerId = MarkerId('id');
  MarkerId markerId2 = MarkerId('id2');
    if(way1 == null){
      way1 = markers;
    }
  try {
    markers.add(Marker(
        infoWindow: InfoWindow(title: 'Embarque'),
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: data));
  } catch (err) {
    print(err.toString());
  }
  try {
    markers.add(Marker(
        infoWindow: InfoWindow(title: 'Desembarque'),
        markerId: markerId2,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(d.latitude, d.longitude)));
  } catch (err) {
    print(err.toString());
  }


  try {
    for (int i = 0; i < way1.length; i++) {
      markers.add(Marker(
          infoWindow: InfoWindow(title: 'Parada${i}'),
          markerId: way1[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: way1));
    }
  } catch (err) {
    print(err.toString());
  }
  return markers;
}


