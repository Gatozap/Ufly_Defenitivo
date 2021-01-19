import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'as lc;
class GeolocatorService{
  Geolocator geo = Geolocator();
  Stream<Position> getCurrentLocation(){
    var localizacaoOpcoes = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    return geo.getPositionStream(localizacaoOpcoes);
  }

  Future<LatLng> getPosition() async {
    final lc.Location location = lc.Location();
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) throw 'GPS service is disabled';
    }
    if (await location.hasPermission() == lc.PermissionStatus.denied) {
      if (await location.requestPermission() != lc.PermissionStatus.granted)
        throw 'No GPS permissions';
    }
    final data = await location.getLocation();
    return LatLng(data.latitude, data.longitude);
  }

}