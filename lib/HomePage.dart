import 'dart:convert';
import 'dart:math';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:google_maps_webservice/places.dart' as gg;


import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';





import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:ufly/GoogleServices/google_maps_services.dart';

import 'package:ufly/Motorista/motorista_controller.dart';

import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Rota/rota_controller.dart';

import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Viagens/FiltroPage.dart';
import 'Controllers/camera_controller.dart';
import 'Objetos/FiltroMotorista.dart';


import 'home_page_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {


  RotaController rc;

  GoogleMapsServices googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();

  final Set<Marker> marks = {};
  Set<Polyline> poly = {};
  ControllerFiltros cf;
  FiltroMotorista fm;


  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  String _currentAddress;
  String filtro;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  TextEditingController destinationController = TextEditingController();
  CameraController cc;


  Position position;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {

    if (rc == null) {
      rc = RotaController();
    }
    localizacaoInicial();
    bg.BackgroundGeolocation.start();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    print('aqui lalalala ${filtro}');
        String text = '';
    void onError(gg.PlacesAutocompleteResponse response) {
      homeScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(response.errorMessage)),
      );
    }
    const apiKey = "AIzaSyB_niut8QCQctZAwMCWUEO5V7wk93ScrrI";
    if (cf == null) {
      cf = ControllerFiltros();
    }
    var map = StreamBuilder(
      stream: rc.outPoly,
      builder: (context, snap) {
        List<Polyline> polylines = getPolys(snap.data);
        return StreamBuilder<LatLng>(
            stream: rc.outLocalizacao,
            builder: (context, localizacao) {
              if (localizacao.data == null) {
                return


                  initialPosition == null? Container( alignment: Alignment.center, child: CircularProgressIndicator()): GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    //polylines: polylines.toSet(),
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(target:initialPosition, zoom: 16 ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = (controller);
                    },
                  );
              }
              List<Marker> markers = getMarkers(localizacao.data,destinationController.text);
              print("AQUI MARKERS ${markers.length}");
              print("AQUI Poly ${polylines.length}");
              return
                initialPosition == null? Container( alignment: Alignment.center, child: CircularProgressIndicator()): GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  polylines: polylines.toSet(),
                  markers: markers.toSet(),
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(target:initialPosition, zoom: 16 ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = (controller);
                  },
                );
            });
      },
    );
    return Scaffold(
      key: homeScaffoldKey,
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('UFLY', context,
          size: 100, backgroundcolor: Colors.white, color: Colors.black),
      body: SlidingUpPanel(
        panel: _floatingPanel(),
        renderPanelSheet: false,
        minHeight: 100,
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
          height: getAltura(context),
          width: getLargura(context),
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                width: getLargura(context),
                height: getAltura(context),
                child: map,
              ),
              Positioned(
                  right: 15,
                  top: 18,
                  child: GestureDetector(
                    onTap: () {
                      Geolocator(). getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
                        print("AQUI LOCALIZAÇÂO ${v}");
                        rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
                        
                      });
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: hTextAbel('ID', context, size: 100),
                    ),
                  )),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<FiltroMotorista>(
                      stream: cf.outFiltro,
                      builder: (context, snap) {
                        if(snap.data == null){
                          return Container();
                        }
                        FiltroMotorista ff = snap.data;
                        print('aqui a bosta da viagem ${ff.viagem}');
                        if (ff.viagem == null) {
                          ff.viagem = true;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getAltura(context) * .020),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: getAltura(context) * .070,
                                width: getLargura(context) * .5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                      
                                        FiltroMotorista f =
                                        await cf.outFiltro.first;
                                        f.viagem = true;

                                        cf.inFiltro.add(f);
                                      },
                                      child: hTextAbel('Viagens', context,
                                          size: 60,
                                          weight: FontWeight.bold,
                                          color: ff.viagem == true
                                              ? Color.fromRGBO(255, 184, 0, 30)
                                              : Colors.black),
                                    ),
                                    sb,
                                    hText('|', context, size: 60),
                                    sb,
                                    GestureDetector(
                                      onTap: () async {
                                        FiltroMotorista f =
                                        await cf.outFiltro.first;
                                        f.viagem = false;

                                        cf.inFiltro.add(f);
                                      },
                                      child: hTextAbel(
                                        'Entregas',
                                        context,
                                        size: 60,
                                        weight: FontWeight.bold,
                                        color: ff.viagem == false
                                            ? Color.fromRGBO(255, 184, 0, 30)
                                            : Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.only(
                        top: getAltura(context) * .020,
                        bottom: getAltura(context) * .010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          color: Color.fromRGBO(248, 248, 248, 100),
                          width: getLargura(context) * .85,
                          child:      AddressSearchField(
                            
                            decoration: InputDecoration(
                               fillColor: Colors.grey[200],
                              filled: true,

                              prefixIcon: Icon(Icons.map, color: Colors.black),
                              labelText: 'Onde vamos?',
                              contentPadding: EdgeInsets.fromLTRB(getAltura(context)*.025,getLargura(context)*.020, getAltura(context)*.025, getLargura(context)*.020),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                  borderSide: BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            controller: locationController,
                            country: "Brasil",
                            city: '${filtro}',
                            hintText: "Pontos",
                            noResultsText: "Nenhum local encontrado...",

                            onDone: (BuildContext dialogContext, AddressPoint point) async {
                              requisicao(locationController.text);
                              Navigator.of(context).pop();
                            },
                            onCleaned: () => print("clean"),
                          ),


                          /*TextField(
                            onTap: ()async{

                            },
                            controller: locationController,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value){
                               requisicao(value);
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            expands: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.mapMarkedAlt,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Onde vamos?',
                              contentPadding: EdgeInsets.fromLTRB(
                                  getLargura(context) * .040,
                                  getAltura(context) * .020,
                                  getLargura(context) * .040,
                                  getAltura(context) * .020),
                            ),
                          ),*/
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  
   requisicao(String intendedLocation)async {

     Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
       List<Placemark> location = await Geolocator().placemarkFromAddress(intendedLocation);
       double latitude = location[0].position.latitude;
       double longitude = location[0].position.longitude;
       LatLng destination = LatLng(latitude, longitude);
       getMarkers(destination,  intendedLocation);
       rc.CalcularRota(v, destination);
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



    Future<void> pesquisaEndereco() async{
                                         try{
                                              final center = await localizacaoInicial();
                                           gg.Prediction p = await PlacesAutocomplete.show(context: context, mode: Mode.overlay,apiKey:'AIzaSyB_niut8QCQctZAwMCWUEO5V7wk93ScrrI', language: 'pt-BR', components: [
                                             gg.Component(gg.Component.country, 'BR'),

                                           ],
                                               sessionToken: Uuid().generateV4(),

                                               radius: center == null ? null : 10000
                                           ) ;
                                         } catch (e) {
                                           return;
                                         }
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
 localizacaoInicial() {
    Geolocator(). getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
      print('aqui localizacao ${v}');
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));

      _initialPosition = LatLng(v.latitude, v.longitude);

      List<Placemark> mark =
      await Geolocator().placemarkFromCoordinates(v.latitude, v.longitude);
      Placemark place = mark[0];
      _currentAddress = '${place.name.isNotEmpty ? place.name + ', ' : ''}${place.thoroughfare.isNotEmpty ? place.thoroughfare + ', ' : ''}${place.subLocality.isNotEmpty ? place.subLocality+ ', ' : ''}${place.locality.isNotEmpty ? place.locality+ ', ' : ''}${place.subAdministrativeArea.isNotEmpty ? place.subAdministrativeArea + ', ' : ''}${place.postalCode.isNotEmpty ? place.postalCode + ', ' : ''}${place.administrativeArea.isNotEmpty ? place.administrativeArea : ''}';
      filtro = '${place.subAdministrativeArea.isNotEmpty ? place.subAdministrativeArea: ''}';

      destinationController.text = _currentAddress;


    });
  }

  Widget ProcurarWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FiltroPage()));
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
        height: getLargura(context) * .10,
        width: getLargura(context) * .97,
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
                color: Colors.white, textaling: TextAlign.center, size: 75)
          ],
        ),
      ),
    );
  }


}

List<Polyline> getPolys(data) {
  List<Polyline> poly = new List();
  if (data == null) {
    return poly;
  }
  PolylineId id = PolylineId("poly");
  try {
    poly.add(Polyline(
      polylineId: id,
      color: Colors.red,
      points: data,
    ));
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
List<Marker> getMarkers(LatLng data, String addres) {

  List<Marker> markers = new List();
  MarkerId markerId = MarkerId('id');
  MarkerId markerId2 = MarkerId('id2');
  try {
    markers.add(Marker(
        markerId: markerId,
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: data));
  } catch (err) {
    print(err.toString());
  }
  try {
    markers.add(Marker(
        markerId: markerId2,
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng(data.latitude, data.longitude)));
  } catch (err) {
    print(err.toString());
  }
  return markers;
}
