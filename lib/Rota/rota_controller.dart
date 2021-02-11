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
  BehaviorSubject<Position> controllerPosition =
      new BehaviorSubject<Position>();
  Stream<Position> get outPosition => controllerPosition.stream;
  Sink<Position> get inPosition => controllerPosition.sink;

  BehaviorSubject<List<List<LatLng>>> controllerPolyline =
      new BehaviorSubject<List<List<LatLng>>>();
  Stream<List<List<LatLng>>> get outPoly => controllerPolyline.stream;
  Sink<List<List<LatLng>>> get inPoly => controllerPolyline.sink;

  BehaviorSubject<List<LatLng>> controllerMarker =
  new BehaviorSubject<List<LatLng>>();
  Stream<List<LatLng>> get outMarker => controllerMarker.stream;
  Sink<List<LatLng>>get inMarker => controllerMarker.sink;

  BehaviorSubject<List<String>> controllerParadas =
  new BehaviorSubject<List<String>>();
  Stream<List<String>> get outParadas => controllerParadas.stream;
  Sink<List<String>> get inParadas => controllerParadas.sink;



  BehaviorSubject<List<LatLng>> controllerPolylineMotorista =
      new BehaviorSubject<List<LatLng>>();
  Stream<List<LatLng>> get outPolyMotorista =>
      controllerPolylineMotorista.stream;
  Sink<List<LatLng>> get inPolyMotorista => controllerPolylineMotorista.sink;

  BehaviorSubject<List<Waypoints>> controllerWayPoints =
      new BehaviorSubject<List<Waypoints>>();
  Stream<List<Waypoints>> get outWayPoints => controllerWayPoints.stream;
  Sink<List<Waypoints>> get inWayPoints => controllerWayPoints.sink;

  LatLng localizacaoUsuario;
  LatLng destinoFinal;
  LatLng parada1;
  LatLng parada2;
  LatLng parada3;
  RotaController() {
    PolylinePoints polylinePoints = PolylinePoints();

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      localizacaoUsuario = LatLng(v.latitude, v.longitude);
      inLocalizacao.add(localizacaoUsuario);
    });
  }

  Future<List<List<LatLng>>> CalcularRota(LatLng v, LatLng c,   {bool isdestinoFinal = true}) async {
    List<List<LatLng>> polylineCoordinates = [];

    return http
        .get(
        ROUTE_QUERY(v.latitude, v.longitude, c.latitude, c.longitude)
    )
        .then((result) {

      localizacaoUsuario = v;

      if (isdestinoFinal == true) {
        destinoFinal = c;
      }


      // polylineCoordinates2.add(LatLng(v.latitude, v.longitude));
      Rota r = Rota.fromJson(json.decode(result.body));
      rota = r;

      for (int i = 0; i < r.routes.length; i++) {
        List<LatLng> rotas = [];

        if (i == 0) {
          rotas.add(LatLng(
              localizacaoUsuario.latitude, localizacaoUsuario.longitude));
          //rotas.add(parada1);
        }

        for (var l in r.routes[0].legs) {
          for (var s in l.steps) {
            for (var i in s.intersections) {

              rotas.add(LatLng(i.location[1], i.location[0]));
            }
          }
        }

        polylineCoordinates.add(rotas);
      }

      polylineCoordinates.last.add(LatLng(
          polylineCoordinates.last.last.latitude,
          polylineCoordinates.last.last.longitude));
      inPoly.add(polylineCoordinates);


      return polylineCoordinates;
    });

  }

  List<LatLng> paradas = [];
  AdicionarParada(LatLng way) async {
      List<LatLng> paradasTemp = paradas;
      paradas = [];



    if (destinoFinal == null) {
      destinoFinal = paradas.last;
    }
    paradas.add(localizacaoUsuario);
    for(var a in paradasTemp){
      if(a != localizacaoUsuario && a != destinoFinal) {
        paradas.add(a);

        print('aqui letra a ${a.toString()}');
      }
    }




    paradas.add(way);
    paradas.add(destinoFinal);


    List<List<LatLng>> rotasTemp = [];
    for (var i = 0; i+1 < paradas.length; i++) {
      if (paradas[i+1] != null) {

        var l = await CalcularRota(paradas[i], paradas[i+1],
            isdestinoFinal: false);
        print('aqui paradas 2323${(l.toList())}');
        rotasTemp.addAll(l);
      }
    }
    inPoly.add(rotasTemp);

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
        double ii = (i.duration) / 3600;

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
    controllerParadas.close();
    controllerWayPoints.close();
  }
}
