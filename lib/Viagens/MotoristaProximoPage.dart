import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Controllers/MotoristaController.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Viagens/motoristas_list_item.dart';

import '../HomePage.dart';
import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class MotoristaProximoPage extends StatefulWidget {
  MotoristaProximoPage({Key key}) : super(key: key);

  @override
  _MotoristaProximoPageState createState() {
    return _MotoristaProximoPageState();
  }
}

class _MotoristaProximoPageState extends State<MotoristaProximoPage> {
  final PagesController pc = new PagesController(0);
  PageController pageController;
  PagesController pg;
  MotoristaController mt;
  Motorista motorista;
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
   static final m =  Motorista(
  foto: 'assets/julio.png',
  nome: 'Júlio',
  rating: 5.0,
  carro: Carro(modelo: 'Argo SUV 2019', categoria: 'Luxo', foto: 'assets/teste.jpg' ),
  agua: true,
  wifi: true,
  balas: true,
  preco: 10.00);
  static final b =  Motorista(
      foto: 'assets/ana.png',
      nome: 'Ana',
      rating: 5.0,
      carro: Carro(modelo: 'C3 Attraction', categoria: "Luxo", foto: 'assets/c33.png'),
      agua: true,
      wifi: true,
      balas: true,
      preco: 20.00);
  static final c =  Motorista(
      foto: 'assets/melissa.png',
      nome: 'Melissa',
      rating: 5.0,
      carro: Carro(modelo: 'Ecosport', categoria: "Luxo", foto: 'assets/eco_sport.png'),
      agua: true,
      wifi: true,
      balas: false,
      preco: 20.00);
  List<Motorista> motoristas = [
           m, b ,c
  ];
  @override
  Widget build(BuildContext context) {
    if(mt == null){
      mt = MotoristaController();
    }
    // TODO: implement build
    return StreamBuilder<int>(
        stream: pc.outPageController,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: myAppBar('Motoristas', context,
                size: ScreenUtil.getInstance().setSp(200),
                backgroundcolor: Color.fromRGBO(255, 184, 0, 30),
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

                        return MotoristasListItem(motoristas[index]);
                      },
                      itemCount: motoristas.length,

                    ),

                );

              }
            ),
            backgroundColor: Color.fromRGBO(255, 190, 0, 10),

          );
        });
  }
}
