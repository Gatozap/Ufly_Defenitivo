import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/HomePage.dart';

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
      appBar: myAppBar('Suas Viagens', context,
          size: getAltura(context) * .10,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: getLargura(context) * .025),
              child: Container(
                child: Image.asset('assets/menu.png'),
              ),
            )
          ]),
      body: Container(
        height: getAltura(context),
        width: getLargura(context),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              sb,
              Container(
                height: getAltura(context) * .45,
                width: getLargura(context) * .95,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: getLargura(context) * .040),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getAltura(context) * .010,
                                    bottom: getAltura(context) * .010,
                                    left: getLargura(context) * .060),
                                child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/danielle.png'),
                                    radius: 40),
                              ),
                              sb,
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    hTextAbel('Danielle', context,
                                        size: 90, color: Colors.black),
                                    sb,
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                          Container(
                            height: getAltura(context) * .15,
                            width: getLargura(context) * .50,
                            child: Image.asset(
                              'assets/eco_sport.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          sb,
                          Row(
                            children: <Widget>[
                              hTextAbel('Ecosport 2019 | ', context,
                                  color: Colors.black, size: 70),
                              hTextMal('Luxo', context,
                                  weight: FontWeight.bold, size: 60)
                            ],
                          ),
                          sb,
                          defaultActionButton(
                              'Mais informações', context, () {},
                              icon: null,
                              color: Color.fromRGBO(255, 210, 0, 30),
                              size: 80,
                              textColor: Colors.black)
                        ],
                      ),
                      sb,
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getAltura(context) * .045,
                            left: getLargura(context) * .010),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Center(
                                child: hTextAbel('06/07/2020\n08:35', context)),
                            sb,
                            Center(
                                child:
                                    hTextAbel('R\$ 20,00', context, size: 80))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sb,
              Container(
                height: getAltura(context) * .45,
                width: getLargura(context) * .95,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: getLargura(context) * .040),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getAltura(context) * .010,
                                    bottom: getAltura(context) * .010,
                                    left: getLargura(context) * .060),
                                child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/kaique.png'),
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
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                          Container(
                            height: getAltura(context) * .15,
                            width: getLargura(context) * .50,
                            child: Image.asset(
                              'assets/argo_suv.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          sb,
                          Row(
                            children: <Widget>[
                              hTextAbel('Argo SUV 2020 | ', context,
                                  color: Colors.black, size: 70),
                              hTextMal('Luxo', context,
                                  size: 60, weight: FontWeight.bold)
                            ],
                          ),
                          sb,
                          defaultActionButton(
                              'mais informações', context, () {},
                              icon: null,
                              color: Color.fromRGBO(255, 210, 0, 30),
                              size: 80,
                              textColor: Colors.black)
                        ],
                      ),
                      sb,
                      Container(
                        height: getLargura(context) * .80,
                        color: Colors.black,
                        width: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getAltura(context) * .045,
                            left: getLargura(context) * .010),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Center(
                                child: hTextAbel('13/07/2020\n17:00', context)),
                            sb,
                            Center(
                                child:
                                    hTextAbel('R\$ 12,00', context, size: 80))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sb,
              Container(
                height: getAltura(context) * .45,
                width: getLargura(context) * .95,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: getLargura(context) * .040),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getAltura(context) * .010,
                                    bottom: getAltura(context) * .010,
                                    left: getLargura(context) * .060),
                                child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/melissa.png'),
                                    radius: 40),
                              ),
                              sb,
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    hTextAbel('Melissa', context,
                                        size: 90, color: Colors.black),
                                    sb,
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          hTextAbel('5,0', context, size: 60),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                          Container(
                            height: getAltura(context) * .15,
                            width: getLargura(context) * .50,
                            child: Image.asset(
                              'assets/c33.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          sb,
                          Row(
                            children: <Widget>[
                              hTextAbel('c3 2019 | ', context,
                                  color: Colors.black, size: 70),
                              hTextMal('Luxo', context,
                                  size: 60, weight: FontWeight.bold)
                            ],
                          ),
                          sb,
                          defaultActionButton(
                              'mais informações', context, () {},
                              icon: null,
                              color: Color.fromRGBO(255, 210, 0, 30),
                              size: 80,
                              textColor: Colors.black)
                        ],
                      ),
                      sb,
                      Container(
                        height: getLargura(context) * .80,
                        color: Colors.black,
                        width: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getAltura(context) * .045,
                            left: getLargura(context) * .010),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Center(
                                child: hTextAbel('04/07/2020\n10:40', context)),
                            sb,
                            Center(
                                child:
                                    hTextAbel('R\$ 15,00', context, size: 80))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sb,
              Container(
                height: getAltura(context) * .45,
                width: getLargura(context) * .95,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: getLargura(context) * .040),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getAltura(context) * .010,
                                    bottom: getAltura(context) * .010,
                                    left: getLargura(context) * .060),
                                child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/denis.png'),
                                    radius: 40),
                              ),
                              sb,
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    hTextAbel('Denis', context,
                                        size: 90, color: Colors.black),
                                    sb,
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          hTextAbel('5,0', context, size: 60),
                                          Container(
                                            child: Image.asset(
                                                'assets/estrela.png'),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                          Container(
                            height: getAltura(context) * .15,
                            width: getLargura(context) * .50,
                            child: Image.asset(
                              'assets/honda.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          sb,
                          Row(
                            children: <Widget>[
                              hTextAbel('Ecosport 2019 | ', context,
                                  color: Colors.black, size: 70),
                              hTextMal('Luxo', context,
                                  size: 60, weight: FontWeight.bold)
                            ],
                          ),
                          sb,
                          defaultActionButton(
                              'mais informações', context, () {},
                              icon: null,
                              color: Color.fromRGBO(255, 210, 0, 30),
                              size: 80,
                              textColor: Colors.black)
                        ],
                      ),
                      sb,
                      Container(
                        height: getLargura(context) * .80,
                        color: Colors.black,
                        width: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getAltura(context) * .045,
                            left: getLargura(context) * .010),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Center(
                                child: hTextAbel('03/07/2020\n18:40', context)),
                            sb,
                            Center(
                                child: hTextAbel('R\$ 8,00', context, size: 80))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sb,
            ],
          ),
        ),
      ),
    );
  }
}
