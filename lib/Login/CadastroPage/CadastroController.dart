



import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/HomePage.dart';

import 'package:ufly/Objetos/Carro.dart';
import 'package:ufly/Objetos/Documentos/DocumentoCNH.dart';

import 'package:ufly/Objetos/Documentos/DocumentoCPF.dart';
import 'package:ufly/Objetos/Documentos/DocumentoRg.dart';
import 'package:ufly/Objetos/Motorista.dart';

import 'package:ufly/Objetos/User.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rxdart/rxdart.dart';

class CadastroController implements BlocBase {

  BehaviorSubject<User> userController = BehaviorSubject<User>();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final databaseReference = FirebaseFirestore.instance.collection('Users');
  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;
 User user;

  BehaviorSubject<String> controllerCPF = BehaviorSubject<String>();
  Stream<String> get outCPF => controllerCPF.stream;
  Sink<String> get inCPF => controllerCPF.sink;
  String CPF;





  BehaviorSubject<String> controllerDrop = BehaviorSubject<String>();
  Stream<String> get outDrop => controllerDrop.stream;
  Sink<String> get inDrop => controllerDrop.sink;
  String Drop;

  BehaviorSubject<String> controllerCAU = BehaviorSubject<String>();
  Stream<String> get outCAU => controllerCAU.stream;
  Sink<String> get inCAU => controllerCAU.sink;
  String CAU;

  BehaviorSubject<bool> controllerisMale = BehaviorSubject<bool>();
  Stream<bool> get outIsMale => controllerisMale.stream;
  Sink<bool> get inIsMale => controllerisMale.sink;


  BehaviorSubject<bool> controllerisMotoristaSelected = BehaviorSubject<bool>();
  Stream<bool> get outIsMotoristaSelected => controllerisMotoristaSelected.stream;
  Sink<bool> get inIsMotoristaSelected => controllerisMotoristaSelected.sink;

  BehaviorSubject<bool> controllerisMotorista = BehaviorSubject<bool>();
  Stream<bool> get outisMotorista => controllerisMotorista.stream;
  Sink<bool> get inisMotorista => controllerisMotorista.sink;
  
  BehaviorSubject<String> controllerTelefone = BehaviorSubject<String>();
  Stream<String> get outTelefone => controllerTelefone.stream;
  Sink<String> get inTelefone => controllerTelefone.sink;
  String telefone;

  BehaviorSubject<String> controllerNome = BehaviorSubject<String>();
  Stream<String> get outNome => controllerNome.stream;
  Sink<String> get inNome => controllerNome.sink;
  String nome;

  BehaviorSubject<DocumentoCPF> controllerDocumentoCPF  = BehaviorSubject<DocumentoCPF>();
  Stream<DocumentoCPF> get outDocumentoCPF => controllerDocumentoCPF.stream;
  Sink<DocumentoCPF> get inDocumentoCPF => controllerDocumentoCPF.sink;
  DocumentoCPF documentoCPF;

  BehaviorSubject<DocumentoCNH> controllerDocumentoCNH  = BehaviorSubject<DocumentoCNH>();
  Stream<DocumentoCNH> get outDocumentoCNH => controllerDocumentoCNH.stream;
  Sink<DocumentoCNH> get inDocumentoCNH => controllerDocumentoCNH.sink;
  DocumentoCNH documentoCNH;

  BehaviorSubject<DocumentoRg> controllerDocumentoRg  = BehaviorSubject<DocumentoRg>();
  Stream<DocumentoRg> get outDocumentoRg => controllerDocumentoRg.stream;
  Sink<DocumentoRg> get inDocumentoRg => controllerDocumentoRg.sink;
  DocumentoRg documentoRg;

  BehaviorSubject<String> controllerDatanascimento = BehaviorSubject<String>();
  Stream<String> get outDatanascimento => controllerDatanascimento.stream;
  Sink<String> get inDatanascimento => controllerDatanascimento.sink;
  String datanascimento;

