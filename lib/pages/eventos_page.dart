import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_evento/pages/eventos_agregar.dart';
import 'package:proyecto_evento/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class EventosPage extends StatelessWidget {
  final formatoFecha = DateFormat('dd-MM-yyyy HH:mm');
  final formatoMes = DateFormat('MMM');
  final formatoDia = DateFormat('dd');

  bool like = true;
  final flip = GestureFlipCardController();

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Santiago');
    tz.setLocalLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
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
                // Acción a realizar al hacer clic en el icono de Google.
              },
              icon: Icon(Icons.ac_unit), // Reemplaza con tu icono de Google
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Estado de conexión '),
          // EMAIL USER
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.yellow.shade900,
            width: double.infinity,
            // child: Text(this.emailUsuario(context), style: TextStyle(color: Colors.white)),
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
                        var evento = eventos[index].data() as Map<String, dynamic>;
                        DateTime fecha_evento = (evento['fecha'] as Timestamp).toDate();
                        DateTime hora_evento = (evento['fecha'] as Timestamp).toDate();
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        color: Colors.orange.shade700,
                                        width: 60,
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(formatoMes.format(fecha_evento),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                            Text(formatoDia.format(fecha_evento),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          '${evento['nombre']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text('${evento['like']}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text(' me gusta',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      child: Icon(
                                        like
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: like
                                            ? Colors.blue.shade900
                                            : Colors.red.shade900,
                                        size: 40,
                                      ),
                                      onTap: () {
                                        like = !like;
                                      },
                                    ),
                                  ),
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
                                  Text('Información del Evento',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(height: 6),
                                  Text(
                                    '${evento['nombre']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${evento['descripcion']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${evento['tipo']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.thumb_up, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        'Like: ${evento['like']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    formatoFecha.format(hora_evento),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Implementa la lógica para agregar eventos
        },
      ),
    );
  }
}
