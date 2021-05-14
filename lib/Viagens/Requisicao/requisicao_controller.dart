

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Objetos/User.dart';

class RequisicaoController extends BlocBase {
  BehaviorSubject<Requisicao> requisicaoController =       new BehaviorSubject<Requisicao>();

  Stream<Requisicao> get outRequisicao => requisicaoController.stream;

  Sink<Requisicao> get inRequisicao => requisicaoController.sink;
  Requisicao requisicao;


  RequisicaoController() {

    // Fired whenever a location is recorded

    requisicaoRef.where('user', isEqualTo: Helper.localUser.id)
        .get()
        .then((v) {
      List<Requisicao> requisicoes = [];
      for (var d in v.docs) {
        print('aqui requisicao 232 ${d.data()}');
        Requisicao m = Requisicao.fromJson(d.data());


        requisicoes.add(m);
      }
      print('aqui requisicao 0 ${requisicoes[0]}');
      requisicao = requisicoes[0];
      inRequisicao.add(requisicao);

    }).catchError((err) {
      print('aqui erro req 1 ${err}');

      requisicao = null;
      inRequisicao.add(requisicao);
    });
  }

 CriarRequisicao(Requisicao requisicao)  {
    requisicao.created_at = DateTime.now();
    requisicao.updated_at = DateTime.now();

    return requisicaoRef.add(requisicao.toJson()).then((v) {
      requisicao.id = v.id;
      print('aqui id ${v.id}');

      return requisicaoRef.doc(requisicao.id).update(requisicao.toJson()).then((v) {
        print('aqui id ${requisicao.id}');
        return dToast('Requisição criada com sucesso ${requisicao.id}');

      }).catchError((err) {
        print('erro  req cria 1 ${err}');
        return null;
      });
    }).catchError((err) {
      print('erro 2 ${err}');
      return null;
    });
  }

 UpdateRequisicao(Requisicao requisicao)  {
    requisicao.updated_at = DateTime.now();
    print('aqui ${requisicao.id}');
    if (requisicao != null) {
      print('aqui ${requisicao.tempo_estimado}');
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
    requisicaoController.close();
  }
}
