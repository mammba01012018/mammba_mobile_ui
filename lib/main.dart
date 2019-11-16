import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mammba/models/LoginResponse.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/pages/drawers/login_page.dart';
import 'package:mammba/pages/drawers/register_page.dart';
import 'package:mammba/pages/home_page.dart';
import 'package:mammba/pages/others/into-slider.dart';
import 'package:requests/requests.dart';

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
    IntroSliderPage.tag: (context) => IntroSliderPage(),
  };


  bool _inAsyncCall = false;
  Member user;
  String csrf;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new HomePage(title: 'Mammba')  
      // home: FutureBuilder (
      //       future: getLoginUser(),
      //       builder: (BuildContext context,  AsyncSnapshot<dynamic> snapshot) {
      //           print(user);
      //           print(snapshot.data);
      //           switch (snapshot.connectionState) {
      //               case ConnectionState.none:
      //               case ConnectionState.waiting: 
      //                 return CircularProgressIndicator();
      //               default: {
      //                 if (snapshot.hasError)
      //                     return Text('Error: ${snapshot.error}');
      //                 else {
      //                   if(snapshot.data == null)
      //                     return  new HomePage(title: 'Mammba');
      //                   else {
      //                     var body = snapshot.data;
      //                     print(body);
      //                     var userMember = body['member'];
      //                     var userFinal = new Member.fromJson(userMember);
      //                     var resultResponse  = new LoginResponse.toSave(userFinal, body['_csrf'].toString());
      //                     user = userMember;
      //                     csrf = resultResponse.csrf;
      //                     return new HomePage(title: 'Mammba', user: user, csrf: csrf);
      //                   }
      //                 }
                        
      //               }
      //           }

      //       }
      //     )
    );
  }

  getWidget() async {
    
    final storage = new FlutterSecureStorage();
    String savedUserName = await storage.read(key: 'username');
    String savedPassword = await storage.read(key: 'password');
    if(savedUserName!=null) {
       var body = logIn(savedUserName, savedPassword);
       return new HomePage(title: 'Mammba', user: body.user, csrf: body.csrf);
    } else {
       return new HomePage(title: 'Mammba');
    }
  }

   getLoginUser() async {
    
  }

  logIn(String username, String password) async {
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/login?username="+username+"&password="+password;
      _inAsyncCall = true;
      try {
        dynamic body = await Requests.post(url, json: true);
        var userMember = body['member'];
        var userFinal = new Member.fromJson(userMember);
        var resultResponse  = new LoginResponse.toSave(userFinal, body['_csrf'].toString());
        _inAsyncCall = false;
        user = userMember;
        csrf = resultResponse.csrf;
        return ({'user': userMember, 'csrf': resultResponse.csrf});
      } catch(e) {
        print(e);
        _inAsyncCall = false;
        return null;
      } finally {
        _inAsyncCall = false;
      }
  }


}