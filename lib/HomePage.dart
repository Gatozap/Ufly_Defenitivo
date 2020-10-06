import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';

import 'package:ufly/Helpers/CustomSwitch.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Viagens/Passageiro/aceitar_passageiro_page.dart';
import 'package:ufly/home_page_list.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'package:ufly/Viagens/FiltroPage.dart';

import 'Objetos/Carro.dart';
import 'Objetos/FiltroMotorista.dart';
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

    if (cf == null) {
      cf = ControllerFiltros();
    }
   

    return  Scaffold(
     drawer: CustomDrawerWidget(),
      appBar: myAppBar('UFLY', context, size: 100, backgroundcolor: Colors.white, color: Colors.black),


      body:
     SlidingUpPanel(
       panel: _floatingPanel(),
       renderPanelSheet: false,
       minHeight: 100,
       maxHeight: getAltura(context) * .40,
       borderRadius: BorderRadius.circular(20),
       collapsed: Container(
         margin:
         const EdgeInsets.only(left: 24.0, right: 24),
         child: Row(
           children: <Widget>[
             Stack(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(top: 25.0),
                   child: Container(
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(24.0),
                             topRight:
                             Radius.circular(24.0)),
                         boxShadow: [
                           BoxShadow(
                             blurRadius: 20.0,
                             color: Colors.grey,
                           ),
                         ]),
                     width: getLargura(context) - 48,
                     child: Column(
                       mainAxisAlignment:
                       MainAxisAlignment.start,
                       crossAxisAlignment:
                       CrossAxisAlignment.center,
                       children: <Widget>[
                         sb,
                         sb,
                         Container(
                           child: Container(
                               width:
                               getLargura(context) * .4,
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

       body: Container(
         height: getAltura(context),
         width: getLargura(context),
         color: Colors.white,
         child: Stack(
           children: <Widget>[
             Container(
                 width: getLargura(context),
                 height: getAltura(context),
                 child: GoogleMap(
                     mapType: MapType.normal,
                     initialCameraPosition: CameraPosition(
                       target: LatLng(40.712776, -74.005974),
                       zoom: 12,
                     ),
                     markers: {posicao})),
             Positioned(
                 right: 15,
                 top: 18,
                 child: CircleAvatar(
                   radius: 25,
                   backgroundColor: Colors.white,
                   child:
                   hTextAbel('ID', context, size: 100),
                 )),
             Column(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[

                         StreamBuilder<FiltroMotorista>(
                         stream: cf.outFiltro,
                         builder: (context, snap) {
                           return Row(
                             mainAxisAlignment:
                             MainAxisAlignment.center,
                             crossAxisAlignment:
                              CrossAxisAlignment.center,
                             children: <Widget>[
                               Padding(
                                 padding: EdgeInsets.only(
                                     top: getAltura(context) *
                                         .020),
                                 child: Container(
                                   decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius:
                                     BorderRadius.circular(
                                         20),
                                   ),
                                   height:
                                   getAltura(context) * .070,
                                   width:
                                   getLargura(context) * .5,
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .center,
                                     children: <Widget>[
                                       GestureDetector(
                                         onTap: () async {
                                           FiltroMotorista f = await
                                           cf.outFiltro.first;
                                           f.viagem = true;

                                           cf.inFiltro.add(
                                               f);

                                         },
                                         child: hTextAbel(
                                           'Viagens',
                                           context,
                                           size: 60,
                                           weight:
                                           FontWeight.bold,
                                           color: snap.data.viagem ==
                                               true
                                               ? Color.fromRGBO(
                                               255,
                                               184,
                                               0,
                                               30)

                                           : Colors.black

                                         ),
                                       ),
                                       sb,
                                       hText('|', context,
                                           size: 60),
                                       sb,
                                       GestureDetector(
                                         onTap: () async {
                                           FiltroMotorista f = await
                                           cf.outFiltro.first;
                                            f.viagem = false;

                                           cf.inFiltro.add(
                                               f);
                                         },
                                         child: hTextAbel(
                                           'Entregas',
                                           context,
                                           size: 60,
                                           weight:
                                           FontWeight.bold,
                                           color: snap.data.viagem ==
                                               false
                                               ? Color.fromRGBO(
                                               255,
                                               184,
                                               0,
                                               30)
                                               : Colors.black,
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           );
                         }
                       ),

                 Padding(
                   padding: EdgeInsets.only(
                       top: getAltura(context) * .020,
                       bottom: getAltura(context) * .010),
                   child: Column(
                     crossAxisAlignment:
                     CrossAxisAlignment.center,
                     mainAxisAlignment:
                     MainAxisAlignment.center,
                     children: <Widget>[
                       Container(
                         color: Color.fromRGBO(
                             248, 248, 248, 100),
                         width: getLargura(context) * .85,
                         child: TextField(
                           style: TextStyle(
                               color: Colors.black,
                               fontWeight: FontWeight.bold),
                           expands: false,
                           decoration: InputDecoration(
                             prefixIcon: Icon(
                               FontAwesomeIcons.mapMarkedAlt,
                               color: Colors.black,
                             ),
                             border: OutlineInputBorder(
                               borderRadius:
                               BorderRadius.circular(
                                   10.0),
                             ),
                             labelText: 'Onde vamos?',
                             contentPadding:
                             EdgeInsets.fromLTRB(
                                 getLargura(context) *
                                     .040,
                                 getAltura(context) *
                                     .020,
                                 getLargura(context) *
                                     .040,
                                 getAltura(context) *
                                     .020),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
     ),
                      );


  }

  Widget _floatingPanel() {
    MotoristaController mt;
    if(mt == null){
      mt = MotoristaController();
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
    StreamBuilder<List<Motorista>>(
    stream: mt.outMotoristas,
        
        builder: (context, AsyncSnapshot<List<Motorista>> snapshot) {
      print('aqui snapshot ${snapshot.data}');
                if(snapshot.data == null){
                  return Container();
                }
                if(snapshot.data.length == 0){
                  return Container(child: hTextMal('Sem carros disponiveis', context));
                }
          return Container(

            width: getLargura(context),
            height: getAltura(context) * .38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {

                if (index == 0) {
                  return ProcurarWidget();
                } else if (index == snapshot.data.length + 1) {
                  return AdicionarAFrotaWidget();
                } else {
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10),
                    child:    Helper.localUser.id != snapshot.data[index -1].id_usuario? FrotaListItem(snapshot.data[index -1]): Container()
                  );
                }
              },
              itemCount: snapshot.data.length + 2,

          ),);
        }
    )]);
  }

  Widget AdicionarAFrotaWidget() {
    return GestureDetector(
      onTap: () {

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
        width: getLargura(context) * .98,
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
            vertical: getAltura(context) * .040),
        height: getLargura(context) * .10,
        width: getLargura(context) * .97,
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
                color: Colors.white, textaling: TextAlign.center, size: 75)
          ],
        ),
      ),
    );
  }

  Marker posicao = Marker(
      onTap: () {
        /*Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AceitarPassageiroPage()));  */
      },
      markerId: MarkerId('posição'),
      position: LatLng(40.712776, -74.005974),
      infoWindow: InfoWindow(title: 'Mapa tester'),
      icon: BitmapDescriptor.defaultMarker);
}
