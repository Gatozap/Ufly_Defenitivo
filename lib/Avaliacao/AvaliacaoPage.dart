

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufly/CorridaBackground/requisicao_corrida_controller.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';

class AvaliacaoPage extends StatefulWidget {
Motorista motorista;
  AvaliacaoPage(this.motorista);

  @override
  _AvaliacaoPageState createState() {
    return _AvaliacaoPageState();
  }
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  RequisicaoCorridaController requisicaoController =
  RequisicaoCorridaController();
  @override
  void initState() {
    if(requisicaoController == null){
      requisicaoController = RequisicaoCorridaController();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double nota;
  double nota_final;
  double nota_total;
  double nota_quantidade;
  @override
  Widget build(BuildContext context) {



    // TODO: implement build
    return
      StreamBuilder<List<Requisicao>>(
          stream: requisicaoController.outRequisicoes,
          // ignore: missing_return
          builder: (context, AsyncSnapshot<List<Requisicao>> requisicao) {
    for(Requisicao r in requisicao.data) {
      return Scaffold(
          body: Container(
              width: getLargura(context),
              height: getAltura(context),
              child: Column(
                children: <Widget>[
                  Container(
                    width: getLargura(context),
                    height: getAltura(context) * .2,
                    color: Color.fromRGBO(255, 184, 0, 30),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: getAltura(context) * .050),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: hTextMal(
                            'Como foi sua corrida?\nAvalie e adicione-a sua frota',

                            context,
                            color: Colors.black,
                            size: 25,
                            weight: FontWeight.bold),
                      ),
                    ),
                  ),
                  sb,

                  CircleAvatar(
                      backgroundImage:
                      widget.motorista.foto == null
                          ? AssetImage(
                          'assets/logo_drawer.png')
                          : CachedNetworkImageProvider(
                          widget.motorista.foto),
                      radius: 50),
                  hTextMal('${widget.motorista.nome}', context, size: 27,
                      weight: FontWeight.bold),
                  Padding(
                    padding: EdgeInsets.only(top: getAltura(context) * .10),
                    child: Container(
                      width: getLargura(context) * .80,
                      height: getAltura(context) * .080,

                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 184, 0, 30),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                          child: hTextAbel('Adicionar a sua Frota', context,
                              size: 25, color: Colors.black)),
                    ),
                  ),
                  sb,
                  sb,
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Divider(
                        color: Colors.black54,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Image.asset('assets/adicionar.png'),
                      )
                    ],
                  ),
                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(
                        left: getLargura(context) * .020,
                        right: getLargura(context) * .020),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: getLargura(context) *
                              .010, left: getLargura(context) * .010),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                nota = 1;
                              });
                            },
                            child: Container(
                              width: getLargura(context) * .230,
                              height: getAltura(context) * .150,
                              child: Column(mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(child: Image.asset(
                                      'assets/muito_ruim.png'),),
                                  hTextAbel('Péssimo', context)
                                ],),
                              decoration: BoxDecoration(
                                color: nota != 1 ? Color.fromRGBO(
                                    218, 218, 218, 80) : Color.fromRGBO(
                                    255, 184, 0, 30),
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              nota = 2;
                            });
                          },
                          child: Container(
                            width: getLargura(context) * .230,
                            height: getAltura(context) * .150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.asset('assets/ruim.png'),),
                                hTextAbel('Ruim', context)
                              ],),
                            decoration: BoxDecoration(
                              color: nota != 2 ? Color.fromRGBO(
                                  218, 218, 218, 80) : Color.fromRGBO(
                                  255, 184, 0, 30),
                              borderRadius: BorderRadius.circular(15.0),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: getLargura(context) *
                              .010, left: getLargura(context) * .010),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                nota = 3;
                              });
                            },
                            child: Container(
                              width: getLargura(context) * .230,
                              height: getAltura(context) * .150,
                              child: Column(mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Image.asset('assets/bom.png'),),
                                  hTextAbel('Bom', context)
                                ],),
                              decoration: BoxDecoration(
                                color: nota != 3 ? Color.fromRGBO(
                                    218, 218, 218, 80) : Color.fromRGBO(
                                    255, 184, 0, 30),
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              nota = 4;
                            });
                          },
                          child: Container(
                            width: getLargura(context) * .230,
                            height: getAltura(context) * .150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.asset('assets/muito_bom.png'),),
                                hTextAbel('Muito Bom', context)
                              ],),
                            decoration: BoxDecoration(
                              color:

                              nota != 4
                                  ? Color.fromRGBO(218, 218, 218, 80)
                                  : Color.fromRGBO(255, 184, 0, 30),
                              borderRadius: BorderRadius.circular(15.0),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ), sb, sb,
                  GestureDetector(
                    onTap: () {
                      if (nota != null) {

                        nota_quantidade = widget.motorista.rating_quantidade + 1.0;
                        widget.motorista.rating_quantidade = nota_quantidade;
                        nota_total = widget.motorista.rating_total + nota;
                        widget.motorista.rating_total = nota_total;
                       nota_final = widget.motorista.rating =
                            widget.motorista.rating_total /
                                widget.motorista.rating_quantidade;

                        widget.motorista.rating = nota_final;
                        r.deleted_at = DateTime.now();
                        requisicaoRef.doc(r.id).update(r.toJson());
                        return motoristaRef.doc(widget.motorista.id).update(
                            widget.motorista.toJson()).then((v) {

                          dToast('Avaliação feita com sucesso!');
                         Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage()));
                        });
                      } else {
                        dToast('Por favor avalie o motorista');
                      }
                    },
                    child: Container(width: getLargura(context) * .90,
                        height: getAltura(context) * .1,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 184, 0, 30),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black26,

                              blurRadius: 4.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        child: Center(
                            child: hTextMal('Avaliar', context, color: Colors
                                .black, size: 25))),
                  )
                ],
              )));
    }
           }
         );

  }
}
