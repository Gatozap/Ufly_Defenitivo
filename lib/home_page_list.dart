import 'package:flutter/material.dart';
import 'package:ufly/Helpers/Helper.dart';

import 'Objetos/Carro.dart';
import 'Objetos/Motorista.dart';
import 'Objetos/User.dart';
import 'Viagens/SolicitarViagemPage.dart';

class FrotaListItem extends StatelessWidget {
  Motorista motorista;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SolicitarViagemPage()));
          },
          child: Container(
            height: getLargura(context) * .42,
            width: getLargura(context) * .38,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: getLargura(context) * .030,
                vertical: getAltura(context) * .025),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      child: CircleAvatar(
                          backgroundImage: AssetImage(motorista.foto),
                          radius: 25),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Color.fromRGBO(0, 255, 0, 10),
                      ),
                    ),
                  ],
                ),
                sb,
                Padding(
                  padding: const EdgeInsets.only(left:16.0,right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        child: hTextAbel(motorista.nome, context,         textaling: TextAlign.center,
                            color: Colors.white, size: 50),
                      ),
                    ],
                  ),
                ),
                sb,
                Padding(
                  padding: const EdgeInsets.only(left:16.0,right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        child: hTextAbel(motorista.carro.modelo, context, textaling: TextAlign.center,
                            color: Colors.white, size: 50),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  FrotaListItem(this.motorista);
}
