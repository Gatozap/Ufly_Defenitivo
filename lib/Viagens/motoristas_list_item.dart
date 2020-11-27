import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufly/Carro/CarroController.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Motorista/motorista_controller.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'ChamandoMotoristaPage/ChamandoMotoristaPage.dart';

class MotoristasListItem extends StatelessWidget {
  CarroController cr;
  MotoristaController mt;
  @override
  Widget build(BuildContext context) {
    if (motorista.agua == null) {
      motorista.agua = false;
    }
    if (motorista.wifi == null) {
      motorista.wifi = false;
    }
    if (motorista.balas == null) {
      motorista.balas = false;
    }
    if(mt == null){
      mt = MotoristaController();
    }
    if (cr == null) {
      cr = CarroController(motorista: motorista);
    }
    return StreamBuilder<List<Carro>>(
        stream: cr.outCarros,
        builder: (context, snapshot) {
          print('carro ${snapshot.data}');
          if (snapshot.data == null) {
            return Container(child: hTextMal('Sem carros 1 ', context));
          }
          if (snapshot.data.length == 0) {
            return Container(child: hTextMal('Sem carros', context));
          }
          return StreamBuilder<List<Motorista>>(
              stream: mt.outMotoristas,

              builder: (context, AsyncSnapshot<List<Motorista>> snap) {
                print('aqui snapshot ${snap.data}');
                if(snap.data == null){
                  return Container();
                }
                if(snap.data.length == 0){
                  return Container(child: hTextMal('Sem motorista disponiveis', context));
                }
                return

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: getAltura(context) * .40,
                      width: getLargura(context) * .85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: getLargura(context) * .030),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: getAltura(context) * .020,
                                          right: getLargura(context) * .010, bottom: getAltura(context)*.010),
                                      child: Container(
                                        height: getAltura(context) * .15,
                                        width: getLargura(context) * .58,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: snapshot.data[0].foto == null
                                                  ? AssetImage('assets/logo_drawer.png')
                                                  : CachedNetworkImageProvider(snapshot.data[0].foto),
                                             ),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: getLargura(context) * .65,
                                      height: getAltura(context)*.090,
                                      child: ListView.builder(
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            Carro carro = snapshot.data[index];

                                            return  Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                hTextAbel(carro.modelo == null? 'Modelo': carro.modelo ,context, color: Colors.blue, weight: FontWeight.bold, size: 60),
                                                carro.categoria== null? hTextAbel(' | Categoria',context, color: Colors.black, weight: FontWeight.bold, size: 60): hTextAbel(' | ${carro.categoria}',context, color: Colors.black, weight: FontWeight.bold, size: 60),
                                              ],
                                            ); }
                                          ),
                                    ),
                                    sb,
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
                                                        height:
                                                            getAltura(context) * .050,
                                                        child: Image.asset(
                                                          'assets/agua.png',
                                                        ),
                                                      ),
                                                      hTextAbel('Água', context,
                                                          size: 60)
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
                                                        height:
                                                            getAltura(context) * .050,
                                                        child: Image.asset(
                                                          'assets/balas.png',
                                                        ),
                                                      ),
                                                      hTextAbel('Balas', context,
                                                          size: 60)
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
                                                        height:
                                                            getAltura(context) * .050,
                                                        child: Image.asset(
                                                          'assets/wifi.png',
                                                        ),
                                                      ),
                                                      hTextAbel('Wi-fi', context,
                                                          size: 60)
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
                                  padding: EdgeInsets.only(
                                      right: getLargura(context) * .010),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .020,
                                              right: getLargura(context) * .010),
                                          child: motorista.foto == null
                                              ? CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(
                                                      'assets/logo_drawer.png'),
                                                  minRadius: 20,
                                                  maxRadius: 30,
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          motorista.foto),
                                                  minRadius: 20,
                                                  maxRadius: 30,
                                                )),
                                      hTextAbel(motorista.nome, context,
                                        size: 60, color: Colors.black),

                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            hTextAbel(
                                                '${motorista.rating == null ? 0 : motorista.rating}',
                                                context,
                                                size: 60),
                                            Container(
                                              child: Image.asset('assets/estrela.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sb,
                                      motorista.preco != null
                                          ? hTextAbel(
                                              'R\$ ${motorista.preco.toStringAsFixed(2)}',
                                              context,
                                              size: 70)
                                          : hTextAbel(
                                          'R\$ 100,00',
                                          context,
                                          size: 70),
                                             sb,sb,
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ChamandoMotoristaPage()));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: getAltura(context) * .010),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color.fromRGBO(255, 184, 0, 30),
                                            ),
                                            height: getAltura(context) * .060,
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, right: 16),
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
                          ],
                        ),
                      ),
                    ),
                  );

            }
          );
        });
  }

  Motorista motorista;
  MotoristasListItem(this.motorista);
}
