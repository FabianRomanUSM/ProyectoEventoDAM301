import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_evento/pages/public/eventos_agregar.dart';
import 'package:proyecto_evento/pages/public/eventos_page.dart';
import 'package:proyecto_evento/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:just_bottom_sheet/drag_zone_position.dart';
import 'package:just_bottom_sheet/just_bottom_sheet.dart';
import 'package:just_bottom_sheet/just_bottom_sheet_configuration.dart';

class AdministradorPage extends StatefulWidget {
  @override
  State<AdministradorPage> createState() => _AdministradorPageState();
}

class _AdministradorPageState extends State<AdministradorPage> {
  final formatoFecha = DateFormat(' dd-MMM-yyyy HH:mm');

  final formatoMes = DateFormat('MMM');
  final formatoDia = DateFormat('dd');

  final scrollController = ScrollController();
  bool like = true;
  final flip = GestureFlipCardController();

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Santiago');
    tz.setLocalLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Icon(
          MdiIcons.calendar,
          color: Colors.yellowAccent.shade700,
          size: 40,
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventosPage()),
                );
              },
              icon: Icon(MdiIcons.calendar), // Reemplaza con tu icono de Google
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Text('Estado de conexión'),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.yellow.shade900,
            width: double.infinity,
          ),
          // LISTA DE EVENTOS
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirestoreService().eventos(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var eventos = snapshot.data!.docs;
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) {
                        var evento =
                            eventos[index].data() as Map<String, dynamic>;
                        DateTime fecha_evento =
                            (evento['fecha'] as Timestamp).toDate();
                        return GestureFlipCard(
                          controller: flip,
                          axis: FlipAxis.vertical,
                          enableController: true,
                          animationDuration: const Duration(milliseconds: 1000),
                          frontWidget: Center(
                            child: Container(
                              height: 200,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background_image.jpg'),
                                    fit: BoxFit.cover,
                                    opacity: 0.5,
                                  ),
                                ),
                                child: Container(
                                  child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Container(
                                          color: Colors.orange.shade800,
                                          width: 60,
                                          height: 60,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  formatoMes
                                                      .format(fecha_evento),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)),
                                              Text(
                                                  formatoDia
                                                      .format(fecha_evento),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${evento['nombre']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                              softWrap: true,
                                              maxLines:
                                                  6, // Puedes ajustar el número de líneas según tus necesidades
                                              overflow: TextOverflow
                                                  .ellipsis, // Puedes cambiar esto según tus necesidades
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: InkWell(
                                        onTap: () {
                                          // Obtener el ID del documento del evento actual
                                          String docId = eventos[index].id;

                                          // Obtener el estado actual del evento
                                          String estadoActual =
                                              evento['estado'];

                                          // Cambiar el estado al contrario
                                          String nuevoEstado =
                                              (estadoActual == 'Activo')
                                                  ? 'Inactivo'
                                                  : 'Activo';

                                          // Llamar al método para cambiar el estado
                                          _cambiarEstado(docId, nuevoEstado);
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Bootstrap.clipboard_check_fill,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              Text(
                                                ' ${evento['estado']} ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 16),
                                            child: InkWell(
                                              onTap: () {
                                                // Obtener el ID del documento del evento actual
                                                String docId =
                                                    eventos[index].id;

                                                // Mostrar el diálogo de confirmación
                                                _mostrarDialogoConfirmacion(
                                                    docId);
                                              },
                                              child: Icon(
                                                MdiIcons.trashCan,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onLongPress: () {
                                        showJustBottomSheet(
                                          context: context,
                                          dragZoneConfiguration:
                                              JustBottomSheetDragZoneConfiguration(
                                            dragZonePosition:
                                                DragZonePosition.outside,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Container(
                                                height: 4,
                                                width: 30,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[300]
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                          configuration:
                                              JustBottomSheetPageConfiguration(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            builder: (context) {
                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                controller: scrollController,
                                                itemBuilder: (context, index) {
                                                  if (index == 0) {
                                                    // Primer elemento con una imagen y un texto
                                                    return Material(
                                                      color: Colors.amberAccent,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/background_image.jpg'),
                                                          Text(
                                                            'Descripión',
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else if (index == 1) {
                                                    // Segundo elemento con un texto
                                                    return Material(
                                                      color: Colors.black,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${evento['descripcion']}',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    // Puedes agregar más casos según tus necesidades
                                                    return Container();
                                                  }
                                                },
                                                itemCount: 2,
                                              );
                                            },
                                            scrollController: scrollController,
                                            closeOnScroll: true,
                                            cornerRadius: 16,
                                            backgroundColor: Theme.of(context)
                                                .canvasColor
                                                .withOpacity(0.5),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                          backWidget: Container(
                            height: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background_image.jpg'),
                                  fit: BoxFit.cover,
                                  opacity: 0.2,
                                ),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('INFORMACIÓN DEL EVENTO',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      SizedBox(width: 4),
                                      Icon(
                                        Bootstrap.ticket_perforated,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      Text(
                                        ' ${evento['tipo']} ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      SizedBox(width: 4),
                                      Icon(
                                        Bootstrap.pin_map_fill,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      Text(
                                        ' ${evento['lugar']} ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      SizedBox(width: 4),
                                      Icon(
                                        Bootstrap.calendar,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      Text(
                                        formatoFecha.format(fecha_evento),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      SizedBox(width: 4),
                                      Text(
                                        ' ${evento['like']} ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Icon(
                                        Bootstrap.hand_thumbs_up_fill,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: eventos.length,
                    );
                  }
                },
              ),
            ),
          ),
          // Align(alignment: Alignment.bottomCenter, child: bottomNav()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => EventoAgregarPage());
          Navigator.push(context, route);
        },
      ),
    );
  }

  void _cambiarEstado(String docId, String nuevoEstado) {
    // Llamar a la función para actualizar el estado del evento en Firestore
    FirestoreService().actualizarEstadoEvento(docId, nuevoEstado);
  }

  void _mostrarDialogoConfirmacion(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar borrado'),
          content: Text('¿Estás seguro de que deseas borrar este evento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Llamar a la función para borrar el evento en Firestore
                FirestoreService().eventosBorrar(docId);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Borrar'),
            ),
          ],
        );
      },
    );
  }
}
