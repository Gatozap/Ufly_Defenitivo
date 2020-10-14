import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:ufly/GoogleServices/google_maps_services.dart';
import 'package:ufly/Helpers/CustomSwitch.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Endereco.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Viagens/Passageiro/aceitar_passageiro_page.dart';
import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Viagens/FiltroPage.dart';
import 'Controllers/camera_controller.dart';
import 'Objetos/FiltroMotorista.dart';
import 'Objetos/Rota.dart';
import 'Rota/rota_controller_teste.dart';

import 'home_page_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  RotaController rc;
  //GoogleMapsPlaces googleplcaes;
  GoogleMapsServices googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();

  final Set<Marker> marks = {};
  Set<Polyline> poly = {};
  ControllerFiltros cf;
  FiltroMotorista fm;


  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  String _currentAddress;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  TextEditingController destinationController = TextEditingController();
  CameraController cc;


  Position position;

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
                      getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
                        print("AQUI LOCALIZAÇÂO ${v}");
                        rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
                        //rc.CalcularRota(widget.endereco, v);
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
                          child: TextField(
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
                          ),
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
     List<LatLng> polylineCoordinates = [];
     getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
       List<Location> location = await locationFromAddress(intendedLocation);
       double latitude = location[0].latitude;
       double longitude = location[0].longitude;
       LatLng destination = LatLng(latitude, longitude);
       getMarkers(destination,  intendedLocation);
       
       http
           .get(
         ROUTE_QUERY(v.longitude, v.latitude, destination.longitude, destination.latitude),
       ).then((result) {
         polylineCoordinates.add(LatLng(v.latitude, v.longitude));
         print("RESULTADO ${result.body}");

         Rota r = Rota.fromJson(json.decode(result.body));
         for (var i in r.routes[0].legs) {
           for (var j in i.steps) {
             for (var k in j.intersections) {
               print(k.location);
               polylineCoordinates.add(LatLng(k.location[1], k.location[0]));
             }
           }
         }
         polylineCoordinates.add(LatLng(destination.latitude, destination.longitude));
         print("RETORNOU ROTA CALCULADA ${polylineCoordinates.length}");
         rc.inPoly.add(polylineCoordinates);
       });

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
  localizacaoInicial() {
    getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
      print('aqui localizacao ${v}');
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));

      _initialPosition = LatLng(v.latitude, v.longitude);

      List<Placemark> mark =
      await placemarkFromCoordinates(v.latitude, v.longitude);
      Placemark place = mark[0];
      _currentAddress = '${place.name.isNotEmpty ? place.name + ', ' : ''}${place.thoroughfare.isNotEmpty ? place.thoroughfare + ', ' : ''}${place.subLocality.isNotEmpty ? place.subLocality+ ', ' : ''}${place.locality.isNotEmpty ? place.locality+ ', ' : ''}${place.subAdministrativeArea.isNotEmpty ? place.subAdministrativeArea + ', ' : ''}${place.postalCode.isNotEmpty ? place.postalCode + ', ' : ''}${place.administrativeArea.isNotEmpty ? place.administrativeArea : ''}';
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
