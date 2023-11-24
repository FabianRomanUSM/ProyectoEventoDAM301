import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_evento/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventoAgregarPage extends StatefulWidget {
  EventoAgregarPage({Key? key}) : super(key: key);

  @override
  State<EventoAgregarPage> createState() => _EventoAgregarPageState();
}

class _EventoAgregarPageState extends State<EventoAgregarPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController tipoCtrl = TextEditingController();
  TextEditingController likeCtrl = TextEditingController();
  TextEditingController estadoCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  DateTime fecha_matricula = DateTime.now();
  final formatoFecha = DateFormat('dd-MMM-yyyy');
  // String jornada = 'd';
  // String carrera = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Evento', style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              //NOMBRE
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(
                  label: Text('Nombre'),
                ),
                validator: (nombre) {
                  if (nombre!.isEmpty) {
                    return 'Indique el nombre del evento';
                  }
                  if (nombre.length < 3) {
                    return 'El nombre debe ser de al menos 3 letras';
                  }
                  return null;
                },
              ),
              //LUGAR
              TextFormField(
                controller: lugarCtrl,
                decoration: InputDecoration(
                  label: Text('Lugar'),
                ),
                validator: (lugar) {
                  if (lugar!.isEmpty) {
                    return 'Indique el lugar del evento';
                  }
                  if (lugar.length < 3) {
                    return 'El nombre del lugar debe ser de al menos 3 letras';
                  }
                  return null;
                },
              ),
              //DESCRIPCIÓN
              TextFormField(
                controller: descripcionCtrl,
                decoration: InputDecoration(
                  label: Text('Descripcion'),
                ),
                validator: (descripcion) {
                  if (descripcion!.isEmpty) {
                    return 'Describa descripción del evento';
                  }
                  if (descripcion.length < 3) {
                    return 'La descripción debe ser de al menos 3 letras';
                  }
                  return null;
                },
              ),
              //TIPO
              TextFormField(
                controller: tipoCtrl,
                decoration: InputDecoration(
                  label: Text('Tipo'),
                ),
                validator: (tipo) {
                  if (tipo!.isEmpty) {
                    return 'Indique el tipo de evento';
                  }
                  if (tipo.length < 3) {
                    return 'El tipo debe ser de al menos 3 letras';
                  }
                  return null;
                },
              ),
              //ESTADO
              TextFormField(
                controller: estadoCtrl,
                decoration: InputDecoration(
                  label: Text('Estado'),
                ),
                validator: (estado) {
                  if (estado!.isEmpty) {
                    return 'Indique el estado del evento';
                  }
                  if (estado.length < 3) {
                    return 'El estado debe ser de al menos 3 letras';
                  }
                  return null;
                },
              ),
              // //LIKE
              // TextFormField(
              //   controller: likeCtrl,
              //   decoration: InputDecoration(
              //     label: Text('Me gusta'),
              //   ),
              //   validator: (like) {
              //     if (like!.isEmpty) {
              //       return 'Indique la edad del estudiante';
              //     }
              //     try {
              //       int.parse(like);
              //     } catch (e) {
              //       return 'Edad debe ser un número entero';
              //     }
              //     int intEdad = int.parse(like);
              //     if (intEdad < 0) {
              //       return 'Edad debe ser mayor o igual a cero';
              //     }
              //     return null;
              //   },
              // ),
              //FECHA EVENTO
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Text('Fecha evento: '),
                    Text(formatoFecha.format(fecha_matricula), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Spacer(),
                    IconButton(
                      icon: Icon(MdiIcons.calendar),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          locale: Locale('es', 'ES'),
                        ).then((fecha) {
                          setState(() {
                            fecha_matricula = fecha ?? fecha_matricula;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              // //JORNADA
              // Container(
              //   margin: EdgeInsets.only(top: 10),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Jornada'),
              //       RadioListTile(
              //         title: Text('Diurna'),
              //         value: 'd',
              //         groupValue: jornada,
              //         onChanged: (jornadaSeleccionada) {
              //           setState(() {
              //             jornada = jornadaSeleccionada!;
              //           });
              //         },
              //       ),
              //       RadioListTile(
              //         title: Text('Vespertina'),
              //         value: 'v',
              //         groupValue: jornada,
              //         onChanged: (jornadaSeleccionada) {
              //           setState(() {
              //             jornada = jornadaSeleccionada!;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // //CARRERA
              // FutureBuilder(
              //     future: FirestoreService().carreras(),
              //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              //         //esperando
              //         return Text('Cargando Carreras...');
              //       } else {
              //         var carreras = snapshot.data!.docs;
              //         return DropdownButtonFormField<String>(
              //           value: carrera == '' ? carreras[0]['nombre'] : carrera,
              //           decoration: InputDecoration(labelText: 'Carrera'),
              //           // items: [
              //           //   DropdownMenuItem(child: Text('T.U. en Informática'), value: 'T.U. en Informática'),
              //           //   DropdownMenuItem(child: Text('Ing. en Informática'), value: 'Ing. en Informática'),
              //           // ],
              //           items: carreras.map<DropdownMenuItem<String>>((carr) {
              //             return DropdownMenuItem<String>(
              //               child: Text(carr['nombre']),
              //               value: carr['nombre'],
              //             );
              //           }).toList(),
              //           onChanged: (carreraSeleccionada) {
              //             setState(() {
              //               carrera = carreraSeleccionada!;
              //             });
              //           },
              //         );
              //       }
              //     }),
              
              //BOTON
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Agregar Evento', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      //formulario está ok
                      //proceder con agregar estudiante a bd
                      FirestoreService().eventosAgregar(
                        nombreCtrl.text.trim(),
                        fecha_matricula,
                        lugarCtrl.text.trim(),
                        descripcionCtrl.text.trim(),
                        tipoCtrl.text.trim(),
                        int.tryParse(likeCtrl.text.trim()) ?? 0,
                        estadoCtrl.text.trim(),
                        
                        // fecha_matricula,
                        // jornada,
                        // carrera,
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}