import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';


import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class SolicitarViagemPage extends StatefulWidget {
  SolicitarViagemPage({Key key}) : super(key: key);

  @override
  _SolicitarViagemPageState createState() {
    return _SolicitarViagemPageState();
  }
}

class _SolicitarViagemPageState extends State<SolicitarViagemPage> {
  ControllerFiltros cf;
  final PagesController pc = new PagesController(0);
  PageController pageController;
  PagesController pg;
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

  @override
  Widget build(BuildContext context) {
    if(cf == null){
      cf = ControllerFiltros();
    }
    // TODO: implement build
    return StreamBuilder<int>(
      stream: pc.outPageController,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Scaffold(
          appBar: myAppBar('Sua Viagem', context, size: ScreenUtil.getInstance().setSp(250), backgroundcolor: Colors.black, color: Colors.white, colorIcon: Colors.white),
          /*bottomNavigationBar: BottomAppBar(
              elevation: 20,
              color: Color.fromRGBO(255, 184, 0, 30),
              child: Container(
                height: getAltura(context) * .1,
                width: getLargura(context),
                child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          snapshot.data == 0
                              ? Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.white,
                              child: Container(
                                child:
                                Image.asset('assets/viagem.png'),
                              ))
                              : GestureDetector(
                              onTap: () {
                                onTap(0);
                              },
                              child: Container(
                                child:
                                Image.asset('assets/viagem.png'),
                              )),
                          hTextAbel('Viagens', context, size: 60)
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          snapshot.data == 1
                              ? Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.white,
                              child: Container(
                                child:
                                Image.asset('assets/entregas.png'),
                              ))
                              : GestureDetector(
                              onTap: () {
                                onTap(1);
                              },
                              child: Container(
                                child:
                                Image.asset('assets/entregas.png'),
                              )),
                          hTextAbel('Entregas', context, size: 60)
                        ],
                      )
                    ]),
              )),*/
          body: Container(
            width: getLargura(context),
            height: getAltura(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    width: getLargura(context),
                    height: getAltura(context)*.36,
                    child: Column(
                      children: <Widget>[


                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.only(left: getLargura(context)*.035, top: getAltura(context)*.020, right: getLargura(context)*.035),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset(
                                      'assets/julio.png',
                                      fit: BoxFit.fill,
                                    ),
                                    width: getLargura(context)*.250,
                                    height: getAltura(context)*.120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                      top: getAltura(context)*.010,
                                      right: getLargura(context)*.010,
                                      child: CircleAvatar(
                                        radius: 4,
                                        backgroundColor:
                                            Color.fromRGBO(0, 255, 0, 10),
                                      )),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                               hTextMal('Júlio', context, color: Colors.white, size: 90, weight: FontWeight.bold),
                                Row(
                                  children: <Widget>[
                                    hTextMal('5,0', context, color: Colors.white, size: 70),
                                    sb,
                                    Container(
                                      child: Image.asset('assets/estrela_oca.png'),
                                    )
                                  ],
                                )
                              ],
                            ),
                            sb,
                            Column(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .15,
                                  width: getLargura(context) * .40,
                                  child: Image.asset(
                                    'assets/argo_suv.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                hTextAbel('Argo SUV 2019 Laranja', context,
                                    color: Colors.white, size: 55),
                              ],
                            ),
                          ],
                        ),
                        sb,


                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                           hTextMal('Comodidades', context, color:  Colors.white, weight: FontWeight.bold, size: 60),
                            Padding(
                              padding: EdgeInsets.only(top: getAltura(context)*.020),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: getAltura(context) * .1,
                                    width: getLargura(context) * .190,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context)*.050,
                                          child: Image.asset(
                                            'assets/agua_branca.png',
                                          ),
                                        ),
                                        hTextAbel('Água', context,
                                            size: 58, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: getAltura(context) * .1,
                                    width: getLargura(context) * .190,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context)*.050,
                                          child: Image.asset(
                                            'assets/bala_branca.png',
                                          ),
                                        ),
                                        hTextAbel('Balas', context,
                                            size: 58, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: getAltura(context) * .1,
                                    width: getLargura(context) * .190,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context)*.050,
                                          child: Image.asset(
                                            'assets/wifi_branca.png',
                                          ),
                                        ),
                                        hTextAbel('Wi-fi', context,
                                            size: 58, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.040),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        hTextMal('Total: ', context, size: 60, weight: FontWeight.bold),
                        hTextMal('R\$ 15,00', context, size: 60),
                      ],
                    ),
                  ),
                  sb,
                  Divider(
                    color: Colors.black54,
                  ),
                  Padding(
                    padding:  EdgeInsets.all(getAltura(context)*.010),
                    child:
                    hTextMal('Opções de Pagamento', context, size: 60, weight: FontWeight.bold),
                  ),sb,
                  StreamBuilder<bool>(
                    stream: cf.outBool,
                    builder: (context, snapshot) {
                      if(cf.dinheiro == null){
                        cf.dinheiro = false;
                      }
                      if(cf.cartao == null){
                        cf.cartao = false;
                      }
                      if(cf.reset == null){
                        cf.reset = false;
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.only(left: getLargura(context)*.025),
                            child: GestureDetector(
                                     onTap: (){
                                       if(cf.dinheiro == true){
                                         cf.dinheiro = false;
                                       }
                                          cf.cartao  = !cf.cartao;
                                          cf.inBool.add(snapshot.data);
                      }  ,
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(MdiIcons.creditCard, color: Colors.black, size: 40,),
                                    hTextAbel('Cartão', context, color: Colors.black, size: 60)
                                  ],
                                ),
                                width: getLargura(context)*.270,
                                height: getAltura(context)*.140,
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30.0),
                                  color: cf.cartao == false? Color.fromRGBO(218, 218, 218, 100):  Color.fromRGBO(255, 184, 0, 30),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left:
                                getLargura(context)*.025),
                            child: GestureDetector(
                              onTap: (){
                                print('aqui');
                                  if(cf.cartao == true){
                                    cf.cartao = false;
                                  }
                                cf.dinheiro  = !cf.dinheiro;
                                cf.inBool.add(snapshot.data);
                      }        ,
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                   Container(width: 40,height: 25,child: Image.asset('assets/dinheiro.png', fit: BoxFit.fill,)),
                                    hTextAbel('Dinheiro', context, color: Colors.black, size: 60)
                                  ],
                                ),
                                width: getLargura(context)*.270,
                                height: getAltura(context)*.140,
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30.0),
                                  color: cf.dinheiro == false? Color.fromRGBO(218, 218, 218, 100):  Color.fromRGBO(255, 184, 0, 30),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left:
                            getLargura(context)*.025, right:
                            getLargura(context)*.025),
                            child: GestureDetector(
                              onTap: (){
                              cf.cartao = false;
                              cf.dinheiro = false;
                              cf.inBool.add(snapshot.data);
                      }        ,
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(MdiIcons.creditCardPlus, color: Colors.black, size: 40,),
                                    hTextAbel('Novo\nCartão', context, color: Colors.black, size: 60)
                                  ],
                                ),
                                width: getLargura(context)*.270,
                                height: getAltura(context)*.140,
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Color.fromRGBO(218, 218, 218, 100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  ),sb,sb,
                  Padding(
                    padding: EdgeInsets.only(
                        left: getLargura(context) * .060,
                        right: getLargura(context) * .060,
                        top: getAltura(context) * .005,
                        bottom: getAltura(context) * .020),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          color: Color.fromRGBO(218, 218, 218, 100)),
                      height: getAltura(context) * .1,
                      width: getLargura(context) * .80,
                      child: Row(
                        children: <Widget>[
                          sb,
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                            size: 50,
                          ),
                          sb,
                          hTextAbel('Solicitar Agora', context, size: 70),
                                Padding(
                                  padding:  EdgeInsets.only(left: getLargura(context)*.045),
                                  child: CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(170, 170, 170, 180),
                            radius: 35,
                            child: Center(
                              child: IconButton(
                                  onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ChamandoMotoristaPage()));
                                  },
                                  icon: Icon(
                                    Icons.expand_more,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                              ),
                            ),
                          ),
                                )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

}
