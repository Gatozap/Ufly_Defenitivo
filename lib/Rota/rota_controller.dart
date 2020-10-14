import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/Helpers.dart';
import 'package:ufly/Objetos/Endereco.dart';
import 'package:ufly/Objetos/Rota.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class RotaController extends BlocBase {
  LatLng localizacao;
  BehaviorSubject<LatLng> controllerLocalizacao = new BehaviorSubject<LatLng>();
  Stream<LatLng> get outLocalizacao => controllerLocalizacao.stream;
  Sink<LatLng> get inLocalizacao => controllerLocalizacao.sink;

  BehaviorSubject<List<LatLng>> controllerPolyline =
      new BehaviorSubject<List<LatLng>>();
  Stream<List<LatLng>> get outPoly => controllerPolyline.stream;
  Sink<List<LatLng>> get inPoly => controllerPolyline.sink;
  RotaController() {
    PolylinePoints polylinePoints = PolylinePoints();

    getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
      print("AQUI LOCALIZAÇÂO ${v}");
      inLocalizacao.add(LatLng(v.latitude, v.longitude));

     // CalcularRota(v);
    });
  }

  /*CalcularRota(Position v) async {
    List<LatLng> polylineCoordinates = [];
    print(v.latitude);
    print(v.longitude);
    /*print(e.latitude);
    print(e.longitude);  */
    http
        .get(
      ROUTE_QUERY(v.latitude, v.longitude, e.latitude, e.longitude),
    )
        .then((result) {
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
      polylineCoordinates.add(LatLng(e.latitude, e.longitude));
      print("RETORNOU ROTA CALCULADA ${polylineCoordinates.length}");
      inPoly.add(polylineCoordinates);
    });
  } */

  @override
  void dispose() {
    controllerLocalizacao.close();
    controllerPolyline.close();

  }
}
