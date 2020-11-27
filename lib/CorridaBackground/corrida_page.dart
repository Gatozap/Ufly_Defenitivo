import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:address_search_field/address_search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_map/flutter_map.dart' as fm;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_webservice/places.dart' as gg;

import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ufly/Ativos/AtivosController.dart';

import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:ufly/Controllers/controller_time.dart';
import 'package:ufly/CorridaBackground/corrida_controller.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';


import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Helpers/Styles.dart';

import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Motorista/motorista_controller_edit.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/User.dart';

import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Perfil/PerfilController.dart';
import 'package:ufly/Perfil/user_list_controller.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Viagens/MotoristaProximoPage.dart';
import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';
import 'package:ufly/Viagens/Requisicao/requisicao_controller.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Viagens/FiltroPage.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class CorridaPage extends StatefulWidget {
  final Position initialPosition;
  CorridaPage(this.initialPosition);

  @override
  _CorridaPageState createState() => new _CorridaPageState();
}

class _CorridaPageState extends State<CorridaPage> {
    double tempo = 25;
  var controllerPreco = new MoneyMaskedTextController(
      leftSymbol: 'R\$', decimalSeparator: '.', thousandSeparator: ',');
  final GeolocatorService geo = GeolocatorService();
  RequisicaoController rccc = RequisicaoController();
  Completer<GoogleMapController> _controller = Completer();
  RotaController rc;
  final CountdownController controller = CountdownController();
  RequisicaoCorridaController requisicaoController =
      RequisicaoCorridaController();
  ControllerFiltros cf;
  MotoristaControllerEdit mt;
  Placemark placemark;
  UserListController usc;
  Requisicao rr;
  String _currentAddress;
  String destinoAddress;
  MotoristaController motoro;
  static LatLng _initialPosition;
  static LatLng destino;
  LatLng get initialPosition => _initialPosition;
  PerfilController pf = PerfilController(Helper.localUser);
  String filtro;
  @override
  void initState() {
    bg.BackgroundGeolocation.start();
    localizacaoInicial();
    Timer(Duration(seconds: 5), () {
      geo.getCurrentLocation().listen((position) {
        telaCentralizada(position);
      });
    });


    super.initState();
  }

  AtivosController ac;
  var lastRota;
  List<fm.LayerOptions> layers;



