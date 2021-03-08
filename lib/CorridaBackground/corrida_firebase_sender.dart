import 'dart:io';
import 'package:ufly/Helpers/SqliteDatabase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:ufly/Objetos/CorridaTeste.dart';
import 'package:ufly/Objetos/Motorista.dart';
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

      SharedPreferences.getInstance().then((value) {
        CarroAtivo ca = CarroAtivo.fromJson(json.decode(value.getString('ca')));
        ca.localizacao = l;
        print('aqui a localizacao ${ca.isAtivo}');
        carrosAtivosRef
            .child(Helper.localUser.id)
            .set(ca.toJson())
            .then((value) {
          print('Localização Atualizada');
        });
      }).catchError((err) {
        print('Erro ao atualizar ativo: ${err.toString()}');
      });

      

      // carrosAtivosRef.child(Helper.localUser.id).set(value)


      add(l);

    } catch (err) {
      print('Erro ao salvar no banco de dados: ${err.toString()}');
    }

  }

  PararLigacao(Carro carro) async {
    print('INICIANDO PARAR');
    corrida.isRunning = false;
    corridaRef.update({
      'isRunning': false
    });



    print('aqui corrida');

    SharedPreferences.getInstance().then((value) {
      CarroAtivo ca = CarroAtivo.fromJson(json.decode(value.getString('ca')));
      gravarCorridaFirestore(ca);
      ca.isAtivo = false;
      print('aqui a porra do ativo ${ca.isAtivo}');
      
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
  gravarCorridaFirestore(CarroAtivo carro) {
    print('INICIANDO GRAVAR 3232');
    Corrida c = corrida;

    c.id_carro = carro.carro_id;
    corridasRef.add(c.toJson()).then((v) {
      c.id = v.id;
      print('INICIANDO GRAVAR 32332');
      corridasRef
          .doc(v.id)
          .update(c.toJson())
          .then((d) async { print('salvou a corrida');
      }).catchError((err) {
        print('ERRO AO SALVAR CORRIDA ${err.toString()}');
      });
    }).catchError((err) {
      print('ERRO AO SALVAR CORRIDA ${err.toString()}');
    });
  }
  IniciarLigacao(Carro carroSelecionado) {
    print('INICIANDO LIGAÇÂO');
    if (started) {
      print('INICIANDO LIGAÇÂO ${started}');
      SharedPreferences.getInstance().then((value) {
        sp = value;
        try {
          corrida = Corrida.fromJson(json.decode(sp.getString('corrida')));
          print('INICIANDO aqui ${corrida}');
        } catch (err) {
          print('Erro ao buscar Corrida ${err.toString()}');
        }

        if (corrida != null && corrida.id != null) {
          print("AQUI A DIABA DA CORRIDA ${corrida.toString()}");
          corridaRef = FirebaseDatabase.instance
              .reference()
              .child('Corridas')
              .reference()
              .child(corrida.id);
          pointsRef = corridaRef.child('points');
          corridaRef.once().then((value) {
            print("AQUI A DIABA DA CORRIDA  2${value.value}");
            corrida = Corrida.fromJson(value.value);
            sp.setString('corrida', json.encode(corrida.toJson()));
            print('INICIADA LIGAÇÂO 4');
          });
        } else {
          print('INICIADA LIGAÇÂO 3');
          corrida = Corrida(
            user: Helper.localUser.id,
            id_carro: carroSelecionado.id,
            dist: 0.0,
            isRunning: true,);
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
    Reference storageReference =
        FirebaseStorage.instance.ref().child('localizacoes/${corrida.id}.json');
    UploadTask  uploadTask = storageReference.putFile(file);
    await uploadTask.then((TaskSnapshot snapshot) {
      print('Upload complete!');
    })
        .catchError((Object e) {
      print(e); // FirebaseException
    });
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      corrida.points_path = fileURL;
      corrida.points = null;
      corridasRef.doc(corrida.id).update({
        'points_path': corrida.points_path,
        'points': corrida.points,
       // 'id': corrida.id.toString(),
        'id_corrida': corrida.id,
      }).then((value) {
        print("LALA ${corrida.points_path} e ${corrida.points}");
        print('Corrida atualizada ${corrida.id.toString()}');
      });
    });
  }

  void PrepararCarroAtivo(Carro carro) {
    CarroAtivo ca = CarroAtivo(
        user_id: Helper.localUser.id,
        isAtivo: true,
        user_nome: Helper.localUser.nome,
        carro_id: carro.id,

        localizacao: null);
    sp.setString('ca', json.encode(ca.toJson()));
    carrosAtivosRef.child(Helper.localUser.id).set(ca.toJson()).then((value) {
      print('Localização Preparada');
    });
  }
}
