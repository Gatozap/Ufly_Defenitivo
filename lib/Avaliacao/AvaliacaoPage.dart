import 'package:flutter/material.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/FiltroMotorista.dart';
import 'package:ufly/Objetos/Motorista.dart';

class AvaliacaoPage extends StatefulWidget {
      Motorista motorista;
  AvaliacaoPage({Key key, this.motorista}) : super(key: key);

  @override
  _AvaliacaoPageState createState() {
    return _AvaliacaoPageState();
  }
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

   int nota;
  

  @override
  Widget build(BuildContext context) {



    // TODO: implement build
    return
          Scaffold(
            body: Container(
                width: getLargura(context),
                height: getAltura(context),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: getLargura(context),
                      height: getAltura(context) * .2,
                      color: Color.fromRGBO(255, 184, 0, 30),
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: getAltura(context)*.050),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: hTextMal(
                              'Como foi sua corrida?\nAvalie e adicione-a sua frota',

                              context,
                              color: Colors.black,
                              size: 70,
                              weight: FontWeight.bold),
                        ),
                      ),
                    ),
                    sb,
               
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/julio.png'),
                      radius: 50,
                    ),
                    hTextMal('Júlio', context, size: 80, weight: FontWeight.bold),
                    Padding(
                      padding: EdgeInsets.only(top: getAltura(context) * .10),
                      child: Container(
                        width: getLargura(context)*.80,
                        height: getAltura(context)*.080,

                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 184, 0, 30),
                        borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                            child: hTextAbel('Adicionar a sua Frota', context,
                                size: 80, color: Colors.black)),
                      ),
                    ),
                    sb,
                    sb,
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Divider(
                          color: Colors.black54,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Image.asset('assets/adicionar.png'),
                        )
                      ],
                    ),
                    sb,  sb,
                    Padding(
                      padding: EdgeInsets.only(
                          left: getLargura(context) * .020,
                          right: getLargura(context) * .020),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){

                               setState(() {
                                 nota = 4;
                               });


                            },
                            child: Container(
                              width: getLargura(context) * .230,
                              height: getAltura(context) * .150,
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                                Container(child: Image.asset('assets/muito_bom.png'),),
                                hTextAbel('Muito Bom', context)
                              ],),
                              decoration: BoxDecoration(
                                color:

                                nota == 4? Color.fromRGBO(218, 218, 218, 80): Color.fromRGBO(255, 184, 0, 30),
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(right: getLargura(context)*.010, left:getLargura(context)*.010 ),
                            child:     GestureDetector(
                              onTap: (){
                                setState(() {
                                  nota = 3;
                                });
                              },
                              child: Container(
                                width: getLargura(context) * .230,
                                height: getAltura(context) * .150,
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                                  Container(child: Image.asset('assets/bom.png'),),
                                  hTextAbel('Bom', context)
                                ],),
                                decoration: BoxDecoration(
                                  color: nota  == 3? Color.fromRGBO(218, 218, 218, 80): Color.fromRGBO(255, 184, 0, 30),
                                  borderRadius: BorderRadius.circular(15.0),

                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                nota = 2;
                              });
                            },
                            child: Container(
                              width: getLargura(context) * .230,
                              height: getAltura(context) * .150,
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                                Container(child: Image.asset('assets/ruim.png'),),
                                hTextAbel('Ruim', context)
                              ],),
                              decoration: BoxDecoration(
                                color: nota == 2? Color.fromRGBO(218, 218, 218, 80): Color.fromRGBO(255, 184, 0, 30),
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(right: getLargura(context)*.010, left:getLargura(context)*.010 ),
                            child:     GestureDetector(
                              onTap: (){
                                setState(() {
                                  nota = 1;
                                });
                              },
                              child: Container(
                                width: getLargura(context) * .230,
                                height: getAltura(context) * .150,
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                                  Container(child: Image.asset('assets/muito_ruim.png'),),
                                  hTextAbel('Péssimo', context)
                                ],),
                                decoration: BoxDecoration(
                                  color: nota == 1? Color.fromRGBO(218, 218, 218, 80): Color.fromRGBO(255, 184, 0, 30),
                                  borderRadius: BorderRadius.circular(15.0),

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),sb,sb,
                    Container(width: getLargura(context)*.90, height: getAltura(context)*.1,    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 184, 0, 30),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,

                          blurRadius: 4.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.0),

                    ),child: Center(child: hTextMal('Avaliar', context, color: Colors.black, size: 80)))
                  ],
                )));

  }
}