  BehaviorSubject<String> controllerCNH = BehaviorSubject<String>();
  Stream<String> get outCNH => controllerCNH.stream;
  Sink<String> get inCNH => controllerCNH.sink;
  String CNH;

  BehaviorSubject<String> controllerRG = BehaviorSubject<String>();
  Stream<String> get outRG => controllerRG.stream;
  Sink<String> get inRG => controllerRG.sink;
  String RG;

  BehaviorSubject<Carro> controllerCarro = BehaviorSubject<Carro>();
  Stream<Carro> get outCarro => controllerCarro.stream;
  Sink<Carro> get inCarro => controllerCarro.sink;
  Carro carro;

  BehaviorSubject<String> controllerPlaca = BehaviorSubject<String>();
  Stream<String> get outPlaca => controllerPlaca.stream;
  Sink<String> get inPlaca => controllerPlaca.sink;
  String placa;


  BehaviorSubject<String> controllerAno = BehaviorSubject<String>();
  Stream<String> get outAno => controllerAno.stream;
  Sink<String> get inAno => controllerAno.sink;
  String Ano;

  BehaviorSubject<String> controllerModelo = BehaviorSubject<String>();
  Stream<String> get outModelo => controllerModelo.stream;
  Sink<String> get inModelo => controllerModelo.sink;
  String Modelo;


  BehaviorSubject<String> controllerCor = BehaviorSubject<String>();
  Stream<String> get outCor => controllerCor.stream;
  Sink<String> get inCor => controllerCor.sink;
  String Cor;

  void updatePlaca(String plac) {
    placa = plac;
    inPlaca.add(placa);
  }

  void updateAno(String ano) {
    Ano = ano;
    inAno.add(Ano);
  }

  void updateCor(String cor) {
    Cor = cor;
    inCor.add(Cor);
  }

  void updateModelo(String modelo) {
    Modelo = modelo;
    inModelo.add(Modelo);
  }
  void updateRG(String rg) {
    RG = rg;
    inRG.add(RG);
  }


  void updateCNH(String cnh) {
    CNH = cnh;
    inCNH.add(CNH);
  }

  void updateTelefone(String tel) {
    telefone = tel;
    inTelefone.add(telefone);
  }


  void updatenome(String tel) {
    nome = tel;
    inNome.add(nome);
  }

  void updateDataNascimento(String data) {
    datanascimento = data;
    inDatanascimento.add(datanascimento);
  }

  void updateCAU(String cau) {
    CAU = cau;
    inCAU.add(CAU);
  }
  void updateCPF(String cpf) {
    CPF = cpf;
    inCPF.add(CPF);
  }


  Validar(int i, SwiperController sc, BuildContext context) async {
    switch (i) {
      case 1:
        if (telefone == '' ) {
          dToast(
              'Por Favor Preencha o Telefone');
        }
        break;
      case 2:


        break;

        case 3:
    break;
    }
  }

  registerUser(User data) {
    print('aqui user ${data.toString()}');
    return _auth
        .createUserWithEmailAndPassword(
        email: data.email.toLowerCase().replaceAll(' ', ''),
        password: data.senha)
        .then((result) {
      auth.User user = result.user;
      user.sendEmailVerification();
      data.created_at = DateTime.now();
      data.id = user.uid;
      data.senha = null;
      data.foto = user.photoURL;
      data.updated_at = DateTime.now();
      data.permissao = 0;
      
      data.tipo = 'Email';

      databaseReference.doc(user.uid).set(data.toJson()).then((v) {
        _auth.signOut();
      }).catchError((err) {});
      return 0;
    }).catchError((err) {
      print('Err: ${err.toString()}');
      erros(err.toString());
    });
  }

  BehaviorSubject<Motorista> controllerMotorista = BehaviorSubject<Motorista>();
  Stream<Motorista> get outMotorista => controllerMotorista.stream;
  Sink<Motorista> get inMotorista => controllerMotorista.sink;
  Motorista motorista;


