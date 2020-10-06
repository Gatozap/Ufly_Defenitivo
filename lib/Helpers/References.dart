import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference userRef = FirebaseFirestore.instance.collection('Users');
CollectionReference chatRef = FirebaseFirestore.instance.collection('Chats');
CollectionReference notificacoesRef = FirebaseFirestore.instance.collection('Notificacoes');
CollectionReference gruposRef = FirebaseFirestore.instance.collection('Grupo');
CollectionReference motoristaRef = FirebaseFirestore.instance.collection('Motorista');
CollectionReference personagensRef =
FirebaseFirestore.instance.collection('Personagens');


CollectionReference carrosRef =
FirebaseFirestore.instance.collection('Carro');

CollectionReference periciasRef =
FirebaseFirestore.instance.collection('Pericias');

CollectionReference talentosRef =
FirebaseFirestore.instance.collection('Talentos');

CollectionReference equipamentosRef =
FirebaseFirestore.instance.collection('Equipamentos');


CollectionReference prestadorRef =
FirebaseFirestore.instance.collection('Prestadores');


