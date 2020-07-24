import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/Controllers/MotoristaController.dart';
import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Viagens/FiltroPage.dart';

import 'Objetos/Carro.dart';
import 'Viagens/InicioDeViagemPage/InicioDeViagemPage.dart';
import 'home_page_list.dart';

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
  ControllerFiltros cf;
  void onTap(int index) {
    pc.inPageController.add(index);
  }

  MotoristaController mt;
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

  static final h = Motorista(
      foto: 'assets/julio.png',
      nome: 'JúlianoAlmeidaSauro',
      isOnline: true,
      carro: Carro(
          foto: 'assets/carro_julio.png',
          categoria: 'Luxo',
          modelo: 'Argo SUV 2020'));
  static final n = Motorista(
      foto: 'assets/melissa.png',
      nome: 'Melissa Melissa',
      isOnline: true,
      carro: Carro(
          foto: 'assets/eco_sport.png', categoria: 'Luxo', modelo: 'Ecosport'));
  static final m = Motorista(
      foto: 'assets/melissa.png',
      nome: 'Melissa',
      isOnline: true,
      carro: Carro(
          foto: 'assets/eco_sport.png', categoria: 'Luxo', modelo: 'Ecosport'));
  List<Motorista> motoristas = [h, n, m];
  @override
  Widget build(BuildContext context) {
    if (mt == null) {
      mt = MotoristaController();
    }
    if (cf == null) {
      cf = ControllerFiltros();
    }
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
                                style:
                                    GoogleFonts.openSans(color: Colors.green),
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
                    size: ScreenUtil.getInstance().setSp(300),
                  ),
                  body: SlidingUpPanel(
                    renderPanelSheet: false,
                    minHeight: 60,
                    maxHeight: getAltura(context) * .35,
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
                    panel: _floatingPanel(),
                    body: Container(
                      height: getAltura(context),
                      width: getLargura(context),
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              StreamBuilder<bool>(
                                  stream: cf.outBool,
                                  builder: (context, snapshot) {
                                    if (cf.viagem == null) {
                                      cf.viagem = false;
                                    }

                                    if (cf.entregas == null) {
                                      cf.entregas = false;
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .020),
                                          child: GestureDetector(
                                            onTap: () {
                                              cf.entregas = false;
                                              cf.viagem = true;
                                              cf.inBool.add(snapshot.data);

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: cf.viagem == false
                                                    ? Color.fromRGBO(
                                                        218, 218, 218, 100)
                                                    : Color.fromRGBO(255, 184, 0, 30),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              height: getAltura(context) * .070,
                                              width: getLargura(context) * .4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.car,
                                                    color:  Colors.black
                                                        ,
                                                    size: 40,
                                                  ),
                                                  hTextAbel('Viagens', context,
                                                      size: 60,
                                                      weight: FontWeight.bold,
                                                      color:  Colors.black
                                                          )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .020,
                                              left: getLargura(context) * .040),
                                          child: GestureDetector(
                                            onTap: () {
                                              cf.entregas = true;
                                              cf.viagem = false;
                                              cf.inBool.add(snapshot.data);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: cf.entregas == false
                                                    ? Color.fromRGBO(
                                                        218, 218, 218, 100)
                                                    : Color.fromRGBO(255, 184, 0, 30),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              height: getAltura(context) * .070,
                                              width: getLargura(context) * .4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.rocket,
                                                    color:  Colors.black
                                                       ,
                                                    size: 30,
                                                  ),
                                                  hTextAbel('Entregas', context,
                                                      size: 60,
                                                      weight: FontWeight.bold,
                                                      color:
                                                           Colors.black
                                                              )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
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
                                      width: getLargura(context) * .85,
                                      child: Center(
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          expands: false,
                                          decoration: InputDecoration(
                                            suffixIcon:
                                                Icon(FontAwesomeIcons.map),
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
                                    sb,
                                    Container(
                                      color: Color.fromRGBO(248, 248, 248, 100),
                                      width: getLargura(context) * .85,
                                      child: TextField(
                                        style: TextStyle(color: Colors.black),
                                        expands: false,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(
                                              FontAwesomeIcons.mapMarkedAlt),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                              Expanded(
                                child: GoogleMap(mapType: MapType.normal, initialCameraPosition: CameraPosition(target: LatLng(40.712776, -74.005974),zoom: 12, ),markers: {posicao})
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          } else {
            return Container();
          }
        });
  }
  Marker posicao = Marker(
    markerId: MarkerId('posição'),
    position: LatLng(40.712776, -74.005974),
    infoWindow: InfoWindow(title: 'Mapa tester'),
    icon:     BitmapDescriptor.defaultMarker
  );
  Widget _floatingPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        StreamBuilder(
            stream: mt.outMotorista,
            builder: (context, snapshot) {
              return Container(
                width: getLargura(context),
                height: getAltura(context) * .25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ProcurarWidget();
                    } else if (index == motoristas.length + 1) {
                      return AdicionarAFrotaWidget();
                    } else {
                      return FrotaListItem(motoristas[index - 1]);
                    }
                  },
                  itemCount: motoristas.length + 2,
                ),
              );
            }),
      ],
    );
  }

  Widget AdicionarAFrotaWidget() {
    return GestureDetector(
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
        height: getLargura(context) * .37,
        width: getLargura(context) * .35,
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
                color: Colors.black, textaling: TextAlign.center, size: 60)
          ],
        ),
      ),
    );
  }

  Widget ProcurarWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FiltroPage()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: getLargura(context) * .010,
            vertical: getAltura(context) * .025),
        height: getLargura(context) * .37,
        width: getLargura(context) * .35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: getLargura(context) * .150,
              height: getLargura(context) * .2,
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: getAltura(context) * .075,
              ),
            ),
            hTextAbel('Procurar', context,
                color: Colors.white, textaling: TextAlign.center, size: 60)
          ],
        ),
      ),
    );
  }
}
