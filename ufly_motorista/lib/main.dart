import 'package:flutter/material.dart';
import 'package:ufly_motorista/Helpers/Helper.dart';
import 'package:ufly_motorista/Login/Login.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: Login(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    ).drive(Tween(begin: 0, end: 3));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 210, 0, 100),
      body: Stack(
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login()));
                controller
                  ..reset()
                  ..forward();
              },
              child: RotationTransition(
                turns: animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Container(
                      width: 112,
                      height: 97,
                      child: Image.asset('assets/logo_ufly.png'),
                    )),
                    sb,
                    Center(
                        child: Text(
                      'UFLY',
                      style: TextStyle(fontFamily: 'BankGothic', fontSize: 60),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
