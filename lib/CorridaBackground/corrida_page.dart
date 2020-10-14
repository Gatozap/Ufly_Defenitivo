import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Helpers/Styles.dart';

import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Localizacao.dart';

import 'package:ufly/CorridaBackground/background/config/env.dart';
import 'package:ufly/CorridaBackground/background/registration_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:shimmer/shimmer.dart';  
import 'package:url_launcher/url_launcher.dart';
import 'package:ufly/CorridaBackground/background/advanced/util/dialog.dart'
    as util;
import 'background/advanced/app.dart';
import 'package:latlong/latlong.dart';

import 'corrida_controller.dart';

class CorridaPage extends StatefulWidget {
  @override
  _CorridaPageState createState() => new _CorridaPageState();
}

class _CorridaPageState extends State<CorridaPage> {
  MapController _mapController;
  MapOptions _mapOptions;
  LatLng _center = new LatLng(-16.6773775, -49.2640222);

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _mapOptions = new MapOptions(
      onPositionChanged: (b, g) {},
      center: _center,
      zoom: 12.0,
      onLongPress: (v) {},
    );
  }


  var lastRota;
  List<LayerOptions> layers;
  @override
  Widget build(BuildContext context) {
    if(corridaController == null){
      corridaController = CorridaController();
    }
    if (layers == null) {
      layers = [
        new TileLayerOptions(
          urlTemplate:
              "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': MAP_TOKEN,
            'id': 'mapbox.streets',
          },
        )
      ];

      //layers.addAll(CriarFronteiras());
    }
    print("AQUI LAYERS ${layers.length}");
    return Scaffold(

      appBar: myAppBar('Rota', context, showBack: true, size: 150),
      bottomSheet: Container(
        color: corPrimaria,
        child: StreamBuilder<Carro>(
          stream: corridaController.outCarro,
          builder: (context, carro) {
            print('aqui carro ${carro.data}');
            return  StreamBuilder<bool>(
                      stream: corridaController.outStarted,
                      builder: (context, started) {
                        return Container(
                            width: getLargura(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  carro.data == null
                                          ? Expanded(
                                              child: hText(
                                                  'Não conseguimos encontrar seu carro contate o suporte',
                                                  context,
                                                  color: Colors.white,
                                                  textaling: TextAlign.center),
                                            )
                                          : started.data
                                              ? Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor: Colors.grey,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        layers = [
                                                          new TileLayerOptions(
                                                            urlTemplate:
                                                                "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                                                            additionalOptions: {
                                                              'accessToken':
                                                                  MAP_TOKEN,
                                                              'id':
                                                                  'mapbox.streets',
                                                            },
                                                          )
                                                        ];
                                                        corridaController
                                                            .finalizarCorrida();
                                                      },
                                                      child: hText(
                                                          'PARAR ROTA', context,
                                                          color: Colors.white,
                                                          weight:
                                                              FontWeight.bold)))
                                              : Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor: Colors.grey,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        corridaController
                                                            .iniciarCorrida();
                                                      },
                                                      child: hText(
                                                          'INICIAR ROTA',
                                                          context,
                                                          color: Colors.white,
                                                          weight:
                                                              FontWeight.bold)))

                                ],
                              ),
                            ));
                      });

          },
        ),
      ),
      body: StreamBuilder<MarkerLayerOptions>(
          stream: corridaController.outUserLocation,
          builder: (context, marker) {
            return  StreamBuilder<List>(
                      stream: corridaController.outRota,
                      builder: (context, rota) {
                        layers = [
                          new TileLayerOptions(
                            urlTemplate:
                                "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                            additionalOptions: {
                              'accessToken': MAP_TOKEN,
                              'id': 'mapbox.streets',
                            },
                          )
                        ];
                        if (rota != lastRota) {
                          if (rota.data != null) {
                            if (rota.data.length != 0) {
                              List<List<LatLng>> pointsSemBairros =
                                  List<List<LatLng>>();
                              List<LatLng> points = List<LatLng>();


                              if (pointsSemBairros.length == 0) {
                                pointsSemBairros.add(points);
                              }
                              if (layers.length > 0) {
                                for (var i in pointsSemBairros) {
                                  try {} catch (err) {
                                    print(
                                        'Erro ao remover Layers ${err.toString()}');
                                  }
                                }
                              }
                              for (var p in pointsSemBairros) {
                                layers.add(PolylineLayerOptions(polylines: [
                                  Polyline(
                                    color: Colors.lightBlue,
                                    strokeWidth: 3,
                                    points: p,
                                  )
                                ]));
                                layers.add(PolylineLayerOptions(polylines: [
                                  Polyline(
                                    color: Colors.blue,
                                    strokeWidth: 8,
                                    borderColor: Colors.white,
                                    borderStrokeWidth: 2,
                                    isDotted: false,
                                    points: p,
                                  )
                                ]));
                              }
                            }
                          }
                        }
                        /*if (layers.length > 1) {
                          layers.removeLast();
                        }*/
                        if (marker.data != null) {
                          layers.add(marker.data);
                          _mapController.move(marker.data.markers[0].point,
                              _mapController.zoom);
                        }

                        return Stack(
                          children: <Widget>[
                            FlutterMap(
                                mapController: _mapController,
                                options: _mapOptions,
                                layers: layers),
                            Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  StreamBuilder<double>(
                                      stream: corridaController
                                          .outDistanciaPercorrida,
                                      builder: (context, snapshot) {
                                        return hText(
                                            snapshot.data == null
                                                ? '0'
                                                : '${snapshot.data.toStringAsFixed(1)} KM',
                                            context);
                                      })
                                ],
                              ),
                            )),
                          ],
                        );
                      });

          }),
    );
  }


}
