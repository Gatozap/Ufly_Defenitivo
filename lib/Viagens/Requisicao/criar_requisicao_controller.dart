

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Objetos/User.dart';

class CriarRequisicaoController extends BlocBase {


  BehaviorSubject<List<Requisicao>> requisicoesController =
  BehaviorSubject<List<Requisicao>>();
  Stream<List<Requisicao>> get outRequisicoes => requisicoesController.stream;
  Sink<List<Requisicao>> get inRequisicoes => requisicoesController.sink;
  List<Requisicao> requisicoes;
  List<Requisicao> requisicoesmain;



  CriarRequisicaoController() {

    requisicaoRef
        .snapshots()
        .listen((QuerySnapshot snap) {

      requisicoes = [];
      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {

          Requisicao p =  Requisicao.fromJson(ds.data());
         
          p.id = ds.id;
          requisicoes.add(p);

        }
        requisicoes.sort(
                (Requisicao a, Requisicao b) => a.user.compareTo(b.user));

        requisicoesmain = requisicoes;
        inRequisicoes.add(requisicoes);
      } else {
        inRequisicoes.add(requisicoes);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });
  }

  CriarRequisicao(Requisicao requisicao)  {
    requisicao.created_at = DateTime.now();
    requisicao.updated_at = DateTime.now();

    return requisicaoRef.add(requisicao.toJson()).then((v) {

      requisicao.id = v.id;


      return requisicaoRef.doc(requisicao.id).update(requisicao.toJson()).then((v) {


      }).catchError((err) {
        print('erro 1 ${err}');
        return null;
      });
    }).catchError((err) {
      print('erro 2 ${err}');
      return null;
    });
  }
  UpdateRequisicao(Requisicao requisicao)  {
    requisicao.updated_at = DateTime.now();

    if (requisicao != null) {

      return requisicaoRef
          .doc(requisicao.id)
          .update(requisicao.toJson())
          .then((v) {


        return 'Atualizado com sucesso!';
      }).catchError((err) {
        print('Error 23: ${err}');
        return 'Error: ${err}';
      });
    } else {
      return Future.delayed(Duration(seconds: 1)).then((v) {
        return 'Erro: Requisicao Nula';
      });
    }
  }


  @override
  void dispose() {

    requisicoesController.close();
  }
}
