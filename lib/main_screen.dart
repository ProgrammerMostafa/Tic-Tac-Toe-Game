import 'package:flutter/material.dart';
import './game_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/photo1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? Column(children: [...photos()])
                    : Row(
                        children: [...photos()],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                ////////////////////////////////////////////////
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  GameScreen(typeGame: 'Single'))),
                      icon: const Icon(
                        Icons.person,
                        size: 30,
                      ),
                      label: const Text('SINGLEPLAYER'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  GameScreen(typeGame: 'MultiPlayer'))),
                      icon: const Icon(
                        Icons.group,
                        size: 30,
                      ),
                      label: const Text('MULTIPLAYER'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> photos() {
    return [
      Image.asset(
        'assets/images/ph1.png',
        height: 100,
        width: 100,
        alignment: Alignment.center,
      ),
      Image.asset(
        'assets/images/ph2.png',
        height: 100,
        width: 100,
      ),
      Image.asset(
        'assets/images/ph3.png',
        height: 100,
        width: 100,
      ),
    ];
  }
}
