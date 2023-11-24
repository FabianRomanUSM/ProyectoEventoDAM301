import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_evento/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

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
  DateTime fecha_actual = DateTime.now();
  final formatoFecha = DateFormat('dd-MMM-yyyy');

  DateTime fechaYHoraEvento = DateTime.now();
  final formatoFechaYHora = DateFormat('dd/MM/yyyy hh:mm a');

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
              //DESCRIPCION
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
              // //ESTADO
              // TextFormField(
              //   controller: estadoCtrl,
              //   decoration: InputDecoration(
              //     label: Text('Estado'),
              //   ),
              //   validator: (estado) {
              //     if (estado!.isEmpty) {
              //       return 'Indique el estado del evento';
              //     }
              //     if (estado.length < 3) {
              //       return 'El estado debe ser de al menos 3 letras';
              //     }
              //     return null;
              //   },
              // ),
              //FECHA Y HORA
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Bootstrap.calendar_event),
                        onPressed: () async {
                          DateTime? dateTime = await showOmniDateTimePicker(
                            context: context,
                            initialDate: fechaYHoraEvento,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            is24HourMode: false,
                            isShowSeconds: false,
                            minutesInterval: 1,
                            secondsInterval: 1,
                            isForce2Digits: true,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            constraints: const BoxConstraints(
                              maxWidth: 350,
                              maxHeight: 650,
                            ),
                            transitionBuilder: (context, anim1, anim2, child) {
                              return FadeTransition(
                                opacity: anim1.drive(
                                  Tween(
                                    begin: 0,
                                    end: 1,
                                  ),
                                ),
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            barrierDismissible: true,
                            selectableDayPredicate: (dateTime) {
                              if (dateTime == DateTime(2023, 2, 25)) {
                                return false;
                              } else {
                                return true;
                              }
                            },
                          );

                          if (dateTime != null &&
                              dateTime != fechaYHoraEvento) {
                            setState(() {
                              fechaYHoraEvento = dateTime;
                            });
                          }
                        },
                      ),
                    ),
                    Text('  Fecha y Hora: ',
                        style: TextStyle(fontSize: 17)),
                    Text(formatoFechaYHora.format(fechaYHoraEvento),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Agregar Evento',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirestoreService().eventosAgregar(
                        nombreCtrl.text.trim(),
                        fecha_actual,
                        lugarCtrl.text.trim(),
                        descripcionCtrl.text.trim(),
                        tipoCtrl.text.trim(),
                        int.tryParse(likeCtrl.text.trim()) ?? 0,
                        estadoCtrl.text.trim(),
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
