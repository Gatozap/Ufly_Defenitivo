import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ufly/Avaliacao/AvaliacaoPage.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Viagens/InicioDeViagemPage/InicioDeViagemPage.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
class ChamandoMotoristaPage extends StatefulWidget {
  ChamandoMotoristaPage({Key key}) : super(key: key);

  @override
  _ChamandoMotoristaPageState createState() {
    return _ChamandoMotoristaPageState();
  }
}

class _ChamandoMotoristaPageState extends State<ChamandoMotoristaPage> {
  final PagesController pc = new PagesController(0);
  PageController pageController;
  PagesController pg;
  void onTap(int index) {
    pc.inPageController.add(index);
  }

  var page0;
  var page1;
  var page2;
  var page3;
  var page4;
  int page = 0;
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
    return StreamBuilder<int>(
        stream: pc.outPageController,
        builder: (context, snapshot) {
          return Scaffold(
            /*bottomNavigationBar: BottomAppBar(
                elevation: 20,
                color: Color.fromRGBO(255, 184, 0, 30),
                child: Container(
                  height: getAltura(context) * .1,
                  width: getLargura(context),
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            snapshot.data == 0
                                ? Shimmer.fromColors(
                                    baseColor: Colors.black,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      child: Image.asset('assets/viagem.png'),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      onTap(0);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InicioDeViagemPage()));
                                    },
                                    child: Container(
                                      child: Image.asset('assets/viagem.png'),
                                    )),
                            hTextAbel('Viagens', context, size: 60)
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            snapshot.data == 1
                                ? Shimmer.fromColors(
                                    baseColor: Colors.black,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      child: Image.asset('assets/entregas.png'),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      onTap(1);
                                    },
                                    child: Container(
                                      child: Image.asset('assets/entregas.png'),
                                    )),
                            hTextAbel('Entregas', context, size: 60)
                          ],
                        )
                      ]),
                )),*/
            body: SlidingUpPanel(
              renderPanelSheet: false,
              minHeight: 60,

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
              panel: FinalizarCorrida(),
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
                                        top: getAltura(context) * .030,
                                        left: getLargura(context) * .110),
                                    child: Icon(
                                      FontAwesomeIcons.mapMarkedAlt,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: getAltura(context) * .020,
                                        left: getLargura(context) * .080),
                                    child: hTextMal('0.0 m', context,
                                        color: Colors.white, size: 70),
                                  ),
                                ],
                              ),
                              Container(
                                width: getLargura(context) * .50,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: getLargura(context) * .020),
                                  child: hTextMal(
                                      'R. Vanderlei Felicio, 300 Heberto de Souza',
                                      context,
                                      size: 50,
                                      color: Colors.white,
                                      weight: FontWeight.bold),
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
        });
  }
  Widget FinalizarCorrida(){
    return Container(
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
                    children: <Widget>[
                      hTextAbel('Júlio', context,
                          size: 70, color: Colors.black),
                      Row(
                        children: <Widget>[
                          hTextAbel('5,0', context,
                              size: 50, color: Colors.black),
                          Container(
                            child: Image.asset(
                                'assets/estrela.png'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: getAltura(context) * .035,
                    left: getLargura(context) * .150),
                child: Container(
                    alignment: Alignment.topRight,
                    child: hTextAbel('R\$ 10,00', context,
                        size: 70, color: Colors.black)),
              ),
            ],
          ),
          sb,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AvaliacaoPage()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              width: getLargura(context) * .70,
              height: getAltura(context) * .080,
              child: Center(
                  child: hTextMal('Finalizar Corrida', context,
                      size: 70,
                      color: Colors.white,
                      weight: FontWeight.bold)),
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
