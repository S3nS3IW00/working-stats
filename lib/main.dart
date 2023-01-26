import 'package:flutter/material.dart';

import './screens/home.dart';

void main() => runApp(WorkingStats());

class WorkingStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        colorScheme: ColorScheme.dark(
          primary: Colors.red,
          onPrimary: Colors.red,
          secondary: Colors.red,
        ),
        scaffoldBackgroundColor: Colors.black87,
        unselectedWidgetColor: Colors.grey,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
