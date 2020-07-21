import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';

class InicioDeViagemPage extends StatefulWidget {
  InicioDeViagemPage({Key key}) : super(key: key);

  @override
  _InicioDeViagemPageState createState() {
    return _InicioDeViagemPageState();
  }
}

class _InicioDeViagemPageState extends State<InicioDeViagemPage> {
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
            bottomNavigationBar: BottomAppBar(
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
                                  child:
                                  Image.asset('assets/viagem.png'),
                                ))
                                : GestureDetector(
                                onTap: () {
                                  onTap(0);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InicioDeViagemPage()));
                                },
                                child: Container(
                                  child:
                                  Image.asset('assets/viagem.png'),
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
                                  child:
                                  Image.asset('assets/entregas.png'),
                                ))
                                : GestureDetector(
                                onTap: () {
                                  onTap(1);
                                },
                                child: Container(
                                  child:
                                  Image.asset('assets/entregas.png'),
                                )),
                            hTextAbel('Entregas', context, size: 60)
                          ],
                        )
                      ]),
                )),
            body: Container(
              height: getAltura(context),
              width: getLargura(context),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Positioned(
                    top: getAltura(context) * .120,
                    child: Container(
                      width: getLargura(context),
                      height: getAltura(context) * .70,
                      child: Image.asset(
                        'assets/chamada_motorista.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(top: getAltura(context)*.48, child: Image.asset('assets/localizacao.png'),),
                  Positioned(top: getAltura(context)*.16, child: Image.asset('assets/caminho.png'),),
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
                  Positioned(
                      bottom: getAltura(context) * .0,
                      child: Container(
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
                                        Row(children: <Widget>[ hTextAbel('Da sua carteira', context, size: 50, ),sb, Image.asset('assets/carteira.png') ],)
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
                                      size: 70,
                                      color: Colors.black,
                                      weight: FontWeight.bold),
                                               sb,  sb,
                                  Image.asset('assets/km.png'),
                                  sb,sb,
                                  hTextMal('2.1 Km', context,
                                      size: 70,
                                      color: Colors.black,
                                      weight: FontWeight.bold),
                                ],
                                
                              ),
                              
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
