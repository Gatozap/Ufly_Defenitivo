import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Objetos/Endereco.dart';

import 'package:ufly/Rota/rota_controller.dart';
import 'package:geolocator/geolocator.dart';

class RotaPage extends StatefulWidget {

  RotaPage();

  @override
  _RotaPageState createState() {
    return _RotaPageState();
  }
}

class _RotaPageState extends State<RotaPage> {
  RotaController rc;
  @override
  void initState() {

    if (rc == null) {
      rc = RotaController();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GoogleMapController _controller;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     LatLng e;
    LatLng locEntrega = LatLng(e.latitude, e.longitude);
    if (locEntrega == null) {
      return hText('Localização NULA', context);
    }

    CameraPosition _kGooglePlex = CameraPosition(
      target: locEntrega,
      zoom: 14.4746,
    );
    var map = StreamBuilder(
      stream: rc.outPoly,
      builder: (context, snap) {
        List<Polyline> polylines = getPolys(snap.data);
        return StreamBuilder<LatLng>(
            stream: rc.outLocalizacao,
            builder: (context, localizacao) {
              if (localizacao.data == null) {
                return GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  //polylines: polylines.toSet(),
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = (controller);
                  },
                );
              }
            //  List<Marker> markers = getMarkers(localizacao.data);

              print("AQUI Poly ${polylines.length}");
              return GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                polylines: polylines.toSet(),
               // markers: markers.toSet(),
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller = (controller);
                },
              );
            });
      },
    );

    return Scaffold(
      appBar: myAppBar(
        'Rota',
        context,
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((v) async {
          print("AQUI LOCALIZAÇÂO ${v}");
          rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
          //rc.CalcularRota(widget.endereco, v);
        });
      },),
      body: map,
    );
  }

  List<Polyline> getPolys(data) {
    List<Polyline> poly = new List();
    if (data == null) {
      return poly;
    }
    PolylineId id = PolylineId("poly");
    try {
      poly.add(Polyline(
        polylineId: id,
        color: Colors.red,
        points: data,
      ));
    } catch (err) {
      print(err.toString());
    }
    return poly;
  }

  List<Marker> getMarkers(LatLng data, String endereco) {

    List<Marker> markers = new List();
    MarkerId markerId = MarkerId('id');
    MarkerId markerId2 = MarkerId('id2');
    try {
      markers.add(Marker(
          markerId: markerId,
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: data));
    } catch (err) {
      print(err.toString());
    }
    try {
      markers.add(Marker(
          markerId: markerId2,
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: LatLng(data.latitude, data.longitude)));
    } catch (err) {
      print(err.toString());
    }
    return markers;
  }
}
