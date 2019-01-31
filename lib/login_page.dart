import 'dart:convert';
import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mammba/common/common-fields.dart';
import 'package:http/http.dart' as http;
import 'package:mammba/home_page.dart';
import 'package:mammba/models/LogInUser.dart';
import 'package:mammba/models/Member.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/login?username="+this.logInUser.userEmail+"&password="+this.logInUser.password;
      var json = jsonCodec.encode(this.logInUser);
      setState(() {
        _inAsyncCall = true;
      });
      http.post( 
        url,
        headers: {HttpHeaders.CONTENT_TYPE: "application/json"},
        body: json)
          .then((response) {
            print("Response status: ${response.statusCode}");
            print("Response body: ${response.body}");
            Map<String, dynamic> member = jsonCodec.decode(response.body);
            print(member['logUsing']);
            var user = member['member'];
            var userFinal = new Member.fromJson(user);
            userFinal.emailAddress = user['emailAddress'];
            HomePage.user = userFinal;
            // print(mem);
            // user = user.province;
            // String address1;
            // String country;
            // String password;
            // String mobileNumber;
            // String emailAddress;
            // String username;
            // String userType;
            print(userFinal.toString());
            // print('We sent the verification link to ${member['emailAddress']}.');

            // Map userMap = json.decode(json);
            // var user = new Member()  fromJson(userMap);
            // var json = jsonCodec.decode(response.body);
            // Member user = json.member;
                // print(user.toString());
            String val = response.body.toString();
            if(response.body.isNotEmpty) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                
                // HomePage.user = response.body;                // Member user; 
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new HomePage())
                );
            } else {
                Alert.alert(context, title: "Invalid Login", content: "Username and password do not match. Please try again")
                  .then((_) => null);
            }
            setState(() {
              _inAsyncCall = false;
            });
          }).catchError((err) {
            print(err);
          });
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
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
          )
        );
      }
    }
    
