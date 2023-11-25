import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_evento/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:proyecto_evento/services/select_image.dart';
import 'package:proyecto_evento/services/upload_image.dart';

class EventoEditarPage extends StatefulWidget {
  EventoEditarPage({Key? key}) : super(key: key);

  @override
  State<EventoEditarPage> createState() => EventoEditarPageState();
}

class EventoEditarPageState extends State<EventoEditarPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController tipoCtrl = TextEditingController();
  TextEditingController likeCtrl = TextEditingController();
  TextEditingController imageCtrl = TextEditingController();
    
  final formKey = GlobalKey<FormState>();

  DateTime fechaYHoraEvento = DateTime.now();
  final formatoFechaYHora = DateFormat('dd/MM/yyyy hh:mm a');

  File? imagen_a_cargar;

  String estado = 'Activo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Evento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                            // Cambia lastDate a un valor futuro, por ejemplo, 5 años desde ahora
                            lastDate:
                                DateTime.now().add(Duration(days: 365 * 5)),
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
                              // Puedes agregar una lógica personalizada aquí para deshabilitar ciertas fechas si es necesario
                              return true;
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
                    Text('  Fecha y Hora: ', style: TextStyle(fontSize: 17)),
                    Text(formatoFechaYHora.format(fechaYHoraEvento),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),
                  ],
                ),
              ),
              //ESTADO
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado: ' ,style: TextStyle(fontSize: 18)),
                    RadioListTile(
                      title: Text('Activo'),
                      value: 'Activo',
                      groupValue: estado,
                      onChanged: (estadoSeleccionada) {
                        setState(() {
                          estado = estadoSeleccionada!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Inactivo'),
                      value: 'Inactivo',
                      groupValue: estado,
                      onChanged: (estadoSeleccionada) {
                        setState(() {
                          estado = estadoSeleccionada!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //FOTO
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700),
                  onPressed: () async {
                    final imagen = await getImage();
                    setState(() {
                      imagen_a_cargar = File(imagen!.path);
                    });
                    if (imagen_a_cargar == null) {
                      return;
                    }
                    final String uploaded = await uploadImage(imagen_a_cargar!);
                    if (uploaded != '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Imagen subida correctamente')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Error al subir la imagen')));
                    }
                  },
                  child: Text('Subir imagen desde dispositivo',
                      style: TextStyle(color: Colors.white))),
              Column(
                children: [
                  imagen_a_cargar != null
                      ? Image.file(imagen_a_cargar!)
                      : Container(
                          margin: const EdgeInsets.all(5),
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey.shade400,
                        ),
                ],
              ),
              //BOTON
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
                        fechaYHoraEvento,
                        lugarCtrl.text.trim(),
                        descripcionCtrl.text.trim(),
                        tipoCtrl.text.trim(),
                        int.tryParse(likeCtrl.text.trim()) ?? 0,
                        imageCtrl.text.trim(),
                        estado,
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
