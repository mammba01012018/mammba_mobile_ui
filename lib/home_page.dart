import 'dart:async';

import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:mammba/contacts_demo.dart';
import 'package:mammba/bottom_navigation_demo.dart';
import 'package:mammba/login_page.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/my_bookings.dart';
import 'package:mammba/register_page.dart';
import 'package:mammba/tabs/tours.dart' as tour;

class HomePage extends StatelessWidget {

  static Member user;
  static String tag = 'home-page';
  

  @override
  Widget build(BuildContext context) {
    print('home page build');
    print(user.toString());
    return new DefaultTabController(
        length: 5,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("MAMMBA"),
            bottom: new TabBar(
              tabs: <Widget>[
                new Container(
                  height: 100.0,
                  child:  new Tab(
                  text: 'To', 
                  icon: new Icon(Icons.card_travel, color: Colors.white ,size: 18.0,),),
                ),
                new Container(
                  height: 100.0,
                  child:   new Tab(
                  text: 'Transpo', 
                  icon: new Icon(Icons.directions_car, color: Colors.green[900],size: 18.0,)),
                ),
                new Container(
                  height: 100.0,
                  child:  new Tab(
                  text: 'Hotels', 
                  icon: new Icon(Icons.hotel, color: Colors.green[900],size: 18.0,)),
                ),
                new Container(
                  height: 100.0,
                  child:  new Tab(
                  text: 'Flights', 
                  icon: new Icon(Icons.airplanemode_active, color:Colors.green[900],size: 18.0,))
                ),
              ],
            ),
          ),
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                   margin: const EdgeInsets.only(bottom: 0.0, top: 0.0),
                   accountName: (user!=null ? new Text(user.firstName + ' '+ user.lastName) : new Text('') ),
                   accountEmail: new Text(user!=null ? user.emailAddress: ''),
                   currentAccountPicture: new GestureDetector(
                    onTap: () {
                      if(user!=null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactsDemo(user: user)),
                      );
                    }
                  },
                  child: user!=null ? new CircleAvatar(
                    backgroundImage: user!=null ? new NetworkImage("https://scontent.fceb1-1.fna.fbcdn.net/v/t1.0-1/c0.0.160.160a/p160x160/1558408_695435787164136_943786540553257078_n.jpg?_nc_cat=104&_nc_ht=scontent.fceb1-1.fna&oh=2cd0ecbc3a0edcaddef834f799cb6cbd&oe=5CD44282")
                       : null, 
                  ) : new Container()
                  ),
                ),
                user == null ? new ListTile(
                  title: new Text("Register"),
                  trailing: new Icon(Icons.account_box),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  }
                ) : new Container(),
                user==null ? new ListTile(
                  title: new Text("Sign In"),
                  trailing: new Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                ): new ListTile(
                  title: new Text("Sign Out"),
                  trailing: new Icon(Icons.settings_power),
                  onTap: () {
                    if(HomePage.user!=null) {
                       HomePage.user = null;
                        Alert.alert(context, title: "", content: "Successfully Logout")
                          .then((_) => null);
                        new Timer(const Duration(milliseconds: 1000), () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                        });
                    }
                  }
                ),
                
                new ListTile(
                  title: new Text("My Bookings"),
                  trailing: new Icon(Icons.book),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyBookings()),
                    );
                  }
                ),
                new ListTile(
                  title: new Text("My Messages"),
                  trailing: new Icon(Icons.message),
                  onTap: () {
                    print(user.toJson());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavigationDemo()),
                    );
                  }
                ),
                new ListTile(
                  title: new Text("Promos"),
                  trailing: new Icon(Icons.card_giftcard),
                ),
                new ListTile(
                  title: new Text("App Settings"),
                  trailing: new Icon(Icons.settings),
                ),
                new ListTile(
                  title: new Text("Help and Feedback"),
                  trailing: new Icon(Icons.phone),
                ),
                
              ],
            )
          ),
          body: new Container()
          // new TabBarView(
          //   children: <Widget>[
          //     new tour.Tours(),
          //     new tour.Tours(),
          //     new tour.Tours(),
          //     new tour.Tours(),
          //   ],
          // )
        ),
      );
  }
}