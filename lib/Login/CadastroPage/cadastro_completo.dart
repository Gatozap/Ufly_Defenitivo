import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:ufly/Carro/CarroController.dart';
import 'package:ufly/Carro/cadastro_carro_controller.dart';
import 'package:ufly/CorridaBackground/corrida_page.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Helpers/References.dart';
import 'package:ufly/Helpers/Rekonizer.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:ufly/Helpers/Styles.dart';
import 'package:ufly/HomePage.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Login/CadastroPage/CadastroController.dart';
import 'package:ufly/Login/Login.dart';
import 'package:ufly/Objetos/Carro.dart';

import 'package:ufly/Objetos/Documentos/DocumentoCNH.dart';
import 'package:ufly/Objetos/Documentos/DocumentoCPF.dart';
import 'package:ufly/Objetos/Documentos/DocumentoRg.dart';
import 'package:ufly/Objetos/Motorista.dart';
import 'package:ufly/Objetos/User.dart';
import 'package:ufly/Perfil/PerfilController.dart';

class CadastroCompleto extends StatefulWidget {
  User user;
  Carro carro;
  Motorista motorista;
  CadastroCompleto({this.user, this.motorista, this.carro});

  @override
  _CadastroCompletoState createState() => _CadastroCompletoState();
}

class _CadastroCompletoState extends State<CadastroCompleto> {
  ProgressDialog pr;
  Carro c;
  CadastroCarroController carroController;
  PerfilController perfilController;
  bool documento_salvo = false;
  @override
  void initState() {
    super.initState();
    if (carroController == null) {
      carroController = CadastroCarroController(carro: widget.carro);
    }
    if (perfilController == null) {
      perfilController = PerfilController(Helper.localUser);
    }
  }

