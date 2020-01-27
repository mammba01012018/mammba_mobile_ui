import 'dart:convert';
import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mammba/common/common-fields.dart';
import 'package:http/http.dart' as http;
import 'package:mammba/models/LogInUser.dart';
import 'package:mammba/models/LoginResponse.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/pages/home_page.dart';
import 'package:mammba/pages/others/into-slider.dart';
import 'package:mammba/pages/others/reset_password_page.dart';
import 'package:mammba/pages/others/security_questions_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:requests/requests.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  static String tag = '/login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

const jsonCodec = const JsonCodec();

class _LoginPageState extends State<LoginPage> {

  LogInUser logInUser = new LogInUser();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _inAsyncCall = false;
  bool _isShowButton = true;
  final myController = TextEditingController();

  String _validateEmail(String value) {
    try {
      return isEmail(value) ?  null : 'Please enter a valid e-mail address';
    } catch (e) {
      return 'Please enter a valid e-mail address';
    }
  }

  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  String _validatePassword(String value) {
    try {
      return value==null || value.length==0 ? 'Please enter the password' : null;
    } catch (e) {
      return 'Please enter the password';
    }
  }

  submit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/login?username="+this.logInUser.userEmail+"&password="+this.logInUser.password;
      var json = jsonCodec.encode(this.logInUser);
      setState(() {
        _inAsyncCall = true;
      });
      try {
        String hostname = Requests.getHostname(url);
        await Requests.clearStoredCookies(hostname);

        dynamic body = await Requests.post(url, json: true,  body: null );
        print('bnody ng login');
        print(body.json());
        var user = body.json()['member'];
        var userFinal = new Member.fromJson(user);
        var resultResponse  = new LoginResponse.toSave(userFinal, body.json()['_csrf'].toString());
        await Requests.setStoredCookies(hostname, {'X-CSRF-TOKEN': body.json()['_csrf']});
        var cookies = await Requests.getStoredCookies(hostname);
        print( userFinal.userStatus.toString());
        print( resultResponse.toString());
        print('csrf to');
        print(body.json()['_csrf'].toString());
        if(userFinal.userStatus=='TempPassword') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetPasswordPage(userId: userFinal.userId, csrf: resultResponse.csrf)),
          );
          if(result==true) {
            resultResponse.user.userStatus='Active';
            Navigator.pop(context, resultResponse);
          }
        } else if(userFinal.userStatus=='Active') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String username = prefs.getString('username');
          String password = prefs.getString('password');
          print('bago from login jkjk') ;
          print(username);
          print(password);

          if(username!=null) {
            Navigator.pop(context, resultResponse);
          } else {
            await prefs.setString('username', this.logInUser.userEmail.toString());
            await prefs.setString('password', this.logInUser.password.toString());
          }
          Navigator.pop(context, resultResponse);
        } else {
          Navigator.pop(context, resultResponse);
        }
      } catch(e) {
        print('catching');
        print(e);
        Alert.alert(context, title: "value", content: "Username and password do not match. Please try again")
        .then((_) => null);
      } finally {
        setState(() {
          _inAsyncCall = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ModalProgressHUD (
            inAsyncCall: _inAsyncCall,
            child: Center(
            child: new Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  CommonField().logo,
                  SizedBox(height: 48.0),
                  TextFormField(
                    controller: myController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 12.5, 20.0, 12.5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    validator: (val) => val.isEmpty? 'Enter username' : null,
                    onSaved: (String value) {
                      this.logInUser.userEmail = value;
                    }
                  ),
                  
                  SizedBox(height: 8.0),
                  
                  TextFormField(
                    autofocus: false,
                    obscureText: _isShowButton,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye, color: Colors.grey, ),
                        onPressed: () {
                          setState(() {
                            _isShowButton = !_isShowButton;
                          });
                       }
                      )
                    ),
                    validator: this._validatePassword,
                    onSaved: (String value) {
                      this.logInUser.password = value;
                    }
                  ),
                  SizedBox(height: 24.0),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Colors.lightBlueAccent,
                      elevation: 5.0,
                      child: MaterialButton(
                        minWidth: 200.0,
                        height: 50.0,
                        onPressed: this.submit,
                        color: Colors.teal,
                        child: Text('Log In', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),

                  FlatButton(
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecurityQuestionsPage(member: new Member(), isUpdate: true, userName: null)),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          )
        );
      }
    }
    
