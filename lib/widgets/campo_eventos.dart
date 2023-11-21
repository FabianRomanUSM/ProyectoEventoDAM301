import 'package:flutter/material.dart';

class CampoEvento extends StatelessWidget {
  const CampoEvento({
    super.key,
    required this.dato,
    required this.icono,
  });

  final String dato;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Icon(this.icono),
          Text(' ' + this.dato),
        ],
      ),
    );
  }
}