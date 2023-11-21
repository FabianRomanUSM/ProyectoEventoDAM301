import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter/cupertino.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estrenos video juegos'),
        leading: Icon(
          MdiIcons.gamepadVariant,
          color: Colors.yellowAccent.shade700,
          size: 40,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(MdiIcons.google),
          )
        ],
      ),
      body: Column(
        children: [
          //Filtro de Eventos
          Container(
            width: double.infinity,
            height: 190,
            child: Container(
              margin: EdgeInsets.only(top: 60),
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x66FFFFFF), width: 10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Evento Finalizados'),
                  Text('Evento Activos'),
                  Text('Evento Destacados'),
                ],
              ),
            ),
          ),

          //Lista de eventos
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/background_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10.0), 
                      child: Container(
                        color: Colors.orange.shade700,
                        width: 60, 
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('31', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20)),
                            Text('NOV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Evento',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text('99', style: TextStyle(color: Colors.white)),
                        Text(' me gusta',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    trailing: InkWell(
                      child: Icon(
                        Icons.favorite_outline,
                        color: Colors.red.shade900,
                        size: 40,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),Bounceable(
                    onTap: () {},
                    scaleFactor: 0.6,
                    child: Icon(
                      CupertinoIcons.person_crop_circle,
                      color: Colors.blueAccent,
                      size: 32,
                    ),
                  ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}