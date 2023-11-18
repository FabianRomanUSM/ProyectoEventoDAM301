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
            //TITULO Y TABS
            Container(
              width: double.infinity,
              height: 190,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/bg_perro.jpg'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
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
            //FIN TITULO Y TABS

            //PAGINAS
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
            borderRadius: BorderRadius.circular(10.0), // Bordes redondos para la imagen
            child: Image.asset(
              'assets/images/background_image.jpg', // Ruta de tu imagen
              width: 60, // Tamaño no expansible
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            children: [
              Text(
                'Evento',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Text('99', style: TextStyle(color: Colors.white)),
              Text(' me gusta', style: TextStyle(color: Colors.white)),
            ],
          ),
          trailing: InkWell(
            child: Icon(Icons.favorite_outline, color: Colors.red.shade900, size: 30,),
            onTap: () {},
          ),
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