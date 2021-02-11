import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:ufly/Ajuda/AjudaPage.dart';
import 'package:ufly/Carro/CarroController.dart';
import 'package:ufly/Carro/cadastro_carro_controller.dart';
import 'package:ufly/Configuracao/ConfiguracaoPage.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';

import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Login/CadastroPage/CadastroController.dart';
import 'package:ufly/Login/Login.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Perfil/PerfilController.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Viagens/SuasViagensPage.dart';

class CustomDrawerWidget extends StatefulWidget {
  @override
  CustomDrawerWidgetState createState() {
    return new CustomDrawerWidgetState();
  }
}

class CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  CadastroCarroController cr;
  PerfilController pf = new PerfilController(Helper.localUser);
  double value = 0;
  ProgressDialog pr;
  RotaController rc;
  PerfilController perfilController;
  @override
  Widget build(BuildContext context) {
    if (perfilController == null) {
      perfilController = PerfilController(Helper.localUser);
    }
    if(cr == null){
      cr = CadastroCarroController();
    }
    
    return Drawer(

        child: Stack(children: <Widget>[
      Scrollbar(
        child: Container(

          decoration: BoxDecoration(color: Colors.white),
          height: getAltura(context),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: ResponsivePixelHandler.toPixel(40, context), left: ResponsivePixelHandler.toPixel(10, context)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
                sb,
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
                Padding(
                  padding:  EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/map.png'),
                      ),
                      menuButton(context, 'Suas Viagens', true, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SuasViagensPage()));
                      }),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/dirija.png'),
                      ),
                      menuButton(context, 'Dirija na Ufly', true, () {
                        /* Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EstatisticaPage(user: Helper.localUser)));*/
                      }),
                    ],
                  ),
                ),



                /*menuButton(context, 'Cadastrar Novos Carros', Icons.directions_car, true, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CadastrarNovoCarroPage(
                          carro: widget.carro, campanha: widget.campanha,
                      )));
                }),*/

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/ajuda.png'),
                      ),
                      menuButton(context, 'Ajuda', true, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AjudaPage()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Image.asset('assets/configuracao.png'),
                      ),
                      menuButton(context, 'Configurações', true, () {

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConfiguracaoPage()));
                      }),
                    ],
                  ),
                ),sb,
               /* Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 15,top: 5),
                  child: StreamBuilder(
                      stream: pf.outUser,
                      builder: (context, snapshot) {
                                print('aqui o zoom ${snapshot.data.zoom}');
                        return Column(
                        children: <Widget>[
                             hTextAbel('Zoom automático: x${snapshot.data.zoom.toStringAsFixed(1)}', context, size: 60),
                          SafeArea(
                            child:  Container(
                                width: getLargura(context),
                                  child: CupertinoSlider(divisions: 25,min: 0,max: 50, value: snapshot.data.zoom,onChanged:(double novoValor){



                                    snapshot.data.zoom = novoValor;
                                                              
                                         userRef.doc( snapshot.data.id).update( snapshot.data.toJson());

                                  }

                                    , )

                            ),
                          ),

                        ],
                      );
                    }
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
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
      ),
    ]));
  }

  separator(context) {
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 2,
        color: Colors.grey[200]);
  }

  Widget menuButton(context, text, isLogout, onPress,
      {color, size, estiloTexto}) {
    return Container(
        width: MediaQuery.of(context).size.width * .5,
        child: MaterialButton(
          onPressed: onPress,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),

              SizedBox(
                width: 10,
              ),
              Container(
                  child: Expanded(
                      child: hTextAbel(
                text,
                context,
                size: size == null ? 20 : size,
              )))
              //Icon(Icons.arrow_forward_ios)
            ],
          ),
        ));
  }
  Future getImageCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
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
      perfilController.updateUser(Helper.localUser);
      pr.hide();
      dToast('Foto salva com sucesso!');
    }
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
      perfilController.updateUser(Helper.localUser);
      print('aqui image ${image.path} e ${Helper.localUser.foto}');
      pr.hide();
      dToast('Foto salva com sucesso');
    }
  }
  doLogout(context) async {
    Helper.fbmsg.unsubscribeFromTopic(Helper.localUser.id);
    await FirebaseAuth.instance.signOut();
    Helper.localUser = null;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
