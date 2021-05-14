import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:ufly/Ativos/AtivosController.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:ufly/CorridaBackground/corrida_controller.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Motorista/motorista_controller_edit.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/User.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Perfil/PerfilController.dart';
import 'package:ufly/Perfil/user_list_controller.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Viagens/InicioDeViagemPage/InicioDeViagemPage.dart';

import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';

import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Viagens/Requisicao/criar_requisicao_controller.dart';

class CorridaPage extends StatefulWidget {
  CorridaPage();

  @override
  _CorridaPageState createState() => new _CorridaPageState();
}

class _CorridaPageState extends State<CorridaPage> {
  double tempo = 25;

  var controllerPreco = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',');
  final GeolocatorService geo = GeolocatorService();

  Completer<GoogleMapController> _controller = Completer();
  RotaController rc;
  final CountdownController controller = CountdownController();
  RequisicaoCorridaController requisicaoController =
      RequisicaoCorridaController();
  var color_green = Colors.green;
  var color_red = Colors.red;
  CriarRequisicaoController criaRc;
  ControllerFiltros cf;
  MotoristaControllerEdit mt;
  Placemark placemark;
  bool online;
  OfertaCorridaController ofertaCorridaController;
  UserListController usc;
  Requisicao rr;
  List<LatLng> marcasRota = [];
  String _currentAddress;
  bool viagemAceita;
  bool viagemRecusada;
  List<Polyline> polylines;
  LatLng motorista_latlng;
  String destinoAddress;
  BitmapDescriptor myIcon;

  List<Marker> markers;
  var requisicao;
  bool possuiChamadaViagem;
  List<LatLng> polylineCoordinates = [];
  MotoristaController motoro;
  static LatLng _initialPosition;
  static LatLng destino;
  static LatLng passageiro_latlng;
  LatLng parada1;
  LatLng parada2;
  LatLng parada3;
  String nome;
  String foto;
  String destinoPassageiro;
  String origemPassageiro;
  LatLng get initialPosition => _initialPosition;
  PerfilController pf = PerfilController(Helper.localUser);
  String filtro;
  @override
  void initState() {
    bg.BackgroundGeolocation.start();

    localizacaoInicial();
    iniciarCorridaPage();


    super.initState();
  }
  iniciarCorridaPage() async {
    if (corridaController == null) {
      corridaController = CorridaController();
    }
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/marker.png');

    bg.BackgroundGeolocation.start();
    geo.getCurrentLocation().listen((position) {
      telaCentralizada(position);
    });
  }

  AtivosController ac;
  var lastRota;

  @override
  Widget build(BuildContext context) {
    if (online == null) {
      online = false;
    }
    if (criaRc == null) {
      criaRc = CriarRequisicaoController();
    }
    if (possuiChamadaViagem == null) {
      possuiChamadaViagem = false;
    }
    if (viagemRecusada == null) {
      viagemRecusada = false;
    }
    if (viagemAceita == null) {
      viagemAceita = false;
    }
    chamadaMotoristaAceita();
    ResponsivePixelHandler.init(
      baseWidth: 360, //A largura usado pelo designer no modelo desenhado
    );
    localizacaoInicial();
    if (requisicaoController == null) {
      requisicaoController = RequisicaoCorridaController();
    }
    if (corridaController == null) {
      corridaController = CorridaController();
    }
    if (rc == null) {
      rc = RotaController();
    }

    if (ac == null) {
      ac = AtivosController();
    }
    if (ofertaCorridaController == null) {
      ofertaCorridaController = OfertaCorridaController();
    }
    if (mt == null) {
      mt = MotoristaControllerEdit();
    }
    if (motoro == null) {
      motoro = MotoristaController();
    }
    if (cf == null) {
      cf = ControllerFiltros();
    }

    var map = StreamBuilder(
        stream: rc.outPolyMotorista,
        builder: (context, snapMotorista) {
          return StreamBuilder(
            stream: rc.outPolyPassageiro,
            builder: (context, snapPassageiro) {
              polylines = getPolys(snapMotorista.data, snapPassageiro.data);
              return StreamBuilder<LatLng>(
                  stream: rc.outLocalizacao,
                  builder: (context, localizacao) {
                    if (localizacao.data == null) {
                      return StreamBuilder<Position>(
                          stream: localizacaoInicial(),
                          builder: (context, snapshot) {
                            print('aqui position ${snapMotorista.data}');
                            if (!snapshot.hasData) {
                              return localizacaoInicial();
                            }
                            return GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              //polylines: polylines.toSet(),
                              mapType: MapType.normal,
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              rotateGesturesEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: _initialPosition,
                                  zoom: Helper.localUser.zoom),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                centerView();
                              },
                            );
                          });
                    }

                    return StreamBuilder(
                        stream: rc.outWays,
                        builder: (context, snapshot) {
                          return StreamBuilder(
                              stream: rc.outMarkers,
                              builder: (context, snap) {
                                print('aqui snap 232 ${snap.data}');
                                if (snapshot.data != null) {
                                  if (parada1 == null) {
                                    markers = getMarkers(snap.data, online);
                                  } else {
                                    markers = getMarkers(
                                      snap.data,
                                      online,
                                      ways: snapshot.data,
                                    );
                                  }
                                }
                                return GoogleMap(
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  trafficEnabled: true,
                                  polylines: polylines.toSet(),
                                  markers: markers == null
                                      ? <Marker>[].toSet()
                                      : markers.toSet(),
                                  mapType: MapType.terrain,
                                  zoomGesturesEnabled: true,
                                  zoomControlsEnabled: false,
                                  rotateGesturesEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                      target: localizacao.data,
                                      zoom: Helper.localUser.zoom),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                    destino == null ? null : centerView();
                                    geo.getCurrentLocation().listen((position) {
                                      telaCentralizada(position);
                                    });
                                  },
                                );
                              });
                        });
                  });
            },
          );
        });

    return StreamBuilder<List<Requisicao>>(
        stream: requisicaoController.outRequisicoes,
        builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
          Future.delayed(Duration(seconds: 3));
          if (requisicao.data == null) {
            for (var req in requisicao.data) {
              return Scaffold(
                drawer: CustomDrawerWidget(),
                appBar: myAppBar('', context, actions: [
                  StreamBuilder<bool>(
                      stream: cf.outHide,
                      builder: (context, snapshot) {
                        if (cf.hide == null) {
                          cf.hide = false;
                        }
                        return IconButton(
                          icon: Icon(
                            cf.hide == true ? MdiIcons.eyeOff : MdiIcons.eye,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            cf.hide = !cf.hide;
                            cf.inHide.add(snapshot.data);
                          },
                        );
                      }),
                ]),
                bottomSheet: Container(
                  color: Colors.white,
                  child: StreamBuilder<Carro>(
                    stream: corridaController.outCarro,
                    builder: (context, carro) {
                      if (requisicao.data == null || requisicao.data.isEmpty) {
                        return StreamBuilder<bool>(
                            stream: corridaController.outStarted,
                            builder: (context, started) {
                              return Container(
                                width: getLargura(context),
                                height: getAltura(context) * .060,
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
                                            onTap: () async {
                                              online = false;
                                              print('aqui bool ${online}');
                                              corridaController
                                                  .finalizarCorrida();
                                            },
                                            child: hTextAbel('OFFLINE', context,
                                                size: 20,
                                                weight: FontWeight.bold,
                                                color: started.data == false
                                                    ? Color.fromRGBO(
                                                        255, 184, 0, 30)
                                                    : Colors.black),
                                          ),
                                    sb,
                                    sb,
                                    hTextAbel('|', context, size: 20),
                                    sb,
                                    sb,
                                    GestureDetector(
                                      onTap: () async {
                                        online = true;
                                        print('aqui bool ${online}');
                                        corridaController.iniciarCorrida();
                                      },
                                      child: hTextAbel(
                                        'ONLINE',
                                        context,
                                        size: 20,
                                        weight: FontWeight.bold,
                                        color: started.data == true
                                            ? Color.fromRGBO(255, 184, 0, 30)
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return StreamBuilder<bool>(
                            stream: corridaController.outStarted,
                            builder: (context, started) {
                              return Container(
                                  width: getLargura(context),
                                  height: getAltura(context) * .060,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: req.motoristas_chamados
                                            .contains(Helper.localUser.id)
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              carro.data == null
                                                  ? Expanded(
                                                      child: hText(
                                                          'Não conseguimos encontrar seu carro contate o suporte',
                                                          context,
                                                          color: Colors.white,
                                                          textaling:
                                                              TextAlign.center),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        online = false;
                                                        print(
                                                            'aqui bool ${online}');
                                                        corridaController
                                                            .finalizarCorrida();
                                                      },
                                                      child: hTextAbel(
                                                          'OFFLINE', context,
                                                          size: 20,
                                                          weight:
                                                              FontWeight.bold,
                                                          color: started.data ==
                                                                  false
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  184,
                                                                  0,
                                                                  30)
                                                              : Colors.black),
                                                    ),
                                              sb,
                                              sb,
                                              hTextAbel('|', context, size: 20),
                                              sb,
                                              sb,
                                              GestureDetector(
                                                onTap: () async {
                                                  online = true;
                                                  print('aqui bool ${online}');
                                                  corridaController
                                                      .iniciarCorrida();
                                                },
                                                child: hTextAbel(
                                                  'ONLINE',
                                                  context,
                                                  size: 20,
                                                  weight: FontWeight.bold,
                                                  color: started.data == true
                                                      ? Color.fromRGBO(
                                                          255, 184, 0, 30)
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ));
                            });
                      }
                    },
                  ),
                ),
                body: StreamBuilder<bool>(
                    stream: cf.outHide,
                    builder: (context, hide) {
                      if (cf.hide == null) {
                        cf.hide = false;
                      }

                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          map,
                          Positioned(
                            bottom: getLargura(context) * .250,
                            right: getAltura(context) * .025,
                            child: FloatingActionButton(
                              onPressed: () {
                                localizacaoInicial();
                              },
                              child:
                                  Icon(Icons.my_location, color: Colors.black),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          IgnorePointer(
                            ignoring: cf.hide,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Requisicao req = requisicao.data[index];

                                if (req == null) {
                                  return map;
                                } else if (req.aceito == null) {
                                  if (req.motoristas_chamados
                                      .contains(Helper.localUser.id)) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: getAltura(context) * .045),
                                        child: SolicitacaoDoPassageiro(
                                            req, cf.hide));
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                              itemCount: requisicao.data.length,
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
          } else
            for (var req in requisicao.data) {
              if (req.aceito == null) {
                if (req.envioPassageiro != null) {
                  if (req.envioPassageiro.contains(Helper.localUser.id)) {
                    possuiChamadaViagem = true;
                    if (usc == null) {
                      usc = UserListController(requisicao: req);
                    }
                    return StreamBuilder<List<User>>(
                        stream: usc.outUsers,
                        // ignore: missing_return
                        builder: (context, AsyncSnapshot<List<User>> user) {
                          for (var us in user.data) {
                            nome = us.nome;
                            if (req.user == us.id) {


                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      child: hTextAbel(
                                          'Solicitação de viagem', context,
                                          size: 20),
                                    ),
                                    sb,
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundImage: user
                                                        .data[0].foto ==
                                                    null
                                                ? AssetImage(
                                                    'assets/logo_drawer.png')
                                                : CachedNetworkImageProvider(
                                                    user.data[0].foto),
                                            radius: 35),
                                        sb,
                                        hTextAbel('${nome}', context, size: 20),
                                      ],
                                    ),
                                    sb,
                                    sb,
                                    Wrap(
                                      children: [
                                        hTextAbel(
                                            'Embarque: ${req.origem.endereco}',
                                            context,
                                            size: 20),
                                      ],
                                    ),
                                    sb,
                                    Wrap(
                                      children: [
                                        hTextAbel(
                                            'Desembarque: ${req.destino.endereco}',
                                            context,
                                            size: 20),
                                      ],
                                    ),
                                    sb,
                                    sb,
                                    sb,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            try {
                                              await requisicaoRef
                                                  .doc(req.id)
                                                  .update({
                                                'envioPassageiro':
                                                    FieldValue.arrayRemove([
                                                  '${Helper.localUser.id}'
                                                ])
                                              }).then((v) {
                                                print(
                                                    'sucesso ao tirar motorista da lista');
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Container(
                                            height: getAltura(context) * .050,
                                            width: getLargura(context) * .3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFf6aa3c),
                                            ),
                                            child: Container(
                                                height:
                                                    getAltura(context) * .125,
                                                width:
                                                    getLargura(context) * .85,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color.fromRGBO(
                                                      255, 184, 0, 30),
                                                ),
                                                child: Center(
                                                    child: hTextAbel(
                                                        'Cancelar', context,
                                                        size: 20))),
                                          ),
                                        ),
                                        sb,
                                        GestureDetector(
                                          onTap: () async {
                                            try {
                                              await requisicaoRef
                                                  .doc(req.id)
                                                  .update({
                                                'envioPassageiro':
                                                    FieldValue.arrayRemove([
                                                  '${Helper.localUser.id}'
                                                ])
                                              }).then((v) async {
                                                try {
                                                  await requisicaoRef
                                                      .doc(req.id)
                                                      .update({
                                                    'motorista_aceitou':
                                                        FieldValue.arrayUnion(
                                                            ['${us.id}'])

                                                  });
                                                  await requisicaoRef
                                                      .doc(req.id)
                                                      .update({
                                                    'cancelou':
                                                    FieldValue.arrayUnion(
                                                        ['${us.id}'])
                                                  });
                                                } catch (e) {
                                                  print(e);
                                                }
                                              });

                                              print(
                                                  'aqui a porra do req ${req.envioPassageiro}');
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Container(
                                            height: getAltura(context) * .050,
                                            width: getLargura(context) * .3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFf6aa3c),
                                            ),
                                            child: Container(
                                                height:
                                                    getAltura(context) * .125,
                                                width:
                                                    getLargura(context) * .85,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color.fromRGBO(
                                                      255, 184, 0, 30),
                                                ),
                                                child: Center(
                                                    child: hTextAbel(
                                                        'Aceitar', context,
                                                        size: 20))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            print('aqui usuario 3213 ${nome}');
                            print('aqui usuario 3213 ');
                          }
                        });
                  }
                } else {
                  return Scaffold(
                    drawer: CustomDrawerWidget(),
                    appBar: myAppBar('', context, actions: [
                      StreamBuilder<bool>(
                          stream: cf.outHide,
                          builder: (context, snapshot) {
                            if (cf.hide == null) {
                              cf.hide = false;
                            }
                            return IconButton(
                              icon: Icon(
                                cf.hide == true
                                    ? MdiIcons.eyeOff
                                    : MdiIcons.eye,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                cf.hide = !cf.hide;
                                cf.inHide.add(snapshot.data);
                              },
                            );
                          }),
                    ]),
                    bottomSheet: Container(
                      color: Colors.white,
                      child: StreamBuilder<Carro>(
                        stream: corridaController.outCarro,
                        builder: (context, carro) {
                          if (requisicao.data == null ||
                              requisicao.data.isEmpty) {
                            return StreamBuilder<bool>(
                                stream: corridaController.outStarted,
                                builder: (context, started) {
                                  return Container(
                                    width: getLargura(context),
                                    height: getAltura(context) * .060,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        carro.data == null
                                            ? Expanded(
                                                child: hText(
                                                    'Não conseguimos encontrar seu carro contate o suporte',
                                                    context,
                                                    color: Colors.white,
                                                    textaling:
                                                        TextAlign.center),
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  corridaController
                                                      .finalizarCorrida();
                                                },
                                                child: hTextAbel(
                                                    'OFFLINE', context,
                                                    size: 20,
                                                    weight: FontWeight.bold,
                                                    color: started.data == false
                                                        ? Color.fromRGBO(
                                                            255, 184, 0, 30)
                                                        : Colors.black),
                                              ),
                                        sb,
                                        sb,
                                        hTextAbel('|', context, size: 20),
                                        sb,
                                        sb,
                                        GestureDetector(
                                          onTap: () async {
                                            corridaController.iniciarCorrida();
                                          },
                                          child: hTextAbel(
                                            'ONLINE',
                                            context,
                                            size: 20,
                                            weight: FontWeight.bold,
                                            color: started.data == true
                                                ? Color.fromRGBO(
                                                    255, 184, 0, 30)
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return StreamBuilder<bool>(
                                stream: corridaController.outStarted,
                                builder: (context, started) {
                                  return Container(
                                      width: getLargura(context),
                                      height: getAltura(context) * .060,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: req.motoristas_chamados
                                                .contains(Helper.localUser.id)
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  carro.data == null
                                                      ? Expanded(
                                                          child: hText(
                                                              'Não conseguimos encontrar seu carro contate o suporte',
                                                              context,
                                                              color:
                                                                  Colors.white,
                                                              textaling:
                                                                  TextAlign
                                                                      .center),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            corridaController
                                                                .finalizarCorrida();
                                                          },
                                                          child: hTextAbel(
                                                              'OFFLINE', context,
                                                              size: 20,
                                                              weight: FontWeight
                                                                  .bold,
                                                              color: started
                                                                          .data ==
                                                                      false
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          184,
                                                                          0,
                                                                          30)
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                  sb,
                                                  sb,
                                                  hTextAbel('|', context,
                                                      size: 20),
                                                  sb,
                                                  sb,
                                                  GestureDetector(
                                                    onTap: () async {
                                                      corridaController
                                                          .iniciarCorrida();
                                                    },
                                                    child: hTextAbel(
                                                      'ONLINE',
                                                      context,
                                                      size: 20,
                                                      weight: FontWeight.bold,
                                                      color: started.data ==
                                                              true
                                                          ? Color.fromRGBO(
                                                              255, 184, 0, 30)
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ));
                                });
                          }
                        },
                      ),
                    ),
                    body: StreamBuilder<bool>(
                        stream: cf.outHide,
                        builder: (context, hide) {
                          if (cf.hide == null) {
                            cf.hide = false;
                          }

                          return Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              map,
                              Positioned(
                                bottom: getLargura(context) * .250,
                                right: getAltura(context) * .025,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    localizacaoInicial();
                                  },
                                  child: Icon(Icons.my_location,
                                      color: Colors.black),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              IgnorePointer(
                                ignoring: cf.hide,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Requisicao req = requisicao.data[index];

                                    if (req == null) {
                                      return map;
                                    } else if (req.aceito == null) {
                                      if (req.motoristas_chamados
                                          .contains(Helper.localUser.id)) {
                                        return Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    getAltura(context) * .045),
                                            child: SolicitacaoDoPassageiro(
                                                req, cf.hide));
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                  itemCount: requisicao.data.length,
                                ),
                              ),
                            ],
                          );
                        }),
                  );
                }
              } else if (req.aceito.motorista == Helper.localUser.id &&
                  req.deleted_at == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InicioDeViagemPage()));
                });
              }
            }
          {
            return Scaffold(
              drawer: CustomDrawerWidget(),
              appBar: myAppBar('', context, actions: [
                StreamBuilder<bool>(
                    stream: cf.outHide,
                    builder: (context, snapshot) {
                      if (cf.hide == null) {
                        cf.hide = false;
                      }
                      return IconButton(
                        icon: Icon(
                          cf.hide == true ? MdiIcons.eyeOff : MdiIcons.eye,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          cf.hide = !cf.hide;
                          cf.inHide.add(snapshot.data);
                        },
                      );
                    }),
              ]),
              bottomSheet: Container(
                color: Colors.white,
                child: StreamBuilder<Carro>(
                  stream: corridaController.outCarro,
                  builder: (context, carro) {
                    return StreamBuilder<List<Requisicao>>(
                        stream: requisicaoController.outRequisicoes,
                        builder: (context,
                            AsyncSnapshot<List<Requisicao>> requisicao) {
                          if (requisicao.data == null ||
                              requisicao.data.isEmpty) {
                            return StreamBuilder<bool>(
                                stream: corridaController.outStarted,
                                builder: (context, started) {
                                  return Container(
                                    width: getLargura(context),
                                    height: getAltura(context) * .060,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        carro.data == null
                                            ? Expanded(
                                                child: hText(
                                                    'Não conseguimos encontrar seu carro contate o suporte',
                                                    context,
                                                    color: Colors.white,
                                                    textaling:
                                                        TextAlign.center),
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  corridaController
                                                      .finalizarCorrida();
                                                },
                                                child: hTextAbel(
                                                    'OFFLINE', context,
                                                    size: 20,
                                                    weight: FontWeight.bold,
                                                    color: started.data == false
                                                        ? Color.fromRGBO(
                                                            255, 184, 0, 30)
                                                        : Colors.black),
                                              ),
                                        sb,
                                        sb,
                                        hTextAbel('|', context, size: 20),
                                        sb,
                                        sb,
                                        GestureDetector(
                                          onTap: () async {
                                            corridaController.iniciarCorrida();
                                          },
                                          child: hTextAbel(
                                            'ONLINE',
                                            context,
                                            size: 20,
                                            weight: FontWeight.bold,
                                            color: started.data == true
                                                ? Color.fromRGBO(
                                                    255, 184, 0, 30)
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            for (Requisicao i in requisicao.data) {
                              return StreamBuilder<bool>(
                                  stream: corridaController.outStarted,
                                  builder: (context, started) {
                                    return Container(
                                        width: getLargura(context),
                                        height: getAltura(context) * .060,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: i.motoristas_chamados
                                                  .contains(Helper.localUser.id)
                                              ? Container()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    carro.data == null
                                                        ? Expanded(
                                                            child: hText(
                                                                'Não conseguimos encontrar seu carro contate o suporte',
                                                                context,
                                                                color: Colors
                                                                    .white,
                                                                textaling:
                                                                    TextAlign
                                                                        .center),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () async {
                                                              corridaController
                                                                  .finalizarCorrida();
                                                            },
                                                            child: hTextAbel(
                                                                'OFFLINE', context,
                                                                size: 20,
                                                                weight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: started
                                                                            .data ==
                                                                        false
                                                                    ? Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            184,
                                                                            0,
                                                                            30)
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                    sb,
                                                    sb,
                                                    hTextAbel('|', context,
                                                        size: 20),
                                                    sb,
                                                    sb,
                                                    GestureDetector(
                                                      onTap: () async {
                                                        corridaController
                                                            .iniciarCorrida();
                                                      },
                                                      child: hTextAbel(
                                                        'ONLINE',
                                                        context,
                                                        size: 20,
                                                        weight: FontWeight.bold,
                                                        color: started.data ==
                                                                true
                                                            ? Color.fromRGBO(
                                                                255, 184, 0, 30)
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ));
                                  });
                            }
                          }
                        });
                  },
                ),
              ),
              body: StreamBuilder<bool>(
                  stream: cf.outHide,
                  builder: (context, hide) {
                    if (cf.hide == null) {
                      cf.hide = false;
                    }

                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        map,
                        Positioned(
                          bottom: getLargura(context) * .250,
                          right: getAltura(context) * .025,
                          child: FloatingActionButton(
                            onPressed: () {
                              localizacaoInicial();
                            },
                            child: Icon(Icons.my_location, color: Colors.black),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        StreamBuilder<List<Requisicao>>(
                            stream: requisicaoController.outRequisicoes,
                            builder: (context,
                                AsyncSnapshot<List<Requisicao>> requisicao) {
                              return IgnorePointer(
                                ignoring: cf.hide,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Requisicao req = requisicao.data[index];

                                    if (req == null) {
                                      return map;
                                    } else if (req.aceito == null) {
                                      if (req.motoristas_chamados
                                          .contains(Helper.localUser.id)) {
                                        return Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    getAltura(context) * .045),
                                            child: SolicitacaoDoPassageiro(
                                                req, cf.hide));
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                  itemCount: requisicao.data.length,
                                ),
                              );
                            }),
                      ],
                    );
                  }),
            );
          }
        });
  }

  Widget SolicitacaoDoPassageiro(requisicaoController, hide) {
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

          return Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
                color: Colors.transparent.withOpacity(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    hide == true
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              rotaPassageiro(requisicaoController);
                              cf.hide = true;
                              cf.inHide.add(cf.hide);
                              Timer(Duration(seconds: 5), () {
                                centerView();
                              });
                            },
                            child: Container(
                              width: getLargura(context) * .5,
                              height: getAltura(context) * .050,
                              child: hTextMal(
                                  requisicaoController.isViagem == true
                                      ? 'Viagem'
                                      : 'Entrega',
                                  context,
                                  size: 25,
                                  textaling: TextAlign.center,
                                  weight: FontWeight.bold,
                                  color: hide == true
                                      ? Colors.transparent.withOpacity(0.0)
                                      : Colors.black),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                color: hide == true
                                    ? Colors.transparent.withOpacity(0.0)
                                    : Colors.white,
                              ),
                            ),
                          ),
                    Container(
                      height: getAltura(context) * .42,
                      width: getLargura(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: hide == true
                            ? Colors.transparent.withOpacity(0.0)
                            : Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: ResponsivePixelHandler.toPixel(
                                        15, context),
                                    bottom: ResponsivePixelHandler.toPixel(
                                        5, context),
                                    left: ResponsivePixelHandler.toPixel(
                                        10, context),
                                    right: ResponsivePixelHandler.toPixel(
                                        10, context)),
                                child: hide == true
                                    ? Container()
                                    : CircleAvatar(
                                        backgroundImage:
                                            user.data[0].foto == null
                                                ? AssetImage(
                                                    'assets/logo_drawer.png')
                                                : CachedNetworkImageProvider(
                                                    user.data[0].foto),
                                        radius: 40),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: ResponsivePixelHandler.toPixel(
                                        15, context),
                                    bottom: ResponsivePixelHandler.toPixel(
                                        5, context),
                                    left: ResponsivePixelHandler.toPixel(
                                        10, context),
                                    right: ResponsivePixelHandler.toPixel(
                                        10, context)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        hTextMal(requisicaoController.user_nome,
                                            context,
                                            size: 20,
                                            weight: FontWeight.bold,
                                            color: hide == true
                                                ? Colors.transparent
                                                    .withOpacity(0.0)
                                                : Colors.black),
                                        sb,
                                        hide == true
                                            ? Container()
                                            : Image.asset('assets/estrela.png'),
                                        sb,
                                        hTextAbel('5,0', context,
                                            size: 20,
                                            color: hide == true
                                                ? Colors.transparent
                                                    .withOpacity(0.0)
                                                : Colors.black),
                                        sb,
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        user.data[0].isMale == true
                                            ? hTextMal('Masculino', context,
                                                size: 20,
                                                color: hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black)
                                            : hTextMal('Feminino', context,
                                                size: 20,
                                                color: hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black),
                                        sb,
                                        hide == true
                                            ? Container()
                                            : Icon(
                                                MdiIcons
                                                    .transitConnectionVariant,
                                                size: 30,
                                                color: Colors.blue,
                                              ),

                                        sb,

                                        //hTextMal('${passageiro.viagens} viagens', context,                                     size: 50)
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        hTextMal(
                                            '${requisicaoController.forma_de_pagamento.toLowerCase()}',
                                            context,
                                            size: 20,
                                            weight: FontWeight.bold,
                                            color: hide == true
                                                ? Colors.transparent
                                                    .withOpacity(0.0)
                                                : Colors.black),
                                        hide = true
                                            ? Container()
                                            : Icon(
                                                Icons.memory,
                                                size: 25,
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              cronometro(context, cf.hide, requisicaoController)
                            
                            ],
                          ),
                          sb,
                          Container(
                            width: getLargura(context),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left:
                                    ResponsivePixelHandler.toPixel(5, context),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                            right: BorderSide(
                                                color: cf.hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black),
                                            bottom: BorderSide(
                                                color: cf.hide == true
                                                    ? Colors.transparent
                                                        .withOpacity(0.0)
                                                    : Colors.black),
                                          )),
                                          width: getLargura(context) * .30,
                                          height: getAltura(context) * .130,
                                          child: Column(
                                            children: <Widget>[
                                              cf.hide == true
                                                  ? Container()
                                                  : hTextMal('Mercado', context,
                                                      size: 20,
                                                      weight: FontWeight.bold,
                                                      color: Colors.black),
                                              sb,
                                              cf.hide == true
                                                  ? Container()
                                                  : hTextMal(
                                                      'R\$ ${preco_mercado.toStringAsFixed(2)}',
                                                      context,
                                                      size: 20,
                                                      color: cf.hide == true
                                                          ? Colors.transparent
                                                              .withOpacity(0.0)
                                                          : Colors.black),
                                              sb,
                                              sb,
                                            ],
                                          )),
                                    ],
                                  ),
                                  cf.hide == true
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  right: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                )),
                                                width:
                                                    getLargura(context) * .30,
                                                height:
                                                    getAltura(context) * .130,
                                                child:
                                                Column(
                                                  children: <Widget>[
                                                    hTextMal(
                                                      'Recebo',
                                                      context,
                                                      size: 20,
                                                      weight: FontWeight.bold,
                                                    ),
                                                    sb,
                                                    hTextMal(
                                                        'R\$ ${preco_recebo.toStringAsFixed(2)}',
                                                        context,
                                                        size: 20,
                                                        textaling:
                                                        TextAlign
                                                            .center),
                                                    sb,
                                                    sb,
                                                  ],
                                                )),
                                          ],
                                        ),
                                  cf.hide == true
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  bottom: BorderSide(
                                                      color: hide == true
                                                          ? Colors.transparent
                                                              .withOpacity(0.0)
                                                          : Colors.black),
                                                )),
                                                width:
                                                    getLargura(context) * .35,
                                                height:
                                                    getAltura(context) * .130,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    hTextMal(
                                                        'Passageiro', context,
                                                        size: 20,
                                                        weight: FontWeight.bold,
                                                        color: Colors.black),
                                                    sb,
                                                    hide == true
                                                        ? Container()
                                                        : Container(
                                                            width: getLargura(
                                                                    context) *
                                                                .32,
                                                            height: getAltura(
                                                                    context) *
                                                                .060,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  controllerPreco,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              expands: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                fillColor:
                                                                    Colors
                                                                        .black,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                labelText:
                                                                    'Preço',
                                                                hintText:
                                                                    'R\$ ',
                                                                contentPadding: EdgeInsets.fromLTRB(
                                                                    ResponsivePixelHandler
                                                                        .toPixel(
                                                                            15,
                                                                            context),
                                                                    ResponsivePixelHandler
                                                                        .toPixel(5,
                                                                            context),
                                                                    ResponsivePixelHandler
                                                                        .toPixel(
                                                                            15,
                                                                            context),
                                                                    ResponsivePixelHandler
                                                                        .toPixel(
                                                                            5,
                                                                            context)),
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
                          cf.hide == true
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        try {
                                          await requisicaoRef
                                              .doc(requisicaoController.id)
                                              .update({
                                            'motoristas_chamados':
                                                FieldValue.arrayRemove(
                                                    ['${Helper.localUser.id}'])
                                          }).then((v) {
                                            print(
                                                'sucesso ao tirar motorista da lista');
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                            height: getAltura(context) * .110,
                                            width: getLargura(context) * .355,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: hide == true
                                                  ? Colors.transparent
                                                      .withOpacity(0.0)
                                                  : Color.fromRGBO(
                                                      218, 218, 218, 100),
                                            ),
                                            child: Center(
                                                child: hTextAbel(
                                                    'Rejeitar', context,
                                                    size: 30,
                                                    weight: FontWeight.bold))),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        double precofinal = double.parse(
                                            controllerPreco.text
                                                .replaceAll(',', '')
                                                .replaceAll('R\$', '')
                                                .replaceAll('.', ''));

                                        if (precofinal != 0.0) {
                                          List<OfertaCorrida> ofertaList = [];
                                          OfertaCorrida oferta = OfertaCorrida(
                                              requisicao:
                                                  requisicaoController.id,
                                              id_usuario:
                                                  requisicaoController.user,
                                              data: requisicaoController
                                                  .created_at,
                                              motorista: Helper.localUser.id,
                                              preco: double.parse(
                                                  controllerPreco.text
                                                      .replaceAll(',', '.')
                                                      .replaceAll('R\$', '')));
                                          ofertaList.add(oferta);
                                          await ofertacorridaRef
                                              .add(oferta.toJson())
                                              .then((v) {
                                            oferta.id = v.id;
                                            List ofertas = [];
                                            ofertas.add(v.id);
                                            requisicaoController.ofertas =
                                                ofertas;
                                            ofertacorridaRef
                                                .doc(oferta.id)
                                                .update(oferta.toJson());

                                            return requisicaoRef
                                                .doc(requisicaoController.id)
                                                .update(requisicaoController
                                                    .toJson())
                                                .then((v) {
                                              dToast('Você aceitou a viagem');

                                              requisicaoRef
                                                  .doc(requisicaoController.id)
                                                  .update({
                                                'motoristas_chamados':
                                                    FieldValue.arrayRemove([
                                                  '${Helper.localUser.id}'
                                                ])
                                              }).then((v) {
                                                print(
                                                    'sucesso ao tirar motorista da lista');
                                              });
                                            });
                                          });
                                        } else {
                                          dToast('Preencha o campo preço');
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            ResponsivePixelHandler.toPixel(
                                                8, context)),
                                        child: Container(
                                            height: getAltura(context) * .110,
                                            width: getLargura(context) * .355,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: hide == true
                                                  ? Colors.transparent
                                                      .withOpacity(0.0)
                                                  : Color.fromRGBO(
                                                      255, 184, 0, 30),
                                            ),
                                            child: Center(
                                                child: hTextAbel(
                                                    'Aceitar', context,
                                                    size: 30,
                                                    weight: FontWeight.bold))),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  centerView() async {
    final GoogleMapController controller = await _controller.future;

    await controller.getVisibleRegion();

    var left = min(passageiro_latlng.latitude, destino.latitude);
    var right = max(passageiro_latlng.latitude, destino.latitude);
    var top = max(passageiro_latlng.longitude, destino.longitude);
    var bottom = min(passageiro_latlng.longitude, destino.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
    controller.animateCamera(cameraUpdate);
  }

  Widget chamadaMotoristaAceita() {
    StreamBuilder<List<Requisicao>>(
        stream: requisicaoController.outRequisicoes,
        builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
          for (var req in requisicao.data) {
            if (req.aceito.motorista == Helper.localUser.id &&
                req.deleted_at == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(MaterialPageRoute(
                    // ignore: missing_return
                    builder: (context) => InicioDeViagemPage()));
              });
            }
          }
        });
  }

  Future<void> telaCentralizada(Position position) async {
    await Future.delayed(Duration(seconds: 3));
    chamadaMotoristaAceita();
    motorista_latlng = LatLng(position.latitude, position.longitude);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: Helper.localUser.zoom,
    )));
  }

  rotaPassageiro(requisicaoController) async {
    List<LatLng> marcasWays = [];
    passageiro_latlng = LatLng(
        requisicaoController.origem.lat, requisicaoController.origem.lng);

    if (requisicaoController.primeiraParada_lat != null) {
      parada1 = LatLng(requisicaoController.primeiraParada_lat,
          requisicaoController.primeiraParada_lng);

      marcasWays.add(parada1);
    }
    if (requisicaoController.segundaParada_lat != null) {
      parada2 = LatLng(requisicaoController.segundaParada_lat,
          requisicaoController.segundaParada_lng);

      marcasWays.add(parada2);
    }
    if (requisicaoController.terceiraParada_lat != null) {
      parada3 = LatLng(requisicaoController.terceiraParada_lat,
          requisicaoController.terceiraParada_lng);
      marcasWays.add(parada3);
    }

    rc.inWays.add(marcasWays);

    destino = LatLng(
        requisicaoController.destino.lat, requisicaoController.destino.lng);
    marcasRota.add(passageiro_latlng);
    marcasRota.add(destino);
    marcasRota.add(motorista_latlng);
    print('aqui as rotas ${marcasRota}');
    rc.CalcularRotaMotorista(motorista_latlng, passageiro_latlng);
    if (requisicaoController.primeiraParada_lat == null) {
      rc.CalcularRotaPassageiro(passageiro_latlng, requisicaoController);
    } else {
      rc.AdicionarParadaPassageiro(requisicaoController, marcasWays);
    }
    rc.inMarkers.add(marcasRota);
  }

  List<Polyline> getPolys(motorista, data) {
    List<Polyline> poly = [];

    if (data == null) {
      return poly;
    }
    if (motorista == null) {
      return poly;
    }
    try {
      for (int i = 0; i < motorista.length; i++) {
        PolylineId id2 = PolylineId("poly${i}");
        poly.add(Polyline(
          width: 10,
          polylineId: id2,
          color: Colors.blue,
          points: motorista[i],
          consumeTapEvents: true,
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    try {
      for (int i = 0; i < data.length; i++) {
        PolylineId id = PolylineId("polypassageiro${i}");
        poly.add(Polyline(
          width: 10,
          polylineId: id,
          color: Colors.deepPurple,
          points: data[i],
          consumeTapEvents: true,
        ));
      }
    } catch (err) {
      print(err.toString());
    }
    return poly;
  }

  localizacaoInicial() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((v) async {
      print('localizacao ${v.latitude}');
      telaCentralizada(v);

      if (possuiChamadaViagem == true) {
        print('viagem true ${possuiChamadaViagem}');
      }
      rc.inLocalizacao.add(LatLng(v.latitude, v.longitude));
      _initialPosition = LatLng(v.latitude, v.longitude);
    });
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
List<Marker> getMarkers(data, bool online, {ways}) {
  print('aqui bool ${online}');
  List<Marker> markers = [];
  if (data == null) {
    return markers;
  }

  try {
    markers.removeWhere((m) => m.markerId.value == 'posicao');

    for (int i = 0; i < data.length; i++) {
      markers.add(Marker(
          infoWindow: InfoWindow(
              title: i == 0
                  ? 'Passageiro'
                  : i == 1
                      ? 'Destino'
                      : 'Minha Posição'),
          markerId: MarkerId(i < 2 ? 'marcas${i}' : 'posicao'),
          icon: i == 0
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet)
              : i == 1
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen)
                  : online == true
                      ? BitmapDescriptor.fromAsset('assets/marker.png')
                      : Container(),
          position: data[i]));
    }
  } catch (err) {
    print(err.toString());
  }

  try {
    for (int i = 0; i < ways.length; i++) {
      MarkerId markerWay = MarkerId("way${i + 1}");
      markers.add(Marker(
        infoWindow: InfoWindow(title: 'Parada nº ${i + 1}'),
        markerId: markerWay,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: ways[i],
      ));
    }
  } catch (err) {
    print(err.toString());
  }
  return markers;
}
