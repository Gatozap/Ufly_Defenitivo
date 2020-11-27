import 'dart:convert';



import 'package:ufly/Objetos/Documentos/DocumentoCNH.dart';
import 'package:ufly/Objetos/Documentos/DocumentoCPF.dart';
import 'package:ufly/Objetos/Documentos/DocumentoRg.dart';
import 'Documentos/DocumentoRg.dart';

class User {
  String id;
  String nome;
    double zoom;
  String celular;
  String cpf;
  bool isMale;
  String email;
   String tipo;
  String senha;

  int permissao;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  DateTime data_nascimento;
  bool antecedentes;
  DateTime antecendete_verificados_em;

  bool isMotorista;

  String foto;
  String RG;
  String CNH;
  
  String conta_bancaria;
  List<DocumentoCNH> cnh;
  List<DocumentoRg> rg;
  List<DocumentoCPF> CPF;
  String telefone;
  String agencia;
  String numero_conta;
  bool isBanido;
  String documento_veiculo;





  User.Empty() {
    permissao = 0;
  }

  User(
      {this.id,
      this.nome,
        this.zoom,
        this.documento_veiculo,
        this.tipo,
      this.data_nascimento,
      this.celular,
      this.cpf,
      this.CPF,
        this.cnh,
      this.rg,
        this.RG, this.CNH,
      this.email,
      this.senha,
      this.numero_conta,
      this.agencia,
      this.permissao,
      this.created_at,
      this.updated_at,
      this.deleted_at,

      this.antecedentes,
      this.isMotorista,
      this.isMale,
      this.telefone,
      this.conta_bancaria,

      this.foto});

  User.fromJson( j) {



        this.zoom = j['zoom'] == null? 18.00: j['zoom'];
    this.id = j['id'] == null ? null : j['id'];
    this.CPF = j['CPF'] == null ? null : getDocumentosCPF(json.decode(j['CPF']));
    this.cnh = j['cnh'] == null ? null : getDocumentosCNH(json.decode(j['cnh']));
    this.rg = j['rg'] == null ? null : getDocumentosRg(json.decode(j['rg']));
    this.documento_veiculo = j['documento_veiculo'] == null? null : j['documento_veiculo'];
    this.telefone = j['telefone'] == null ? null : j['telefone'];
    this.conta_bancaria =
        j['conta_bancaria'] == null ? null : j['conta_bancaria'];
    this.RG = j['RG'] == null ? null : j['RG'];
    this.CNH = j['CNH'] == null ? null : j['CNH'];
    this.tipo = j['tipo'] == null ? null : j['tipo'];
    this.isMale = j['isMale'] == null ? false : j['isMale'];
    this.nome = j['nome'] == null ? null : j['nome'];
    this.agencia = j['agencia'] == null ? null : j['agencia'];
    this.numero_conta = j['numero_conta'] == null ? null : j['numero_conta'];

    this.data_nascimento = j['data_nascimento'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['data_nascimento']);

    this.celular = j['celular'] == null ? null : j['celular'];
    this.cpf = j['cpf'] == null ? null : j['cpf'];
    this.email = j['email'] == null ? null : j['email'];
    this.senha = j['senha'] == null ? null : j['senha'];

    this.antecendete_verificados_em = j['antecendete_verificados_em'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['antecendete_verificados_em']);

    this.antecedentes = j['antecedentes'] == null ? null : j['antecedentes'];

    this.permissao = j['permissao'] == null ? null : j['permissao'];
    this.created_at = j['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['created_at']);
    this.updated_at = j['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['updated_at']);
    this.deleted_at = j['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']);

    this.isMotorista = j['isMotorista'] == null ? null : j['isMotorista'];

    this.foto = j['foto'] == null ? null : j['foto'];
    this.data_nascimento = j['data_nascimento'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(j['data_nascimento']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpf'] = this.cpf;
    data['RG'] = this.RG;
    data['CNH'] = this.CNH;
    data['id'] = this.id;
    data['zoom'] = this.zoom;
    data['telefone'] = this.telefone;
    data['CPF'] = this.CPF == null ? null : json.encode(this.CPF);
    data['nome'] = this.nome;
      data['tipo'] = this.tipo;
    data['cnh'] = this.cnh == null ? null : json.encode(this.cnh);
    data['rg'] = this.rg == null ? null : json.encode(this.rg);
    data['documento_veiculo'] = this.documento_veiculo;




    data['numero_conta'] = this.numero_conta;
    data['agencia'] = this.agencia;

    data['conta_bancaria'] = this.conta_bancaria;

    data['data_nascimento'] = this.data_nascimento != null
        ? this.data_nascimento.millisecondsSinceEpoch
        : null;
    data['isMale'] = this.isMale;
    data['celular'] = this.celular;

    data['cpf'] = this.cpf;

    data['email'] = this.email;
    data['antecedentes'] = this.antecedentes;
    data['senha'] = this.senha;
    data['permissao'] = this.permissao;

    data['antecendete_verificados_em'] = this.antecendete_verificados_em != null
        ? this.antecendete_verificados_em.millisecondsSinceEpoch
        : null;
    data['created_at'] =
        this.created_at != null ? this.created_at.millisecondsSinceEpoch : null;
    data['updated_at'] =
        this.updated_at != null ? this.updated_at.millisecondsSinceEpoch : null;
    data['deleted_at'] =
        this.deleted_at != null ? this.deleted_at.millisecondsSinceEpoch : null;

    data['isMotorista'] = this.isMotorista;

    data['foto'] = this.foto;

    return data;
  }


  @override
  String toString() {
    return 'User{id: $id, nome: $nome,zoom:$zoom, celular: $celular, cpf: $cpf, isMale: $isMale, email: $email, tipo: $tipo, senha: $senha, permissao: $permissao, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, data_nascimento: $data_nascimento, antecedentes: $antecedentes, antecendete_verificados_em: $antecendete_verificados_em, isMotorista: $isMotorista, foto: $foto, RG: $RG, CNH: $CNH, conta_bancaria: $conta_bancaria, cnh: $cnh, rg: $rg, CPF: $CPF, telefone: $telefone, agencia: $agencia, numero_conta: $numero_conta, isBanido: $isBanido, documento_veiculo: $documento_veiculo}';
  }

  static getDocumentosCPF(decoded) {
    print('AQUI DECODED ${decoded}');
    List<DocumentoCPF> talentos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      talentos.add(DocumentoCPF.fromJson(i));
    }
    return talentos;
  }
  static getDocumentosCNH(decoded) {
    print('AQUI DECODED ${decoded}');
    List<DocumentoCNH> talentos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      talentos.add(DocumentoCNH.fromJson(i));
    }
    return talentos;
  }
  static getDocumentosRg(decoded) {
    print('AQUI DECODED ${decoded}');
    List<DocumentoRg> talentos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      talentos.add(DocumentoRg.fromJson(i));
    }
    return talentos;
  }
}
