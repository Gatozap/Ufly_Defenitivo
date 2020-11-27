import 'package:geolocator/geolocator.dart';

class GeolocatorService{
  Geolocator geo = Geolocator();
  Stream<Position> getCurrentLocation(){
    var localizacaoOpcoes = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    return geo.getPositionStream(localizacaoOpcoes);
  }
  Future<Position> getPosicaoInicial()async{
    return geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}