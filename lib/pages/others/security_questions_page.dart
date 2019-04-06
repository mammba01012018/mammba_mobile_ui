import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:mammba/models/Member.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SecurityQuestionsPage extends StatefulWidget {
  static String tag = 'security-questions-page';

  Member member = new Member();
  bool isUpdate = false;
  String userName = '';

  SecurityQuestionsPage({Key key, this.member, this.isUpdate, this.userName}) : super(key: key);

  @override
  _SecurityQuestionsPageState createState() => _SecurityQuestionsPageState();
}

const jsonCodec = const JsonCodec();

class _SecurityQuestionsPageState extends State<SecurityQuestionsPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _questions = <String>['Select'];
  String _question1;
  String _answer;
  int _userId;

  bool _inAsyncCall = false;

  submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(widget.isUpdate==true) {
        this.updateSecurityQuestion();
      } else {
        this.setSecurityQuestion();
      }
    } 
  }
  
  void updateSecurityQuestion() {
     var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/securityQuestions/validateAnswer?"  
          + "userId=" + _userId.toString() + '&'
          + "answer=" + _answer.toString();
      http.post(url, headers: {HttpHeaders.CONTENT_TYPE: "application/json"})
        .then((response) {
          if(response.statusCode==200) {
            var jsonM = jsonCodec.decode(response.body);
            String res = response.body;
            print(res);
            if(res=='true') {
              setState(() {
                Alert.alert(context, title: "Answer Accepted", content: "Please check your email for the updated password", ok: 'OK')
                    .then((_) => Navigator.of(context).pop());
              });
             
            } else {
              Alert.alert(context, title: "Answer Denied", content: "Answer doesn't matched")
                  .then((_) => null);
            }
          } else {
            
          }
        }).catchError((err) {
          print(err);
        });
  }

  void setSecurityQuestion() {
    int userId= widget.member.userId;
    int questionId = int.parse(_question1.split("=")[0]);
    var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/securityQuestions/addQAUser?"
        + "userId=" + userId.toString() + '&'
        + "questionId=" + questionId.toString() + '&'
        + "answer=" + _answer.toString();
      http.post(url, headers: {HttpHeaders.CONTENT_TYPE: "application/json"})
        .then((response) {
            if(response.statusCode==200) {
                Alert.alert(context, title: "", content: "Security question added")
                  .then((_) => null);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
  
  String _validateAnswer(String value) {
    if (value.length == 0 || value=='' || value==null) {
      return 'Please enter answer to sequrity question';
    }
    return null;
  }

  void getSecurityQuestions() {
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/securityQuestions/getAll";
      http.post(url, headers: {HttpHeaders.CONTENT_TYPE: "application/json"})
        .then((response) {
          if(response.statusCode==200) {
            var jsonM = jsonCodec.decode(response.body);
            List<String> lists = <String>[];
            for(var q in jsonM) {
              lists.add(q);
            }
            setState(() {
              _questions= lists;
            });
          } else {
            
          }
        }).catchError((err) {
          print(err);
        });
  }

  void getSecurityQuestion() {
    print('getting security question');
    print(widget.userName);
      var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/securityQuestions/getQuestionFromUserName?"  + "userName=" + widget.userName;

      print(url);
      http.post(url, headers: {HttpHeaders.CONTENT_TYPE: "application/json"})
        .then((response) {
          if(response.statusCode==200) {
            var jsonM = jsonCodec.decode(response.body);
            String res = response.body;
            setState(() {
              _userId=int.parse(res.replaceAll('"', '').replaceAll('{', '').replaceAll('}', '').split(":")[0]);
              _question1=res.replaceAll('"', '').replaceAll('{', '').replaceAll('}', '').split(":")[1];
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
    if(widget.isUpdate==true) {
      this.getSecurityQuestion();
    } else {
      this.getSecurityQuestions();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Question'),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top:50.0, left: 20.0, right: 20.0, bottom: 20.0),
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 8.0),
                        widget.isUpdate== true ? new Text (_question1==null? '': _question1) : InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Security Question',
                            contentPadding: EdgeInsets.all(2.0),
                          ),
                          isEmpty: _question1 == null,
                          child:  DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                iconSize: widget.isUpdate==true ? 0.0 : 24.0,
                                value: _questions.length==0 ? null: _question1,
                                items: _questions.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _question1 = newValue;
                                  });
                                },
                                isExpanded: true,
                              )
                            ),
                        ),
                        SizedBox(height: 40.0),
                        SizedBox(height: 8.0),
                        new TextFormField(// Use secure text for passwords.
                          decoration: new InputDecoration(
                            labelText: 'Answer',
                            labelStyle: new TextStyle(fontSize: 15.0)
                          ),
                          validator: this._validateAnswer,
                          onSaved: (String value) {
                            _answer = value;
                          }
                        ),
                        SizedBox(height: 40.0),
                         new Container(
                          width: screenSize.width,
                          child: new RaisedButton(
                            color: Colors.teal,
                            padding: EdgeInsets.all(15.0),
                            child: new Text(
                              'Submit',
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
                      ]
                     )
                )
              )
            )
          )
      )
    );
  }
}


