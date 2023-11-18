import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Titulo'),
        leading: Icon(MdiIcons.partyPopper, color: Colors.amber.shade700,),
        actions: [IconButton(onPressed: (){}, icon: Icon(MdiIcons.accountBadge))],
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}