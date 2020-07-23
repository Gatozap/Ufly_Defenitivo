import 'package:flutter/material.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'Objetos/Carro.dart';
import 'Objetos/Motorista.dart';
import 'Objetos/User.dart';
import 'Viagens/SolicitarViagemPage.dart';

class HomePageList extends StatelessWidget {

  Motorista motorista;


  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  SolicitarViagemPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(),
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.symmetric(
              horizontal: getLargura(context) * .020,
              vertical: getAltura(context) * .025),

          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      backgroundImage:
                      AssetImage(motorista.foto),
                      radius: 30),
                  Padding(
                    padding: EdgeInsets.only(
                        top: getAltura(context) * .030,
                        left: getLargura(context) * .015),
                    child: Container(
                      child: hTextAbel(motorista.nome, context,
                          color: Colors.white, size: 65),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getLargura(context) * .010,
                        right: getLargura(context)*.020,
                        top: getAltura(context) * .005),
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor:
                      Color.fromRGBO(0, 255, 0, 10),
                    ),
                  )
                ],
              ),
              Container(
                height: getAltura(context) * .075,
                child: Image.asset(
                  motorista.carro.foto,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                  child: hTextAbel(
                      motorista.carro.modelo, context,
                      size: 50, color: Colors.white))
            ],
          ),
        ),
      ),],);
  }

  HomePageList(this.motorista);
}


