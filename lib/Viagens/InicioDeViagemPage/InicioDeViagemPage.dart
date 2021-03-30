import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class InicioDeViagemPage extends StatefulWidget {
  InicioDeViagemPage({Key key}) : super(key: key);

  @override
  _InicioDeViagemPageState createState() {
    return _InicioDeViagemPageState();
  }
}

class _InicioDeViagemPageState extends State<InicioDeViagemPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(

            body: SlidingUpPanel(
              renderPanelSheet: false,
              minHeight: 60,
              panel: viagemWidget(),
              maxHeight: getAltura(context) * .25,
              borderRadius: BorderRadius.circular(20),
              collapsed:
              Container(
                margin: const EdgeInsets.only(left: 24.0, right: 24),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24.0),
                                    topRight: Radius.circular(24.0)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 20.0,
                                    color: Colors.grey,
                                  ),
                                ]),
                            width: getLargura(context) - 48,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                sb,
                                sb,
                                Container(
                                  child: Container(
                                      width: getLargura(context) * .4,
                                      color: Colors.grey,
                                      height: 3),
                                )
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              body: Container(
                height: getAltura(context),
                width: getLargura(context),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Expanded(
                        child: GoogleMap(mapType: MapType.normal, initialCameraPosition: CameraPosition(target: LatLng(40.712776, -74.005974),zoom: 12, ),markers: {posicao})
                    ),
                    Positioned(
                        top: getAltura(context) * .060,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          height: getAltura(context) * .150,
                          width: getLargura(context) * .80,
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: getAltura(context) * .020,
                                          left: getLargura(context) * .110),
                                      child: Container(child: Image.asset('assets/seta_frente.png'),)
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: getAltura(context) * .020,
                                        left: getLargura(context) * .050),
                                    child: Center(
                                      child: hTextMal('120 m', context,
                                          color: Colors.white, size: 70),
                                    ),
                                  ),
                                ],
                              ),
                              Container(

                                width: getLargura(context) * .50,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: getLargura(context) * .020),
                                  child: Center(
                                    child: hTextMal(
                                        'Av. Itavuvu',
                                        context,
                                        size: 70,
                                        color: Colors.white,
                                        weight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),

                  ],
                ),
              ),
            ),
          );

  }

  Widget viagemWidget(){
    return     Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: getAltura(context) * .250,
      width: getLargura(context) * .90,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: getAltura(context) * .030,
                        left: getLargura(context) * .070),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,
                      backgroundImage:
                      AssetImage('assets/julio.png'),
                    ),
                  ),
                  sb,
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: getAltura(context) * .035,
                    left: getLargura(context) * .025),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      hTextAbel('Júlio', context,
                          size: 20, color: Colors.black),
                      Row(
                        children: <Widget>[
                          hTextAbel('5,0', context,
                              size: 20, color: Colors.black),
                          Container(
                            child: Image.asset(
                                'assets/estrela.png'),
                          ),
                        ],
                      ),
                      Row(children: <Widget>[ hTextAbel('Da sua carteira', context, size: 20, ),sb, Image.asset('assets/carteira.png') ],)
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: getLargura(context)*.150, bottom: getAltura(context)*.040),
                child: Container(child: Image.asset('assets/fechar.png')),
              )
            ],
          ),
          sb,
          Container(

            width: getLargura(context) * .70,
            height: getAltura(context) * .080,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                hTextMal('3 min', context,
                    size: 20,
                    color: Colors.black,
                    weight: FontWeight.bold),
                sb,  sb,
                Image.asset('assets/km.png'),
                sb,sb,
                hTextMal('2.1 Km', context,
                    size: 20,
                    color: Colors.black,
                    weight: FontWeight.bold),
              ],

            ),

          )
        ],
      ),
    );
  }
  Marker posicao = Marker(
      markerId: MarkerId('posição'),
      position: LatLng(40.712776, -74.005974),
      infoWindow: InfoWindow(title: 'Mapa tester'),
      icon:     BitmapDescriptor.defaultMarker
  );
}
