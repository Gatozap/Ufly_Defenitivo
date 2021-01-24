import 'package:flutter/material.dart';
import 'package:ufly/Objetos/SizeConfig.dart';
import 'package:address_search_field/address_search_field.dart';
import 'package:responsive_pixel/responsive_pixel.dart';
import 'package:ufly/Helpers/Helper.dart';
import 'package:ufly/Rota/rota_controller.dart';
class ParadasListItem extends StatelessWidget {


    String filtro;
  ParadasListItem({this.filtro}) ;

  @override
  Widget build(BuildContext context) {
    TextEditingController parada1Controller = TextEditingController();
    TextEditingController parada2Controller = TextEditingController();
    TextEditingController parada3Controller = TextEditingController();
    RotaController rc;
    WidgetsFlutterBinding.ensureInitialized();
    final geoMethods = GeoMethods(
      googleApiKey: 'AIzaSyCW3el7IIcqaKRx_PZ24Ab6P0VJnWhMAx4',
      language: 'pt-BR',
      countryCode: 'bra',
      country: 'Brasil',
      city: '${filtro}',
    );

    SizeConfig().init(context);
      if(rc == null){
        rc = RotaController();
      }

    ResponsivePixelHandler.init(
      baseWidth: 360, //A largura usado pelo designer no modelo desenhado
    );// TODO: implement build
    return Scaffold(
           body: Column(children: <Widget>[


             parada2Controller.text.isEmpty?
             Padding(
               padding: EdgeInsets.only(
                   top: getAltura(context) * .050,
                   bottom: getAltura(context) * .010),
               child: Center(
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(25),
                     color: Colors.white,
                     border: Border.all(
                       color: Colors.white,
                       width: 2,
                     ),
                   ),
                   width: getLargura(context) * .80,
                   child: TextField(
                     decoration: InputDecoration(
                       fillColor: Colors.white,
                       filled: true,
                       suffixIcon: IconButton(
                           onPressed: () {

                           },
                           icon: Icon(Icons.my_location,
                               color: Colors.black)),
                       prefixIcon: Icon(Icons.location_on,
                           color: Colors.black),
                       labelText: 'Parada nº um',
                       contentPadding: EdgeInsets.fromLTRB(
                           getAltura(context) * .025,
                           getLargura(context) * .020,
                           getAltura(context) * .025,
                           getLargura(context) * .020),
                       border: OutlineInputBorder(
                           borderRadius:
                           BorderRadius.circular(25.0),
                           borderSide: BorderSide(
                               color: Colors.white)),
                     ),
                     controller: parada2Controller,
                     onTap: () {
                       showDialog(
                           context: context,
                           builder: (context) =>
                               AddressSearchBuilder(
                                 geoMethods: geoMethods,
                                 controller: parada2Controller,
                                 builder: (
                                     BuildContext context,
                                     AsyncSnapshot<List<Address>> snapshot, {
                                       TextEditingController controller,
                                       Future<void> Function() searchAddress,
                                       Future<Address> Function(Address address) getGeometry,
                                     }) {
                                   return AddressSearchDialog(
                                     snapshot: snapshot,
                                     controller: controller,
                                     searchAddress: searchAddress,
                                     getGeometry: getGeometry,
                                     onDone: (Address address)
                                       {parada2Controller.text = address.coords.toString();

                                       }
                                   );
                                 },
                               )
                         // false = user must tap button, true = tap outside dialog

                       );
                     },
                   ),
                 ),
               ),
             ):Container(),
             parada3Controller.text.isEmpty?
             Padding(
               padding: EdgeInsets.only(
                   top: getAltura(context) * .050,
                   bottom: getAltura(context) * .010),
               child: Center(
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(25),
                     color: Colors.white,
                     border: Border.all(
                       color: Colors.white,
                       width: 2,
                     ),
                   ),
                   width: getLargura(context) * .80,
                   child: TextField(
                     decoration: InputDecoration(
                       fillColor: Colors.white,
                       filled: true,
                       suffixIcon: IconButton(
                           onPressed: () {

                           },
                           icon: Icon(Icons.my_location,
                               color: Colors.black)),
                       prefixIcon: Icon(Icons.location_on,
                           color: Colors.black),
                       labelText: 'Parada nº um',
                       contentPadding: EdgeInsets.fromLTRB(
                           getAltura(context) * .025,
                           getLargura(context) * .020,
                           getAltura(context) * .025,
                           getLargura(context) * .020),
                       border: OutlineInputBorder(
                           borderRadius:
                           BorderRadius.circular(25.0),
                           borderSide: BorderSide(
                               color: Colors.white)),
                     ),
                     controller: parada3Controller,
                     onTap: () {
                       showDialog(
                           context: context,
                           builder: (context) =>
                               AddressSearchBuilder(
                                 geoMethods: geoMethods,
                                 controller: parada3Controller,
                                 builder: (
                                     BuildContext context,
                                     AsyncSnapshot<List<Address>> snapshot, {
                                       TextEditingController controller,
                                       Future<void> Function() searchAddress,
                                       Future<Address> Function(Address address) getGeometry,
                                     }) {
                                   return AddressSearchDialog(
                                     snapshot: snapshot,
                                     controller: controller,
                                     searchAddress: searchAddress,
                                     getGeometry: getGeometry,
                                     onDone: (Address address) => parada3Controller.text = address.coords.toString(),
                                   );
                                 },
                               )
                         // false = user must tap button, true = tap outside dialog

                       );
                     },
                   ),
                 ),
               ),
             ):Container(),

               ],)
    );
  }
}
