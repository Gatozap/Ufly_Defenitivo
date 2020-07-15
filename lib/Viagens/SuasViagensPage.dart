import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Helpers/Helper.dart';

class SuasViagensPage extends StatefulWidget {
  SuasViagensPage({Key key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Container(
              width: getLargura(context),
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Suas Viagens',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'malgun'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 25.0),
                    child: Container(
                      child: Image.asset('assets/viagens_menu.png'),
                    ),
                  )
                ],
              ),
            ),
          ),
          sb,
          Container(
            height: getAltura(context)*.45,
            width: getLargura(context) * .95,
            decoration: BoxDecoration(
              color: Color.fromRGBO(230, 230, 230, 100),
              
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.only(top:8.0, bottom: 8),
                            child: CircleAvatar(
                                backgroundImage: AssetImage('assets/kaique.png'),
                                radius: 40),
                          ),
                          sb,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                            hTextAbel('Kaique', context,
                                size: 90, color: Colors.black),
                            sb,
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset('assets/estrela.png'),
                                  ),
                                  Container(
                                    child: Image.asset('assets/estrela.png'),
                                  ),
                                  Container(
                                    child: Image.asset('assets/estrela.png'),
                                  ),
                                  Container(
                                    child: Image.asset('assets/estrela.png'),
                                  ),
                                  Container(
                                    child: Image.asset('assets/estrela.png'),
                                  )
                                ],
                              ),
                            )
                          ]),

                        ],
                      ),
                      Container(

                        height: getAltura(context)*.15, width: getLargura(context)*.50,
                        child: Image.asset('assets/argo_suv.png',fit: BoxFit.fill,),
                      ),sb,
                      Row(
                        children: <Widget>[
                          hTextAbel('Argo SUV 2020 | ', context,color: Colors.black, size: 70),
                          Text('Luxo', style: TextStyle(color: Colors.black, fontFamily: 'malgun',fontWeight: FontWeight.bold, fontSize: 20),),
                        ],
                      ),sb,
                      defaultActionButton('mais informações', context, (){

                      }, icon: null, color: Color.fromRGBO(255, 210, 0, 100), size: 80, textColor: Colors.black)
                    ],
                  ),
                  sb,Container(height: getLargura(context)*.80, color: Colors.black, width: 2,),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 25.0, left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Center(child: hTextAbel('13/07/2020\n17:00', context)), sb,
                    Center(child: hTextAbel('R\$ 12,00', context, size: 80))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
