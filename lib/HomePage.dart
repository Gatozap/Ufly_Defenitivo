import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufly/Compartilhados/custom_drawer_widget.dart';
import 'package:ufly/Controllers/PagesController.dart';
import 'package:ufly/Helpers/Helper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  final PagesController pc = new PagesController(0);
  PageController pageController;
  var page0;
  var page1;
  var page2;
  var page3;
  var page4;
  int page = 0;
  void onTap(int index) {
    pc.inPageController.add(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
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
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('UFLY', context, ),

      bottomNavigationBar: BottomAppBar(
          elevation: 20,
          color: Color.fromRGBO(255, 184, 0, 100),
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: getLargura(context)*.25,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Center(
                            child: Container(
                          height: 35,
                          child: Image.asset(
                            'assets/viagem.png',
                          ),
                        )),
                      ),
                      hTextAbel('Viagens', context, size: 70)
                    ],
                  ),
                ),
                Container(
                  height: getLargura(context)*.25,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Center(
                            child: Container(
                          height: 35,
                          child: Image.asset(
                            'assets/entregas.png',
                          ),
                        )),
                      ),
                      hTextAbel('Entregas', context, size: 75)
                    ],
                  ),
                ),
              ])),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            
              
              Padding(
                padding:  EdgeInsets.only(top: 20.0, bottom: 20),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(left: 25.0, right: 10),
                      child: Container(
                        width: 40,
                        height: 50,
                        child: Image.asset(
                          'assets/destino.png',
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          color: Color.fromRGBO(248, 248, 248, 100),
                          width: getLargura(context)*.75,
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            expands: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: '     Onde você está?',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                            ),
                          ),
                        ),
                        sb,
                        Container(
                          color: Color.fromRGBO(248, 248, 248, 100),
                          width: getLargura(context)*.75,
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            expands: false,

                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  ),
                              labelText: '     Qual seu destino?',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                sb,
              Container(
                width: getLargura(context),
                height: 230,
                child: Image.asset(
                  'assets/mapa_inicial.png',
                  fit: BoxFit.fill,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarCampanhaPage())); */
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: getLargura(context) * .40,
                        width: getLargura(context) * .40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 75,
                              height: 75,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 65,
                              ),
                            ),
                            hTextAbel('Procurar', context,
                                color: Colors.white,
                                textaling: TextAlign.center,
                                size: 60)
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarCampanhaPage())); */
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: getLargura(context) * .40,
                        width: getLargura(context) * .40,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                  CircleAvatar(backgroundImage: AssetImage('assets/julio.png'), radius: 30),
                                Padding(
                                  padding:  EdgeInsets.only(top:30.0, left: 2),
                                  child: Container(

                                    child: hTextAbel('Júlio', context,
                                        color: Colors.white,

                                        size: 65),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 15.0, top: 10),
                                  child: CircleAvatar(radius: 8, backgroundColor: Color.fromRGBO(0, 255, 0, 100),),
                                )
                              ],
                            ),
                            Container( height: 50,child: Image.asset('assets/carro_julio.png', fit: BoxFit.fill,),),
                            Container( child: hTextAbel('Argo SUV 2020', context, size: 50, color: Colors.white))
                          ],

                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarCampanhaPage())); */
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: getLargura(context) * .40,
                        width: getLargura(context) * .40,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                CircleAvatar(backgroundImage: AssetImage('assets/ana.png'), radius: 30),
                                Padding(
                                  padding:  EdgeInsets.only(top:30.0, left: 2),
                                  child: Container(

                                    child: hTextAbel('Ana', context,
                                        color: Colors.white,

                                        size: 65),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 15.0, top: 10),
                                  child: CircleAvatar(radius: 8, backgroundColor: Color.fromRGBO(0, 255, 0, 100),),
                                )
                              ],
                            ),
                            Container( height: 50,child: Image.asset('assets/c3.png', fit: BoxFit.fill,),),
                            Container( child: hTextAbel('C3 Attraction', context, size: 50, color: Colors.white))
                          ],

                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarCampanhaPage())); */
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: getLargura(context) * .40,
                        width: getLargura(context) * .40,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                CircleAvatar(backgroundImage: AssetImage('assets/pedro.png'), radius: 30),
                                Padding(
                                  padding:  EdgeInsets.only(top:30.0, left: 2),
                                  child: Container(

                                    child: hTextAbel('Pedro', context,
                                        color: Colors.white,

                                        size: 65),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 15.0, top: 10),
                                  child: CircleAvatar(radius: 8, backgroundColor: Color.fromRGBO(0, 255, 0, 100),),
                                )
                              ],
                            ),
                            Container( height: 50,child: Image.asset('assets/fazer250.png', fit: BoxFit.fill,),),
                            Container( child: hTextAbel('Fazer 250', context, size: 50, color: Colors.white))
                          ],

                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarCampanhaPage())); */
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:  Color.fromRGBO(248, 248, 248, 100),
                      
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: getLargura(context) * .40,
                        width: getLargura(context) * .40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 75,
                              height: 75,
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Colors.black,
                                size: 65,
                              ),
                            ),
                            hTextAbel('Adicionar\na Frota', context,
                                color: Colors.black,
                                textaling: TextAlign.center,
                                size: 60)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
