import 'package:flutter/material.dart';
import 'package:koinversor/view/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: MyThemes.meuTema,
  ));
}

class MyThemes {
  static final meuTema = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    appBarTheme: const AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.black,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: const TextTheme(
      bodyText2: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
    ),
  );
}
