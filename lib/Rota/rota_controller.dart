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

  BehaviorSubject<List<List<LatLng>>> controllerPolylinePassageiro =
  new BehaviorSubject<List<List<LatLng>>>();
  Stream<List<List<LatLng>>> get outPolyPassageiro =>
      controllerPolylinePassageiro.stream;
  Sink<List<List<LatLng>>> get inPolyPassageiro => controllerPolylinePassageiro.sink;

  BehaviorSubject<List<List<LatLng>>> controllerPolylineMotorista =
      new BehaviorSubject<List<List<LatLng>>>();
  Stream<List<List<LatLng>>> get outPolyMotorista =>
      controllerPolylineMotorista.stream;
  Sink<List<List<LatLng>>> get inPolyMotorista => controllerPolylineMotorista.sink;

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
      Rota r = Rota.fromJson(json.decode(result.body));
      rota = r;

      for (int i = 0; i < r.routes.length; i++) {
        List<LatLng> rotas = [];

        if (i == 0) {
          rotas.add(LatLng(
              localizacaoUsuario.latitude, localizacaoUsuario.longitude));

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


      }
    }




    paradas.add(way);
    paradas.add(destinoFinal);


    List<List<LatLng>> rotasTemp = [];
    for (var i = 0; i+1 < paradas.length; i++) {
      if (paradas[i+1] != null) {

        var l = await CalcularRota(paradas[i], paradas[i+1],
            isdestinoFinal: false);

        rotasTemp.addAll(l);
      }
    }
    inPoly.add(rotasTemp);

  }
  Future<List<List<LatLng>>> CalcularRotaPassageiro(LatLng passageiro_inicial, requisicaoController, {bool isdestinoFinal = true}) async {
    List<LatLng> rotas = [];
    List<List<LatLng>> polylineCoordinatesPassageiro = [];
    for (int i = 0; i < requisicaoController.rota.routes.length; i++) {


      if (i == 0) {
        rotas.add(LatLng(
            passageiro_inicial.latitude, passageiro_inicial.longitude));
      }

      for (var l in requisicaoController.rota.routes[0].legs) {
        for (var s in l.steps) {
          for (var i in s.intersections) {
            rotas.add(LatLng(i.location[1], i.location[0]));
          }
        }
      }

      polylineCoordinatesPassageiro.add(rotas);
    }
    polylineCoordinatesPassageiro.last.add(LatLng(
        polylineCoordinatesPassageiro.last.last.latitude,
        polylineCoordinatesPassageiro.last.last.longitude));
    inPolyPassageiro.add(polylineCoordinatesPassageiro);
    return polylineCoordinatesPassageiro;
  }
  AdicionarParadaPassageiro(requisicaoController, way) async {
    List<LatLng> paradasTemp = paradas;
    paradas = [];
    if (destinoFinal == null) {
      destinoFinal = LatLng(
          requisicaoController.destino.lat, requisicaoController.destino.lng);
    }
    paradas.add(LatLng(
        requisicaoController.origem.lat, requisicaoController.origem.lng));
    for(var a in paradasTemp){
      if(a != localizacaoUsuario && a != destinoFinal) {
        paradas.add(a);
      }
    }
    paradas.add(way[0]);
    paradas.add(way[1]);
    paradas.add(way[2]);
    paradas.add(destinoFinal);
    List<List<LatLng>> rotasTemp = [];
    for (var i = 0; i+1 < paradas.length; i++) {
      if (paradas[i+1] != null) {

        var l = await CalcularRotaPassageiro(paradas[i], requisicaoController);

        rotasTemp.addAll(l);
      }
    }
    inPolyPassageiro.add(rotasTemp);

  }

  Future<List<List<LatLng>>> CalcularRotaMotorista(LatLng v, LatLng c, {bool isdestinoFinal = true}) async {
    List<List<LatLng>> polylineCoordinatesMotorista = [];

    http
        .get(
      ROUTE_QUERY(v.latitude, v.longitude, c.latitude, c.longitude),
    )
        .then((result) {
              print('aqui body ${result.body}');
      localizacaoUsuario = v;

      if (isdestinoFinal == true) {
        destinoFinal = c;

      }



      Rota r = Rota.fromJson(json.decode(result.body));
      rota = r;

      for (int i = 0; i < r.routes.length; i++) {
        List<LatLng> rotas = [];

        if (i == 0) {

          rotas.add(LatLng(
              localizacaoUsuario.latitude, localizacaoUsuario.longitude));

        }

        for (var l in r.routes[0].legs) {
          for (var s in l.steps) {
            for (var i in s.intersections) {

              rotas.add(LatLng(i.location[1], i.location[0]));

            }
          }
        }

        polylineCoordinatesMotorista.add(rotas);
      }

      polylineCoordinatesMotorista.last.add(LatLng(
          polylineCoordinatesMotorista.last.last.latitude,
          polylineCoordinatesMotorista.last.last.longitude));
      inPolyMotorista.add(polylineCoordinatesMotorista);

      return polylineCoordinatesMotorista;
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
