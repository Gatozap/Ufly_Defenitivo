import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class CameraController implements BlocBase {

  BehaviorSubject<CameraPosition> _controllercamera = new BehaviorSubject<CameraPosition>();

  Stream<CameraPosition> get outCameraController => _controllercamera.stream;

  Sink<CameraPosition> get inCameraController => _controllercamera.sink;


  BehaviorSubject<GoogleMapController> _controllerMapGoogle = new BehaviorSubject<GoogleMapController>();

  Stream<GoogleMapController> get outGoogleController => _controllerMapGoogle.stream;

  Sink<GoogleMapController> get inGoogleController => _controllerMapGoogle.sink;



  @override
  void dispose() {
    _controllercamera.close();
  }

  CameraController(CameraPosition position) {
                inCameraController.add(position);
  }
}