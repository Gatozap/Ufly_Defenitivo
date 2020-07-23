import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Controllers/MotoristaController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Viagens/SuasViagensList.dart';

class SuasViagensPage extends StatefulWidget {


  @override
  _SuasViagensPageState createState() {
    return _SuasViagensPageState();
  }
}

class _SuasViagensPageState extends State<SuasViagensPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final h = Motorista(
      preco: 10.00,
  rating: 5.0,
      foto: 'assets/julio.png',
      nome: 'Júlio',
      isOnline: true,
      carro: Carro(
          foto: 'assets/carro_julio.png',
          categoria: 'Luxo',
          modelo: 'Argo SUV 2020'));
  static final m = Motorista(
      preco: 10.00,
      rating: 5.0,
      foto: 'assets/julio.png',
      nome: 'Júlio',
      isOnline: true,
      carro: Carro(
          foto: 'assets/carro_julio.png',
          categoria: 'Luxo',
          modelo: 'Argo SUV 2020'));

  MotoristaController mt;
  static final n = Motorista(

      preco: 10.00,
      rating: 5.0,
      foto: 'assets/melissa.png',
      nome: 'Melissa',
      isOnline: true,
      carro: Carro(
          foto: 'assets/eco_sport.png', categoria: 'Luxo', modelo: 'Ecosport'));
  List<Motorista> motoristas = [h, n, m];
  @override
  Widget build(BuildContext context) {
    if(mt == null){
       mt = MotoristaController();
    }
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Suas Viagens', context,
          size: ScreenUtil.getInstance().setSp(250),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: getLargura(context) * .025),
              child: Container(
                child: Image.asset('assets/menu.png'),
              ),
            )
          ]),
      body: StreamBuilder(
        stream: mt.outMotorista,
        builder: (context, snapshot) {
          return Container(
            width: getLargura(context),
            height: getAltura(context),
            child: ListView.builder(
              shrinkWrap: true,

              itemBuilder: (context, index) {

                return SuasViagemList(motoristas[index]);
              },
              itemCount: motoristas.length,

            ),

          );
        }
      )
    );
  }

}
