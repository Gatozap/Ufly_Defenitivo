import 'package:flutter/material.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class MotoristasListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sb,
        Center(
          child: Container(
            height: getAltura(context) * .37,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: getAltura(context) * .020,
                                bottom: getAltura(context) * .010),
                            child: CircleAvatar(
                                backgroundImage: AssetImage(motorista.foto),
                                radius: 30),
                          ),
                          sb,
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                hTextAbel(motorista.nome, context,
                                    size: 70, color: Colors.black),
                                sb,
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      hTextAbel(motorista.rating, context,
                                          size: 70),
                                      Container(
                                        child:
                                            Image.asset('assets/estrela.png'),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ],
                      ),
                      Container(
                        height: getAltura(context) * .12,
                        width: getLargura(context) * .45,
                        child: Image.asset(
                          motorista.carro.foto,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          hTextAbel(motorista.carro.modelo, context,
                              color: Colors.black, size: 60),
                          hTextMal(motorista.carro.categoria, context,
                              size: 60, weight: FontWeight.bold)
                        ],
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              motorista.agua
                                  ? Container(
                                      height: getAltura(context) * .080,
                                      width: getLargura(context) * .170,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: getAltura(context) * .050,
                                            child: Image.asset(
                                              'assets/agua.png',
                                            ),
                                          ),
                                          hTextAbel('Água', context, size: 50)
                                        ],
                                      ),
                                    )
                                  : Container(),
                              motorista.bala
                                  ? Container(
                                      height: getAltura(context) * .080,
                                      width: getLargura(context) * .170,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: getAltura(context) * .050,
                                            child: Image.asset(
                                              'assets/balas.png',
                                            ),
                                          ),
                                          hTextAbel('Balas', context, size: 50)
                                        ],
                                      ),
                                    )
                                  : Container(),
                              motorista.wifi
                                  ? Container(
                                      height: getAltura(context) * .080,
                                      width: getLargura(context) * .170,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: getAltura(context) * .050,
                                            child: Image.asset(
                                              'assets/wifi.png',
                                            ),
                                          ),
                                          hTextAbel('Wi-fi', context, size: 50)
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  sb,
                  Padding(
                    padding: EdgeInsets.only(left: getLargura(context) * .030),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: getAltura(context) * .060,
                        ),
                        sb,
                        hTextAbel(motorista.preco, context, size: 70),
                        sb,
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChamandoMotoristaPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(255, 184, 0, 30),
                            ),
                            height: getAltura(context) * .060,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0, right: 15),
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Motorista motorista;
  MotoristasListItem(this.motorista);
}
