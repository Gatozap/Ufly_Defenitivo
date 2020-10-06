import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly_motorista/Controllers/Controllers.dart';
import 'package:ufly_motorista/Helpers/Helper.dart';
import 'package:ufly_motorista/Objetos/Passageiro.dart';

class HomePage extends StatefulWidget {
  Passageiro passageiro;
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  Controllers solicitacaoController;
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
    int solicitacao;
            if(solicitacaoController == null){
              solicitacaoController = Controllers();
            }
    // TODO: implement build
    return StreamBuilder<int>(
      stream: solicitacaoController.outSolicitacao,
      builder: (context, snapshot) {

        if(solicitacaoController.solicitacao == null){
          solicitacaoController.solicitacao = 0;
        }
        return Scaffold(
          body: Container(
            width: getLargura(context),
            height: getAltura(context),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(40.712776, -74.005974), zoom: 13),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {marca, marca1},
                ),
                Positioned(
                    top: 60,
                    child: GestureDetector(
                      onTap: () {
                        solicitacaoController.solicitacao++;
                        print(solicitacaoController.solicitacao);
                        solicitacaoController.inSolicitacao.add(solicitacaoController.solicitacao);

                      },
                      child: Container(
                        color: Colors.white,
                        child: hTextMal(
                          'Simular Solicitação',
                          context,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    )),


                Positioned(
                  bottom: 0,
                  child:   solicitacaoController.solicitacao != 0 ?SolicitacaoDoPassageiro(p, solicitacao): Container()
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Marker marca1 = Marker(
      markerId: MarkerId('marca 1'),
      position: LatLng(40.712360, -74.005973),
      infoWindow: InfoWindow(title: ''),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

  Marker marca = Marker(
      markerId: MarkerId('marca 1'),
      position: LatLng(40.712370, -74.005974),
      infoWindow: InfoWindow(title: 'Marca de teste'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan));

  Passageiro p = Passageiro(
      nome: 'Denis Oliveira',
      foto: 'assets/julio.png',
      viagens: 30,
      sexo: true);
   void Contador(){

     int time = 25;
     Timer timer;
         timer = Timer.periodic(Duration(seconds: 25), (timer) {
            //StreamBuilder


         });
     
   }
  Widget SolicitacaoDoPassageiro(
    Passageiro passageiro, solicitacao
  ) {

    return StreamBuilder<int>(
      stream: solicitacaoController.outSolicitacao,
      builder: (context, snapshot) {
         if(solicitacaoController.solicitacao == null){
           solicitacaoController.solicitacao = 0;
         }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: getLargura(context) * .5,
              height: getAltura(context) * .050,
              child: hTextMal('Viagem', context,
                  size: 70, textaling: TextAlign.center, weight: FontWeight.bold),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                color: Colors.white,
              ),
            ),
            Container(
              height: getAltura(context) * .50,
              width: getLargura(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: getAltura(context) * .020,
                            bottom: getAltura(context) * .010,
                            left: getLargura(context) * .040,
                            right: getLargura(context) * .030),
                        child: CircleAvatar(
                            backgroundImage: AssetImage(passageiro.foto),
                            radius: 40),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getAltura(context) * .020,
                            bottom: getAltura(context) * .010,
                            left: getLargura(context) * .040,
                            right: getLargura(context) * .030),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                hTextMal(passageiro.nome, context,
                                    size: 50, weight: FontWeight.bold),
                                sb,
                                Image.asset('assets/estrela.png'),
                                sb,
                                hTextAbel('5,0', context, size: 70),
                                sb,
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                passageiro.sexo == true
                                    ? hTextMal('Masculino', context, size: 50)
                                    : hTextMal('Feminino', context, size: 50),
                                sb,
                                Icon(
                                  MdiIcons.transitConnectionVariant,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                sb,
                                hTextMal('${passageiro.viagens} viagens', context,
                                    size: 50)
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                hTextMal('Desconhecido', context,
                                    size: 50, weight: FontWeight.bold),
                                sb,
                                Icon(
                                  Icons.memory,
                                  size: 25,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  sb,
                  Container(
                    width: getLargura(context),

                    child: Padding(
                      padding: EdgeInsets.only(left: getLargura(context) * .030,),
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(color: Colors.black),
                                        bottom: BorderSide(color: Colors.black),
                                          )),
                                  width: getLargura(context) * .30,
                                  height: getAltura(context)*.120,
                                  child: Column(
                                    children: <Widget>[
                                      hTextMal('Mercado', context,
                                          size: 60, weight: FontWeight.bold),
                                      sb,

                                      hTextMal('R\$ 44,20', context, size: 60),
                                      sb,   sb,
                                    ],
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(color: Colors.black),
                                        bottom: BorderSide(color: Colors.black),
                                          )),
                                  width: getLargura(context) * .30,
                                  height: getAltura(context)*.120,
                                  child: Column(
                                    children: <Widget>[
                                      hTextMal('Mínimo', context,
                                          size: 60, weight: FontWeight.bold),
                                      sb,

                                      hTextMal('R\$ 28,20', context, size: 60),
                                      sb,sb,
                                    ],
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.black),
                                         )),
                                  width: getLargura(context) * .35,
                                  height: getAltura(context)*.120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      hTextMal('Passageiro', context,
                                          size: 60, weight: FontWeight.bold),
                                      sb,

                                      Container(
                                        width: getLargura(context) * .32,
                                        height: getAltura(context) * .050,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          expands: false,
                                          decoration: InputDecoration(
                                                          fillColor: Colors.black,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            labelText: 'Preço',

                                            hintText: '22,22',
                                            contentPadding: EdgeInsets.fromLTRB(
                                                getLargura(context) * .040,
                                                getAltura(context) * .010,
                                                getLargura(context) * .040,
                                                getAltura(context) * .010),
                                          ),
                                        ),
                                      ),
                                        sb,
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: getLargura(context),

                    child: Padding(
                      padding: EdgeInsets.only(left: getLargura(context) * .030, ),
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(color: Colors.black),
                                        )),
                                  width: getLargura(context) * .30,
                                  height: getAltura(context)*.1,
                                  child: Column(
                                    children: <Widget>[
                                      hTextMal('Líquido', context,
                                          size: 60, weight: FontWeight.bold),
                                      hTextMal('(-25%)', context, size: 35),

                                      hTextMal('R\$ 44,20', context, size: 60),

                                    ],
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(color: Colors.black),
                                      )),
                                  width: getLargura(context) * .30,
                                  height: getAltura(context)*.1,
                                  child: Column(
                                    children: <Widget>[
                                      hTextMal('Líquido', context,
                                          size: 60, weight: FontWeight.bold),
                                      hTextMal('(-10%)', context, size: 35),

                                      hTextMal('R\$ 44,20', context, size: 60),

                                    ],
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                         )),
                                  width: getLargura(context) * .35,
                                  height: getAltura(context)*.1,
                                  child: Column(

                                    children: <Widget>[

                                      hTextMal('Recebo', context,
                                          size: 60, weight: FontWeight.bold),

                                         SizedBox(height: 6,),
                                      Container(
                                        width: getLargura(context) * .30,
                                        height: getAltura(context) * .040,
                                        decoration: BoxDecoration(border: Border.all()),
                                        child: Center(child: hTextMal('R\$ 22.35', context, size: 60, textaling: TextAlign.center))
                                      ),
                                      sb,
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          solicitacaoController.solicitacao--;
                          print(solicitacaoController.solicitacao);
                          solicitacaoController.inSolicitacao.add(solicitacaoController.solicitacao);
                        },
                        child: Container(
                            height: getAltura(context)*.090,
                            width: getLargura(context)*.350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(218, 218, 218, 100),
                            ),
                            child:
                            Center(child: hTextAbel('Rejeitar', context, size: 70,weight: FontWeight.bold))),
                      ),
                      Column(children: <Widget>[Icon(Icons.timer), hTextMal('s', context, size: 60)],),
                      GestureDetector(
                        onTap: () {
                             dToast('Você aceitou a viagem');

                             
                        },
                        child: Container(
                            height: getAltura(context)*.090,
                            width: getLargura(context)*.350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(255, 184, 0, 30),
                            ),
                            child:
                            Center(child: hTextAbel('Aceitar', context, size: 70, weight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
