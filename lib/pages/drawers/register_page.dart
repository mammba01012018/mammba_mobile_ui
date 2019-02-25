import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mammba/common/RegisterUtil.dart';
import 'package:mammba/common/widgets/country-picker.dart';
import 'package:mammba/models/Member.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:mammba/pages/home_page.dart';
import 'package:mammba/pages/others/security_questions_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mammba/common/widgets/date-time-picker.dart';
import 'package:mammba/common/utils/input-validators.dart';
import 'package:country_pickers/countries.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  bool isUpdate = false;
  Member updateUser = new Member();
  String csrf;

  RegisterPage({Key key, this.updateUser, this.isUpdate, this.csrf}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

const jsonCodec = const JsonCodec();

class _RegisterPageState extends State<RegisterPage> {
   final _controller = new TextEditingController();
  
  RegisterUtil registerUtil = new RegisterUtil();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Member member = new Member();
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('ph');
  Country _selectedDialogCountryCode = CountryPickerUtils.getCountryByIsoCode('ph');
  DateTime _birthDate = DateTime.now();
  var _gender = "Male";
  List<String> _genders = <String>['Male', 'Female'];
  List<DropdownMenuItem<String>> _questions = [];
  var _question1 = null;
  var _question2 = null;
  bool _inAsyncCall = false;
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

  submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(widget.isUpdate==null) {
        this.createUser();
      } else {
        this.updateUser();
      }
    } 
  }

  void updateUser() {
      setState(() {
        _inAsyncCall = true;
      });
      this.member.birthDate = this._birthDate.year.toString() + '-' + this._birthDate.month.toString() 
        + '-' + this._birthDate.day.toString() ;
      this.member.gender = this._gender;
      this.member.country = this._selectedDialogCountry.name;
      print(this.member.memberId);
      var jsonM = jsonCodec.encode(
                 { 
                  "firstName": this.member.firstName,
                  "lastName": this.member.lastName,
                  "middleInitial": this.member.middleInitial,
                  "gender": this.member.gender,
                  "address2": this.member.address2,
                  "rate": this.member.rate,
                  "birthDate": this.member.birthDate,
                  "province": this.member.province,
                  "country": this.member.country,
                  "address1": this.member.address1,
                  "username": this.member.username,
                  "password": this.member.password,
                  "mobileNumber": this.member.mobileNumber,
                  "emailAddress": this.member.emailAddress,
                  "memberId": HomePage.user,
                  "userId": HomePage.user.userId,
                 }
            );
        print(widget.csrf.toString());
        print(jsonM);
      //   var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/updateMember?_csrf="+widget.csrf.toString();
      //   http.post( 
      //         url,
      //         headers: {HttpHeaders.CONTENT_TYPE: "application/json"},
      //         body: jsonM)
      //           .then((response) {
      //             print(response);
      //             print("Response status: ${response.statusCode}");
      //             print("Response body: ${response.body}");

      //             if(response.body=='Unable to register member.') {
      //               Alert.alert(context, title: "", content: "Member already exist")
      //                   .then((_) => null);
      //             } else {
      //               if(response.statusCode==200) {
      //                   Navigator.of(context).pop();
                         
      //               } else {
      //                   Alert.alert(context, title: "Invalid Login", content: "Username and password do not match. Please try again")
      //                     .then((_) => null);
      //               }
      //             }
      //             setState(() {
      //               _inAsyncCall = false;
      //             });
      //           }).catchError((err) {
      //             print(err);
      //           });
  }


  void createUser() {
      setState(() {
        _inAsyncCall = true;
      });
      this.member.birthDate = this._birthDate.year.toString() + '-' + this._birthDate.month.toString() 
        + '-' + this._birthDate.day.toString() ;
      this.member.gender = this._gender;
      this.member.country = this._selectedDialogCountry.name;
      var jsonM = jsonCodec.encode(
                 { 
                  "firstName": this.member.firstName,
                  "lastName": this.member.lastName,
                  "middleInitial": this.member.middleInitial,
                  "gender": this.member.gender,
                  "address2": this.member.address2,
                  "rate": this.member.rate,
                  "birthDate": this.member.birthDate,
                  "province": this.member.province,
                  "country": this.member.country,
                  "address1": this.member.address1,
                  "username": this.member.username,
                  "password": this.member.password,
                  "mobileNumber": this.member.mobileNumber,
                  "emailAddress": this.member.emailAddress,
                 }
            );
        var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/registerMember";
        http.post( 
              url,
              headers: {HttpHeaders.CONTENT_TYPE: "application/json"},
              body: jsonM)
                .then((response) {
                  print(response);
                  print("Response status: ${response.statusCode}");
                  print("Response body: ${response.body}");
                  String val = response.body.toString();
                 
                  if(response.body=='Unable to register member.') {
                    Alert.alert(context, title: "", content: "Member already exist")
                        .then((_) => null);
                  } else {
                    if(response.statusCode==200) {
                        // Navigator.of(context).pop();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => SecurityQuestionsPage(member: widget.updateUser, isUpdate: widget.isUpdate)),
                        //   );
                    } else {
                        Alert.alert(context, title: "Invalid Login", content: "Username and password do not match. Please try again")
                          .then((_) => null);
                    }
                  }
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


  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select country'),
            onValuePicked: (Country country) => 
               setState(() => 
                setCountry(country)
               ),
            itemBuilder: _buildDialogItem)),
  );

  setCountry(Country country) {
    _selectedDialogCountry = country;
    this.member.country = country.name;
  }

  void _openCountryPickerCodeDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select country'),
            onValuePicked: (Country country) =>
                setState(() => 
                 _selectedDialogCountryCode = country
                ),
            itemBuilder: _buildDialogItem)),
  );

 

   Widget _buildDialogItem(Country country) => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name)),
      ],
    );

  Widget _buildDialogCodeItem(Country country) =>
   Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text("Country Code: ", style: new TextStyle(color: Colors.grey, fontSize: 11.5),),
        SizedBox(height: 3.2),
        Text("+${country.phoneCode}"),
      ],
    );
  
  Future _selectDate () async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1985),
      lastDate: new DateTime(2018)
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    if(widget.isUpdate!=null) {
      this._gender = widget.updateUser.gender;
      for(var i=0; i<countriesList.length; i++) {
        if(countriesList[i]['name']==widget.updateUser.country) {
          _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode(countriesList[i]['isoCode']);
          break;
        }
      }
    }
    this.getSecurityQuestions();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                            new Text('Basic Information', style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 16.0, color: Colors.teal),),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: new TextFormField(
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(20),
                                    ],
                                    initialValue: widget.isUpdate!=null ? widget.updateUser.firstName : '',
                                    textCapitalization: TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: new TextStyle(fontSize: 15.0)
                                    ),
                                    validator: (val) => val.isEmpty? 'First name is required' : null,
                                    onSaved: (String value) {
                                      this.member.firstName = value;
                                    }
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  flex: 4,
                                  child:  new TextFormField(
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(20),
                                      ],
                                      initialValue: widget.isUpdate!=null ? widget.updateUser.lastName : '',
                                      textCapitalization: TextCapitalization.words,
                                      keyboardType: TextInputType.text,
                                      decoration: new InputDecoration(
                                        labelText: 'Last Name',
                                        labelStyle: new TextStyle(fontSize: 15.0)
                                      ),
                                      validator: (val) => val.isEmpty? 'Last name is required' : null,
                                      onSaved: (String value) {
                                        this.member.lastName = value;
                                      }
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: new TextFormField(
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(1),
                                      ],
                                      initialValue: widget.isUpdate!=null ? widget.updateUser.middleInitial : '',
                                      textCapitalization: TextCapitalization.characters,
                                      keyboardType: TextInputType.text,
                                      decoration: new InputDecoration(
                                        labelText: 'Middle initial (optional)',
                                        labelStyle: new TextStyle(fontSize: 15.0),
                                      ),
                                      // validator: this._validateEmail,
                                      onSaved: (String value) {
                                        this.member.middleInitial = value;
                                      }
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  flex: 4,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Gender',
                                      contentPadding: EdgeInsets.all(5.0),
                                    ),
                                    isEmpty: _gender == null,
                                    // widget.isUpdate!=null ? widget.updateUser.gender : _gender,
                                    child: new DropdownButtonHideUnderline(
                                        child: new DropdownButton<String>(
                                          value: _gender,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _gender = newValue;
                                            });
                                          },
                                          items: _genders.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: 13.0),
                            DateTimePicker(
                              labelText: 'Birthdate',
                              // selectedDate: widget.isUpdate!=null ? DateTime.parse(widget.updateUser.birthDate) : _birthDate,
                              selectedDate: _birthDate,
                              selectDate: (DateTime date) {
                                setState(() {
                                  _birthDate = date;
                                });
                              },
                            ),
                          ],
                        )
                      ),
                    ),
                    Card(
                      elevation: 2.5,
                      child: new Container(
                        padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Address", style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 16.0, color: Colors.teal),),
                            new TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: widget.isUpdate!=null ? widget.updateUser.address1 : '',
                              decoration: new InputDecoration(
                                labelText: 'Lot No., Street No., Barangay ',
                                labelStyle: new TextStyle(fontSize: 15.0)
                              ),
                              validator:  (val) => val.isEmpty? 'Enter your address' : null,
                              onSaved: (String value) {
                                this.member.address1 = value;
                              }
                          ),
                          Row(
                            
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    initialValue: widget.isUpdate!=null ? widget.updateUser.address2 : '',
                                    textCapitalization: TextCapitalization.words,
                                    decoration: new InputDecoration(
                                      labelText: 'City ',
                                      labelStyle: new TextStyle(fontSize: 15.0)
                                    ),
                                    validator:  (val) => val.isEmpty? 'Enter city' : null,
                                    onSaved: (String value) {
                                      this.member.address2 = value;
                                    }
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                flex: 4,
                                child: new TextFormField(
                                  keyboardType: TextInputType.text,
                                  initialValue: widget.isUpdate!=null ? widget.updateUser.province : '',
                                  textCapitalization: TextCapitalization.words,
                                  decoration: new InputDecoration(
                                    labelText: 'Province/State ',
                                    labelStyle: new TextStyle(fontSize: 15.0)
                                  ),
                                  validator:  (val) => val.isEmpty? 'Enter the state/province' : null,
                                  onSaved: (String value) {
                                    this.member.province = value;
                                  }
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 13.0),
                          CountryPickerDropdowns(
                              labelText: 'Country',
                              isCountryCode: false,
                              isShowFlag: false,
                              selectedCountry: _selectedDialogCountry,
                              selectCountry: (Country country) {
                                setState(() {
                                  _selectedDialogCountry = country;
                                });
                              },
                            ),
                          ],
                        )
                      ),
                    ),
                    Card(
                      elevation: 2.5,
                      child: new Container(
                        padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Account", style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 16.0, color: Colors.teal),),
                            new TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(20),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: new TextStyle(fontSize: 15.0)
                                ),
                                validator: (val) => val.isEmpty? 'username is required' : null,
                                onSaved: (String value) {
                                  this.member.username= value;
                                }
                            ),
                            new TextFormField(
                              initialValue: widget.isUpdate!=null ? widget.updateUser.emailAddress : '',
                              keyboardType: TextInputType.emailAddress,
                              decoration: new InputDecoration(
                                labelText: 'E-mail Address',
                                labelStyle: new TextStyle(fontSize: 15.0)
                              ),
                              validator: InputValidators.validateEmail,
                              onSaved: (String value) {
                                this.member.emailAddress = value;
                              }
                            ),
                            SizedBox(height: 13.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 3 ,
                                  child:  CountryPickerDropdowns(
                                    labelText: 'Country Code',
                                    isCountryCode: true,
                                    isShowFlag: false,
                                    selectedCountry: _selectedDialogCountry,
                                    selectCountry: (Country country) {
                                      setState(() {
                                        _selectedDialogCountry = country;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: new TextFormField(
                                        initialValue: widget.isUpdate!=null ? 
                                           widget.updateUser.mobileNumber.replaceAll(this._selectedDialogCountryCode.phoneCode, '')
                                             : '',
                                        keyboardType: TextInputType.phone,
                                        decoration: new InputDecoration(
                                          labelStyle: new TextStyle(fontSize: 15.0),
                                          labelText: 'Mobile Number',
                                          contentPadding: EdgeInsets.fromLTRB(0.0, 12.5, 20.0, 16.0),
                                        ),
                                        validator: (val) => val.isEmpty? 'Mobile number is required' : null,
                                        onSaved: (String value) {
                                          this.member.mobileNumber = this._selectedDialogCountryCode.phoneCode + value;
                                        }
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child:  new TextFormField(
                                    obscureText: true, // Use secure text for passwords.
                                    decoration: new InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: new TextStyle(fontSize: 15.0)
                                    ),
                                    validator: this._validatePassword,
                                    onSaved: (String value) {
                                      this.member.password = value;
                                      this.password = value;
                                    }
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  flex: 4,
                                  child:  new TextFormField(
                                    obscureText: true, // Use secure text for passwords.
                                    decoration: new InputDecoration(
                                      labelText: 'Confirm Password',
                                      labelStyle: new TextStyle(fontSize: 15.0)
                                    ),
                                    validator: this._validateConfirmPassword
                                  ),    
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                    // Card(
                    //   elevation: 2.5,
                    //   child: new Container(
                    //   padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 20.0),
                    //   child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         new Text('Security Questions', style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 16.0, color: Colors.teal),),
                    //         SizedBox(height: 13.0),
                    //         InputDecorator(
                    //           decoration: const InputDecoration(
                    //             labelText: 'Question 1',
                    //             contentPadding: EdgeInsets.all(5.0),
                    //           ),
                    //           child: new DropdownButtonHideUnderline(
                    //               child: new DropdownButton<String>(
                    //                 value: _question1,
                    //                 isDense: true,
                    //                 onChanged: (String newValue) {
                    //                   setState(() {
                    //                     _question1 = newValue;
                    //                   });
                    //                 },
                    //                 items: _questions,
                    //               ),
                    //             ),
                    //         ),
                    //         new TextFormField(
                    //           decoration: new InputDecoration(
                    //             labelText: 'Answer 1',
                    //             labelStyle: new TextStyle(fontSize: 15.0)
                    //           ),
                    //           validator: this._validatePassword,
                    //           onSaved: (String value) {
                    //             this.member.password = value;
                    //             this.password = value;
                    //           }
                    //         ),
                    //         SizedBox(height: 13.0),
                    //         InputDecorator(
                    //           decoration: const InputDecoration(
                    //             labelText: 'Question 2',
                    //             contentPadding: EdgeInsets.all(5.0),
                    //           ),
                    //           child: new DropdownButtonHideUnderline(
                    //               child: new DropdownButton<String>(
                    //                 value: _question2,
                    //                 isDense: true,
                    //                 onChanged: (String newValue) {
                    //                   setState(() {
                    //                     _question2 = newValue;
                    //                   });
                    //                 },
                    //                 items: _questions
                    //               ),
                    //             ),
                    //         ),
                    //         new TextFormField(
                    //             decoration: new InputDecoration(
                    //               labelText: 'Answer 2',
                    //               labelStyle: new TextStyle(fontSize: 15.0)
                    //             ),
                    //             validator: this._validatePassword,
                    //             onSaved: (String value) {
                    //               this.member.password = value;
                    //               this.password = value;
                    //             }
                    //           ),
                    //       ],
                    //     )
                    //   ),
                    // ),
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


