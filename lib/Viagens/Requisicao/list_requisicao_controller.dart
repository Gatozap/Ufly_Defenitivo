import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/Requisicao.dart';
import 'package:ufly/Objetos/User.dart';

class ListRequisicaoController extends BlocBase {


  BehaviorSubject<List<Requisicao>> requisicoesController =
  BehaviorSubject<List<Requisicao>>();
  Stream<List<Requisicao>> get outRequisicoes => requisicoesController.stream;
  Sink<List<Requisicao>> get inRequisicoes => requisicoesController.sink;
  List<Requisicao> requisicoes;
  List<Requisicao> requesicoesmain;



  ListRequisicaoController() {
    requisicaoRef
        .snapshots()
        .listen((QuerySnapshot snap) {
      requisicoes = new List();
      if (snap.docs.length > 0) {
        for (DocumentSnapshot ds in snap.docs) {
          Requisicao p =  Requisicao.fromJson(ds.data());
          p.id = ds.id;
          requisicoes.add(p);

        }
        requisicoes.sort(
                (Requisicao a, Requisicao b) => a.id.compareTo(b.id));
        requesicoesmain = requisicoes;
        inRequisicoes.add(requisicoes);
      } else {
        inRequisicoes.add(requisicoes);
      }
    }).onError((err) {
      print('Erro: ${err.toString()}');
    });

  }



  UpdateRequisicao(Requisicao requisicao)  {
    requisicao.updated_at = DateTime.now();
    print('aqui ${requisicao.id}');
    if (requisicao != null) {
      print('aqui ${requisicao.id}');
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
