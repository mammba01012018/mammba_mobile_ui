import 'package:flutter/material.dart';
import 'package:mammba/common/common-fields.dart';
import 'package:mammba/home_page.dart';
import 'package:mammba/login_page.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/my_bookings.dart';
import 'package:mammba/register_page.dart';

class IndexPage extends StatefulWidget {
  static String tag = 'index-page';
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  
  
  static Member user;

  @override
  Widget build(BuildContext context) {
    
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(0.0),
        // shadowColor: Colors.lightBlueAccent,
        // elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) =>
                new LoginPage())
              );
            // Navigator.pushNamed(context, LoginPage.tag);
            // Navigator.of(context).pushNamed(LoginPage.tag);
          },
          color: Colors.teal,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(0.0),
        // shadowColor: Colors.lightBlueAccent,
        // elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) =>
                new RegisterPage())
              );
          },
          color: Colors.teal,
          child: Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final myBookingsButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(0.0),
        // shadowColor: Colors.lightBlueAccent,
        // elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) =>
                new MyBookings())
              );
            // Navigator.pushNamed(context, LoginPage.tag);
            // Navigator.of(context).pushNamed(LoginPage.tag);
          },
          color: Colors.teal,
          child: Text('My Bookings', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final startBookingButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(0.0),
        // shadowColor: Colors.lightBlueAccent,
        // elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) =>
                new LoginPage())
              );
          },
          color: Colors.teal,
          child: Text('Start Booking', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
    
    final homePageButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(0.0),
        // shadowColor: Colors.lightBlueAccent,
        // elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          onPressed: () {
            
            Navigator.push(context, new MaterialPageRoute(
             
              builder: (context) => new HomePage())
            );
          },
          color: Colors.teal,
          child: Text('Start Booking', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only( left: 24.0, right: 24.0, top: 0.0),
          children: <Widget>[
            CommonField().logo,
            SizedBox(height: 48.0),
            homePageButton,
            SizedBox(height: 8.0),
            myBookingsButton
          ],
        ),
      ),
    );
  }
}