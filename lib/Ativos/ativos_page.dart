import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Ativo.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'AtivosController.dart';

class AtivosPage extends StatefulWidget {
  AtivosPage({Key key}) : super(key: key);

  @override
  _AtivosPageState createState() => _AtivosPageState();
}

class _AtivosPageState extends State<AtivosPage> {
  AtivosController ac;
  GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    if (ac == null) {
      ac = AtivosController();
    }
    return Scaffold(
      appBar: myAppBar('Carros Ativos', context, showBack: true),
      body: StreamBuilder(
          stream: ac.outAtivos,
          builder: (context, snapshot) {

                  return FutureBuilder(
                      future: getMarkers(snapshot.data),
                      builder: (context, future) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(-16.665136, -49.286041),
                            zoom: 16,
                          ),
                          zoomGesturesEnabled: true,
                          markers: future.data == null
                              ? Set<Marker>()
                              : future.data.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            _controller=controller;
                          },
                        );
                      });
          }),
    );
  }

  BitmapDescriptor sourceIcon;
  getMarkers(List ativos) async {
    List<Marker> markers;
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 4.5),
      "assets/marker.png",
    );
    markers = [];

    for(CarroAtivo ca in ativos){
      try {
        markers.add(Marker(
          markerId: MarkerId(ca.user_id),
          position: LatLng(
            ca.localizacao.latitude,
              ca.localizacao.longitude,
          ),
          infoWindow: InfoWindow(onTap: () async {
            Carro carro = Carro.fromJson((await carrosRef.doc(ca.carro_id).get()).data);
            print("AQUI CARRO ${carro.id}");

          },
              title:'${ca.user_nome}',  snippet: '${ca.isAtivo}',),
          icon: sourceIcon,
        ));
      } catch (err) {
        print('Erro ao criar marker ${err.toString()}');
      }
      print("ADICIONOU MARKER ${markers.length}");
    }
    print("AQUI MARKERS ${markers.length}");
    return markers;
  }
}