  @override
  Widget build(BuildContext context) {

    if (rccc == null) {
      rccc = RequisicaoController();
    }

    if (rc == null) {
      rc = RotaController();
    }
    if (ac == null) {
      ac = AtivosController();
    }

    if (mt == null) {
      mt = MotoristaControllerEdit();
    }
    if (motoro == null) {
      motoro = MotoristaController();
    }
    if(cf == null){
      cf = ControllerFiltros();
    }
    var map = StreamBuilder(
      stream: rc.outPoly,
      builder: (context, snap) {
        List<Polyline> polylines = getPolys(snap.data);
        return StreamBuilder<LatLng>(
            stream: rc.outLocalizacao,
            builder: (context, localizacao) {
              if (localizacao.data == null) {
                return StreamBuilder<Position>(
                    stream: geo.getCurrentLocation(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return StreamBuilder(
                          stream: pf.outUser,
                          builder: (context, user) {
                            return GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              //polylines: polylines.toSet(),
                              mapType: MapType.normal,

                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: localizacao.data,
                                  zoom: Helper.localUser.zoom),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            );
                          });
                    });
              }
              List<Marker> markers = getMarkers(localizacao.data, destino, _initialPosition);

              return StreamBuilder(
                  stream: pf.outUser,
                  builder: (context, user) {
                    return GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      trafficEnabled: true,
                      polylines: polylines.toSet(),
                      markers: markers.toSet(),
                      mapType: MapType.terrain,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: localizacao.data,
                          zoom: Helper.localUser.zoom),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        centerView();
                      },
                    );
                  });
            });
      },
    );
    if (corridaController == null) {
      corridaController = CorridaController();
    }

    return Scaffold(
      drawer: CustomDrawerWidget(),
      appBar: myAppBar(
        '',
        context,
        actions: [  StreamBuilder<bool>(
          stream: cf.outHide,
          builder: (context, snapshot) {
            if(cf.hide == null){
              cf.hide = false;
            }
            return IconButton(
              icon: Icon(
                cf.hide == true
                    ? MdiIcons.eye
                    : MdiIcons.eyeOff,
                color: Colors.blue,
              ),
              onPressed: () {
                cf.hide = ! cf.hide;
                cf.inHide.add(snapshot.data);

              },
            );
          }
        ),]
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: StreamBuilder<Carro>(
          stream: corridaController.outCarro,
          builder: (context, carro) {

            return StreamBuilder<bool>(
                stream: corridaController.outStarted,
                builder: (context, started) {
                  return StreamBuilder<Motorista>(
                      stream: mt.outMotorista,
                      builder: (context, snap) {


                        if (snap.data == null) {
                          return Container();
                        }

                        return Container(
                            width: getLargura(context),
                            height: getAltura(context) * .060,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  carro.data == null
                                      ? Expanded(
                                          child: hText(
                                              'Não conseguimos encontrar seu carro contate o suporte',
                                              context,
                                              color: Colors.white,
                                              textaling: TextAlign.center),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            snap.data.isOnline = false;

                                            motoristaRef
                                                .doc(snap.data.id)
                                                .update(snap.data.toJson())
                                                .then((value) {

                                              return snap.data;
                                            }).catchError((err) {
                                              return null;
                                            });

                                            corridaController
                                                .finalizarCorrida();
                                          },
                                          child: hTextAbel('OFFLINE', context,
                                              size: 60,
                                              weight: FontWeight.bold,
                                              color: snap.data.isOnline == false
                                                  ? Color.fromRGBO(
                                                      255, 184, 0, 30)
                                                  : Colors.black),
                                        ),
                                  sb,
                                  sb,
                                  hTextAbel('|', context),
                                  sb,
                                  sb,
                                  GestureDetector(
                                    onTap: () async {
                                      snap.data.isOnline = true;

                                      motoristaRef
                                          .doc(snap.data.id)
                                          .update(snap.data.toJson())
                                          .then((value) {

                                        return snap.data;
                                      }).catchError((err) {
                                        return null;
                                      });
                                      corridaController.iniciarCorrida();
                                    },
                                    child: hTextAbel(
                                      'ONLINE',
                                      context,
                                      size: 60,
                                      weight: FontWeight.bold,
                                      color: snap.data.isOnline == true
                                          ? Color.fromRGBO(255, 184, 0, 30)
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      });
                });
          },
        ),
      ),
      body: StreamBuilder<List<Requisicao>>(
          stream: requisicaoController.outRequisicoes,
          builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
            return StreamBuilder<bool>(
              stream: cf.outHide,
              builder: (context, snapshot) {
                if(cf.hide == null){
                  cf.hide = false;
                }
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    map,
                    Positioned(
                      right: getLargura(context) * .080,
                      bottom: getAltura(context) * .080,
                      child: FloatingActionButton(
                        onPressed: () {
                          localizacaoInicial();
                        },
                        child: Icon(Icons.my_location, color: Colors.black),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Requisicao req = requisicao.data[index];

                        if (req.ofertas == null) {
                          if (req.motoristas_chamados
                              .contains(Helper.localUser.id)) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: getAltura(context) * .055),
                              child: cf.hide == true?Container(): SolicitacaoDoPassageiro(req),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                      itemCount: requisicao.data.length,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Requisicao req = requisicao.data[index];

                        if (req.ofertas == null) {
                          if (req.motoristas_chamados
                              .contains(Helper.localUser.id)) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: getAltura(context) * .070),
                              child: Cronometro(req),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                      itemCount: requisicao.data.length,
                    ),
                  ],
                );
              }
            );
          }),
    );
  }

  Widget Cronometro(reqController){


         return  Column(
           children: <Widget>[
             Icon(Icons.timer),
             Center(
               child: Countdown(
                 controller: controller,
                 seconds: 25,
                 build: (_, double time) => hText( time.toStringAsFixed(0), context, size: 80),
                 interval: Duration(milliseconds: 100),
                  onFinished: ()async {
                    try {
                      await requisicaoRef.doc(reqController.id).update({
                        'motoristas_chamados': FieldValue.arrayRemove(
                            ['${Helper.localUser.id}'])
                      }).then((v) {
                        print('sucesso ao tirar motorista da lista');
                      });
                    }catch (e) {
                      print(e);
                    }
                  },


    ),
             )
           ],
         );
  }


  Widget SolicitacaoDoPassageiro(requisicaoController) {
    



    print('aqui preço ${controllerPreco.text}');
    double preco_recebo = ((double.parse(controllerPreco.text
                .replaceAll(',', '')
                .replaceAll('R\$', ''))) *
            90) /
        100;

    if (usc == null) {
      usc = UserListController(requisicao: requisicaoController);
    }

    return StreamBuilder<List<User>>(
        stream: usc.outUsers,
        builder: (context, AsyncSnapshot<List<User>> user) {
          double preco_outros =
              requisicaoController.tempo_estimado < 2.00 ? 3 : 5;
          double preco_mercado =
              (preco_outros) * requisicaoController.distancia;
          double preco_mercado_liquido = ((preco_mercado) * 75) / 100;
          double preco_minimo = ((preco_mercado) * 85) / 100;
          double preco_minimo_liquido = ((preco_mercado) * 90) / 100;

          return  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<bool>(
                    stream: cf.outHide,
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () {
                          requisicao(requisicaoController);
                          centerView();
                          cf.hide =true;
                          cf.inHide.add(snapshot.data);
                        },
                        child: Container(
                          width: getLargura(context) * .5,
                          height: getAltura(context) * .050,
                          child: hTextMal(
                              requisicaoController.isViagem == true
                                  ? 'Viagem'
                                  : 'Entrega',
                              context,
                              size: 70,
                              textaling: TextAlign.center,
                              weight: FontWeight.bold),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
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
                                  backgroundImage: user.data[0].foto == null
                                      ? AssetImage('assets/logo_drawer.png')
                                      : CachedNetworkImageProvider(
                                          user.data[0].foto),
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
                                      hTextMal(
                                          requisicaoController.user_nome, context,
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
                                      user.data[0].isMale == true
                                          ? hTextMal('Masculino', context, size: 50)
                                          : hTextMal('Feminino', context, size: 50),
                                      sb,
                                      Icon(
                                        MdiIcons.transitConnectionVariant,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                      sb,
                                      //hTextMal('${passageiro.viagens} viagens', context,                                     size: 50)
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
                            padding: EdgeInsets.only(
                              left: getLargura(context) * .030,
                            ),
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
                                        height: getAltura(context) * .120,
                                        child: Column(
                                          children: <Widget>[
                                            hTextMal('Mercado', context,
                                                size: 60, weight: FontWeight.bold),
                                            sb,
                                            hTextMal(
                                                'R\$ ${preco_mercado.toStringAsFixed(2)}',
                                                context,
                                                size: 60),
                                            sb,
                                            sb,
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
                                        height: getAltura(context) * .120,
                                        child: Column(
                                          children: <Widget>[
                                            hTextMal('Mínimo', context,
                                                size: 60, weight: FontWeight.bold),
                                            sb,
                                            hTextMal(
                                                'R\$ ${preco_minimo.toStringAsFixed(2)}',
                                                context,
                                                size: 60),
                                            sb,
                                            sb,
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
                                        height: getAltura(context) * .120,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            hTextMal('Passageiro', context,
                                                size: 60, weight: FontWeight.bold),
                                            sb,
                                            Container(
                                              width: getLargura(context) * .32,
                                              height: getAltura(context) * .050,
                                              child: TextFormField(
                                                onTap: (){

                                                },
                                                controller: controllerPreco,
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
                                                  hintText: 'R\$ ',
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          getLargura(context) *
                                                              .040,
                                                          getAltura(context) * .010,
                                                          getLargura(context) *
                                                              .040,
                                                          getAltura(context) *
                                                              .010),
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
                            padding: EdgeInsets.only(
                              left: getLargura(context) * .030,
                            ),
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
                                        height: getAltura(context) * .1,
                                        child: Column(
                                          children: <Widget>[
                                            hTextMal('Líquido', context,
                                                size: 60, weight: FontWeight.bold),
                                            hTextMal('(-25%)', context, size: 35),
                                            hTextMal(
                                                'R\$ ${preco_mercado_liquido.toStringAsFixed(2)}',
                                                context,
                                                size: 60),
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
                                        height: getAltura(context) * .1,
                                        child: Column(
                                          children: <Widget>[
                                            hTextMal('Líquido', context,
                                                size: 60, weight: FontWeight.bold),
                                            hTextMal('(-10%)', context, size: 35),
                                            hTextMal(
                                                'R\$${preco_minimo_liquido.toStringAsFixed(2)}',
                                                context,
                                                size: 60),
                                          ],
                                        )),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(border: Border()),
                                        width: getLargura(context) * .35,
                                        height: getAltura(context) * .1,
                                        child: Column(
                                          children: <Widget>[
                                            hTextMal('Recebo', context,
                                                size: 60, weight: FontWeight.bold),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Container(
                                                width: getLargura(context) * .30,
                                                height: getAltura(context) * .040,
                                                decoration: BoxDecoration(
                                                    border: Border.all()),
                                                child: Center(
                                                    child: hTextMal(
                                                        'R\$ ${preco_recebo.toStringAsFixed(2)}',
                                                        context,
                                                        size: 60,
                                                        textaling:
                                                            TextAlign.center))),
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
                                      onTap: () async{
                                        try {
                     await requisicaoRef.doc(requisicaoController.id).update({
                       'motoristas_chamados': FieldValue.arrayRemove(
                           ['${Helper.localUser.id}'])
                     }).then((v) {
                       print('sucesso ao tirar motorista da lista');
                     });
                   }catch (e) {
                     print(e);
                   } 
                                      },
                                      child: Padding(
                                        padding:  EdgeInsets.only(right: 8.0),
                                        child: Container(
                                            height: getAltura(context) * .090,
                                            width: getLargura(context) * .350,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color.fromRGBO(218, 218, 218, 100),
                                            ),
                                            child: Center(
                                                child: hTextAbel('Rejeitar', context,
                                                    size: 70, weight: FontWeight.bold))),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        dToast('Você aceitou a viagem');
                                      },
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: 8.0),
                                        child: Container(
                                            height: getAltura(context) * .090,
                                            width: getLargura(context) * .350,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color.fromRGBO(255, 184, 0, 30),
                                            ),
                                            child: Center(
                                                child: hTextAbel('Aceitar', context,
                                                    size: 70, weight: FontWeight.bold))),
                                      ),
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

  centerView() async {
    final GoogleMapController controller = await _controller.future;

    await controller.getVisibleRegion();

    var left = min(_initialPosition.latitude, destino.latitude);
    var right = max(_initialPosition.latitude, destino.latitude);
    var top = max(_initialPosition.longitude, destino.longitude);
    var bottom = min(_initialPosition.longitude, destino.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
    controller.animateCamera(cameraUpdate);
  }

  Future<void> telaCentralizada(Position position) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: Helper.localUser.zoom)));
  }

  List<Polyline> getPolys(data) {
    List<Polyline> poly = new List();
    if (data == null) {
      return poly;
    }
    PolylineId id = PolylineId("poly");
    try {
      poly.add(Polyline(
        polylineId: id,
        color: Colors.red,
        points: data,
      ));
    } catch (err) {
      print(err.toString());
    }
    return poly;
  }

  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {

      telaCentralizada(v);
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
      _initialPosition = LatLng(v.latitude, v.longitude);
      List<Placemark> mark =
          await Geolocator().placemarkFromCoordinates(v.latitude, v.longitude);

      _currentAddress =
          '${mark[0].name.isNotEmpty ? mark[0].name + ', ' : ''}${mark[0].thoroughfare.isNotEmpty ? mark[0].thoroughfare + ', ' : ''}${mark[0].subLocality.isNotEmpty ? mark[0].subLocality + ', ' : ''}${mark[0].locality.isNotEmpty ? mark[0].locality + ', ' : ''}${mark[0].subAdministrativeArea.isNotEmpty ? mark[0].subAdministrativeArea + ', ' : ''}${mark[0].postalCode.isNotEmpty ? mark[0].postalCode + ', ' : ''}${mark[0].administrativeArea.isNotEmpty ? mark[0].administrativeArea : ''}';
      filtro =
          '${mark[0].subAdministrativeArea.isNotEmpty ? mark[0].subAdministrativeArea : ''}';
    });
  }

  requisicao(requisicaoController) async {
    LatLng inicial_posicao = LatLng(
        requisicaoController.origem.lat, requisicaoController.origem.lng);

    LatLng destination = LatLng(
        requisicaoController.destino.lat, requisicaoController.destino.lng);
    destino = destination;

    getMarkers(inicial_posicao, destination, _initialPosition);

    List<Placemark> mark = await Geolocator().placemarkFromCoordinates(
        requisicaoController.destino.lat, requisicaoController.destino.lng);

    Placemark place = mark[0];

    destinoAddress =
        '${place.name.isNotEmpty ? place.name + ', ' : ''}${place.thoroughfare.isNotEmpty ? place.thoroughfare + ', ' : ''}${place.subLocality.isNotEmpty ? place.subLocality + ', ' : ''}${place.locality.isNotEmpty ? place.locality + ', ' : ''}${place.subAdministrativeArea.isNotEmpty ? place.subAdministrativeArea + ', ' : ''}${place.postalCode.isNotEmpty ? place.postalCode + ', ' : ''}${place.administrativeArea.isNotEmpty ? place.administrativeArea : ''}';

    rc.CalcularRota(inicial_posicao, destination);
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

void onCameraMove(CameraPosition position, LatLng l) {
  l = position.target;
}

BitmapDescriptor sourceIcon;
List<Marker> getMarkers(LatLng data, LatLng d, LatLng motorista) {
  List<Marker> markers = new List();
  MarkerId markerId = MarkerId('id');
  MarkerId markerId2 = MarkerId('id2');
  MarkerId markerId3 = MarkerId('id3');
  try {
    markers.add(Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: data));
  } catch (err) {
    print(err.toString());
  }
  try {
    markers.add(Marker(
        markerId: markerId2,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng(d.latitude, d.longitude)));
  } catch (err) {
    print(err.toString());
  }
  try {
    markers.add(Marker(
        markerId: markerId3,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: motorista));
  } catch (err) {
    print(err.toString());
  }
  return markers;
}
