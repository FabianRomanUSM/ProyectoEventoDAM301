import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_evento/pages/eventos_agregar.dart';
import 'package:proyecto_evento/services/firestore_service.dart';
import 'package:proyecto_evento/widgets/campo_eventos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class EventosPage extends StatelessWidget {
  final formatoFecha = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
        leading: Icon(MdiIcons.firebase, color: Colors.yellow.shade700),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [PopupMenuItem(child: Text('Cerrar Sesión'), value: 'logout')],
            onSelected: (opcion) {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //EMAIL USER
          Container(
            padding: EdgeInsets.all(10),
            color: Color(0xFF051E34),
            width: double.infinity,
            // child: Text(this.emailUsuario(context), style: TextStyle(color: Colors.white)),
          ),
          //LISTA DE EVENTOS
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirestoreService().eventos(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var evento = snapshot.data!.docs[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.red,
                                icon: MdiIcons.trashCan,
                                label: 'Borrar',
                                onPressed: (context) {
                                  FirestoreService().eventosBorrar(evento.id);
                                },
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(MdiIcons.account),
                            title: Text('${evento['nombre']}'),
                            subtitle: Text(evento['descripcion']),
                            onLongPress: () {
                              mostrarInfoEvento(context, evento);
                            },
                          ),
                        );
                      },
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
          // MaterialPageRoute route = MaterialPageRoute(builder: (context) => EventosAgregarPage());
          // Navigator.push(context, route);
        },
      ),
    );
  }

  void mostrarInfoEvento(BuildContext context, evento) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              border: Border.all(color: Colors.blue.shade900, width: 2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: Text('Información del Eventos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF051E34))),
                ),
                CampoEvento(dato: '${evento['nombre']} ${evento['tipo']}', icono: MdiIcons.account),
                // CampoEvento(dato: '${evento['lugar']} años', icono: MdiIcons.cake),
                // CampoEvento(dato: '${evento['nombre']}', icono: MdiIcons.schoolOutline),
                // CampoEvento(dato: formatoFecha.format(evento['fecha_actual'].toDate()), icono: MdiIcons.calendarRange),
                // CampoEvento(dato: formatoHora.format(evento['fecha_actual'].toDate()), icono: MdiIcons.calendarRange),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text('Cerrar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // String emailUsuario(BuildContext context) {
  //   final usuario = Provider.of<User?>(context);
  //   return usuario!.email.toString();
  // }
}