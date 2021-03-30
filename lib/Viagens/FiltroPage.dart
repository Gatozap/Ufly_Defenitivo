import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/FiltroMotorista.dart';
import 'package:ufly/Viagens/MotoristaProximoPage.dart';

class FiltroPage extends StatefulWidget {
  FiltroPage({Key key}) : super(key: key);

  @override
  _FiltroPageState createState() {
    return _FiltroPageState();
  }
}

class _FiltroPageState extends State<FiltroPage> {

  ControllerFiltros cf;




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

    //if (cf == null) {
      cf = ControllerFiltros();
   // }
    // TODO: implement build
    return Scaffold(

            appBar: myAppBar('Filtros', context,                                size: 100,                 showBack: true),
            body: Container(     
              height: getAltura(context),
              width: getLargura(context),
              child: StreamBuilder<FiltroMotorista>(
                  stream: cf.outFiltro,
                  builder: (context, snapshot) {
                    if(snapshot.data == null){
                      return Container();
                    }

                    List<Widget> itens = [];
                    if (snapshot.data.isCarro) {
                      itens.add(Padding(
                        padding:
                            EdgeInsets.only(left: getLargura(context) * .070),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.isCarro = !snapshot.data.isCarro;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.motoristaMulher) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.motoristaMulher = !snapshot.data.motoristaMulher;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.luxo) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.luxo = !snapshot.data.luxo;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.portaMalasGrande) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.portaMalasGrande = !snapshot.data.portaMalasGrande;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.chofer) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.chofer = !snapshot.data.chofer;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .035,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.seisPassageiros) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.seisPassageiros = !snapshot.data.seisPassageiros;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.todas) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.todas = !snapshot.data.todas;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.isMoto) {
                      itens.add(Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.isMoto = !snapshot.data.isMoto;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                    if (snapshot.data.basico) {
                      itens.add(Padding(
                        padding:
                            EdgeInsets.only(left: getLargura(context) * .020),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.basico = !snapshot.data.basico;
                            cf.inFiltro.add(snapshot.data);
                          },
                          child: Chip(
                            padding: EdgeInsets.only(
                                bottom: getAltura(context) * .020,
                                left: getLargura(context) * .025,
                                right: getLargura(context) * .025),
                            backgroundColor: Color.fromRGBO(255, 184, 0, 30),
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
                                      snapshot.data.isCarro == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.isCarro = !snapshot.data.isCarro;
                                      cf.inFiltro.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Carros', context, size: 65),
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      snapshot.data.isMoto == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.isMoto = !snapshot.data.isMoto;
                                      cf.inFiltro.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Motos', context, size: 65),
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      snapshot.data.todas == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.todas = !snapshot.data.todas;
                                      cf.inFiltro.add(snapshot.data);
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
                                      snapshot.data.basico == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.basico = !snapshot.data.basico;
                                      cf.inFiltro.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Básico', context, size: 65),
                                  IconButton(
                                    iconSize: getAltura(context) * .050,
                                    icon: Icon(
                                      snapshot.data.luxo == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.luxo = !snapshot.data.luxo;
                                      cf.inFiltro.add(snapshot.data);
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
                                      snapshot.data.portaMalasGrande == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.portaMalasGrande =
                                          !snapshot.data.portaMalasGrande;
                                      cf.inFiltro.add(snapshot.data);
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
                                      snapshot.data.seisPassageiros == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.seisPassageiros = !snapshot.data.seisPassageiros;
                                      cf.inFiltro.add(snapshot.data);
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
                                      snapshot.data.motoristaMulher == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.motoristaMulher = !snapshot.data.motoristaMulher;
                                      cf.inFiltro.add(snapshot.data);
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
                                      snapshot.data.chofer == false
                                          ? Icons.add_circle_outline
                                          : MdiIcons.checkboxMarkedCircle,
                                      color: Color.fromRGBO(255, 184, 0, 30),
                                    ),
                                    onPressed: () {
                                      snapshot.data.chofer = !snapshot.data.chofer;
                                      cf.inFiltro.add(snapshot.data);
                                    },
                                  ),
                                  hTextAbel('Chofer', context, size: 65),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getLargura(context) * .055,
                                    right: getLargura(context) * .055,
                                    top: getAltura(context) * .040,
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

  }
}
