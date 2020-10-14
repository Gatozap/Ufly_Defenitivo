import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
class RotaControllerTeste extends BlocBase {
  LatLng localizacao;
  BehaviorSubject<LatLng> controllerLocalizacao = new BehaviorSubject<LatLng>();
  Stream<LatLng> get outLocalizacao => controllerLocalizacao.stream;
  Sink<LatLng> get inLocalizacao => controllerLocalizacao.sink;

  Set<Marker> marca;
  BehaviorSubject<Set<Marker>> controllermarca = new BehaviorSubject<Set<Marker>>();
  Stream<Set<Marker>> get outMarca => controllermarca.stream;
  Sink<Set<Marker>> get inMarca => controllermarca.sink;

  BehaviorSubject<GoogleMapController> controllerGoogle = new BehaviorSubject<GoogleMapController>();
  Stream<GoogleMapController> get outGoogle => controllerGoogle.stream;
  Sink<GoogleMapController> get inGoogle=> controllerGoogle.sink;

  BehaviorSubject<CameraPosition> controllerPosition = new BehaviorSubject<CameraPosition>();
  Stream<CameraPosition> get outPosition => controllerPosition.stream;
  Sink<CameraPosition> get inPosition=> controllerPosition.sink;



  @override
  void dispose() {
    controllerLocalizacao.close();
    controllermarca.close();
    // TODO: implement dispose
  }

}