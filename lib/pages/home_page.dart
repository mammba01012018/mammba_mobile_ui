import 'dart:async';
import 'dart:convert';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mammba/models/LogInUser.dart';
import 'package:mammba/models/LoginResponse.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/pages/drawers/login_page.dart';
import 'package:mammba/pages/drawers/register_page.dart';
import 'package:mammba/pages/others/contacts_demo.dart';
import 'package:mammba/pages/tourpages/tours_result.dart';
import 'package:mammba/tabs/my_bookings.dart';
import 'package:mammba/tabs/tours.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  final String title;
  Member user;
  String csrf;
  static String tag = 'home-page';
  bool savedUser = false;
  String titleTo ='Register';
  HomePage({Key key, this.title,  this.user, this.csrf}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

const jsonCodec = const JsonCodec();


class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  Tours tours;
  Tours tours2;
  Tours tours3;
  Tours tours4;
  MyBookings myBookings;
  List<Widget> pages;
  Widget currentPage;
  bool _inAsyncCall = false;
  

  @override
  void initState() {
    tours = Tours();
    tours2 = Tours();
    tours3 = Tours();
    tours4 = Tours();
    myBookings = MyBookings();

    

    pages = [tours, tours2, tours3, tours4, myBookings];

    currentPage = tours;
    print('start');
    
    initUser();
    super.initState();
  }

  initUser() async {
    String username;
    String password;
    Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
    _sprefs.then(
      (pref)
        {
          username = pref.getString('username');
          password = pref.getString('password');
          print('bago shared preferendsadsaceasasas asasa') ;
          print(username);
          print(password);
          this.loginSave(username, password);
        }
    );
  }

  loginSave(username, password) async {
    if(username!=null) {
      print('nervana');
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/login?username="+username+"&password="+password;
      _inAsyncCall = true;
      try {
        dynamic body = await Requests.post(url, json: true);
        var userMember = body['member'];
        var userFinal = new Member.fromJson(userMember);
        var resultResponse  = new LoginResponse.toSave(userFinal, body['_csrf'].toString());
        widget.user = userFinal;
        setState(() {
          widget.user = userFinal;
          widget.csrf = resultResponse.csrf;
        });
        print('user eto eto adasdsad');
        print(userFinal);
        _inAsyncCall = false;
        return userFinal;
      } catch(e) {
        print(e);
        _inAsyncCall = false;
      } finally {
        _inAsyncCall = false;
      }
    } 
  }

  void _awaitReturnValueFromLogInScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new LoginPage(),
        ));
    print('returned resule from login');
    print(result.toString());
    setState(() {
      widget.user = result.user;
      widget.csrf = result.csrf;
    });
  }

  void _awaitReturnValueFromRegisterScreen(BuildContext context) async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new RegisterPage(),
        ));
      this.loginTo();
  }

   loginTo() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username');
      String password = prefs.getString('password');
      print('from reguister login jkjk') ;
      print(username);
      print(password);
      LogInUser logInUser = new LogInUser();
      logInUser.userEmail = username;
      logInUser.password = password;
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/login?username="+username+"&password="+password;
      var json = jsonCodec.encode(logInUser);
      setState(() {
        _inAsyncCall = true;
      });
      try {
        dynamic body = await Requests.post(url, json: true, body: json );
        var user = body['member'];
        var userFinal = new Member.fromJson(user);
        var resultResponse  = new LoginResponse.toSave(userFinal, body['_csrf'].toString());
        print('login eto adkjasgdjkgas dvjas');
        setState(() {
          widget.user = userFinal;
          widget.csrf = resultResponse.csrf;
        });
      } catch(e) {
        print(e);
        Alert.alert(context, title: "value", content: "Username and password do not match. Please try again")
        .then((_) => null);
      } finally {
        setState(() {
          _inAsyncCall = false;
        });
      }
  }
 
  clearLoginUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    widget.savedUser = false;
  }

  void setUserFromUpdated(BuildContext context) async {
     final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactsDemo(user: widget.user, csrf: widget.csrf)),
      );
      if(result!=null) {
        setState(() {
          widget.user = result;
        });
      }
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
                   accountName: (widget.user!=null ? new Text(widget.user.firstName + ' '+ widget.user.lastName) : new Text('') ),
                   accountEmail: new Text(widget.user!=null ? widget.user.emailAddress: ''),
                   currentAccountPicture: new GestureDetector(
                   onTap: () {
                      if(widget.user!=null) {
                        setUserFromUpdated(context);
                     }
                  },
                  child: widget.user!=null ? new CircleAvatar(
                    backgroundImage: widget.user!=null ? new NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIAVvRR35IC9yiDnGjU5dJJU_wxJLLiXQKpefCQdtoUSF7PCQRTg")
                       : null, 
                  ) : new Container()
                  ),
                ),
                widget.user == null ? new ListTile(
                  title: new Text('Register'),
                  trailing: new Icon(Icons.account_box),
                  onTap: () {
                   _awaitReturnValueFromRegisterScreen(context);
                  }
                ) : new Container(),
                widget.user==null ? new ListTile(
                  title: new Text(widget.user==null ? 'Sign-In' : widget.user.userId.toString()),
                  trailing: new Icon(Icons.account_circle),
                  onTap: () {
                    _awaitReturnValueFromLogInScreen(context);
                  }
                ): new ListTile(
                  title: new Text("Sign Out"),
                  trailing: new Icon(Icons.settings_power),
                  onTap: () {
                    if(widget.user!=null) {
                      this.clearLoginUser();
                      setState(() {
                        widget.user = null;
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
