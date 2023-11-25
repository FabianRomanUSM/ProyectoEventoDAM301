import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //LISTAR EVENTO POR FECHA
  Stream<QuerySnapshot> eventos() {
    return _firestore.collection('eventos').snapshots();
  }

  //LISTAR EVENTO POR FINALIZADOS, 3 DIAS
  Stream<QuerySnapshot> eventosFinalizados() {
    DateTime actual = DateTime.now();
    Timestamp timeStampNow = Timestamp.fromDate(actual);
    return FirebaseFirestore.instance.collection('eventos').where('fecha', isLessThan: timeStampNow).snapshots();
  }

  //LISTAR EVENTO PROXIMOS
  Stream<QuerySnapshot> eventosProximos() {
    DateTime actual = DateTime.now();
    Timestamp timeStampNow = Timestamp.fromDate(actual);
    return FirebaseFirestore.instance.collection('eventos').where('fecha', isGreaterThanOrEqualTo: timeStampNow).snapshots();
  }

  //INSERTAR NUEVO EVENTO
  Future<void> eventosAgregar(String nombre, DateTime fecha, String lugar, String descripcion, String tipo, int like, String image, String estado) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'fecha': fecha,
      'lugar': lugar,
      'descripcion': descripcion,
      'tipo': tipo,
      'like': 0,
      'image': image,
      'estado': estado,
    });
  }

  //BORRAR EVENTO
  Future<void> eventosBorrar(String docId) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }

// EDITAR EVENTO
  Future<void> editarEvento(
    String docId,
    String nombre,
    DateTime fecha,
    String lugar,
    String descripcion,
    String tipo,
    String estado,
  ) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).update({
      'nombre': nombre,
      'fecha': fecha,
      'lugar': lugar,
      'descripcion': descripcion,
      'tipo': tipo,
      'estado': estado,
    });
  }

  //LIKE
  Stream<DocumentSnapshot> streamEvento(String docId) {
  return FirebaseFirestore.instance.collection('eventos').doc(docId).snapshots();
  } 
  Future<void> MeGusta(String docId, int meGusta) async {
    int numero = meGusta +1; 
    return FirebaseFirestore.instance.collection('eventos').doc(docId).update({
      'like': numero,
    });
  }

  Future<void> actualizarEstadoEvento(String docId, String nuevoEstado) {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).update({'estado': nuevoEstado});
  }
}


