import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AceitarPassageiroPage extends StatefulWidget {
  AceitarPassageiroPage({Key key}) : super(key: key);

  @override
  _AceitarPassageiroPageState createState() => _AceitarPassageiroPageState();
}

class _AceitarPassageiroPageState extends State<AceitarPassageiroPage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: Border.all(),
      title: new Text('Deseja Sair?'),
      content: Text('Tem Certeza?'),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            'Cancelar',
            style:
            GoogleFonts.openSans(color: Colors.green),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text(
            'Sair',
            style: GoogleFonts.openSans(color: Colors.red),
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
        )
      ],
    );
  }
}