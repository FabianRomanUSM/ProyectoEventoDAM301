import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiesta'),
        leading: Icon(MdiIcons.partyPopper, color: Colors.amber.shade700,),
        actions: [IconButton(onPressed: (){},icon: Icon(MdiIcons.google),)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: [
                ListTile(
                  leading: Icon(MdiIcons.dog, size: 30, color: Colors.deepPurple),
                  title: Row(
                    children: [
                      Text(
                        'Evento',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        ' (Perro)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text('99'),
                      Text(' me gusta')
                    ],
                  ),
                  trailing: InkWell(
                    child: Icon(MdiIcons.heartOutline, color: Colors.red.shade900, size: 30,),
                    onTap: () {},
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
          ),
        ],
      ),

      //BOTON AGREGAR
      floatingActionButton: FloatingActionButton(
        child: Icon(
          MdiIcons.plus,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
      ),
    );
  }
}