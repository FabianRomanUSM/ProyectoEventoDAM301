import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  //insertar nuevo estudiante
  Future<void> eventosAgregar(String nombre, DateTime fecha, /*DateTime hora,*/ String lugar, String descripcion, String tipo, int like, /*String foto,*/ String estado) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'fecha': fecha,
      // 'hora': hora,
      'lugar': lugar,
      'descripcion': descripcion,
      'tipo': tipo,
      'like': like,
      // 'foto': foto,
      'estado':estado,
    });
  }



  //borrar evento
  Future<void> eventosBorrar(String docId) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }

  //obtener la lista de evento
  Future<QuerySnapshot> ordenar() async {
    return FirebaseFirestore.instance.collection('evento').orderBy('nombre').get();
  }
}