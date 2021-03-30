import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:responsive_pixel/responsive_pixel.dart';

import 'package:ufly/Ajuda/AjudaPage.dart';

import 'package:ufly/Configuracao/ConfiguracaoPage.dart';

import 'package:ufly/CorridaBackground/corrida_page.dart';

import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Objetos/SizeConfig.dart';

import 'package:ufly/Perfil/PerfilController.dart';

import 'package:ufly/Viagens/SuasViagensPage.dart';
import 'package:rxdart/rxdart.dart';





class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  ProgressDialog pr;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);
  PerfilController pf = new PerfilController(Helper.localUser);
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final screenWidth = MediaQuery.of(context).size.width;
      if(pf == null){
        pf = PerfilController(Helper.localUser);
      }
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: ResponsivePixelHandler.toPixel(10, context)),
                  color:  Colors.white,
                  child: Column(
                    children: <Widget>[

                      GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return
                                  AlertDialog(
                                    title: hText(
                                        "Selecione uma opção",
                                        context),
                                    content:
                                    SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          defaultActionButton(
                                              'Galeria',
                                              context, () {
                                            getImage();
                                            Navigator.of(
                                                context)
                                                .pop();
                                          },
                                              icon: MdiIcons
                                                  .face),
                                          sb,
                                          defaultActionButton(
                                              'Camera', context,
                                                  () {
                                                getImageCamera();
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                              icon: MdiIcons
                                                  .camera)
                                        ],
                                      ),
                                    ),
                                  );
                              });
                        },
                        child:
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Helper.localUser.foto == null?
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/logo_drawer.png'),
                              ):
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: CachedNetworkImageProvider(Helper.localUser.foto),
                              )
                            ],
                          ),
                        ),
                      ),sb,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          hTextMal('${Helper.localUser.nome}', context, size: 17, weight: FontWeight.bold)
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            hTextAbel('5,0', context),
                            sb,
                            Container(
                              child: Image.asset('assets/estrela.png'),
                            )
                          ]),
                      sb,
                      Divider(),
                      sb,
                      Row(
                        children: <Widget>[ sb,
                          Container(
                            width: SizeConfig.safeBlockHorizontal*9,
                            child: Image.asset('assets/home.png'),
                          ),
                          menuButton(context, 'Início', true, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                       Helper.localUser.isMotorista == true? CorridaPage() :HomePage()
                                 ));
                          }),
                        ],
                      ),
                      Row(
                        children: [ sb,
                          Container(
                            width: SizeConfig.safeBlockHorizontal*9,
                            child: Image.asset('assets/map.png'),
                          ),
                          menuButton(context, 'Suas Viagens', true, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SuasViagensPage()));
                          }),
                        ],
                      ),

                      Row(
                        children: [  sb,
                          Container(
                             width: SizeConfig.safeBlockHorizontal*9,
                            child: Image.asset('assets/dirija.png'),
                          ),
                          menuButton(context, 'Dirija na Ufly', true, () {
                            /* Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EstatisticaPage(user: Helper.localUser)));*/
                          }),
                        ],
                      ),

                      Row(
                        children: [  sb,
                          Container(
                            width: SizeConfig.safeBlockHorizontal*9,
                            child: Image.asset('assets/ajuda.png'),
                          ),
                          menuButton(context, 'Ajuda', true, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AjudaPage()));
                          }),
                        ],
                      ),

                      Row(
                        children: [ sb,
                          Container(
                            width: SizeConfig.safeBlockHorizontal*9,
                            child: Image.asset('assets/configuracao.png'),
                          ),
                          menuButton(context, 'Configurações', true, () {

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ConfiguracaoPage()));
                          }),
                        ],
                      ),

                      Row(
                        children: <Widget>[ sb,
                          Container(
                            width: SizeConfig.safeBlockHorizontal*9,
                            child: Icon(Icons.zoom_out_map, color: Colors.black, size: 35),
                          ),
                          menuButton(context, 'Zoom Automático', true, () {

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return
                                    StreamBuilder(
                                        stream: pf.outUser,
                                        builder: (context, snapshot) {
                                          print('snap ${snapshot.data}');
                                          return
                                            AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  hTextAbel('Zoom automático ${snapshot.data.zoom.toStringAsFixed(0)}', context, size: 20),sb,
                                                  Container(
                                                      width: getLargura(context),
                                                      child: CupertinoSlider(divisions: 25,min: 0,max: 50, value:  snapshot.data.zoom,onChanged:(double novoValor){

                                                        snapshot.data.zoom = novoValor;
                                                        pf.inUser.add(snapshot.data);
                                                      }

                                                        , )

                                                  ),sb
                                                  ,
                                                  GestureDetector(
                                                    onTap: (){
                                                      userRef.doc(snapshot.data.id).update(snapshot.data.toJson()).then((v){
                                                        dToast('Zoom atualizado com sucesso');
                                                        Navigator.of(context).pop();
                                                      });
                                                    }         ,
                                                    child: Container(
                                                      height:
                                                      getAltura(context) *
                                                          .070,
                                                      width:
                                                      getLargura(context) *
                                                          .5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                        color:
                                                        Color(0xFFf6aa3c),
                                                      ),
                                                      child: Container(
                                                          height: getAltura(
                                                              context) *
                                                              .125,
                                                          width: getLargura(
                                                              context) *
                                                              .85,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10),
                                                            color:
                                                            Color.fromRGBO(
                                                                255,
                                                                184,
                                                                0,
                                                                30),
                                                          ),
                                                          child: Center(
                                                              child: hTextAbel(
                                                                  'SALVAR',
                                                                  context,
                                                                  size: 25))),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            );
                                        }
                                    );
                                });
                          }),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: getLargura(context) * .25, left: 10, ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 38,
                                child: Image.asset('assets/sair.png'),
                              ),
                              menuButton(context, 'Sair', true, () {
                                doLogout(context);

                              }),

                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.15),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 100,
                      color:Colors.white,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future getImageCamera() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    if (image.path == null) {
      pr.hide();
      return dToast('Erro ao salvar imagem');
    } else {
      Helper.localUser.foto = await uploadPicture(
        image.path,
      );
      pf.updateUser(Helper.localUser);
      pr.hide();
      dToast('Foto salva com sucesso!');
    }
  }

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    print('aqui');
    if (image.path == null) {
      print('aqui image 2 ${image.path}');
      return dToast('Erro ao salvar imagem');

    } else {
      Helper.localUser.foto = await uploadPicture(
        image.path,
      );
      pf.updateUser(Helper.localUser);
      print('aqui image ${image.path} e ${Helper.localUser.foto}');
      pr.hide();
      dToast('Foto salva com sucesso');
    }
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}