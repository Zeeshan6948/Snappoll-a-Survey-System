import 'package:flutter/material.dart';
import 'package:snap_poll/start_screen.dart';

import 'home_screen.dart';

class RenderingScreen extends StatefulWidget {
  const RenderingScreen({super.key});

  @override
  State<RenderingScreen> createState() {
    return _RenderingScreenState();
  }
}

class _RenderingScreenState extends State<RenderingScreen> {
  Widget? activeScreen;

  @override
  void initState() {
    activeScreen = StartScreen(switchScreen);
    super.initState();
  }

  switchScreen() {
    setState(() {
      activeScreen = const HomeScreen();
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 30, 4, 77),
                Colors.lightBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: activeScreen,
        ),
      ),
    );
  }
}
