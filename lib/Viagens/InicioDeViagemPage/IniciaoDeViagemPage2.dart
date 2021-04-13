import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Ativos/AtivosController.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:ufly/Avaliacao/AvaliacaoPage.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';

import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/GoogleServices/geolocator_service.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';

import 'package:ufly/Objetos/OfertaCorrida.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Objetos/User.dart';
import 'package:ufly/Perfil/user_controller.dart';
import 'package:ufly/Rota/rota_controller.dart';
import 'package:ufly/Viagens/FiltroPage.dart';
import 'package:ufly/Viagens/OfertaCorrida/oferta_corrida_controller.dart';
import 'package:ufly/Helpers/Helper.dart';

class InicioDeViagemPage2 extends StatefulWidget {
  InicioDeViagemPage2({Key key}) : super(key: key);

  @override
  _InicioDeViagemPage2State createState() {
    return _InicioDeViagemPage2State();
  }
}

class _InicioDeViagemPage2State extends State<InicioDeViagemPage2> {

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
    return Scaffold(body: GestureDetector(onTap: (){
      print('aqui printou');

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AvaliacaoPage()));

    }, child: Container(alignment: Alignment.center,child: hTextAbel('Aqui avaliação', context, size: 80),)),);
  }
}