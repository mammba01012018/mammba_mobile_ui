import 'dart:async';

import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/pages/drawers/login_page.dart';
import 'package:mammba/pages/drawers/register_page.dart';
import 'package:mammba/pages/others/contacts_demo.dart';
import 'package:mammba/tabs/my_bookings.dart';
import 'package:mammba/tabs/tours.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  static Member user;
  static String csrf;
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  Tours tours;
  Tours tours2;
  Tours tours3;
  Tours tours4;
  MyBookings myBookings;
  List<Widget> pages;
  Widget currentPage;
  static Member user;
  static String csrf;

  @override
  void initState() {
    tours = Tours();
    tours2 = Tours();
    tours3 = Tours();
    tours4 = Tours();
    myBookings = MyBookings();

    pages = [tours, tours2, tours3, tours4, myBookings];

    currentPage = tours;

    super.initState();
  }

  void _awaitReturnValueFromLogInScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new LoginPage(),
        ));
    setState(() {
      user = result.user;
      csrf = result.csrf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                        print(user.userId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactsDemo(user: user, csrf: csrf)),
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
                    _awaitReturnValueFromLogInScreen(context);
                  }
                ): new ListTile(
                  title: new Text("Sign Out"),
                  trailing: new Icon(Icons.settings_power),
                  onTap: () {
                    if(user!=null) {
                      setState(() {
                        user = null;
                        Navigator.of(context).pop();
                        Alert.alert(context, title: "", content: "Successfully Logout")
                           .then((_) => null
                        );
                      });
                    }
                  }
                ),
                new ListTile(
                  title: new Text("My Messages"),
                  trailing: new Icon(Icons.message),
                  onTap: () {
                    print(user.toJson());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BottomNavigationDemo()),
                    // );
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
      
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: Text('Tour' , textScaleFactor: 0.85),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            title: Text("Transpo" , textScaleFactor: 0.85),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            title: Text("Hotels" , textScaleFactor: 0.85),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            title: Text("Flights", textScaleFactor: 0.85),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text("MyBookings", textScaleFactor: 0.85),
          ),
        ],
      ),
    );
  }
}