  SwiperController sc = new SwiperController();
  CadastroController cc = new CadastroController();
  var controllercpf =
      new MaskedTextController(text: '', mask: '000.000.000-00');
  Future getDocumentoCNHCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(13, context), fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(19, context), fontWeight: FontWeight.w600));
    //pr.show();
    if (cc.documentoCNH == null) {
      cc.documentoCNH = DocumentoCNH();
    }

    if (cc.documentoCNH.frente != null && cc.documentoCNH.verso == null) {
      cc.documentoCNH.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      for (String s in plavras) {
        print(text);
      }
    }

    if (cc.documentoCNH.frente == null) {
      cc.documentoCNH.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      String sequencial = text.replaceAll('\n', ' ');
      var s = validarDocumento(sequencial);
      if (s != null) {
        switch (s) {
          case documentos.CNH:
            cc.documentoCNH.tipo = 'CNH';
            cc.documentoCNH.isValid = true;
            cc.documentoCNH.data = sequencial;
            cc.inDocumentoCNH.add(cc.documentoCNH);
            break;
          case documentos.PASSAPORTE:
            cc.documentoCNH.tipo = 'PASSAPORTE';
            cc.documentoCNH.isValid = true;
            cc.documentoCNH.data = sequencial;
            cc.inDocumentoCNH.add(cc.documentoCNH);
            break;
        }
        ;
      } else {
        cc.documentoCNH.isValid = true;
        cc.inDocumentoCNH.add(cc.documentoCNH);
      }
    }

    cc.inDocumentoCNH.add(cc.documentoCNH);
    pr.hide();
    dToast('Salvando Foto!');
  }

  Future getDocumentoCNH() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('aqui o image ${image.path}');
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(13, context), fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(19, context), fontWeight: FontWeight.w600));
    if (image.path == null) {
      print('erro');
      dToast('Erro ao salvar imagem');
    } else {
      //pr.show();
      if (cc.documentoCNH == null) {
        cc.documentoCNH = DocumentoCNH();
      }
      print('aqui cc ${cc.documentoCNH}');
      if (cc.documentoCNH.frente != null && cc.documentoCNH.verso == null) {
        cc.documentoCNH.verso = await uploadPicture(
          image.path != null ? image.path : Container(),
        );
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        vision.BatchAnnotateImagesResponse result =
            await RekognizeProvider().search(base64Image);
        print('AQUI RECONHECIMENTO ${result.toJson()}');

        List<Map<String, Object>> r = result.toJson()['responses'];
        Map<String, Object> r2 = r[0]['fullTextAnnotation'];
        String text = r2['text'];
        List<String> plavras = text.split('\n');
        for (String s in plavras) {
          print(text);
        }
      }

      if (cc.documentoCNH.frente == null) {
        cc.documentoCNH.frente = await uploadPicture(
          image.path,
        );
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        vision.BatchAnnotateImagesResponse result =
            await RekognizeProvider().search(base64Image);
        print('AQUI RECONHECIMENTO ${result.toJson()}');

        List<Map<String, Object>> r = result.toJson()['responses'];
        Map<String, Object> r2 = r[0]['fullTextAnnotation'];
        String text = r2['text'];
        List<String> plavras = text.split('\n');
        String sequencial = text.replaceAll('\n', ' ');
        var s = validarDocumento(sequencial);
        if (s != null) {
          switch (s) {
            case documentos.CNH:
              cc.documentoCNH.tipo = 'CNH';
              cc.documentoCNH.isValid = true;
              cc.documentoCNH.data = sequencial;
              cc.inDocumentoCNH.add(cc.documentoCNH);
              break;
          }
        } else {
          cc.documentoCNH.isValid = true;
          cc.inDocumentoCNH.add(cc.documentoCNH);
        }
      }

      cc.inDocumentoCNH.add(cc.documentoCNH);
      pr.hide();
      dToast('Salvando Foto!');
    }
  }

  Future getDocumentoCPFCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(13, context), fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize:ResponsivePixelHandler.toPixel(19, context), fontWeight: FontWeight.w600));
    //pr.show();
    if (cc.documentoCPF == null) {
      cc.documentoCPF = DocumentoCPF();
    }

    if (cc.documentoCPF.frente != null && cc.documentoCPF.verso == null) {
      cc.documentoCPF.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      for (String s in plavras) {
        print(text);
      }
    }

    if (cc.documentoCPF.frente == null) {
      cc.documentoCPF.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      String sequencial = text.replaceAll('\n', ' ');
      var s = validarDocumento(sequencial);
      if (s != null) {
        switch (s) {
          case documentos.RG:
            cc.documentoCNH.tipo = 'RG';
            cc.documentoCNH.isValid = true;
            cc.documentoCNH.data = sequencial;
            cc.inDocumentoCNH.add(cc.documentoCNH);
            break;
          case documentos.CPF:
            cc.CPF = getCPF(sequencial);
            cc.documentoCNH.tipo = 'CPF';
            print("AQUI CPF${getCPF(sequencial)}");
            cc.inCPF.add(cc.CPF);
            cc.documentoCNH.isValid = true;
            cc.documentoCNH.data = sequencial;
            cc.inDocumentoCNH.add(cc.documentoCNH);
            break;
          case documentos.CNH:
            cc.documentoCPF.tipo = 'CNH';
            cc.documentoCPF.isValid = true;
            cc.documentoCPF.data = sequencial;
            cc.inDocumentoCPF.add(cc.documentoCPF);
            break;
          case documentos.PASSAPORTE:
            cc.documentoCPF.tipo = 'PASSAPORTE';
            cc.documentoCPF.isValid = true;
            cc.documentoCPF.data = sequencial;
            cc.inDocumentoCPF.add(cc.documentoCPF);
            break;
        }
        ;
      } else {
        cc.documentoCPF.isValid = true;
        cc.inDocumentoCPF.add(cc.documentoCPF);
      }
    }

    cc.inDocumentoCPF.add(cc.documentoCPF);
    pr.hide();
    dToast('Salvando Foto!');
  }

  Future getDocumentoCPF() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('aqui o image ${image.path}');
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(13, context), fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(19, context), fontWeight: FontWeight.w600));
    if (image.path == null) {
      print('erro');
      dToast('Erro ao salvar imagem');
    } else {
      //pr.show();
      if (cc.documentoCPF == null) {
        cc.documentoCPF = DocumentoCPF();
      }
      if (cc.documentoCPF.frente != null && cc.documentoCPF.verso == null) {
        cc.documentoCPF.verso = await uploadPicture(
          image.path != null ? image.path : Container(),
        );
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        vision.BatchAnnotateImagesResponse result =
            await RekognizeProvider().search(base64Image);
        print('AQUI RECONHECIMENTO ${result.toJson()}');

        List<Map<String, Object>> r = result.toJson()['responses'];
        Map<String, Object> r2 = r[0]['fullTextAnnotation'];
        String text = r2['text'];
        List<String> plavras = text.split('\n');
        for (String s in plavras) {
          print(text);
        }
      }

      if (cc.documentoCPF.frente == null) {
        cc.documentoCPF.frente = await uploadPicture(
          image.path,
        );
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        vision.BatchAnnotateImagesResponse result =
            await RekognizeProvider().search(base64Image);
        print('AQUI RECONHECIMENTO ${result.toJson()}');

        List<Map<String, Object>> r = result.toJson()['responses'];
        Map<String, Object> r2 = r[0]['fullTextAnnotation'];
        String text = r2['text'];
        List<String> plavras = text.split('\n');
        String sequencial = text.replaceAll('\n', ' ');
        var s = validarDocumento(sequencial);
        if (s != null) {
          switch (s) {
            case documentos.RG:
              cc.documentoCPF.tipo = 'RG';
              cc.documentoCPF.isValid = true;
              cc.documentoCPF.data = sequencial;
              cc.inDocumentoCPF.add(cc.documentoCPF);
              break;
            case documentos.CPF:
              cc.CPF = getCPF(sequencial);
              cc.documentoCPF.tipo = 'CPF';
              print("AQUI CPF${getCPF(sequencial)}");
              cc.inCPF.add(cc.CPF);
              cc.documentoCPF.isValid = true;
              cc.documentoCPF.data = sequencial;
              cc.inDocumentoCPF.add(cc.documentoCPF);
              break;
            case documentos.CNH:
              cc.documentoCPF.tipo = 'CNH';
              cc.documentoCPF.isValid = true;
              cc.documentoCPF.data = sequencial;
              cc.inDocumentoCPF.add(cc.documentoCPF);
              break;
            case documentos.PASSAPORTE:
              cc.documentoCPF.tipo = 'PASSAPORTE';
              cc.documentoCPF.isValid = true;
              cc.documentoCPF.data = sequencial;
              cc.inDocumentoCPF.add(cc.documentoCPF);
              break;
          }
          ;
        } else {
          cc.documentoCPF.isValid = true;
          cc.inDocumentoCPF.add(cc.documentoCPF);
        }
      }

      cc.inDocumentoCNH.add(cc.documentoCNH);
      pr.hide();
      dToast('Salvando Foto!');
    }
  }

  Future getDocumentoRgCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(13, context), fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(19, context), fontWeight: FontWeight.w600));
    //pr.show();
    if (cc.documentoRg == null) {
      cc.documentoRg = DocumentoRg();
    }

    if (cc.documentoRg.frente != null && cc.documentoRg.verso == null) {
      cc.documentoRg.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      for (String s in plavras) {
        print(text);
      }
    }

    if (cc.documentoRg.frente == null) {
      cc.documentoRg.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      String sequencial = text.replaceAll('\n', ' ');
      var s = validarDocumento(sequencial);
      if (s != null) {
        switch (s) {
          case documentos.RG:
            cc.documentoRg.tipo = 'RG';
            cc.documentoRg.isValid = true;
            cc.documentoRg.data = sequencial;
            cc.inDocumentoRg.add(cc.documentoRg);
            break;
          case documentos.CNH:
            cc.documentoRg.tipo = 'CNH';
            cc.documentoRg.isValid = true;
            cc.documentoRg.data = sequencial;
            cc.inDocumentoRg.add(cc.documentoRg);
            break;
          case documentos.PASSAPORTE:
            cc.documentoRg.tipo = 'PASSAPORTE';
            cc.documentoRg.isValid = true;
            cc.documentoRg.data = sequencial;
            cc.inDocumentoRg.add(cc.documentoRg);
            break;
        }
        ;
      } else {
        cc.documentoRg.isValid = true;
        cc.inDocumentoRg.add(cc.documentoRg);
      }
    }

    cc.inDocumentoRg.add(cc.documentoRg);
    pr.hide();
    dToast('Salvando Foto!');
  }

  Future getDocumentoRg() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('aqui o image ${image.path}');
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(13, context), fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: ResponsivePixelHandler.toPixel(19, context), fontWeight: FontWeight.w600));
    if (image.path == null) {
      print('erro');
      dToast('Erro ao salvar imagem');
    } else {
      //pr.show();
      if (cc.documentoRg == null) {
        cc.documentoRg = DocumentoRg();
      }
      if (cc.documentoRg.frente != null && cc.documentoRg.verso == null) {
        cc.documentoRg.verso = await uploadPicture(
          image.path != null ? image.path : Container(),
        );
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        vision.BatchAnnotateImagesResponse result =
            await RekognizeProvider().search(base64Image);
        print('AQUI RECONHECIMENTO ${result.toJson()}');

        List<Map<String, Object>> r = result.toJson()['responses'];
        Map<String, Object> r2 = r[0]['fullTextAnnotation'];
        String text = r2['text'];
        List<String> plavras = text.split('\n');
        for (String s in plavras) {
          print(text);
        }
      }

      if (cc.documentoRg.frente == null) {
        cc.documentoRg.frente = await uploadPicture(
          image.path,
        );
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        vision.BatchAnnotateImagesResponse result =
            await RekognizeProvider().search(base64Image);
        print('AQUI RECONHECIMENTO ${result.toJson()}');

        List<Map<String, Object>> r = result.toJson()['responses'];
        Map<String, Object> r2 = r[0]['fullTextAnnotation'];
        String text = r2['text'];
        List<String> plavras = text.split('\n');
        String sequencial = text.replaceAll('\n', ' ');
        var s = validarDocumento(sequencial);
        if (s != null) {
          switch (s) {
            case documentos.RG:
              cc.documentoRg.tipo = 'RG';
              cc.documentoRg.isValid = true;
              cc.documentoRg.data = sequencial;
              cc.inDocumentoRg.add(cc.documentoRg);
              break;

            case documentos.CNH:
              cc.documentoRg.tipo = 'CNH';
              cc.documentoRg.isValid = true;
              cc.documentoRg.data = sequencial;
              cc.inDocumentoRg.add(cc.documentoRg);
              break;
            case documentos.PASSAPORTE:
              cc.documentoRg.tipo = 'PASSAPORTE';
              cc.documentoRg.isValid = true;
              cc.documentoRg.data = sequencial;
              cc.inDocumentoRg.add(cc.documentoRg);
              break;
          }
          ;
        } else {
          cc.documentoRg.isValid = true;
          cc.inDocumentoRg.add(cc.documentoRg);
        }
      }

      cc.inDocumentoRg.add(cc.documentoRg);
      pr.hide();
      dToast('Salvando Foto!');
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    ResponsivePixelHandler.init(
      baseWidth: 360, //A largura usado pelo designer no modelo desenhado
    );
    if(c == null){
      c = Carro.Empty();
    }
    int duracao = 300;

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(

                title: hTextAbel('Deseja voltar a tela de login?', context,
                    size: 20, weight: FontWeight.bold),
                actions: <Widget>[
                  MaterialButton(
                    child: hTextAbel('Cancelar', context, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  MaterialButton(
                    child: hTextAbel('Sim', context, size: 20),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login()));
                      userRef.doc(Helper.localUser.id).delete();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
          body: StreamBuilder<bool>(
              stream: cc.outIsMotoristaSelected,
              builder: (context, isMotorista) {
                var telefone = MaskedTextController(
                    text: cc.telefone, mask: '(00) 00000-0000');
                var dataNascimento = MaskedTextController(
                    text: cc.datanascimento, mask: '00/00/0000');
                var CPF =
                    MaskedTextController(text: cc.CPF, mask: '000.000.000-00');
                var controllerRG = TextEditingController(text: cc.RG);
                if (isMotorista == null) {
                  return Container();
                }
                if (isMotorista.hasData) {
                  return Swiper(
                    // ignore: missing_return
                    itemBuilder: (BuildContext context, int index) {
                      switch (index) {
                        case 0:
                          return Stack(children: <Widget>[
                            isMotorista.data == true
                                ? Positioned(
                                    child: MaterialButton(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                        color: Colors.blue,
                                        onPressed: index != null
                                            ? index < 5 - 1
                                                ? () {
                                                    sc.next(animation: true);
                                                  }
                                                : null
                                            : null,
                                        shape: new CircleBorder(
                                            side:
                                                BorderSide(color: Colors.blue))),
                                    bottom: 5,
                                    right: 10,
                                  )
                                : Container(),
                            SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: ResponsivePixelHandler.toPixel(40, context)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        hTextBank(
                                          'UFLY',
                                          context,
                                          color: Color.fromRGBO(255, 184, 0, 1),
                                          size: 30,
                                        ),
                                        sb,
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ResponsivePixelHandler.toPixel(35, context)),
                                          child: hTextMal('AJUDA', context,
                                              size: 25, weight: FontWeight.bold),
                                        ),sb,sb,
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
                                              userRef.doc(Helper.localUser.id).delete();
                                            }
                                            ,child: hTextMal('ENTRAR', context, size: 25, weight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  sb, Divider(color: Colors.black), sb,

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ResponsivePixelHandler.toPixel(5, context)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          height: getAltura(context) * .070,
                                          width: getLargura(context) * .6,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  cc.inIsMotoristaSelected
                                                      .add(false);
                                                },
                                                child: hTextAbel(
                                                  'Passageiro',
                                                  context,
                                                  size: 20,
                                                  weight: FontWeight.bold,
                                                  color: isMotorista.data == false
                                                      ? corPrimaria
                                                      : Colors.black,
                                                ),
                                              ),
                                              sb,
                                              hText('|', context, size: 20),
                                              sb,
                                              GestureDetector(
                                                onTap: () {
                                                  cc.inIsMotoristaSelected
                                                      .add(true);
                                                },
                                                child: hTextAbel(
                                                  'Motorista',
                                                  context,
                                                  size: 20,
                                                  weight: FontWeight.bold,
                                                  color: isMotorista.data == false
                                                      ? Colors.black
                                                      : corPrimaria,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),



                                  StreamBuilder<bool>(
                                      stream: cc.outIsMale,
                                      builder: (context, isMale) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: getAltura(context) * .020),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                height: getAltura(context) * .070,
                                                width: getLargura(context) * .6,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        cc.inIsMale.add(false);
                                                      },
                                                      child: hTextAbel(
                                                        'Feminino',
                                                        context,
                                                        size: 20,
                                                        weight: FontWeight.bold,
                                                        color:
                                                            isMale.data == false
                                                                ? corPrimaria
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                    sb,
                                                    hText('|', context, size: 20),
                                                    sb,
                                                    GestureDetector(
                                                      onTap: () {
                                                        cc.inIsMale.add(true);
                                                      },
                                                      child: hTextAbel(
                                                        'Masculino',
                                                        context,
                                                        size: 20,
                                                        weight: FontWeight.bold,
                                                        color:
                                                            isMale.data == false
                                                                ? Colors.black
                                                                : corPrimaria,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                      StreamBuilder<bool>(
                                          stream: cc.outisMoto,
                                          builder: (context, isMoto) {
                                            return Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: getAltura(context) * .020),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(20),
                                                    ),
                                                    height: getAltura(context) * .070,
                                                    width: getLargura(context) * .6,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            cc.inisMoto.add(true);
                                                            print('moto ${isMoto.data}');
                                                          },
                                                          child: hTextAbel(
                                                            'Carro',
                                                            context,
                                                            size: 20,
                                                            weight: FontWeight.bold,
                                                            color:
                                                            isMoto.data == false
                                                                ? Colors.black
                                                                : corPrimaria,
                                                          ),
                                                        ),
                                                        sb,
                                                        hText('|', context, size: 20),
                                                        sb,
                                                        GestureDetector(
                                                          onTap: () {
                                                            cc.inisMoto.add(false);
                                                          },
                                                          child: hTextAbel(
                                                            'Moto',
                                                            context,
                                                            size: 20,
                                                            weight: FontWeight.bold,
                                                            color:
                                                            isMoto.data == false
                                                                ? corPrimaria
                                                                : Colors.black,
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () => showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return
                                                      AlertDialog(
                                                      title: hText(
                                                          "Selecione uma opção",
                                                          context),
                                                      content:
                                                      SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            defaultActionButton(
                                                                'Galeria',
                                                                context, () {
                                                              getImage();
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                                icon: MdiIcons
                                                                    .face),
                                                            sb,
                                                            defaultActionButton(
                                                                'Camera', context,
                                                                    () {
                                                                  getImageCamera();
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                },
                                                                icon: MdiIcons
                                                                    .camera)
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                              child: Stack(
                                                children: [
                                                  CircleAvatar(
                                                      radius: 75,
                                                      backgroundColor:
                                                      Colors.transparent,
                                                      child:
                                                      Helper.localUser.foto != null
                                                          ? Image(
                                                        image:
                                                        CachedNetworkImageProvider(
                                                            Helper
                                                                .localUser
                                                                .foto),
                                                      )
                                                          : Image(
                                                        image: CachedNetworkImageProvider(
                                                            'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'),
                                                      )),
                                                  Helper.localUser.foto == null ?Positioned(bottom: 10, right: 10, child: Icon(MdiIcons.cameraEnhanceOutline, color: Colors.blue, size: 50)): Container()
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  StreamBuilder<String>(
                                      stream: cc.outTelefone,
                                      builder: (context, snapshot) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: ResponsivePixelHandler.toPixel(5, context),
                                              right: ResponsivePixelHandler.toPixel(28, context),
                                              left: ResponsivePixelHandler.toPixel(28, context)),
                                          child: TextField(
                                              onChanged: (value) {
                                                cc.updateTelefone(value);
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Telefone',
                                                hintText:
                                                    '(11) 9 9999-9999 (Oom WhatsApp)',
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        ResponsivePixelHandler.toPixel(20, context),
                                                        ResponsivePixelHandler.toPixel(15, context),
                                                        ResponsivePixelHandler.toPixel(20, context),
                                                        ResponsivePixelHandler.toPixel(15, context)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              keyboardType: TextInputType.number,
                                              onSubmitted: (tel) {
                                                cc.updateTelefone(tel);
                                                Future.delayed(Duration(
                                                        milliseconds: duracao))
                                                    .then((v) {
                                                  sc.next(animation: true);
                                                });
                                              },
                                              controller: telefone),
                                        );
                                      }),
                                  sb,
                                  StreamBuilder<String>(
                                      stream: cc.outDatanascimento,
                                      builder: (context, snapshot) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: ResponsivePixelHandler.toPixel(5, context),
                                              right: ResponsivePixelHandler.toPixel(28, context),
                                              left: ResponsivePixelHandler.toPixel(28, context)),
                                          child: TextField(
                                              onChanged: (value) {
                                                cc.updateDataNascimento(value);
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Data Nascimento',
                                                hintText: 'dd-mm-aaaa',
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        ResponsivePixelHandler.toPixel(20, context),
                                                        ResponsivePixelHandler.toPixel(15, context),
                                                        ResponsivePixelHandler.toPixel(20, context),
                                                        ResponsivePixelHandler.toPixel(15, context)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              keyboardType: TextInputType.number,
                                              onSubmitted: (data) {
                                                cc.updateDataNascimento(data);
                                                Future.delayed(Duration(
                                                        milliseconds: duracao))
                                                    .then((v) {
                                                  sc.next(animation: true);
                                                });
                                              },
                                              controller: dataNascimento),
                                        );
                                      }),
                                  sb,
                                  isMotorista.data == false
                                      ? Column(
                                          children: [
                                            StreamBuilder<String>(
                                                stream: cc.outCPF,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data != null &&
                                                      controllercpf
                                                          .text.isEmpty) {
                                                    controllercpf.text =
                                                        snapshot.data;
                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: ResponsivePixelHandler.toPixel(5, context),
                                                        right: ResponsivePixelHandler.toPixel(28, context),
                                                        left: ResponsivePixelHandler.toPixel(28, context)),
                                                    child: TextField(
                                                        onChanged: (value) {
                                                          cc.updateCPF(value);
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'CPF',
                                                          hintText:
                                                              '000.000.000-00',
                                                          contentPadding:
                                                              EdgeInsets.fromLTRB(
                                                                  ResponsivePixelHandler.toPixel(20, context),
                                                                  ResponsivePixelHandler.toPixel(15, context),
                                                                  ResponsivePixelHandler.toPixel(20, context),
                                                                  ResponsivePixelHandler.toPixel(15, context)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                        ),
                                                        keyboardType:
                                                            TextInputType.number,
                                                        onSubmitted: (data) {
                                                          cc.updateCPF(data);
                                                          Future.delayed(Duration(
                                                                  milliseconds:
                                                                      duracao))
                                                              .then((v) {
                                                            sc.next(
                                                                animation: true);
                                                          });
                                                        },
                                                        controller: CPF),
                                                  );
                                                }),
                                            sb,
                                            StreamBuilder<bool>(
                                                stream: cc.outIsMotoristaSelected,
                                                builder: (context, isMotorista) {
                                                  return StreamBuilder<bool>(
                                                      stream: cc.outIsMale,
                                                      builder: (context, isMale) {
                                                        return StreamBuilder<
                                                                String>(
                                                            stream: cc
                                                                .outDatanascimento,
                                                            builder: (context,
                                                                snapshot) {
                                                              return isMotorista
                                                                          .data ==
                                                                      false
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        Helper.localUser
                                                                                .cpf =
                                                                            CPF.text;
                                                                        Helper.localUser
                                                                                .celular =
                                                                            telefone
                                                                                .text;
                                                                        DateFormat
                                                                            df =
                                                                            DateFormat(
                                                                                'dd/MM/yyyy');


                                                                        Helper.localUser
                                                                                .data_nascimento =
                                                                            df.parse(
                                                                                await dataNascimento.text);


                                                                        Helper.localUser
                                                                                .isMale =
                                                                            isMale
                                                                                .data;
                                                                        Helper.localUser
                                                                                .isMotorista =
                                                                            isMotorista
                                                                                .data;
                                                                        userRef
                                                                            .doc(Helper
                                                                                .localUser
                                                                                .id)
                                                                            .update(Helper
                                                                                .localUser
                                                                                .toJson())
                                                                            .then(
                                                                                (v) {
                                                                          dToast('Usuário criado com sucesso!');
                                                                          Navigator.of(context).pushReplacement(
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => Helper.localUser.isMotorista == true?  CorridaPage()
                                                                                    :
                                                                                         HomePage()
                                                                                   ));
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            getAltura(context) *
                                                                                .1,
                                                                        width: getLargura(
                                                                                context) *
                                                                            .850,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color: Color(
                                                                              0xFFf6aa3c),
                                                                        ),
                                                                        child: Container(
                                                                            height: getAltura(context) * .125,
                                                                            width: getLargura(context) * .85,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(10),
                                                                              color: Color.fromRGBO(
                                                                                  255,
                                                                                  184,
                                                                                  0,
                                                                                  30),
                                                                            ),
                                                                            child: Center(child: hTextAbel('CONTINUAR', context, size: 30))),
                                                                      ),
                                                                    )
                                                                  : Container();

                                                            });
                                                      });
                                                }),
                                          ],
                                        )
                                      : Column(
                                          children: <Widget>[
                                            StreamBuilder<DocumentoCPF>(
                                                stream: cc.outDocumentoCPF,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }
                                                  if (snapshot.data.isValid) {
                                                    return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    snapshot.data
                                                                                .verso !=
                                                                            null
                                                                        ? hText(
                                                                            'Frente',
                                                                            context)
                                                                        : Container(),
                                                                    snapshot.data
                                                                                .frente ==
                                                                            null
                                                                        ? Container(
                                                                            width: snapshot.data.verso != null
                                                                                ? getLargura(context) *
                                                                                    .3
                                                                                : getLargura(context) *
                                                                                    .6,
                                                                            height: getAltura(context) *
                                                                                .2,
                                                                            color:
                                                                                Colors.grey[300])
                                                                        : fotoDocumento(
                                                                            snapshot
                                                                                .data
                                                                                .frente,
                                                                            isValid: snapshot
                                                                                .data
                                                                                .isValid,
                                                                            largura: snapshot.data.verso != null
                                                                                ? getLargura(context) * .3
                                                                                : getLargura(context) * .6,
                                                                          ),
                                                                    defaultActionButton(
                                                                        'Refazer',
                                                                        context,
                                                                        () {
                                                                      cc.documentoCPF
                                                                              .frente =
                                                                          null;
                                                                      cc.inDocumentoCPF
                                                                          .add(cc
                                                                              .documentoCPF);
                                                                    },
                                                                        icon:
                                                                            null),
                                                                  ],
                                                                ),
                                                              ),
                                                              sb,
                                                              snapshot.data
                                                                          .verso !=
                                                                      null
                                                                  ? Container(
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          hText(
                                                                              'Verso',
                                                                              context),
                                                                          snapshot.data.verso ==
                                                                                  null
                                                                              ? Container(
                                                                                  width: getLargura(context) * .3,
                                                                                  height: getAltura(context) * .2,
                                                                                  color: Colors.grey[300])
                                                                              : fotoDocumento(snapshot.data.verso, isValid: snapshot.data.isValid),
                                                                          defaultActionButton(
                                                                              'Refazer',
                                                                              context,
                                                                              () {
                                                                            cc.documentoCPF.verso =
                                                                                null;
                                                                            cc.inDocumentoCPF
                                                                                .add(cc.documentoCPF);
                                                                          }, icon: null),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          )
                                                        ]);
                                                  }
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                hText('Frente',
                                                                    context),
                                                                snapshot.data.frente ==
                                                                        null
                                                                    ? Container(
                                                                        width:
                                                                            getLargura(context) *
                                                                                .3,
                                                                        height:
                                                                            getAltura(context) *
                                                                                .2,
                                                                        color: Colors
                                                                                .grey[
                                                                            300])
                                                                    : fotoDocumento(
                                                                        snapshot
                                                                            .data
                                                                            .frente),
                                                                defaultActionButton(
                                                                    'Refazer',
                                                                    context, () {
                                                                  cc.documentoCPF
                                                                          .frente =
                                                                      null;
                                                                  cc.inDocumentoCPF
                                                                      .add(cc
                                                                          .documentoCPF);
                                                                }, icon: null),
                                                              ],
                                                            ),
                                                          ),
                                                          sb,
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                hText('Verso',
                                                                    context),
                                                                snapshot.data.verso ==
                                                                        null
                                                                    ? Container(
                                                                        width:
                                                                            getLargura(context) *
                                                                                .3,
                                                                        height:
                                                                            getAltura(context) *
                                                                                .2,
                                                                        color: Colors
                                                                                .grey[
                                                                            300])
                                                                    : fotoDocumento(
                                                                        snapshot
                                                                            .data
                                                                            .verso),
                                                                defaultActionButton(
                                                                    'Refazer',
                                                                    context, () {
                                                                  cc.documentoCPF
                                                                          .verso =
                                                                      null;
                                                                  cc.inDocumentoCPF
                                                                      .add(cc
                                                                          .documentoCPF);
                                                                }, icon: null),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }),
                                            StreamBuilder<String>(
                                                stream: cc.outCPF,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data != null &&
                                                      controllercpf
                                                          .text.isEmpty) {
                                                    controllercpf.text =
                                                        snapshot.data;
                                                  }
                                                  return StreamBuilder<bool>(
                                                      stream: cc
                                                          .outIsMotoristaSelected,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.data ==
                                                            null) {
                                                          return Container();
                                                        }

                                                        if (snapshot.data) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(
                                                                top: getAltura(
                                                                        context) *
                                                                    .010,
                                                                right: getLargura(
                                                                        context) *
                                                                    .075,
                                                                left: getLargura(
                                                                        context) *
                                                                    .075),
                                                            child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  cc.updateCPF(
                                                                      value);
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'CPF',
                                                                  hintText:
                                                                      '000.000.000-00',
                                                                  contentPadding: EdgeInsets.fromLTRB(
                                                                      getAltura(
                                                                              context) *
                                                                          .025,
                                                                      getLargura(
                                                                              context) *
                                                                          .020,
                                                                      getAltura(
                                                                              context) *
                                                                          .025,
                                                                      getLargura(
                                                                              context) *
                                                                          .020),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              9.0),
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color:
                                                                                  Colors.black)),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              9.0),
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color:
                                                                                  Colors.black)),
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                onSubmitted:
                                                                    (tel) {
                                                                  cc.updateCPF(
                                                                      tel);
                                                                },
                                                                controller: CPF),
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      });
                                                }),
                                            sb,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                StreamBuilder<bool>(
                                                    stream:
                                                        cc.outIsMotoristaSelected,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.data == null) {
                                                        return Container();
                                                      }

                                                      if (snapshot.data) {
                                                        return defaultActionButton(
                                                            'Anexar foto CPF',
                                                            context, () async {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                  child:
                                                                      AlertDialog(
                                                                    title: hText(
                                                                        "Selecione uma opção",
                                                                        context),
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          ListBody(
                                                                        children: <
                                                                            Widget>[
                                                                          defaultActionButton(
                                                                              'Galeria',
                                                                              context,
                                                                              () {
                                                                            getDocumentoCPF();
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          }, icon: MdiIcons.face),
                                                                          sb,
                                                                          defaultActionButton(
                                                                              'Camera',
                                                                              context,
                                                                              () {
                                                                            getDocumentoCPFCamera();
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          }, icon: MdiIcons.camera)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        }, icon: null);
                                                      } else {
                                                        return Container();
                                                      }
                                                    }),
                                              ],
                                            ),
                                            sb,
                                          ],
                                        ),
                                ]))
                          ]);

                        case 1:
                          var controllerCNH = TextEditingController(text: cc.CNH);
                          return Stack(
                            children: <Widget>[
                              Positioned(
                                child: MaterialButton(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blue,
                                    onPressed: index != null
                                        ? index < 5 - 1
                                            ? () {
                                                sc.next(animation: true);
                                              }
                                            : null
                                        : null,
                                    shape: new CircleBorder(
                                        side: BorderSide(color: Colors.blue))),
                                bottom: 5,
                                right: 10,
                              ),
                              Positioned(
                                child: MaterialButton(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blue,
                                    onPressed: index != 0
                                        ? () {
                                            sc.previous(animation: true);
                                          }
                                        : null,
                                    shape: new CircleBorder(
                                        side: BorderSide(color: Colors.blue))),
                                bottom: 5,
                                left: 10,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: ResponsivePixelHandler.toPixel(60, context)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          hTextBank(
                                            'UFLY',
                                            context,
                                            color: Color.fromRGBO(255, 184, 0, 1),
                                            size: 30,
                                          ),
                                          sb,
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: ResponsivePixelHandler.toPixel(35, context)),
                                            child: hTextMal('AJUDA', context,
                                                size: 25,
                                                weight: FontWeight.bold),
                                          ),sb,sb,
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()));
                                                userRef.doc(Helper.localUser.id).delete();
                                              }
                                              ,child: hTextMal('ENTRAR', context, size: 25, weight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),


                                    sb,
                                    Column(
                                      children: <Widget>[
                                        Divider(color: Colors.black),
                                        StreamBuilder<DocumentoCNH>(
                                            stream: cc.outDocumentoCNH,
                                            builder: (context, snapshot) {
                                              if (snapshot.data == null) {
                                                return Container();
                                              }
                                              if (snapshot.data.isValid == null) {
                                                snapshot.data.isValid = true;
                                                return Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                snapshot.data
                                                                    .verso !=
                                                                    null
                                                                    ? hText(
                                                                    'Frente',
                                                                    context)
                                                                    : Container(),
                                                                snapshot.data
                                                                    .frente ==
                                                                    null
                                                                    ? Container(
                                                                    width: snapshot.data.verso != null
                                                                        ? getLargura(context) *
                                                                        .3
                                                                        : getLargura(context) *
                                                                        .6,
                                                                    height:
                                                                    getAltura(context) *
                                                                        .2,
                                                                    color: Colors
                                                                        .grey[
                                                                    300])
                                                                    : fotoDocumento(
                                                                  snapshot
                                                                      .data
                                                                      .frente,
                                                                  isValid: snapshot
                                                                      .data
                                                                      .isValid,
                                                                  largura: snapshot
                                                                      .data.verso !=
                                                                      null
                                                                      ? getLargura(context) *
                                                                      .3
                                                                      : getLargura(context) *
                                                                      .6,
                                                                ),
                                                                defaultActionButton(
                                                                    'Refazer',
                                                                    context, () {
                                                                  cc.documentoCNH
                                                                      .frente =
                                                                  null;
                                                                  cc.inDocumentoCNH
                                                                      .add(cc
                                                                      .documentoCNH);
                                                                }, icon: null),
                                                              ],
                                                            ),
                                                          ),
                                                          sb,
                                                          snapshot.data.verso !=
                                                              null
                                                              ? Container(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                hText(
                                                                    'Verso',
                                                                    context),
                                                                snapshot.data.verso ==
                                                                    null
                                                                    ? Container(
                                                                    width: getLargura(context) *
                                                                        .3,
                                                                    height: getAltura(context) *
                                                                        .2,
                                                                    color: Colors.grey[
                                                                    300])
                                                                    : fotoDocumento(
                                                                    snapshot
                                                                        .data.verso,
                                                                    isValid:
                                                                    snapshot.data.isValid),
                                                                defaultActionButton(
                                                                    'Refazer',
                                                                    context,
                                                                        () {
                                                                      cc.documentoCNH
                                                                          .verso =
                                                                      null;
                                                                      cc.inDocumentoCNH
                                                                          .add(cc
                                                                          .documentoCNH);
                                                                    },
                                                                    icon:
                                                                    null),
                                                              ],
                                                            ),
                                                          )
                                                              : Container(),
                                                        ],
                                                      )
                                                    ]);
                                              }
                                              return Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            hText('Frente',
                                                                context),
                                                            snapshot.data
                                                                .frente ==
                                                                null
                                                                ? Container(
                                                                width: getLargura(
                                                                    context) *
                                                                    .3,
                                                                height: getAltura(
                                                                    context) *
                                                                    .2,
                                                                color: Colors
                                                                    .grey[
                                                                300])
                                                                : fotoDocumento(
                                                                snapshot.data
                                                                    .frente),
                                                            defaultActionButton(
                                                                'Refazer',
                                                                context, () {
                                                              cc.documentoCNH
                                                                  .frente = null;
                                                              cc.inDocumentoCNH.add(
                                                                  cc.documentoCNH);
                                                            }, icon: null),
                                                          ],
                                                        ),
                                                      ),
                                                      sb,
                                                      Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            hText(
                                                                'Verso', context),
                                                            snapshot.data.verso ==
                                                                null
                                                                ? Container(
                                                                width: getLargura(
                                                                    context) *
                                                                    .3,
                                                                height: getAltura(
                                                                    context) *
                                                                    .2,
                                                                color: Colors
                                                                    .grey[
                                                                300])
                                                                : fotoDocumento(
                                                                snapshot.data
                                                                    .verso),
                                                            defaultActionButton(
                                                                'Refazer',
                                                                context, () {
                                                              cc.documentoCNH
                                                                  .verso = null;
                                                              cc.inDocumentoCNH.add(
                                                                  cc.documentoCNH);
                                                            }, icon: null),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }),
                                        StreamBuilder<String>(
                                            stream: cc.outCNH,
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null &&
                                                  controllerCNH.text.isEmpty) {
                                                controllerCNH.text =
                                                    snapshot.data;
                                              }
                                              return StreamBuilder<bool>(
                                                  stream:
                                                  cc.outIsMotoristaSelected,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == null) {
                                                      return Container();
                                                    }

                                                    if (snapshot.data) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            top: getAltura(
                                                                context) *
                                                                .010,
                                                            right: getLargura(
                                                                context) *
                                                                .075,
                                                            left: getLargura(
                                                                context) *
                                                                .075),
                                                        child: TextField(
                                                            onChanged: (value) {
                                                              cc.updateCNH(value);
                                                            },
                                                            decoration:
                                                            InputDecoration(
                                                              labelText:
                                                              'Nº Registro CNH',
                                                              hintText:
                                                              '021545212365',
                                                              contentPadding: EdgeInsets.fromLTRB(
                                                                  ResponsivePixelHandler.toPixel(20, context),
                                                                  ResponsivePixelHandler.toPixel(15, context),
                                                                  ResponsivePixelHandler.toPixel(20, context),
                                                                  ResponsivePixelHandler.toPixel(15, context)),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      9.0),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      9.0),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            keyboardType:
                                                            TextInputType
                                                                .number,
                                                            onSubmitted: (tel) {
                                                              cc.updateCNH(tel);
                                                            },
                                                            controller:
                                                            controllerCNH),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  });
                                            }),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                                stream: cc.outIsMotoristaSelected,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }

                                                  if (snapshot.data) {
                                                    return defaultActionButton(
                                                        'Anexar foto CNH',
                                                        context, () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                              child: AlertDialog(
                                                                title: hText(
                                                                    "Selecione uma opção",
                                                                    context),
                                                                content:
                                                                SingleChildScrollView(
                                                                  child: ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      defaultActionButton(
                                                                          'Galeria',
                                                                          context,
                                                                              () {
                                                                            getDocumentoCNH();
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon: MdiIcons
                                                                              .face),
                                                                      sb,
                                                                      defaultActionButton(
                                                                          'Camera',
                                                                          context,
                                                                              () {
                                                                            getDocumentoCNHCamera();
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon: MdiIcons
                                                                              .camera)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }, icon: null);
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ],
                                        ),
                                        StreamBuilder<DocumentoRg>(
                                            stream: cc.outDocumentoRg,
                                            builder: (context, snapshot) {
                                              if (snapshot.data == null) {
                                                return Container();
                                              }
                                              if (snapshot.data.isValid) {
                                                return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                snapshot.data
                                                                            .verso !=
                                                                        null
                                                                    ? hText(
                                                                        'Frente',
                                                                        context)
                                                                    : Container(),
                                                                snapshot.data
                                                                            .frente ==
                                                                        null
                                                                    ? Container(
                                                                        width: snapshot.data.verso != null
                                                                            ? getLargura(context) *
                                                                                .3
                                                                            : getLargura(context) *
                                                                                .6,
                                                                        height:
                                                                            getAltura(context) *
                                                                                .2,
                                                                        color: Colors
                                                                                .grey[
                                                                            300])
                                                                    : fotoDocumento(
                                                                        snapshot
                                                                            .data
                                                                            .frente,
                                                                        isValid: snapshot
                                                                            .data
                                                                            .isValid,
                                                                        largura: snapshot
                                                                                    .data.verso !=
                                                                                null
                                                                            ? getLargura(context) *
                                                                                .3
                                                                            : getLargura(context) *
                                                                                .6,
                                                                      ),
                                                                defaultActionButton(
                                                                    'Refazer',
                                                                    context, () {
                                                                  cc.documentoRg
                                                                          .frente =
                                                                      null;
                                                                  cc.inDocumentoRg
                                                                      .add(cc
                                                                          .documentoRg);
                                                                }, icon: null),
                                                              ],
                                                            ),
                                                          ),
                                                          sb,
                                                          snapshot.data.verso !=
                                                                  null
                                                              ? Container(
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      hText(
                                                                          'Verso',
                                                                          context),
                                                                      snapshot.data.verso ==
                                                                              null
                                                                          ? Container(
                                                                              width: getLargura(context) *
                                                                                  .3,
                                                                              height: getAltura(context) *
                                                                                  .2,
                                                                              color: Colors.grey[
                                                                                  300])
                                                                          : fotoDocumento(
                                                                              snapshot
                                                                                  .data.verso,
                                                                              isValid:
                                                                                  snapshot.data.isValid),
                                                                      defaultActionButton(
                                                                          'Refazer',
                                                                          context,
                                                                          () {
                                                                        cc.documentoRg
                                                                                .verso =
                                                                            null;
                                                                        cc.inDocumentoRg
                                                                            .add(cc
                                                                                .documentoRg);
                                                                      },
                                                                          icon:
                                                                              null),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      )
                                                    ]);
                                              }
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            hText('Frente',
                                                                context),
                                                            snapshot.data
                                                                        .frente ==
                                                                    null
                                                                ? Container(
                                                                    width: getLargura(
                                                                            context) *
                                                                        .3,
                                                                    height: getAltura(
                                                                            context) *
                                                                        .2,
                                                                    color: Colors
                                                                            .grey[
                                                                        300])
                                                                : fotoDocumento(
                                                                    snapshot.data
                                                                        .frente),
                                                            defaultActionButton(
                                                                'Refazer',
                                                                context, () {
                                                              cc.documentoRg
                                                                  .frente = null;
                                                              cc.inDocumentoRg.add(
                                                                  cc.documentoRg);
                                                            }, icon: null),
                                                          ],
                                                        ),
                                                      ),
                                                      sb,
                                                      Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            hText(
                                                                'Verso', context),
                                                            snapshot.data.verso ==
                                                                    null
                                                                ? Container(
                                                                    width: getLargura(
                                                                            context) *
                                                                        .3,
                                                                    height: getAltura(
                                                                            context) *
                                                                        .2,
                                                                    color: Colors
                                                                            .grey[
                                                                        300])
                                                                : fotoDocumento(
                                                                    snapshot.data
                                                                        .verso),
                                                            defaultActionButton(
                                                                'Refazer',
                                                                context, () {
                                                              cc.documentoRg
                                                                  .verso = null;
                                                              cc.inDocumentoRg.add(
                                                                  cc.documentoRg);
                                                            }, icon: null),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }),
                                        StreamBuilder<String>(
                                            stream: cc.outRG,
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null &&
                                                  controllerRG.text.isEmpty) {
                                                controllerRG.text = snapshot.data;
                                              }
                                              return StreamBuilder<bool>(
                                                  stream:
                                                      cc.outIsMotoristaSelected,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == null) {
                                                      return Container();
                                                    }

                                                    if (snapshot.data) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            top: getAltura(
                                                                    context) *
                                                                .010,
                                                            right: getLargura(
                                                                    context) *
                                                                .075,
                                                            left: getLargura(
                                                                    context) *
                                                                .075),
                                                        child: TextField(
                                                            onChanged: (value) {
                                                              cc.updateRG(value);
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: 'RG',
                                                              hintText:
                                                                  '14568465-5',
                                                              contentPadding: EdgeInsets.fromLTRB(
                                                                  getAltura(
                                                                          context) *
                                                                      .025,
                                                                  getLargura(
                                                                          context) *
                                                                      .020,
                                                                  getAltura(
                                                                          context) *
                                                                      .025,
                                                                  getLargura(
                                                                          context) *
                                                                      .020),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9.0),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              9.0),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onSubmitted: (tel) {
                                                              cc.updateRG(tel);
                                                            },
                                                            controller:
                                                                controllerRG),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  });
                                            }),
                                        sb,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                                stream: cc.outIsMotoristaSelected,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }

                                                  if (snapshot.data) {
                                                    return defaultActionButton(
                                                        'Anexar foto RG', context,
                                                        () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15.0),
                                                              child: AlertDialog(
                                                                title: hText(
                                                                    "Selecione uma opção",
                                                                    context),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child: ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      defaultActionButton(
                                                                          'Galeria',
                                                                          context,
                                                                          () {
                                                                        getDocumentoRg();
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                          icon: MdiIcons
                                                                              .face),
                                                                      sb,
                                                                      defaultActionButton(
                                                                          'Camera',
                                                                          context,
                                                                          () {
                                                                        getDocumentoRgCamera();
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                          icon: MdiIcons
                                                                              .camera)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }, icon: null);
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ],
                                        ),
                                        sb,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              sb,
                            ],
                          );
                        case 2:

                          var controllerPlaca = MaskedTextController(
                              text: cc.placa, mask: 'AAA-0000');
                          var controllerCor = TextEditingController(text: cc.Cor);
                          var controllerAno =
                              MaskedTextController(text: cc.Ano, mask: '0000');
                          var controllerModelo =
                              TextEditingController(text: cc.Modelo);
                          return Stack(
                            children: <Widget>[
                              Positioned(
                                child: MaterialButton(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blue,
                                    onPressed: index != 0
                                        ? () {
                                            sc.previous(animation: true);
                                          }
                                        : null,
                                    shape: new CircleBorder(
                                        side: BorderSide(color: Colors.blue))),
                                bottom: 5,
                                left: 10,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 60.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          hTextBank(
                                            'UFLY',
                                            context,
                                            color: Color.fromRGBO(255, 184, 0, 1),
                                            size: 30,
                                          ),
                                          sb,
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: ResponsivePixelHandler.toPixel(35, context)),
                                            child: hTextMal('AJUDA', context,
                                                size: 25,
                                                weight: FontWeight.bold),
                                          ),sb,sb,
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()));
                                                userRef.doc(Helper.localUser.id).delete();
                                              }
                                              ,child: hTextMal('ENTRAR', context, size: 30, weight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),  Divider(
                                      color: Colors.black,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[


                                        hTextBank('Foto do veículo', context, size: 20),sb,
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: () =>
                                                    getImageCarro(c),
                                                child: Container(
                                                    width: getLargura(context)*.6,
                                                  height:getAltura(context) * .2,
                                                  child: c.foto != null
                                                    ? c.foto.contains('http')
                                                    ? Image(image: CachedNetworkImageProvider(
                                                    c.foto))
                                                    : FileImage(File(c.foto))
                                                    : Image.asset(
                                                    'assets/carro_foto.png'),)
                                                ),
                                            Helper.localUser.foto == null ?Positioned(top: 10, right: 25, child: Icon(MdiIcons.cameraEnhanceOutline, color: Colors.black, size: 50)): Container()
                                          ],
                                        ),
                                        sb,
                                        hTextBank('Foto do documento do veículo', context, size: 20),sb,
                                        Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () =>
                                                          getImageDocumento(
                                                              c),
                                                      child: Container(
                                                        width: getLargura(context)*.6,
                                                        height:getAltura(context) * .2,
                                                        child: c.foto_documento != null
                                                            ? c.foto_documento.contains('http')
                                                            ? Image(image: CachedNetworkImageProvider(
                                                            c.foto_documento))
                                                            : FileImage(File(c.foto_documento))
                                                            : Image.asset(
                                                            'assets/icone_foto.png'),)
                                                    ),
                                                  ],
                                                ),
                                              ),sb,
                                        Divider(color: Colors.black),sb,
                                        hTextBank('Informações do carro', context,
                                            size: 20),
                                        sb,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: getLargura(context) *
                                                        .075),
                                                child: TextField(
                                                    onChanged: (value) {
                                                      cc.updatePlaca(value);
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Placa',
                                                      hintText: 'AAA-0000',
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020,
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9.0),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.black)),
                                                    ),
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    onSubmitted: (tel) {
                                                      cc.updatePlaca(tel);
                                                    },
                                                    controller: controllerPlaca),
                                              ),
                                            ),
                                            sb,
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: getLargura(context) *
                                                        .075),
                                                child: TextField(
                                                    onChanged: (value) {
                                                      cc.updateAno(value);
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Ano',
                                                      hintText: '2008',
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020,
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9.0),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.black)),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onSubmitted: (tel) {
                                                      cc.updateAno(tel);
                                                    },
                                                    controller: controllerAno),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sb,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: getLargura(context) *
                                                        .075),
                                                child: TextField(
                                                    onChanged: (value) {
                                                      cc.updateModelo(value);
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Modelo',
                                                      hintText: 'Prisma',
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020,
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9.0),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.black)),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    onSubmitted: (tel) {
                                                      cc.updateModelo(tel);
                                                    },
                                                    controller: controllerModelo),
                                              ),
                                            ),
                                            sb,
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: getLargura(context) *
                                                        .075),
                                                child: TextField(
                                                    onChanged: (value) {
                                                      cc.updateCor(value);
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Cor',
                                                      hintText: 'Azul',
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020,
                                                              getAltura(context) *
                                                                  .025,
                                                              getLargura(
                                                                      context) *
                                                                  .020),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9.0),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.black)),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    onSubmitted: (tel) {
                                                      cc.updateCor(tel);
                                                    },
                                                    controller: controllerCor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sb,


                                        StreamBuilder<bool>(
                                            stream: cc.outIsMale,
                                            builder: (context, isMale) {
                                              return StreamBuilder<Carro>(
                                                  stream:
                                                      carroController.outCarro,
                                                  builder: (context, snapshot) {
                                                    Carro carro = snapshot.data;
                                                    return StreamBuilder<bool>(
                                                      stream: cc.outisMoto,
                                                      builder: (context, isMoto) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            String foto = carro.foto;
                                                            String foto_d =
                                                                carro.foto_documento;
                                                            List<Carro> carros =
                                                                [];
                                                            Carro cccc = Carro(
                                                              id_usuario: Helper.localUser.id,
                                                              cor: controllerCor.text,
                                                              ano: int.parse(
                                                                  controllerAno.text),
                                                              placa: controllerPlaca
                                                                  .text,
                                                              modelo: controllerModelo
                                                                  .text,
                                                              foto: foto,
                                                              foto_documento: foto_d,
                                                              nome_motorista: Helper
                                                                  .localUser.nome,
                                                              isMoto: isMoto.data
                                                            );
                                                            carros.add(cccc);

                                                            List<Motorista>
                                                                motoristas =
                                                                [];
                                                            Motorista motorista =
                                                                Motorista(
                                                                  isOnline: false,
                                                              rating: 5,
                                                              rating_quantidade: 1,
                                                              rating_total: 5,
                                                              id_usuario:
                                                                  Helper.localUser.id,
                                                              nome_usuario: Helper
                                                                  .localUser.nome,
                                                              nome: Helper
                                                                  .localUser.nome,
                                                              foto: Helper
                                                                  .localUser.foto,
                                                            );
                                                            motoristas.add(motorista);

                                                            Helper.localUser.cpf =
                                                                controllercpf.text;
                                                            Helper.localUser.celular =
                                                                telefone.text;
                                                            DateFormat df =
                                                                DateFormat(
                                                                    'dd/MM/yyyy');
                                                            print(
                                                                'AQUI DATA ${await dataNascimento.text}');

                                                            Helper.localUser
                                                                    .data_nascimento =
                                                                df.parse(
                                                                    await dataNascimento
                                                                        .text);

                                                            if (motorista == null ||
                                                                cccc == null) {
                                                              dToast(
                                                                  'Preencha os dados do carro e motorista corretamente');
                                                            } else {
                                                              carroController
                                                                  .CriarCarros(cccc,
                                                                      motorista);
                                                              cc.atualizarDados(
                                                                  sc, context);
                                                            }
                                                          },
                                                          child:
                                                          Container(
                                                            height:
                                                                getAltura(context) *
                                                                    .1,
                                                            width:
                                                                getLargura(context) *
                                                                    .850,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),
                                                              color:
                                                                  Color(0xFFf6aa3c),
                                                            ),
                                                            child: Container(
                                                                height: getAltura(
                                                                        context) *
                                                                    .125,
                                                                width: getLargura(
                                                                        context) *
                                                                    .85,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color:
                                                                      Color.fromRGBO(
                                                                          255,
                                                                          184,
                                                                          0,
                                                                          30),
                                                                ),
                                                                child: Center(
                                                                    child: hTextAbel(
                                                                        'CADASTRAR',
                                                                        context,
                                                                        size: 30))),
                                                          ),
                                                        );
                                                      }
                                                    );
                                                  });
                                            })
                                      ],
                                    ),
                                    sb,
                                    sb,
                                    sb,
                                    sb,
                                    sb,
                                    sb,
                                    sb,sb
                                  ],
                                ),
                              ),
                            ],
                          );
                          break;
                        default:
                          return Container();
                      }
                    },
                    itemCount: isMotorista.data == true ? 3 : 1,
                    loop: false,
                    scrollDirection: Axis.horizontal,
                    controller: sc,
                    onIndexChanged: (i) {
                      cc.Validar(i, sc, context);
                    },
                    pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: FractionPaginationBuilder(
                          color: Colors.blue,
                          activeColor: Colors.blueAccent,
                          fontSize: 22,
                          activeFontSize: 26,
                        )),
                  );
                } else {
                  return Container();
                }
              })),
    );
  }

  Future getImageCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    if (image.path == null) {
      pr.hide();
      return dToast('Erro ao salvar imagem');
    } else {
      Helper.localUser.foto = await uploadPicture(
        image.path,
      );
      perfilController.updateUser(Helper.localUser);
      pr.hide();
      dToast('Foto salva com sucesso!');
    }
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    print('aqui');
    if (image.path == null) {
      print('aqui image 2 ${image.path}');
      return dToast('Erro ao salvar imagem');

    } else {
      Helper.localUser.foto = await uploadPicture(
        image.path,
      );
      perfilController.updateUser(Helper.localUser);
      print('aqui image ${image.path} e ${Helper.localUser.foto}');
      pr.hide();
      dToast('Foto salva com sucesso');
    }
  }

  Future getImageDocumento(Carro c) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            AlertDialog(
            content: Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 18.0),
                  label: const Text('Camera', semanticsLabel: 'Camera', style: TextStyle(fontFamily: 'BankGothic')),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    String url = await Helper().uploadPicture(image.path);
                    c.foto_documento = url;
                    carroController.inCarro.add(c);

                    dToast('Salvando foto documento do carro!');
                  },
                ),
                FlatButton.icon(
                  icon: const Icon(Icons.photo, size: 18.0),
                  label: const Text('Galeria', semanticsLabel: 'Galeria', style: TextStyle(fontFamily: 'BankGothic')),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    String url = await Helper().uploadPicture(image.path);
                    c.foto_documento = url;
                    carroController.inCarro.add(c);
                    dToast('Salvando foto documento do carro!');
                  },
                )
              ],
            ),
          );
        });
  }

  Future getImageCarro(Carro c) async {
    if(c == null){
      c = Carro();
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 18.0),
                  label: const Text('Camera', semanticsLabel: 'Camera'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    String url = await Helper().uploadPicture(image.path);
                    c.foto = url;
                    carroController.inCarro.add(c);

                    dToast('Salvando foto do carro!');
                  },
                ),
                FlatButton.icon(
                  icon: const Icon(Icons.photo, size: 18.0),
                  label: const Text('Galeria', semanticsLabel: 'Galeria'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    String url = await Helper().uploadPicture(image.path);
                    c.foto = url;
                    carroController.inCarro.add(c);
                    dToast('Salvando foto do carro!');
                  },
                )
              ],
            ),
          );
        });
  }

  Widget fotoDocumento(String foto, {isValid = false, largura = null}) {
    largura = largura == null ? getLargura(context) * .3 : largura;
    if (isValid) {
      return Container(
          width: largura,
          height: getAltura(context) * .2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: corPrimaria,
              width: 8,
            ),
          ),
          child: Image(
              image: CachedNetworkImageProvider(foto), fit: BoxFit.fitHeight));
    }
    return Container(
        width: largura,
        height: getAltura(context) * .2,
        child: Image(
            image: CachedNetworkImageProvider(foto), fit: BoxFit.fitHeight));
  }
}
