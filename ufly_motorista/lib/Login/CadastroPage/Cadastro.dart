import 'package:flutter/material.dart';
import 'package:ufly_motorista/Helpers/Helper.dart';

class Cadastro extends StatefulWidget {
  Cadastro({Key key}) : super(key: key);

  @override
  _CadastroState createState() {
    return _CadastroState();
  }
}

class _CadastroState extends State<Cadastro> {
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
    return Scaffold(appBar: myAppBar('Cadastro', context),);
  }
}