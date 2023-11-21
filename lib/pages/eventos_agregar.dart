// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:proyecto_evento/services/firestore_service.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// class EventosAgregarPage extends StatefulWidget {
//   EventosAgregarPage({Key? key}) : super(key: key);

//   @override
//   State<EventosAgregarPage> createState() => _EventosAgregarPageState();
// }

// class _EventosAgregarPageState extends State<EventosAgregarPage> {
//   TextEditingController nombreCtrl = TextEditingController();
//   TextEditingController lugarCtrl = TextEditingController();
//   TextEditingController descripcionCtrl = TextEditingController();
//   TextEditingController tipoCtrl = TextEditingController();
//   TextEditingController fotoCtrl = TextEditingController();

//   final formKey = GlobalKey<FormState>();
//   DateTime fecha_actual = DateTime.now();
//   final formatoFecha = DateFormat('dd-MM-yyyy');
//   final formatoHora = DateFormat('HH:mm');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Eventos Form', style: TextStyle(color: Colors.white)),
//       ),
//       body: Form(
//         key: formKey,
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: ListView(
//             children: [
//               //NOMBRE
//               TextFormField(
//                 controller: nombreCtrl,
//                 decoration: InputDecoration(
//                   label: Text('Nombre'),
//                 ),
//                 validator: (nombre) {
//                   if (nombre!.isEmpty) {
//                     return 'Indique el nombre del evento';
//                   }
//                   if (nombre.length < 3) {
//                     return 'Nombre debe ser de al menos 3 letras';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: lugarCtrl,
//                 decoration: InputDecoration(
//                   label: Text('Lugar'),
//                 ),
//                 validator: (lugar) {
//                   if (lugar!.isEmpty) {
//                     return 'Indique el lugar del evento';
//                   }
//                   if (lugar.length < 3) {
//                     return 'Lugar debe ser de al menos 3 letras';
//                   }
//                   return null;
//                 },
//               ),
//               //DESCRIPCION
//               TextFormField(
//                 controller: descripcionCtrl,
//                 decoration: InputDecoration(
//                   label: Text('Descripción'),
//                 ),
//                 validator: (nombre) {
//                   if (nombre!.isEmpty) {
//                     return 'Indique la descripción del evento';
//                   }
//                   if (nombre.length < 3) {
//                     return 'Descripción debe ser de al menos 3 letras';
//                   }
//                   return null;
//                 },
//               ),
//               //TIPO
//               TextFormField(
//                 controller: tipoCtrl,
//                 decoration: InputDecoration(
//                   label: Text('Tipo'),
//                 ),
//                 validator: (tipo) {
//                   if (tipo!.isEmpty) {
//                     return 'Indique el nombre del evento';
//                   }
//                   if (tipo.length < 3) {
//                     return 'Nombre debe ser de al menos 3 letras';
//                   }
//                   return null;
//                 },
//               ),
//               //FECHA
//               Container(
//                 margin: EdgeInsets.only(top: 15),
//                 child: Row(
//                   children: [
//                     Text('Fecha del Evento: '),
//                     Text(formatoFecha.format(fecha_actual),
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16)),
//                     Spacer(),
//                     IconButton(
//                       icon: Icon(MdiIcons.calendar),
//                       onPressed: () {
//                         showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime.now(),
//                           locale: Locale('es', 'ES'),
//                         ).then((fecha) {
//                           setState(() {
//                             fecha_actual = fecha ?? fecha_actual;
//                           });
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ), //HORA
//               Container(
//                 margin: EdgeInsets.only(top: 15),
//                 child: Row(
//                   children: [
//                     Text('Fecha del Evento: '),
//                     Text(formatoHora.format(fecha_actual),
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16)),
//                     Spacer(),
//                     IconButton(
//                       icon: Icon(MdiIcons.clock),
//                       onPressed: () {
//                         showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime.now(),
//                           locale: Locale('es', 'ES'),
//                         ).then((fecha) {
//                           setState(() {
//                             fecha_actual = fecha ?? fecha_actual;
//                           });
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ), //LUGAR
//               //BOTON
//               Container(
//                 margin: EdgeInsets.only(top: 30),
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: Text('Agregar Evento',
//                       style: TextStyle(color: Colors.white)),
//                   onPressed: () {
//                     if (formKey.currentState!.validate()) {
//                       FirestoreService().eventosAgregar(
//                         nombreCtrl.text.trim(),
//                         lugarCtrl.text.trim(),
//                         descripcionCtrl.text.trim(),
//                         tipoCtrl.text.trim(),
//                         fotoCtrl.text.trim(),
//                         fecha_actual,
//                       );
//                       Navigator.pop(context);
//                     };
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }