import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Viagens/FiltroPage.dart';
import 'package:ufly/Viagens/InicioDeViagemPage/InicioDeViagemPage.dart';
import 'package:ufly/Viagens/SolicitarViagemPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
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
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != null) {
            return WillPopScope(
              onWillPop: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        shape: Border.all(),
                        title: new Text('Deseja Sair?'),
                        content: Text('Tem Certeza?'),
                        actions: <Widget>[
                          MaterialButton(
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.openSans(color: Colors.green),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          MaterialButton(
                            child: Text(
                              'Sair',
                              style: GoogleFonts.openSans(color: Colors.red),
                            ),
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                          )
                        ],
                      );
                    });
              },
              child: Scaffold(
                drawer: CustomDrawerWidget(),
                appBar: myAppBar(
                  'UFLY',
                  context,
                  size: getAltura(context) * .15,
                ),
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
                    )),*/
                body: Container(
                  height: getAltura(context),
                  width: getLargura(context),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: getAltura(context) * .020,
                            bottom: getAltura(context) * .010),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: Color.fromRGBO(248, 248, 248, 100),
                              width: getLargura(context) * .75,
                              child: Padding(
                                padding: EdgeInsets.only(),
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    expands: false,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(FontAwesomeIcons.map),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      labelText: 'Onde você está?',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          getLargura(context) * .040,
                                          getAltura(context) * .020,
                                          getLargura(context) * .040,
                                          getAltura(context) * .020),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            sb,
                            Container(
                              color: Color.fromRGBO(248, 248, 248, 100),
                              width: getLargura(context) * .75,
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                expands: false,
                                decoration: InputDecoration(
                                  suffixIcon:
                                      Icon(FontAwesomeIcons.mapMarkedAlt),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'Qual seu destino?',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      getLargura(context) * .040,
                                      getAltura(context) * .020,
                                      getLargura(context) * .040,
                                      getAltura(context) * .020),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: getLargura(context),
                        height: getAltura(context) * .35,
                        child: Image.asset(
                          'assets/mapa_inicial.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FiltroPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: getLargura(context) * .020,
                                    vertical: getAltura(context) * .025),
                                height: getLargura(context) * .40,
                                width: getLargura(context) * .40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: getLargura(context) * .2,
                                      height: getLargura(context) * .2,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: getAltura(context) * .075,
                                      ),
                                    ),
                                    hTextAbel('Procurar', context,
                                        color: Colors.white,
                                        textaling: TextAlign.center,
                                        size: 60)
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SolicitarViagemPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: getLargura(context) * .020,
                                    vertical: getAltura(context) * .025),
                                height: getLargura(context) * .40,
                                width: getLargura(context) * .40,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/julio.png'),
                                            radius: 30),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .030,
                                              left: getLargura(context) * .015),
                                          child: Container(
                                            child: hTextAbel('Júlio', context,
                                                color: Colors.white, size: 65),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: getLargura(context) * .030,
                                              top: getAltura(context) * .015),
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                                Color.fromRGBO(0, 255, 0, 10),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: getAltura(context) * .075,
                                      child: Image.asset(
                                        'assets/carro_julio.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                        child: hTextAbel(
                                            'Argo SUV 2020', context,
                                            size: 50, color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CriarCampanhaPage())); */
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: getLargura(context) * .020,
                                    vertical: getAltura(context) * .025),
                                height: getLargura(context) * .40,
                                width: getLargura(context) * .40,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/ana.png'),
                                            radius: 30),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .030,
                                              left: getLargura(context) * .015),
                                          child: Container(
                                            child: hTextAbel('Ana', context,
                                                color: Colors.white, size: 65),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: getLargura(context) * .030,
                                              top: getAltura(context) * .015),
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                                Color.fromRGBO(0, 255, 0, 10),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: getAltura(context) * .075,
                                      child: Image.asset(
                                        'assets/c3.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                        child: hTextAbel(
                                            'C3 Attraction', context,
                                            size: 50, color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CriarCampanhaPage())); */
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: getLargura(context) * .020,
                                    vertical: getAltura(context) * .025),
                                height: getLargura(context) * .40,
                                width: getLargura(context) * .40,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/pedro.png'),
                                            radius: 30),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .030,
                                              left: getLargura(context) * .015),
                                          child: Container(
                                            child: hTextAbel('Pedro', context,
                                                color: Colors.white, size: 65),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: getLargura(context) * .030,
                                              top: getAltura(context) * .015),
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                                Color.fromRGBO(0, 255, 0, 10),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: getAltura(context) * .075,
                                      child: Image.asset(
                                        'assets/fazer250.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                        child: hTextAbel('Fazer 250', context,
                                            size: 50, color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CriarCampanhaPage())); */
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(218, 218, 218, 100),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: getLargura(context) * .020,
                                    vertical: getAltura(context) * .025),
                                height: getLargura(context) * .40,
                                width: getLargura(context) * .40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: getLargura(context) * .2,
                                      width: getLargura(context) * .2,
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.black,
                                        size: getAltura(context) * .075,
                                      ),
                                    ),
                                    hTextAbel('Adicionar\na Frota', context,
                                        color: Colors.black,
                                        textaling: TextAlign.center,
                                        size: 60)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
