import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:mammba/common/RegisterUtil.dart';
import 'package:mammba/models/Member.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mammba/models/SecurityQuestion.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SecurityQuestionsPage extends StatefulWidget {
  static String tag = 'security-questions-page';

  Member member = new Member();
  bool isUpdate = false;

  SecurityQuestionsPage({Key key, this.member, this.isUpdate}) : super(key: key);

  @override
  _SecurityQuestionsPageState createState() => _SecurityQuestionsPageState();
}

const jsonCodec = const JsonCodec();

class _SecurityQuestionsPageState extends State<SecurityQuestionsPage> {
   final _controller = new TextEditingController();
  
  RegisterUtil registerUtil = new RegisterUtil();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _questions = [];
  String _question1 = null;
  String _question2 = null;
  bool _inAsyncCall = false;
  SecurityQuestion securityQuestion1 = new SecurityQuestion();
  SecurityQuestion securityQuestion2 = new SecurityQuestion();

  String _validatePassword(String value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      // if(widget.isUpdate==null) {
      //   this.createUser();
      // } else {
      //   this.getSecurityQuestions();
      // }
      this.createSecurityQuestions();
    } 
  }

  void createSecurityQuestions() {
      // setState(() {
      //   _inAsyncCall = true;
      // });
      print(widget.member);
      print(widget.isUpdate);
      var jsonM1 = jsonCodec.encode({ 
        "userId": widget.member.memberId,
        "questionId": int.parse(this._question1.split("-")[0]),
        "answer": this.securityQuestion1.answer
      });
      var jsonM2 = jsonCodec.encode({ 
        "userId": widget.member.memberId,
        "questionId": int.parse(this._question1.split("-")[0]),
        "answer": this.securityQuestion1.answer
      });
      this.sendSecurityQuestion(jsonM1);
      this.sendSecurityQuestion(jsonM2);
  }

  void sendSecurityQuestion(var jsonM) {
     var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/addQAUser";
        http.post( 
              url,
              headers: {HttpHeaders.CONTENT_TYPE: "application/json"},
              body: jsonM)
                .then((response) {
                  print(response);
                  print("Response status: ${response.statusCode}");
                  print("Response body: ${response.body}");
  Alert.alert(context, title: "Invalid Login", content: "Username and password do not match. Please try again")
                          .then((_) => null);
                    // if(response.statusCode==200) {
                    //     Navigator.of(context).pop();
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => SecurityQuestionsPage(updateUser: widget.updateUser, isUpdate: widget.isUpdate)),
                    //       );
                    // } else {
                    //     Alert.alert(context, title: "Invalid Login", content: "Username and password do not match. Please try again")
                    //       .then((_) => null);
                    // }
                  setState(() {
                    _inAsyncCall = false;
                  });
                }).catchError((err) {
                  print(err);
                });
  }




  void getSecurityQuestions() {
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/securityQuestions/getAll";
      http.post( 
          url,
          headers: {HttpHeaders.CONTENT_TYPE: "application/json"})
            .then((response) {
              if(response.statusCode==200) {
                  var jsonM = jsonCodec.decode(response.body);
                List<DropdownMenuItem<String>> list = [];
                  for(var q in jsonM) {
                    list.add(new DropdownMenuItem(child: new Text(q), value: q));
                  }
                  setState(() {
                    _questions= list;
                  });
              } else {
              }
              
            }).catchError((err) {
              print(err);
            });
  }


  
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    this.getSecurityQuestions();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Questions'),
        backgroundColor: Colors.teal
      ),
      body: ModalProgressHUD (
          inAsyncCall: _inAsyncCall,
          child:  DropdownButtonHideUnderline(
            child: SafeArea(
              top: false,
              bottom: false,
              child: new Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(top:10.0, left: 8.0, right: 8.0, bottom: 20.0),
                  children: <Widget>[
                    Card(
                      elevation: 2.5,
                      child: new Container(
                      padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Security Questions', style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 16.0, color: Colors.teal),),
                            SizedBox(height: 13.0),
                            InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Question 1',
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                              child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton<String>(
                                    value: _question1,
                                    isExpanded: true,
                                    isDense: false,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _question1 = newValue;
                                      });
                                    },
                                    items: _questions,
                                  ),
                                ),
                            ),
                            new TextFormField(
                              decoration: new InputDecoration(
                                labelText: 'Answer 1',
                                labelStyle: new TextStyle(fontSize: 15.0)
                              ),
                              validator: this._validatePassword,
                              onSaved: (String value) {
                                this.securityQuestion1.answer = value;
                              }
                            ),
                            SizedBox(height: 13.0),
                            InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Question 2',
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                              child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton<String>(
                                    value: _question2,
                                    isDense: false,
                                    isExpanded: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _question2 = newValue;
                                      });
                                    },
                                    items: _questions
                                  ),
                                ),
                            ),
                            new TextFormField(
                                decoration: new InputDecoration(
                                  labelText: 'Answer 2',
                                  labelStyle: new TextStyle(fontSize: 15.0)
                                ),
                                validator: this._validatePassword,
                                onSaved: (String value) {
                                  this.securityQuestion2.answer = value;
                                }
                              ),
                          ],
                        )
                      ),
                    ),
                    new Container(
                      width: screenSize.width,
                      child: new RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: new Text(
                          widget.isUpdate!=null ? 'Update' : 'Register',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                          ),
                        ),
                        onPressed: this.submit,
                      ),
                      margin: new EdgeInsets.only(
                        top: 20.0
                      ),
                    ) 
                  ],
                ),
            ),
            )
      ),
      )
      
      
       
    );
  }
}


