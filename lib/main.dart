import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:mammba/pages/drawers/login_page.dart';
import 'package:mammba/pages/drawers/register_page.dart';
import 'package:mammba/pages/home_page.dart';

void main() => runApp(
    new AlertProvider(
      child: new MyApp(),
      config: new AlertConfig(ok: "OK", cancel: "CANCEL"),
));

class MyApp extends StatelessWidget {
   final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    RegisterPage.tag: (context) => RegisterPage(),
    HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new HomePage(title: 'Mammba')
    );
  }
}