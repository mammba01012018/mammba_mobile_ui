import 'package:flutter/material.dart';
import 'package:mammba/home_page.dart';
import 'package:mammba/index_page.dart';
import 'package:mammba/login_page.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/my_bookings.dart';
import 'package:mammba/register_page.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:mammba/start_booking.dart';

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
    MyBookings.tag: (context) => MyBookings(),
    StartBooking.tag: (context) => StartBooking(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
        buttonColor: Colors.teal
      ),
      home: IndexPage(),
    );
  }
}