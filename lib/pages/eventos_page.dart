import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
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
  bool like = false;

  @override
  Widget build(BuildContext context) {
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
              icon: Logo(Logos.google, size: 30),
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Estado de conección '),
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
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      itemBuilder: (context, index) {
                        var evento = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/background_image.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                color: Colors.orange.shade700,
                                width: 60,
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('31',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    Text('NOV',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
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
                                    style: TextStyle(color: Colors.white)),
                                Text(' me gusta',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            trailing: InkWell(
                              child: Icon(
                                like
                                    ? OctIcons.heart_fill_16
                                    : OctIcons.heart_16,
                                color: like
                                    ? Colors.blue.shade900
                                    : Colors.red.shade900,
                                size: 40,
                              ),
                              onTap: () {
                                like = !like;
                              },
                            ),
                            onLongPress: () {
                              mostrarInfoEvento(context, evento);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.docs.length,
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
                  child: Text('Información del Evento',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF051E34))),
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style:
                        OutlinedButton.styleFrom(backgroundColor: Colors.white),
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