  CadastroController({bool editar = false, this.carro, this.motorista}){

    inIsMale.add(false);
    inIsMotoristaSelected.add(false);
    inisMotorista.add(false);
    telefone = '';
    inTelefone.add(telefone);
    datanascimento = '';
    inDatanascimento.add(datanascimento);
  }

  void atualizarDados(SwiperController sc, BuildContext context) {
    outIsMotoristaSelected.first.then((isMotorista) {
      outIsMale.first.then((isMale) async {
        if (isMotorista != null || isMale || null) {
          if (telefone == '' || datanascimento == '') {
            dToast(
                'Por Favor Preencha ${telefone == ''
                    ? 'o Telefone'
                    : 'a Data de Nascimento'}');
            return;
          }
          Helper.localUser.isMotorista = isMotorista;
          Helper.localUser.isMale = isMale;

          Helper.localUser.RG = RG;
          Helper.localUser.CNH = CNH;
          Helper.localUser.cpf = CPF;
          Helper.localUser.zoom = 18.00;
          if(Helper.localUser.cpf == null){
            dToast('Preencha o CPF');
          }
          if(Helper.localUser.CNH == null){
            dToast('Preencha a CNH');
          }
          if(Helper.localUser.RG == null){
            dToast('Preencha o RG');
          }
          if (carro != null) {
            if (motorista.carro == null) {
              motorista.carro = new List<Carro>();
            }
            carro.created_at = DateTime.now();
            carro.updated_at = DateTime.now();
            motorista.carro.add(carro);
          }
          if (documentoCPF != null) {
            if (Helper.localUser.CPF == null) {
              Helper.localUser.CPF = new List<DocumentoCPF>();
            }
            documentoCPF.created_at = DateTime.now();
            documentoCPF.updated_at = DateTime.now();
            if (!documentoCPF.isValid) {
              dToast(
                  'Foto do documento Invalida por favor tente tirar a foto novamente');
              return;
            }
            Helper.localUser.CPF.add(documentoCPF);
          }
          if (documentoRg != null) {
            if (Helper.localUser.rg == null) {
              Helper.localUser.rg = new List<DocumentoRg>();
            }
            documentoRg.created_at = DateTime.now();
            documentoRg.updated_at = DateTime.now();
            if (!documentoRg.isValid) {
              dToast(
                  'Foto do documento Invalida por favor tente tirar a foto novamente');
              return;
            }
            Helper.localUser.rg.add(documentoRg);
          }
          if (documentoCNH != null) {
            if (Helper.localUser.cnh == null) {
              Helper.localUser.cnh = new List<DocumentoCNH>();
            }
            documentoCNH.created_at = DateTime.now();
            documentoCNH.updated_at = DateTime.now();
            if (!documentoCNH.isValid) {
              dToast(
                  'Foto do documento Invalida por favor tente tirar a foto novamente');
              return;
            }
            Helper.localUser.cnh.add(documentoCNH);
          }

          userRef
              .doc(Helper.localUser.id)
              .update(Helper.localUser.toJson())
              .then((v) {
            dToast('Conta criada com sucesso!');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => Helper.localUser.isMotorista == true? Consumer<Position>(
                        builder: (context, position, widget) {
                          return CorridaPage(position);
                        }
                    ): Consumer<Position>(
                        builder: (context, position, widget) {
                          return HomePage(position);
                        }
                    )));
          }).catchError((err) {
            return null;
          });


        }
      });
    });
  }
  erros(data) {
    switch (data) {
      case 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)':
        dToastTop('E-mail já existe, tente outro e-mail');
        break;

      case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
        dToastTop(
            'Insira um e-mail válido contendo @hotmail.com ou @gmail.com e entre outros');
        break;

      default: dToastTop(data);
      break;
    }
  }
  @override
  void dispose() {
   userController.close();
   controllerTelefone.close();
   controllerDatanascimento.close();
   controllerisMotorista.close();
   controllerisMotoristaSelected.close();
   controllerisMale.close();
   controllerDocumentoRg.close();
   controllerDocumentoCPF.close();
   controllerDocumentoCNH.close();
  }

}