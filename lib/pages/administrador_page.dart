import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<EventosPage> {
  final con = FlipCardController();
  final con1 = FlipCardController();
  final cong = GestureFlipCardController();
  final cong1 = GestureFlipCardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlipCards"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            GestureFlipCard(
              controller: cong1,
              axis: FlipAxis.vertical,
              enableController: true,
              animationDuration: const Duration(milliseconds: 1000),
              frontWidget: Center(
                child: Container(
                  height: 200,
                  width: 140,
                  child: Image.asset(
                    'assets/images/background_image.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              backWidget: Container(
                height: 200,
                width: 140,
                child: Image.asset(
                  'assets/images/background_image.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Flip Bottom'),
              onPressed: () {
                // Flip the card programmatically

                cong.flipcard();
                cong1.flipcard();
              },
            ),
          ],
        ),
      ),
    );
  }
}