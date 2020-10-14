import 'dart:io';
import 'package:ufly/Helpers/SqliteDatabase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ufly/Objetos/CorridaTeste.dart';
import 'corrida_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/CarroAtivo.dart';
import 'dart:async';
import 'dart:convert';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Objetos/Localizacao.dart';

class CorridaFirebaseSender {
  DatabaseReference corridaRef;
  DatabaseReference pointsRef;
  SharedPreferences sp;

  Corrida corrida;
  CorridaFirebaseSender() {}

  AdicionarLatLng(Localizacao l, double distancia) {
    try {
      if (corrida == null) {
        SharedPreferences.getInstance().then((value) {
          sp = value;
          try {
            corrida = Corrida.fromJson(json.decode(sp.getString('corrida')));
          } catch (err) {
            print('Erro ao buscar Corrida ${err.toString()}');
          }
        });
      }
      SharedPreferences.getInstance().then((value) {
        CarroAtivo ca = CarroAtivo.fromJson(json.decode(value.getString('ca')));
        ca.localizacao = l;
        carrosAtivosRef
            .child(Helper.localUser.id)
            .set(ca.toJson())
            .then((value) {
          print('Localização Atualizada');
        });
      }).catchError((err) {
        print('Erro ao atualizar ativo: ${err.toString()}');
      });
      print("GUARDANDO LOCALIZAÇÂO");
      l.corrida = corrida.id;
      // carrosAtivosRef.child(Helper.localUser.id).set(value)


      add(l);
    } catch (err) {
      print('Erro ao salvar no banco de dados: ${err.toString()}');
    }
    try {
      print("AQUI CORRIDA ${corrida.id}");
      corridaRef.update({
        'dist': distancia,
        'last_seen': DateTime.now().millisecondsSinceEpoch
      });
    } catch (err) {
      print('Erro ao atualizar localização');
    }
  }

  PararLigacao(Carro carro) async {
    print('INICIANDO PARAR');
    corrida.isRunning = false;

    corridaRef.update({'isRunning': false});
    List localizacoes = await getAll();
    ContabilizarCorrida(carro, localizacoes);

    SharedPreferences.getInstance().then((value) {
      CarroAtivo ca = CarroAtivo.fromJson(json.decode(value.getString('ca')));
      ca.isAtivo = false;
      carrosAtivosRef.child(Helper.localUser.id).set(ca.toJson()).then((value) {
        print('Localização Atualizada');
      });
    }).catchError((err) {
      print('Erro ao atualizar ativo: ${err.toString()}');
    });
    //TODO COMPUTAR OS DADOS PRO FIRESTORE
    Future.delayed(Duration(seconds: 5)).then((value) => (v) {
          sp.setString('corrida', '');
          corridaRef = null;
          pointsRef = null;
          corrida = null;
        });
  }

  IniciarLigacao(Carro carroSelecionado) {
    print('INICIANDO LIGAÇÂO');
    if (started) {
      SharedPreferences.getInstance().then((value) {
        sp = value;
        try {
          corrida = Corrida.fromJson(json.decode(sp.getString('corrida')));
        } catch (err) {
          print('Erro ao buscar Corrida ${err.toString()}');
        }

        if (corrida != null) {
          print("AQUI A DIABA DA CORRIDA ${corrida.toString()}");
          corridaRef = FirebaseDatabase.instance
              .reference()
              .child('Corridas')
              .reference()
              .child(corrida.id);
          pointsRef = corridaRef.child('points');
          corridaRef.once().then((value) {
            corrida = Corrida.fromJson(value.value);
            sp.setString('corrida', json.encode(corrida.toJson()));
            print('INICIADA LIGAÇÂO 2 ${corrida.id}');
          });
        } else {
          corrida = Corrida(
            user: Helper.localUser.id,
            id_carro: carroSelecionado.id,
            dist: 0.0,
            isRunning: true,
          );
          corridaRef = FirebaseDatabase.instance
              .reference()
              .child('Corridas')
              .reference()
              .push();
          corridaRef.set(corrida.toJson());
          corrida.id = corridaRef.key;
          corridaRef.update({'id': corrida.id});
          PrepararCarroAtivo(carroSelecionado);
          sp.setString('corrida', json.encode(corrida));
          pointsRef = corridaRef.child('points');
          print('INICIADA LIGAÇÂO ${corrida.id}');
        }
      });
    }
  }

  Future<void> ContabilizarCorrida(Carro carro, localizacoes) async {
    print('INICIANDO CONTABILIZAR');
    List localizacoesTemp = new List();
    for (var l1 in localizacoes) {
      if (l1.corrida == corrida.id) {
        localizacoesTemp.add(l1);
      }
    }
    localizacoes = localizacoesTemp;

    DeletarPontos();
  }

  Future uploadFile(File file, Corrida corrida) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('localizacoes/${corrida.id}.json');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      corrida.points_path = fileURL;
      corrida.points = null;
      corridasRef.doc(corrida.id).update({
        'points_path': corrida.points_path,
        'points': corrida.points,
        'id': corrida.id,
        'id_corrida': corrida.id,
      }).then((value) {
        print("LALA ${corrida.points_path} e ${corrida.points}");
        print('Corrida atualizada ${corrida.id}');
      });
    });
  }

  void PrepararCarroAtivo(Carro carro) {
    CarroAtivo ca = CarroAtivo(
        user_id: Helper.localUser.id,
        isAtivo: true,
        user_nome: Helper.localUser.nome,
        localizacao: null);
    sp.setString('ca', json.encode(ca.toJson()));
    carrosAtivosRef.child(Helper.localUser.id).set(ca.toJson()).then((value) {
      print('Localização Preparada');
    });
  }
}
