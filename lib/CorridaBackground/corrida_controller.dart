
import 'package:sembast/sembast.dart';
import 'package:ufly/CorridaBackground/corrida_firebase_sender.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Helpers/SqliteDatabase.dart';


import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/CorridaTeste.dart';

import 'package:ufly/Objetos/Localizacao.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'  as bg;
import 'package:ufly/CorridaBackground/background/advanced/util/dialog.dart' as util;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void headlessTask(bg.HeadlessEvent headlessEvent) async {
  switch (headlessEvent.name) {
    case bg.Event.LOCATION:
      var l = headlessEvent.event;


      Localizacao loc;


      loc = Localizacao(
          latitude: l.coords.latitude,
          longitude: l.coords.longitude,
          timestamp: DateTime.now(),
          );
      try {
        add(loc);
      } catch (err) {
        print('Erro ao salvar no banco de dados: ${err.toString()}');
      }
      break;
    case bg.Event.MOTIONCHANGE:
      var l = headlessEvent.event;
      print("AQUI CHANGE ${l.toString()}");
      User u = await getUser();
      print("USER ${u.id} ${u.nome}");

      break;
     }
}








class CorridaController extends BlocBase {
  List rota;
  BehaviorSubject<List> rotaController = BehaviorSubject<List>();
  Stream<List> get outRota => rotaController.stream;
  Sink<List> get inRota => rotaController.sink;

  CorridaFirebaseSender cfs = CorridaFirebaseSender();
  Carro carro;
  BehaviorSubject<Carro> carroController = BehaviorSubject<Carro>();
  Stream<Carro> get outCarro => carroController.stream;
  Sink<Carro> get inCarro => carroController.sink;

  BehaviorSubject<bool> startedController = BehaviorSubject<bool>();
  Stream<bool> get outStarted => startedController.stream;
  Sink<bool> get inStarted => startedController.sink;



  Corrida corrida;
  BehaviorSubject<Corrida> corridaController = BehaviorSubject<Corrida>();
  Stream<Corrida> get outCorrida => corridaController.stream;
  Sink<Corrida> get inCorrida => corridaController.sink;



  MarkerLayerOptions UserLocation;
  MarkerLayerOptions LastUserLocation;
  BehaviorSubject<MarkerLayerOptions> userLocationController =
      BehaviorSubject<MarkerLayerOptions>();
  Stream<MarkerLayerOptions> get outUserLocation =>
      userLocationController.stream;
  Sink<MarkerLayerOptions> get inUserLocation => userLocationController.sink;
 // final geolocator = Geolocator();

  SharedPreferences sp;
  double distanciaPercorrida = 0.0;
  BehaviorSubject<double> distanciaPercorridaController =
      BehaviorSubject<double>();
  Stream<double> get outDistanciaPercorrida =>
      distanciaPercorridaController.stream;
  Sink<double> get inDistanciaPercorrida => distanciaPercorridaController.sink;

