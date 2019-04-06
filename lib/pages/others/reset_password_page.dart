import 'dart:_http';
import 'dart:convert';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:requests/requests.dart';

class ResetPasswordPage extends StatefulWidget {
  static String tag = '/reset-password-page';
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();

  int userId;
  String csrf;

  ResetPasswordPage({Key key, this.userId, this.csrf}) : super(key: key);
}

const jsonCodec = const JsonCodec();

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  bool _inAsyncCall = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String password;
  String confirmPassword;


  String _validatePassword(String value) {
    this.password = value;
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  String _validateConfirmPassword(String value) {
    if(this.password!=value) {
      return 'The password does not match';
    }
    return null;
  }

  submit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/mammba-user/updateAuth?"
        +  "_csrf=" +  widget.csrf.toString() + "&"
        +  "pwd=" +  this.password  + "&"
        +  "userId="+ widget.userId.toString() ;
      setState(() {
        _inAsyncCall = true;
      });
      try {
        dynamic body = await Requests.post(url, json: true, body: json );
      } catch(e) {
        String errorString = e.toString();
        print(e);
        print(errorString);
        print(errorString.contains("Successfully reset credentials"));
        if(errorString.contains("Successfully reset credentials")==true){
          Alert.alert(context, title: "Password Updated", content: "Password successfully updated")
            .then((_) => Navigator.pop(context, true));
        } 
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
          appBar: AppBar(
            title: const Text('Update Password'),
            backgroundColor: Colors.teal
          ),
          body: ModalProgressHUD (
            inAsyncCall: _inAsyncCall,
            child: Center(
            child: new Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  // new Text('Update your Password',textAlign:TextAlign.center, style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 24.0, color: Colors.teal),),
                  SizedBox(height: 2.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    validator: _validatePassword,
                    onSaved: (String value) {
                      this.password = value;
                    }
                  ),
                  
                  SizedBox(height: 16.0),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                      contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))
                    ),
                    validator: _validateConfirmPassword,
                    onSaved: (String value) {
                      this.confirmPassword = value;
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
                        child: Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          )
        );
  }
}
    
