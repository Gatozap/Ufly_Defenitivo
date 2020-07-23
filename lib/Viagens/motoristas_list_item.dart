import 'package:flutter/material.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class MotoristasListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: [
        sb,
        Center(
          child: Container(
            height: getAltura(context) * .36,
            width: getLargura(context) * .90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: getLargura(context) * .030),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Padding(
                        padding:  EdgeInsets.only(top: getAltura(context)*.010, right: getLargura(context)*.010),
                        child: Container(

                          height: getAltura(context) * .20,
                          width: getLargura(context) * .58,
                          decoration: BoxDecoration(
                           image: DecorationImage(image: AssetImage(motorista.carro.foto, ), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(30),
                          ),

                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: getLargura(context) * .3,

                            child: hTextAbel(motorista.carro.modelo, context,
                                color: Colors.black, size: 60),
                          ),sb,
                          hTextAbel('|', context, size: 60), sb,
                          hTextMal(motorista.carro.categoria, context,
                              size: 60, weight: FontWeight.bold)
                        ],
                      ),sb,
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            motorista.agua
                                ? Container(
                                    height: getAltura(context) * .090,
                                    width: getLargura(context) * .170,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .050,
                                          child: Image.asset(
                                            'assets/agua.png',
                                          ),
                                        ),
                                        hTextAbel('Água', context, size: 60)
                                      ],
                                    ),
                                  )
                                : Container(),
                            motorista.balas
                                ? Container(
                                    height: getAltura(context) * .090,
                                    width: getLargura(context) * .170,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .050,
                                          child: Image.asset(
                                            'assets/balas.png',
                                          ),
                                        ),
                                        hTextAbel('Balas', context, size: 60)
                                      ],
                                    ),
                                  )
                                : Container(),
                            motorista.wifi
                                ? Container(
                                    height: getAltura(context) * .090,
                                    width: getLargura(context) * .170,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .050,
                                          child: Image.asset(
                                            'assets/wifi.png',
                                          ),
                                        ),
                                        hTextAbel('Wi-fi', context, size: 60)
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                
                  Padding(
                    padding:  EdgeInsets.only( right: getLargura(context)*.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(top: getAltura(context)*.020, right: getLargura(context)*.010),
                          child: CircleAvatar(
                              backgroundImage: AssetImage(motorista.foto),
                              radius: 35),

                        ),
                        hTextAbel(motorista.nome, context,
                            size: 80, color: Colors.black),

                        Container(
                          child: Row(
                            children: <Widget>[
                              hTextAbel('${motorista.rating}', context,
                                  size: 70),
                              Container(
                                child:
                                Image.asset('assets/estrela.png'),
                              ),
                            ],
                          ),
                        ),sb,
                        hTextAbel('R\$ ${motorista.preco.toStringAsFixed(2)}', context, size: 70),

                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChamandoMotoristaPage()));
                          },
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: getAltura(context)*.020),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(255, 184, 0, 30),
                              ),
                              height: getAltura(context) * .060,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0, right: 16),
                                  child: Text(
                                    'Solicitar',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'malgun',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),sb,
      ],
    );
  }

  Motorista motorista;
  MotoristasListItem(this.motorista);
}
