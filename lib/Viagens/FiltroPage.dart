import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Viagens/MotoristaProximoPage.dart';

class FiltroPage extends StatefulWidget {
  FiltroPage({Key key}) : super(key: key);

  @override
  _FiltroPageState createState() {
    return _FiltroPageState();
  }
}

class _FiltroPageState extends State<FiltroPage> {
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
    ControllerFiltros cf;
    if (cf == null) {
      cf = ControllerFiltros();
    }
    // TODO: implement build
    return StreamBuilder<int>(
        stream: pc.outPageController,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Scaffold(
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
            appBar: myAppBar('Filtros', context,
                estiloTexto: 'BankGothic',
                size: getAltura(context) * .15,
                showBack: true),
            body: Container(     
              height: getAltura(context),
              width: getLargura(context),
              child: StreamBuilder<bool>(
                  stream: cf.outBool,
                  builder: (context, snapshot) {
                    if (cf.carros == null) {
                      cf.carros = false;
                    }
                    if (cf.moto == null) {
                      cf.moto = false;
                    }
                    if (cf.todas == null) {
                      cf.todas = false;
                    }
                    if (cf.basico == null) {
                      cf.basico = false;
                    }
                    if (cf.luxo == null) {
                      cf.luxo = false;
                    }
                    if (cf.chofer == null) {
                      cf.chofer = false;
                    }
                    if (cf.seisPassageiros == null) {
                      cf.seisPassageiros = false;
                    }
                    if (cf.portaMalasGrande == null) {
                      cf.portaMalasGrande = false;
                    }
                    if (cf.motoristaMulher == null) {
                      cf.motoristaMulher = false;
                    }
                    List<Widget> itens = new List();
                    if (cf.carros) {
                      itens.add(Padding(
                        padding:
                            EdgeInsets.only(left: getLargura(context) * .070),
                        child: GestureDetector(
                          onTap: () {
                            cf.carros = !cf.carros;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Carros', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.motoristaMulher) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.motoristaMulher = !cf.motoristaMulher;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label:
                                hTextMal('Motorista Mulher', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.luxo) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.luxo = !cf.luxo;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Conforto/Luxo', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.portaMalasGrande) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.portaMalasGrande = !cf.portaMalasGrande;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Porta Malas Grande', context,
                                size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.chofer) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.chofer = !cf.chofer;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Chofer', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.seisPassageiros) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.seisPassageiros = !cf.seisPassageiros;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('6 Passageiros', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.todas) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.todas = !cf.todas;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Todas', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.moto) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            cf.moto = !cf.moto;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Motos', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    if (cf.basico) {
                      itens.add(Padding(
                        padding:
                            EdgeInsets.only(left: getLargura(context) * .020),
                        child: GestureDetector(
                          onTap: () {
                            cf.basico = !cf.basico;
                            cf.inBool.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 0.49),
                            label: hTextMal('Básico', context, size: 60),
                            avatar: Container(
                              child: Icon(
                                MdiIcons.closeCircle,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: getAltura(context) * .015,
                              left: getLargura(context) * .020,
                              bottom: getAltura(context) * .005),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              height: getAltura(context) * .040,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: itens,
                              ),

                            ),
                          ),
                        ),
                   
                        Padding(
                          padding: EdgeInsets.only(
                            left: getLargura(context) * .040,
                            right: getLargura(context) * .020,
                          ),
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: getLargura(context) * .040,
                                      right: getLargura(context) * .020,
                                      top: getAltura(context) * .015,
                                      bottom: getAltura(context) * .010),
                                  child: hTextMal('Meio de locomoção', context,
                                      size: 60, weight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.carros == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.carros = !cf.carros;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Carros', context, size: 65),
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.moto == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.moto = !cf.moto;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Motos', context, size: 65),
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.todas == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.todas = !cf.todas;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Todas', context, size: 65),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: getLargura(context) * .040,
                                      right: getLargura(context) * .020,
                                      top: getAltura(context) * .010,
                                      bottom: getAltura(context) * .010),
                                  child: hTextMal('Categoria', context,
                                      size: 60, weight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.basico == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.basico = !cf.basico;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Básico', context, size: 65),
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.luxo == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.luxo = !cf.luxo;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Conforto/Luxo', context, size: 65),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: getLargura(context) * .040,
                                      right: getLargura(context) * .020,
                                      top: getAltura(context) * .010,
                                      bottom: getAltura(context) * .010),
                                  child: hTextMal('Comodidades', context,
                                      size: 60, weight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.portaMalasGrande == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.portaMalasGrande =
                                          !cf.portaMalasGrande;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Porta Malas Grande', context,
                                      size: 65),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.seisPassageiros == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.seisPassageiros = !cf.seisPassageiros;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('6 Passageiros', context, size: 65),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.motoristaMulher == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.motoristaMulher = !cf.motoristaMulher;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Motorista Mulher', context,
                                      size: 65),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      cf.chofer == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      cf.chofer = !cf.chofer;
                                      cf.inBool.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Chofer', context, size: 65),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getLargura(context) * .055,
                                    right: getLargura(context) * .055,
                                    top: getAltura(context) * .005,
                                    bottom: getAltura(context) * .020),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(75.0),
                                        color:
                                            Color.fromRGBO(218, 218, 218, 100)),
                                    height: getAltura(context) * .070,
                                    width: getLargura(context) * .695,
                                    child: Row(
                                      children: <Widget>[
                                        sb,
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.black,
                                          size: getAltura(context) * .060,
                                        ),
                                        sb,
                                        hTextAbel('Procurar Motorista', context),


                                        CircleAvatar(
                                          backgroundColor:
                                              Color.fromRGBO(170, 170, 170, 180),
                                          radius: 27.5,
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MotoristaProximoPage()));
                                            },
                                            icon: Icon(
                                              Icons.expand_more,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                        )
                      ],
                    );
                  }),
            ),
          );
        });
  }
}
