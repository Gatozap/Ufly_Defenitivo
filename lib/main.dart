import 'dart:convert';
import 'dart:io';




import 'package:provider/provider.dart';
import 'package:ufly/Objetos/Notificacao.dart';

import 'package:ufly/splash_page.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'GoogleServices/geolocator_service.dart';
import 'Helpers/Helper.dart';
import 'Helpers/NotificacoesHelper.dart';


Future main() async {

  runApp(MyApp());

  FirebaseOptions options = FirebaseOptions(
    messagingSenderId: '1040230764138',
    apiKey: 'AIzaSyB_niut8QCQctZAwMCWUEO5V7wk93ScrrI',
    projectId: 'ufly-56615',
    databaseURL: 'https://ufly-56615.firebaseio.com',
    storageBucket: 'ufly-56615.appspot.com',
    androidClientId:
    '1040230764138-addsr9kprf5rn8dsfe65hug1d5ilco0q.apps.googleusercontent.com',
    appId:
    '1040230764138-addsr9kprf5rn8dsfe65hug1d5ilco0q.apps.googleusercontent.com',
  );
  try {
    await Firebase.initializeApp(name: 'ufly', options: options);
  }catch(err){

  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final geoService = GeolocatorService();

  @override
  Widget build(BuildContext context) {

    return
      FutureProvider(
        create: (context) => geoService.getPosicaoInicial(),
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:SplashPage(),
    ),
      );
  }

  Future onSelectNotification() async {
    SharedPreferences.getInstance().then((sp) {
      var p = sp.getString('lastpush');
      var j = json.decode(p);
      Notificacao n = new Notificacao.fromJson(Platform.isIOS ? j : j['data']);
      n.data = json.decode(n.data);
      print('ABRINDO NOTIFICACAO ${n.toString()}');
      switch (n.behaivior) {
      }
    });
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    dToast('Aqui push ${payload.toString()}');
    NotificacoesHelper().showNotification(json.decode(payload), context);
    SharedPreferences.getInstance().then((sp) {
      sp.setString('lastpush', json.encode(payload));
    });
    print('Notificação AQUI Launch');
  }

  var flutterLocalNotificationsPlugin;
  @override
  void initState() {

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (n) {
          onSelectNotification();
        });
    NotificacoesHelper.flutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin;

    //TODO DEFINIR BEHAVIOURS DAS PUSHS
    Helper.fbmsg = new FirebaseMessaging();
    Helper.fbmsg.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print('Notificação AQUI Launch');

        //App Terminated
        //dToast('Aqui push ${msg.toString()}');
        NotificacoesHelper().showNotification(msg, context);
        SharedPreferences.getInstance().then((sp) {
          sp.setString('lastpush', json.encode(msg));
        });
      },
      onResume: (Map<String, dynamic> msg) {
        print('Notificação AQUI RESUME');
        //App in Background
        //dToast('Aqui push ${msg.toString()}');
        SharedPreferences.getInstance().then((sp) {
          sp.setString('lastpush', json.encode(msg));
        });
        NotificacoesHelper().showNotification(msg, context);
      },
      onMessage: (Map<String, dynamic> msg) {
        print('Notificação Message');
        //App in Foreground
        //dToast('Aqui push ${msg.toString()}');
        SharedPreferences.getInstance().then((sp) {
          sp.setString('lastpush', json.encode(msg));
        });
        NotificacoesHelper().showNotification(msg, context);
      },
    );

    //NotificacoesHelper().showDailyAtTime();

    Helper.fbmsg.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, badge: true, sound: true));
    Helper.fbmsg.onIosSettingsRegistered.listen((IosNotificationSettings ins) {
      print("dispositivo registrado");
    });
    Helper.fbmsg.getToken().then((token) {
      print("TOKEN REGISTRADO" + token);
      Helper.token = token;
    });
    Helper.fbmsg.subscribeToTopic('global');
    Helper.fbmsg.subscribeToTopic('teste');
    super.initState();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
