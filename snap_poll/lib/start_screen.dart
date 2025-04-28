import 'package:flutter/material.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class StartScreen extends StatelessWidget {
  const StartScreen(this.startRenderingScreen, {super.key});

  final void Function() startRenderingScreen;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/sp01.png',
            width: 200,
            color: const Color.fromARGB(200, 255, 255, 255),
          ),
          const SizedBox(height: 100),
          OutlinedButton.icon(
            onPressed: startRenderingScreen,
            style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
            icon: const Icon(Icons.arrow_right_alt),
            label: const Text('homescreen'),
          ),
        ],
      ),
    );
  }
}
