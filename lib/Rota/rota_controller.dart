import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/Helpers.dart';

import 'package:ufly/Objetos/Rota.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class RotaController extends BlocBase {
  Rota rota;
  LatLng localizacao;
  BehaviorSubject<LatLng> controllerLocalizacao = new BehaviorSubject<LatLng>();
  Stream<LatLng> get outLocalizacao => controllerLocalizacao.stream;
  Sink<LatLng> get inLocalizacao => controllerLocalizacao.sink;

  Position posicao;
  BehaviorSubject<Position> controllerPosition = new BehaviorSubject<Position>();
  Stream<Position> get outPosition => controllerPosition.stream;
  Sink<Position> get inPosition => controllerPosition.sink;

  BehaviorSubject<List<LatLng>> controllerPolyline =
      new BehaviorSubject<List<LatLng>>();
  Stream<List<LatLng>> get outPoly => controllerPolyline.stream;
  Sink<List<LatLng>> get inPoly => controllerPolyline.sink;

  BehaviorSubject<List<LatLng>> controllerPolylineMotorista =
  new BehaviorSubject<List<LatLng>>();
  Stream<List<LatLng>> get outPolyMotorista => controllerPolylineMotorista.stream;
  Sink<List<LatLng>> get inPolyMotorista => controllerPolylineMotorista.sink;
  
  RotaController() {
    PolylinePoints polylinePoints = PolylinePoints();

    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
      print('aqui loca ${v.latitude} e ${v.longitude}');
      inLocalizacao.add(LatLng(v.latitude, v.longitude));
    });
  }

  CalcularRota(LatLng v, LatLng c) async {
    List<LatLng> polylineCoordinates = [];

    http
        .get(
      ROUTE_QUERY(v.latitude, v.longitude, c.latitude, c.longitude),
    )
        .then((result) {
      polylineCoordinates.add(LatLng(v.latitude, v.longitude));


      Rota r = Rota.fromJson(json.decode(result.body));
      rota = r;
      for (var i in r.routes[0].legs) {
        double ii = (i.duration)/3600;


        for (var j in i.steps) {

          for (var k in j.intersections) {


            polylineCoordinates.add(LatLng(k.location[1], k.location[0]));

          }
        }
      }

      polylineCoordinates.add(LatLng(c.latitude, c.longitude));

      Geolocator().placemarkFromCoordinates(c.latitude, c.longitude);
      inPoly.add(polylineCoordinates);
    });
  }

  CalcularRotaMotorista(LatLng v, LatLng c) async {
    List<LatLng> polylineCoordinates = [];

    http
        .get(
      ROUTE_QUERY(v.latitude, v.longitude, c.latitude, c.longitude),
    )
        .then((result) {
      polylineCoordinates.add(LatLng(v.latitude, v.longitude));


      Rota r = Rota.fromJson(json.decode(result.body));
      rota = r;
      for (var i in r.routes[0].legs) {
        double ii = (i.duration)/3600;


        for (var j in i.steps) {

          for (var k in j.intersections) {


            polylineCoordinates.add(LatLng(k.location[1], k.location[0]));

          }
        }
      }

      polylineCoordinates.add(LatLng(c.latitude, c.longitude));

      Geolocator().placemarkFromCoordinates(c.latitude, c.longitude);
      inPolyMotorista.add(polylineCoordinates);
    });
  }
  @override
  void dispose() {
    controllerLocalizacao.close();
    controllerPolyline.close();
    controllerPolylineMotorista.close();
  }
}
