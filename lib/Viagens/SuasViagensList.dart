import 'package:flutter/material.dart';
import 'package:ufly/Helpers/Helper.dart';


class SuasViagemList extends StatelessWidget {


  SuasViagemList() ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Column(children: <Widget>[
      Padding(
        padding:  EdgeInsets.symmetric(vertical: getAltura(context)*.010),
        child: Container(
        height: getAltura(context) * .45,
        width: getLargura(context) * .95,
        decoration: BoxDecoration(
          color: Color.fromRGBO(218, 218, 218, 100),
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

                  Padding(
                    padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.010),
                    child: Container(

                      height: getAltura(context) * .20,
                      width: getLargura(context) * .58,
                      decoration: BoxDecoration(
                       // image: DecorationImage(image: AssetImage(motorista.carro.foto, ), fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(30),
                      ),

                    ),
                  ),
                  sb,
                  Padding(
                    padding:  EdgeInsets.only(top: getAltura(context)*.030),
                    child: Row(
                      children: <Widget>[
                       // hTextAbel('${motorista.carro.modelo}| ', context,
                        //    color: Colors.black, size: 70),
                       // hTextMal(motorista.carro.categoria, context,
                        //    weight: FontWeight.bold, size: 60)
                      ],
                    ),
                  ),
                  sb,
                  Padding(
                    padding:  EdgeInsets.only(top: getAltura(context)*.040),
                    child: defaultActionButton(
                        'Mais informações', context, () {},
                        icon: null,
                        color: Color.fromRGBO(255, 210, 0, 30),
                        size: 80,
                        textColor: Colors.black),
                  )
                ],
              ),
              sb,
              Padding(
                padding: EdgeInsets.only(
                    bottom: getAltura(context) * .045,
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: getAltura(context) * .010,
                          bottom: getAltura(context) * .010,
                          left: getLargura(context) * .040, right:  getLargura(context) * .030),
                      child: CircleAvatar(
                         // backgroundImage:
                         // AssetImage(motorista.foto),
                          radius: 40),
                    ),

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         // hTextAbel(motorista.nome, context,
                          //    size: 90, color: Colors.black),
                          sb,
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                               // hTextAbel("${motorista.rating}", context, size: 70),
                                Container(
                                  child: Image.asset(
                                      'assets/estrela.png'),
                                ),

                              ],
                            ),
                          )
                        ]),
                    sb,
                    hTextAbel('06/07/2020\n08:35', context),
                    sb,
                    //Center(
                       // child:
                       // hTextAbel('R\$ ${motorista.preco.toStringAsFixed(2)}', context, size: 80)
    //)
                  ],
                ),
              )
            ],
          ),
        ),
    ),
      ),],);
  }


}
