import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';

import '../HomePage.dart';
import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class MotoristaProximoPage extends StatefulWidget {
  MotoristaProximoPage({Key key}) : super(key: key);

  @override
  _MotoristaProximoPageState createState() {
    return _MotoristaProximoPageState();
  }
}

class _MotoristaProximoPageState extends State<MotoristaProximoPage> {
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
          appBar: myAppBar('Motoristas', context, size: getAltura(context)*.14, backgroundcolor: Color.fromRGBO(255, 184, 0, 30), actions: [
            Padding(
              padding: EdgeInsets.only(right: getLargura(context) * .025),
              child: Container(
                child: Image.asset('assets/menu.png'),
              ),
            )]),
         /* bottomNavigationBar: BottomAppBar(
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
              )),*/
          body: Container(
            width: getLargura(context),
            height: getAltura(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  sb,
                  Center(
                    child: Container(
                      height: getAltura(context) * .37,
                      width: getLargura(context) * .90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: getLargura(context)*.030),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: getAltura(context)*.020, bottom: getAltura(context)*.010),
                                      child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage('assets/danielle.png'),
                                          radius: 30),
                                    ),
                                    sb,
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          hTextAbel('Danielle', context,
                                              size: 70, color: Colors.black),
                                          sb,
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                hTextAbel('5,0', context, size: 70),
                                                Container(
                                                  child: Image.asset(
                                                      'assets/estrela.png'),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ],
                                ),
                                Container(
                                  height: getAltura(context) * .12,
                                  width: getLargura(context) * .45,
                                  child: Image.asset(
                                    'assets/eco_sport.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    hTextAbel('Ecosport 2019 | ', context,
                                        color: Colors.black, size: 60),
                                   hTextMal('Luxo', context, size: 60, weight:  FontWeight.bold)
                                  ],
                                ),


                                   Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/agua.png',

                                                ),
                                              ),
                                              hTextAbel('Água', context, size: 50)
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/balas.png',

                                                ),
                                              ),
                                              hTextAbel('Balas', context, size: 50)
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/wifi.png',

                                                ),
                                              ),
                                              hTextAbel('Wi-fi', context, size: 50)
                                            ],
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            sb,
                            Container(
                              height: getLargura(context) * .70,
                              color: Colors.black,
                              width: 2,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: getLargura(context)*.030),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(height: getAltura(context) * .060,),sb,
                                  hTextAbel('R\$ 10,00', context, size: 70),
                                  sb,

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ChamandoMotoristaPage()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(255, 184, 0, 30),
                                      ),
                                      height: getAltura(context) * .060,
                                      child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 15.0, right: 15),
                                      child: Text(
                                        'Solicitar',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'malgun',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  sb,
                  Center(
                    child: Container(
                      height: getAltura(context) * .37,
                      width: getLargura(context) * .90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: getLargura(context)*.030),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: getAltura(context)*.020, bottom: getAltura(context)*.010),
                                      child: CircleAvatar(
                                          backgroundImage:
                                          AssetImage('assets/jonatam.png'),
                                          radius: 30),
                                    ),
                                    sb,
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          hTextAbel('Jonathan', context,
                                              size: 70, color: Colors.black),
                                          sb,
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                hTextAbel('5,0', context, size: 70),
                                                Container(
                                                  child: Image.asset(
                                                      'assets/estrela.png'),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ],
                                ),
                                Container(
                                  height: getAltura(context) * .12,
                                  width: getLargura(context) * .45,
                                  child: Image.asset(
                                    'assets/argo_suv.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    hTextAbel('Argo SUV 2020 | ', context,
                                        color: Colors.black, size: 60),
                                    hTextMal('Luxo', context, size: 60, weight:  FontWeight.bold)
                                  ],
                                ),


                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/agua.png',

                                                ),
                                              ),
                                              hTextAbel('Água', context, size: 50)
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/balas.png',

                                                ),
                                              ),
                                              hTextAbel('Balas', context, size: 50)
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/wifi.png',

                                                ),
                                              ),
                                              hTextAbel('Wi-fi', context, size: 50)
                                            ],
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            sb,
                            Container(
                              height: getLargura(context) * .70,
                              color: Colors.black,
                              width: 2,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: getLargura(context)*.030),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(height: getAltura(context) * .060,),sb,
                                  hTextAbel('R\$ 10,00', context, size: 70),
                                  sb,

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ChamandoMotoristaPage()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(255, 184, 0, 30),
                                      ),
                                      height: getAltura(context) * .060,
                                      child: Center(
                                        child: Padding(
                                          padding:
                                          EdgeInsets.only(left: 15.0, right: 15),
                                          child: Text(
                                            'Solicitar',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'malgun',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),sb, Center(
                    child: Container(
                      height: getAltura(context) * .35,
                      width: getLargura(context) * .90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: getLargura(context)*.030),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: getAltura(context)*.020, bottom: getAltura(context)*.010),
                                      child: CircleAvatar(
                                          backgroundImage:
                                          AssetImage('assets/danielle.png'),
                                          radius: 30),
                                    ),
                                    sb,
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          hTextAbel('Danielle', context,
                                              size: 70, color: Colors.black),
                                          sb,
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                hTextAbel('5,0', context, size: 70),
                                                Container(
                                                  child: Image.asset(
                                                      'assets/estrela.png'),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ],
                                ),
                                Container(
                                  height: getAltura(context) * .12,
                                  width: getLargura(context) * .45,
                                  child: Image.asset(
                                    'assets/eco_sport.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    hTextAbel('Ecosport 2019 | ', context,
                                        color: Colors.black, size: 60),
                                    hTextMal('Luxo', context, size: 60, weight:  FontWeight.bold)
                                  ],
                                ),


                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/agua.png',

                                                ),
                                              ),
                                              hTextAbel('Água', context, size: 50)
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/balas.png',

                                                ),
                                              ),
                                              hTextAbel('Balas', context, size: 50)
                                            ],
                                          ),

                                        ),
                                        Container(
                                          height: getAltura(context) * .080,
                                          width: getLargura(context) * .170,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: getAltura(context)*.050,
                                                child: Image.asset(
                                                  'assets/wifi.png',

                                                ),
                                              ),
                                              hTextAbel('Wi-fi', context, size: 50)
                                            ],
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            sb,
                            Container(
                              height: getLargura(context) * .70,
                              color: Colors.black,
                              width: 2,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: getLargura(context)*.030),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(height: getAltura(context) * .060,),sb,
                                  hTextAbel('R\$ 10,00', context, size: 70),
                                  sb,

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ChamandoMotoristaPage()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(255, 184, 0, 30),
                                      ),
                                      height: getAltura(context) * .060,
                                      child: Center(
                                        child: Padding(
                                          padding:
                                          EdgeInsets.only(left: 15.0, right: 15),
                                          child: Text(
                                            'Solicitar',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'malgun',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  sb,
                ],
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(255, 190, 0, 10),

        );
      }
    );
  }
}
