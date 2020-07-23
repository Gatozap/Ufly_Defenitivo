import 'package:flutter/material.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/Favoritos.dart';

class ConfiguracaoPageList extends StatelessWidget {
  Favoritos favoritos;
  ConfiguracaoPageList(this.favoritos, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.only(left: getLargura(context)*.040, top: getAltura(context)*.020,right:  getLargura(context)*.020 ),
            child: Container(
              width: getLargura(context)*.1,
              child: Image.asset('assets/home.png'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: getAltura(context)*.020),
                  child: hTextMal(favoritos.local, context, size: 50, weight: FontWeight.bold)
              ),
              Padding(
                  padding: EdgeInsets.only(top:  getAltura(context)*.005),
                  child: Container(child: hTextMal(favoritos.endereco, context, size: 45))
              ),
          
            ],
          ),

        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right:  getAltura(context)*.050, top: getAltura(context)*.015 ,
            ),
            child: hTextMal('Excluir', context, size: 50, weight: FontWeight.bold),
          )
        ],
      ),
    ],);
  }
}
