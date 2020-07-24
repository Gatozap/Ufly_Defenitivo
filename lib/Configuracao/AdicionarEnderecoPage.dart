import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ufly/Helpers/Helper.dart';

class AdicionarEnderecoPage extends StatefulWidget {
  AdicionarEnderecoPage({Key key}) : super(key: key);

  @override
  _AdicionarEnderecoPageState createState() {
    return _AdicionarEnderecoPageState();
  }
}

class _AdicionarEnderecoPageState extends State<AdicionarEnderecoPage> {
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
      appBar: myAppBar('Adicionar Endereço', context,

          size: ScreenUtil.getInstance().setSp(200),
          showBack: true,
         ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Color.fromRGBO(218, 218, 218, 100),
              child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                ),
                expands: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Endereço desejado',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20),
            child: Container(
                child: Text(
              'Adicione o endereço desejado para ser preenchido automaticamente nos campos de busca',
              style: TextStyle(
                fontSize: 20,
              ),
            )),

          ),sb,sb,
          Container(height: getAltura(context)*.60, child: Image.asset('assets/mapa_inicial.png'),)
        ],
      ),
    );
  }
}
