import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ufly/Controllers/ControllerFiltros.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Viagens/InicioDeViagemPage/InicioDeViagemPage.dart';

import 'Carro/CarroController.dart';
import 'Motorista/motorista_controller.dart';
import 'Objetos/Carro.dart';

import 'Objetos/Endereco.dart';
import 'Objetos/User.dart';
import 'Viagens/SolicitarViagemPage.dart';

class FrotaListItem extends StatelessWidget {
   Motorista motorista;
    User user;

   FrotaListItem(this.motorista);
   MotoristaController mt;
   bool isFavorito = false;
   CarroController cr ;
  @override
  Widget build(BuildContext context) {
    if(isFavorito == null){
      isFavorito = false ;
    }
    if(mt == null){
      mt = MotoristaController();
    }
          // isFavorito = motorista.favoritos.contains(Helper.localUser.id);
         if(cr == null){
           cr = CarroController(motorista: motorista);
         }

        if(motorista.agua == null){
          motorista.agua = false;
        }
         if(motorista.balas == null){
           motorista.balas = false;
         }
         if(motorista.wifi == null){
           motorista.wifi = false;
         }


         return GestureDetector(
      onTap: (){
       /* Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RotaPage()));*/
    }       ,
      child:       Container(
            width: getLargura(context)*.95,
                  height: getAltura(context)*.42,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: StreamBuilder<List<Motorista>>(
                stream: mt.outMotoristas,

                builder: (context, AsyncSnapshot<List<Motorista>> snapshot) {

                  if(snapshot.data == null){
                    return Container();
                  }
                  if(snapshot.data.length == 0){
                    return Container(child: hTextMal('Sem motorista disponiveis', context));
                  }
                  return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(top: 15.0),
                      child: StreamBuilder<List<Carro>>(
                        stream: cr.outCarros,
                        builder: (context, snapshot) {


                          if(snapshot.data == null){
                            return Container();
                          }
                          if(snapshot.data.length == 0){
                              return Container();
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                Carro carro = snapshot.data[index];

                                   return  Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       hTextAbel(carro.modelo == null? 'Modelo': carro.modelo ,context, color: Colors.blue, weight: FontWeight.bold, size: 60),
                                       carro.categoria== null? hTextAbel(' | Categoria',context, color: Colors.black, weight: FontWeight.bold, size: 60): hTextAbel(' | ${carro.categoria}',context, color: Colors.black, weight: FontWeight.bold, size: 60),
                                     ],
                                   );
                              }



                          );
                        }
                     ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        StreamBuilder<List<Carro>>(
                            stream: cr.outCarros,
                            builder: (context, snapshot) {

                              if(snapshot.data == null){
                                return Container();
                              }
                              if(snapshot.data.length == 0){
                                return Container(child: hTextMal('Sem foto', context));
                              }
                              return Positioned(
                              child:
                              snapshot.data[0].foto == null?Container(
                                height: getAltura(context) * .20,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image:  AssetImage('assets/honda.png')),
                                  borderRadius: BorderRadius.circular(30),
                                ),

                              ):

                              Container(
                                height: getAltura(context) * .20,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image:  CachedNetworkImageProvider(snapshot.data[0].foto),),
                                  borderRadius: BorderRadius.circular(30),
                                ),

                              ),
                            );
                          }
                        ),
                        Positioned(
                           bottom: 0,
                          child: motorista.foto == null?CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/logo_drawer.png'),
                            minRadius: 20, maxRadius: 30,)
                          :CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: CachedNetworkImageProvider(motorista.foto),
                              minRadius: 20, maxRadius: 30,)
                          ,),


                      ],
                    ),
                       Divider(),
                     Padding(
                       padding:  EdgeInsets.only(bottom: getAltura(context)*.010),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          motorista.agua
                              ? Container(

                            width: getLargura(context) * .1,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .050,
                                  child: Image.asset(
                                    'assets/agua.png',
                                  ),
                                ),

                              ],
                            ),
                          )
                              : Container(),
                          motorista.balas
                              ? Container(


                            width: getLargura(context) * .1,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .050,
                                  child: Image.asset(
                                    'assets/balas.png',
                                  ),
                                ),

                              ],
                            ),
                          )
                              : Container(),
                          motorista.wifi
                              ? Container(

                            width: getLargura(context) * .1,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .050,
                                  child: Image.asset(
                                    'assets/wifi.png',
                                  ),
                                ),

                              ],
                            ),
                          )
                              : Container(),
                              sb,
                         isFavorito?
                         Center(
                           child: GestureDetector( onTap:(){
                             if(motorista.favoritos == null){
                               motorista.favoritos = new List();
                             }
                             motorista.favoritos.add(Helper.localUser.id);
                             updateMotorista(motorista);
                           },child: Container( alignment: Alignment.centerRight,child: Icon(FontAwesomeIcons.solidHeart, ))),
                         ):
                         Center(
                           child: GestureDetector(onTap:(){
                             List favoritos = new List();
                               for(var f in motorista.favoritos){
                                  if(f != Helper.localUser.id){
                                    favoritos.add(f);
                                  }
                               }

                             motorista.favoritos = favoritos;
                             updateMotorista(motorista);
                           },child: Container( alignment: Alignment.centerRight,child: Icon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 30))),
                         ),
                        ],
                    ),
                     ),
                    Padding(
                      padding:  EdgeInsets.only(bottom: getAltura(context) * .010),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          hText(motorista.nome , context,
                              size: 60, color: Colors.black), sb,
                          Container(
                            child:
                            Image.asset('assets/estrela.png'),
                          ),sb,
                          hText('5,0', context,
                              size: 60, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
    );
  }


}
