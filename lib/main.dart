import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import './main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //////////////////////////////////////
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs.getStringList('Single') == null) {
    _prefs.setStringList('Single', ['Player 1', 'Computer', '0', '4']);
    _prefs.setStringList('MultiPlayer', ['Player 1', 'Player 2', '0', '4']);
  }
  //////////////////////////////////////
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromARGB(255, 2, 10, 37),
        shadowColor: const Color.fromARGB(255, 5, 21, 71),
        splashColor: const Color.fromARGB(255, 72, 114, 252),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          headline4: TextStyle(
            color: Colors.red,
            fontSize: 50,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(240, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            elevation: MaterialStateProperty.all(8.0),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      home: const MainScreen(),
      builder: FlutterSmartDialog.init(),
    );
  }
}