  finalizarCorrida() async {
    started = false;
    inStarted.add(started);
    sp.setBool('started', started);
    if (carro == null) {
      carrosRef
          .where('id_usuario', isEqualTo: Helper.localUser.id)
          .get()
          .then((v) {
        List<Carro> carros = new List<Carro>();
        for (var d in v.docs) {
          Carro c = Carro.fromJson(d.data());
          carros.add(c);
        }
        carro = carros[0];
        print('aqui a porra do carro ${carro.toString()}');
        cfs.PararLigacao(carro);
      });
    } else {
      cfs.PararLigacao(carro);
    }


    bg.BackgroundGeolocation.changePace(false).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });
    bg.BackgroundGeolocation.removeListeners();

    inRota.add(rota);
    distanciaPercorrida = 0.0;
    inDistanciaPercorrida.add(distanciaPercorrida);
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("CLOSE"));

    bg.BackgroundGeolocation.stop();
    enabled = (await bg.BackgroundGeolocation.state).enabled;
  }

  iniciarCorrida() async {
    print("CHAMANDO LALAL");
    enabled = (await bg.BackgroundGeolocation.state).enabled;
    started = true;
    if (!enabled) {
      dynamic callback = (bg.State state) async {
        enabled = state.enabled;
        try {
          sp.setBool('started', started);
        } catch (err) {
          sp = await SharedPreferences.getInstance();
          sp.setBool('started', started);
        }
        inStarted.add(started);
        try {
          corrida = Corrida.fromJson(json.decode(sp.getString('corrida')));
        } catch (err) {
          print('Error ${err.toString()}');
        }
        print("AQUI CAPETA CORRIDA");
        var LocalizacoesTemp = await getAll();

        rota = LocalizacoesTemp == null ? new List() : LocalizacoesTemp;
        inRota.add(rota);
        distanciaPercorrida = 0.0;
        if (rota.length != 0) {
          var lastPoint;
          for (var l in rota) {

            if (lastPoint != null) {
              distanciaPercorrida += calculateDistance(
                l.latitude,
                l.longitude,
                lastPoint.latitude,
                lastPoint.longitude,
              );
            }
            lastPoint = l;
          }
        }
        print("CHEGOU AQUI LOLO2 ${started} ");

        inDistanciaPercorrida.add(distanciaPercorrida);
        //if (started) {
        cfs.IniciarLigacao(carro);
        print("CHEGOU AQUI LOLO ");
        bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
          print('[changePace] success $isMoving');
        }).catchError((e) {
          print('[changePace] ERROR: ' + e.toString());
          //setupBackground();
        });
        print("CHEGOU AQUI ");
        bg.BackgroundGeolocation.onLocation((bg.Location location) {
          novaLocalizacao(
              LatLng(location.coords.latitude, location.coords.longitude));
        }, (err) {
          print("Error: ${err.toString()}");
        });
        bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
        try {
          bg.BackgroundGeolocation.registerHeadlessTask(headlessTask)
              .catchError((err) {
            print('Error: ${err.toString()}');
          });
        } catch (err) {
          print('Error: ${err.toString()}');
        }
      };
      print("CHAMANDO?");
      bg.BackgroundGeolocation.start().then(callback).catchError((onError) {
        print("Error: ${onError.toString()}");
      });
    } 

    else {
      try {
        sp.setBool('started', started);
      } catch (err) {
        sp = await SharedPreferences.getInstance();
        sp.setBool('started', started);
      }
      inStarted.add(started);
      try {
        corrida = Corrida.fromJson(json.decode(sp.getString('corrida')));
      } catch (err) {
        print('Error ${err.toString()}');
      }

      print("AQUI CAPETA CORRIDA");
      var LocalizacoesTemp = await getAll();

      rota = LocalizacoesTemp == null ? new List() : LocalizacoesTemp;
      inRota.add(rota);
      distanciaPercorrida = 0.0;
      if (rota.length != 0) {
        var lastPoint;
        for (var l in rota) {
          if (lastPoint != null) {
            distanciaPercorrida += calculateDistance(
              l.latitude,
              l.longitude,
              lastPoint.latitude,
              lastPoint.longitude,
            );
          }
          lastPoint = l;
        }
      }
      print("CHEGOU AQUI LOLO2  ");


      inDistanciaPercorrida.add(distanciaPercorrida);
      //if (started) {
      cfs.IniciarLigacao(carro);
      print("CHEGOU AQUI LOLO ");
      bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
        print('[changePace] success $isMoving');
      }).catchError((e) {
        print('[changePace] ERROR: ' + e.toString());
        //setupBackground();
      });
      print("CHEGOU AQUI 32");
      bg.BackgroundGeolocation.onLocation((bg.Location location) {
        novaLocalizacao(
            LatLng(location.coords.latitude, location.coords.longitude));
      }, (err) {
        print("Error: ${err.toString()}");
      });
      bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
      try {
        bg.BackgroundGeolocation.registerHeadlessTask(headlessTask)
            .catchError((err) {
          print('Error: ${err.toString()}');
        });
      } catch (err) {
        print('Error: ${err.toString()}');
      }
    }

    //bg.BackgroundGeolocation.start();

    // }
  }

  bool done = false;
  setupBackground() async {
    Map deviceParams = await Config.deviceParams;
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            forceReloadOnBoot: true,
            enableHeadless: true,
            preventSuspend: true,
            stopTimeout: 1,
            reset: false,
            distanceFilter: 10.0,
            url: 'http://localhost:8080/locations',
            persistMode: Config.PERSIST_MODE_ALL,
            params: deviceParams,
            stopOnTerminate: false,
            activityType: Config.ACTIVITY_TYPE_AUTOMOTIVE_NAVIGATION,
            stopOnStationary: false,
            notification: bg.Notification(
                largeIcon: 'drawable/ic_launcher',
                smallIcon: 'drawable/autooh',
                priority: Config.NOTIFICATION_PRIORITY_MAX,
                title: 'Você está ganhando Dinheiro',
                //color: '#007A9A',
                text: 'Estamos acompanhando sua localização'),
            startOnBoot: true,
            foregroundService: true,
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_OFF))
        .then((bg.State state) async {
      print("AQUI LOLOLO ${state.enabled}");
      enabled = state.enabled;
      //bg.BackgroundGeolocation.start();
      if (enabled) {
        SharedPreferences.getInstance().then((value) {
          sp = value;
          started = value.getBool('started') == null
              ? false
              : value.getBool('started');
          if (started) {
            iniciarCorrida();
          }
        });
      } else {}
    });
    //bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("BUTTON_CLICK"));
  }

  CorridaController() {
    inUserLocation.add(UserLocation);
    inStarted.add(started);
    distanciaPercorrida = 0;
    inDistanciaPercorrida.add(distanciaPercorrida);
    setupBackground();
    // Fired whenever a location is recorded
    print('aqui usuario ${Helper.localUser.id}');
    carrosRef.where('id_usuario', isEqualTo: Helper.localUser.id)
        .get()
        .then((v) {
      List<Carro> carros = new List<Carro>();
      for (var d in v.docs) {
        Carro c = Carro.fromJson(d.data());
             print('aqui carro 232 ${c.toJson()}');

          carros.add(c);
      }
      carro = carros[0];
      inCarro.add(carro);
      SharedPreferences.getInstance().then((value) {
        sp = value;
        
        started =
            value.getBool('started') == null ? false : value.getBool('started');
        if (started) {
          iniciarCorrida();
        }
      });
    }).catchError((err) {
      print('aqui erro 1 ${err}');
      carro = null;
      inCarro.add(carro);
    });
  }
  Localizacao LastLoc;
  novaLocalizacao(LatLng l) {

    if (started == true) {
      print('Nova localização ${started}');
      Localizacao loc;


      UserLocation = new MarkerLayerOptions(
        markers: [
          new Marker(
            width: 25,
            height: 25,
            point: l,
            builder: (ctx) => new Container(
              child: Image.asset(
                "assets/marker.png",
              ),
            ),
          ),
        ],
      );

      loc = Localizacao(
          latitude: l.latitude,
          longitude: l.longitude,
          timestamp: DateTime.now(),
         );
      if (loc != null) {
        rota.add(loc);
        inRota.add(rota);
        if (LastLoc != null) {

            distanciaPercorrida += calculateDistance(loc.latitude,
                loc.longitude, LastLoc.latitude, LastLoc.longitude);
            LastLoc = loc;
            inDistanciaPercorrida.add(distanciaPercorrida);

        }
      }

      if (LastUserLocation != null) {
        if (UserLocation.markers[0].point.latitude !=
                LastUserLocation.markers[0].point.latitude &&
            UserLocation.markers[0].point.longitude !=
                LastUserLocation.markers[0].point.latitude) {

            cfs.AdicionarLatLng(loc, distanciaPercorrida);

          inUserLocation.add(UserLocation);
          LastUserLocation = UserLocation;
        }
      } else {
        inUserLocation.add(UserLocation);
        LastUserLocation = UserLocation;
      }
    } else {
      distanciaPercorrida = 0;
      inDistanciaPercorrida.add(distanciaPercorrida);
    }
  }

  @override
  void dispose() {
    carroController.close();
    startedController.close();

    userLocationController.close();
    distanciaPercorridaController.close();
  }


}

bool _checkIfValidMarker(
  LatLng tap,
  List<LatLng> vertices,
) {
  int intersectCount = 0;
  for (int j = 0; j < vertices.length - 1; j++) {
    if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
      intersectCount++;
    }
  }
  return ((intersectCount % 2) == 1); // odd = inside, even = outside;
}

bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
  double aY = vertA.latitude;
  double bY = vertB.latitude;
  double aX = vertA.longitude;
  double bX = vertB.longitude;
  double pY = tap.latitude;
  double pX = tap.longitude;

  if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
    return false; // a and b can't both be above or below pt.y, and a or
    // b must be east of pt.x
  }

  double m = (aY - bY) / (aX - bX); // Rise over run
  double bee = (-aX) * m + aY; // y = mx + b
  double x = (pY - bee) / m; // algebra is neat!

  return x > pX;
}

bool enabled = false;
bool done;
bool started = false;
CorridaController corridaController;
