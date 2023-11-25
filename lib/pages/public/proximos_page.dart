import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_evento/pages/public/eventos_agregar.dart';
import 'package:proyecto_evento/pages/public/eventos_page.dart';
import 'package:proyecto_evento/pages/public/finalizados_page.dart';
import 'package:proyecto_evento/pages/public/login_page.dart';
import 'package:proyecto_evento/pages/public/proximos_page.dart';
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

import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';


class ProximosPage extends StatefulWidget {
  @override
  State<ProximosPage> createState() => _ProximosPageState();
}

class _ProximosPageState extends State<ProximosPage> {
  final formatoFecha = DateFormat(' dd-MMM-yyyy HH:mm');

  final formatoMes = DateFormat('MMM');
  final formatoDia = DateFormat('dd');

  final scrollController = ScrollController();
  bool like = true;
  final flip = GestureFlipCardController();

  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "Eventos",
      Colors.orange,
      labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      Icons.search,
      "Finalizados",
      Colors.red,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.layers,
      "Proximos",
      Colors.blue,
      circleStrokeColor: Colors.black,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Santiago');
    tz.setLocalLocation(location);

    return Scaffold(
      appBar: AppBar(
         title: Text('Eventos', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              icon: Logo(Logos.google), // Reemplaza con tu icono de Google
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            ),
          Text('Estado de conexión'),
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
                stream: FirestoreService().eventosProximos(),
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
                                      subtitle: Container(
                                        child: Row(
                                          children: [
                                            Icon(Bootstrap.clipboard_check_fill, color: Colors.white,size: 16,),
                                            Text(
                                          ' ${evento['estado']} ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                          ],
                                        ),
                                      ),
                                      trailing: Container(
                                      child: InkWell(
                                        child: Icon(
                                          like
                                              ? Icons.favorite
                                              : Icons.favorite,
                                          color: like
                                              ? Colors.red.shade900
                                              : Colors.red.shade900,
                                          size: 40,
                                        ),
                                        onTap: () async {
                                          // Obtener el ID del evento actual
                                          String docId = eventos[index].id;

                                          // Obtener el número actual de likes
                                          int currentLikes = evento['like'];

                                          // Actualizar el número de likes en Firestore
                                          await FirestoreService().MeGusta(docId, currentLikes);

                                          // Cambiar el estado local para actualizar el ícono de "Me gusta"
                                          setState(() {
                                            like = !like;
                                          });
                                        },
                                      ),
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
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
      
    );
  }
  Widget bodyContainer() {
    Color? selectedColor = tabItems[selectedPos].circleColor;
    String slogan;
    switch (selectedPos) {
      case 0:
        slogan = "Todos los eventoso";
        break;
      case 1:
        slogan = "Eventos finalizad";
        break;
      case 2:
        slogan = "Proximos eventos";
        break;
      default:
        slogan = "";
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(
          child: Text(
            slogan,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value = _navigationController.value! + 1;
        }
      },
    );
  }

  Widget bottomNav() {
  return CircularBottomNavigation(
    tabItems,
    controller: _navigationController,
    selectedPos: selectedPos,
    barHeight: bottomNavBarHeight,
    barBackgroundColor: Colors.white,
    backgroundBoxShadow: <BoxShadow>[
      BoxShadow(color: Colors.black45, blurRadius: 10.0),
    ],
    animationDuration: Duration(milliseconds: 300),
    selectedCallback: (int? selectedPos) {
      setState(() {
        this.selectedPos = selectedPos ?? 0;
        print(_navigationController.value);

        // Agregar la navegación aquí
        switch (selectedPos) {
          case 0:
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventosPage()),
                );
            break;
          case 1:
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinalizadosPage()),
                );
            break;
          case 2:
            
            break;
        }
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
