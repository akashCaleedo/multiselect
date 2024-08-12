import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        primaryColorLight: Colors.redAccent,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFEEEEEE),
        ),
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        primaryColorLight: Colors.redAccent,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1b1926)),
        snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.red),
        canvasColor: const Color(0xFF272537),
        dialogBackgroundColor: const Color(0xFF343346),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF383849),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // DropDownMultiSelect comes from multiselect
        child: DropDownMultiSelect(
          selectedValuesStyle: const TextStyle(
              color: Colors.white, overflow: TextOverflow.ellipsis),
          onChanged: (List<String> x) {
            setState(() {
              selected = x;
            });
            log(selected.toString(), name: "MultiSelect");
          },
          options: const [
            'Select 1',
            'b',
            'c',
            'd',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
            'Select 1',
          ],
          selectedValues: selected,
          whenEmpty: 'Select Something',
        ),
      ),
    ));
  }
}
