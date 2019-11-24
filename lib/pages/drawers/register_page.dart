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
import 'package:mammba/pages/others/security_questions_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mammba/common/widgets/date-time-picker.dart';
import 'package:mammba/common/utils/input-validators.dart';
import 'package:country_pickers/countries.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  bool isUpdate = false;
  Member updateUser;
  String csrf;
  int memberId;
  int userId;
  bool edited = false;

  RegisterPage({Key key, this.updateUser, this.memberId, this.userId, this.isUpdate, this.csrf}) : super(key: key);

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
  var _gender;
  List<String> _genders = <String>['Male', 'Female'];
  List<DropdownMenuItem<String>> _questions = [];
  var _question1 = null;
  var _question2 = null;
  bool _inAsyncCall = false;
  String password;
  String confirmPassword;
  bool _isShowButtonPassword = true;
  bool _isShowButtonConfirmPassword = true;

  String _validateConfirmPassword(String value) {
    if(this.password!=value) {
      return 'The password does not match';
    }
    return null;
  }

  String _validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    //print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (value.length < 8) {
        return 'Must be at least 8 characters.';
      }
      // if (!regex.hasMatch(value))
      //   return 'Must contain number, special characters, upper case and lower case letter';
      else
        return null;
    }
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

  void updateUser() async {
      setState(() {
        _inAsyncCall = true;
      });
      this.member.birthDate = this._birthDate.year.toString() + '-' + this._birthDate.month.toString() 
        + '-' + this._birthDate.day.toString() ;
      this.member.gender = this._gender;
      this.member.country = this._selectedDialogCountry.name;
      var jsonM = jsonCodec.encode(
              {
              "password": this.member.password,
              "mobileNumber": this.member.mobileNumber,
              "emailAddress": this.member.emailAddress,
              "firstName": this.member.firstName,
              "lastName": this.member.lastName,
              "birthDate": this.member.birthDate,
              "gender": widget.updateUser.gender,
              "address1": this.member.address1,
              "address2": this.member.address2,
              "middleInitial": this.member.middleInitial,
              "userId": widget.updateUser.userId,
              'memberId': widget.updateUser.memberId,
              "province": this.member.province,
              "country": this.member.country,
              }
        );
        Map<String, String> headers = {"Content-type": "application/json"};
        var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/mammba-user/updateMember?_csrf=" + widget.csrf.toString();
        try {
          dynamic body = await Requests.post(url, json: true, headers: headers, body: jsonM );
          var userFinal = new Member.fromJson(body);
          Alert.alert(context, title: "Updated", content: "Changes successfully saved")
            .then((_) => Navigator.pop(context, userFinal));
        } catch(e) {
          print(e);
        } finally {
          setState(() {
            _inAsyncCall = false;
          });
        }
  }

  void createUser() async {
      setState(() {
        _inAsyncCall = true;
      });
      this.member.birthDate = this._birthDate.year.toString() + '-' + this._birthDate.month.toString() 
        + '-' + this._birthDate.day.toString() ;
      this.member.gender = this._gender;
      this.member.country = this._selectedDialogCountry.name;
      SharedPreferences shared_User = await SharedPreferences.getInstance();

      await shared_User.setString('username', this.member.username);
      await shared_User.setString('password', this.member.password);
       String usernamse = shared_User.getString('username');
          String passwosrd = shared_User.getString('password');
          print('from reguister2313234 login jkjk') ;
          print(usernamse);
          print(passwosrd);
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
            print(jsonM);
        var url = "http://jpcloudusa021.nshostserver.net:33926/mammba/registerMember";
        http.post( 
              url,
              headers: {HttpHeaders.CONTENT_TYPE: "application/json"},
              body: jsonM)
                .then((response) {
                  print("REGISTER TO");
                  print(response);
                  print("Response status: ${response.statusCode}");
                  print("Response body: ${response.body}");
                  
                    if(response.statusCode==200) {
                        Map<String, dynamic> resultMember  = jsonCodec.decode(response.body);
                        var updateUsers = new Member.fromJson(resultMember);
                        print(password);
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecurityQuestionsPage(member: updateUsers, isUpdate: widget.isUpdate, userName: null, password: this.member.password)),
                          );
                    } else {
                        Alert.alert(context, title: "", content: response.body.toString())
                          .then((_) => null);
                    }
                  setState(() {
                    _inAsyncCall = false;
                  });
                }).catchError((err) {
                  print(err);
                });
  }

  


  void goToSecurityPage() async {
    final secResult  = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecurityQuestionsPage(member: widget.updateUser, isUpdate: widget.isUpdate, userName: null)),
      );
    Navigator.pop(context, secResult); // pass result of C to A
    print('sesas reasdsad');
    print(secResult);

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
    this.getSecurityQuestions();
    if(widget.updateUser!=null && (widget.updateUser.country!=null || widget.updateUser.country!='') && widget.edited==false) {
      _selectedDialogCountry = CountryPickerUtils.getCountryByName(widget.updateUser.country);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate==true? 'Edit Account' : 'Sign Up'),
        backgroundColor: Colors.teal
      ),
      body: ModalProgressHUD (
          inAsyncCall: _inAsyncCall,
          child:  DropdownButtonHideUnderline(
            child: SafeArea(
              top: false,
              bottom: false,
              child: 
              new Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top:10.0, left: 8.0, right: 8.0, bottom: 20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                widget.isUpdate==true ? new Container() : Expanded(
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
                             widget.isUpdate!=null ? new Container() : DateTimePicker(
                              labelText: 'Birthdate',
                              selectedDate: widget.isUpdate!=null ? DateTime.parse(widget.updateUser.birthDate) : _birthDate,
                              //selectedDate: _birthDate,
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
                                 // widget.updateUser.country = country.name;
                                 this.member.country = country.name;
                                  widget.edited = true;
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
                            new Text("Accounts", style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 16.0, color: Colors.teal),),
                            widget.isUpdate==true ? new Container() : new TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(20),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: new TextStyle(fontSize: 15.0)
                                ),
                                initialValue: widget.isUpdate!=null ? widget.updateUser.username: null,
                                validator: (val) => val.isEmpty? 'username is required' : null,
                                onSaved: (String value) {
                                  this.member.username= value;
                                }
                            ),
                            TextFormField(
                              initialValue: widget.isUpdate!=null ? widget.updateUser.emailAddress: null,
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
                                widget.isUpdate==true ? new Container() : Expanded(
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
                                           widget.updateUser.mobileNumber
                                             : '',
                                        keyboardType: TextInputType.phone,
                                        decoration: new InputDecoration(
                                          labelStyle: new TextStyle(fontSize: 15.0),
                                          labelText: 'Mobile Number',
                                          contentPadding: EdgeInsets.fromLTRB(0.0, 12.5, 20.0, 16.0),
                                        ),
                                        validator: (val) => val.isEmpty? 'Mobile number is required' : null,
                                        onSaved: (String value) {
                                          if(widget.isUpdate==null) {
                                            this.member.mobileNumber = this._selectedDialogCountryCode.phoneCode + value;
                                          } else {
                                            this.member.mobileNumber = value;
                                          }
                                        }
                                  ),
                                ),
                              ],
                            ),
                            widget.isUpdate==true ? new Container() : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child:  TextFormField(
                                    initialValue: widget.isUpdate!=null ? widget.updateUser.password : '',
                                    obscureText: _isShowButtonPassword, 
                                    decoration: new InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: new TextStyle(fontSize: 15.0),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.remove_red_eye, color: Colors.grey, ),
                                        onPressed: () {
                                          setState(() {
                                            _isShowButtonPassword = !_isShowButtonPassword;
                                          });
                                      }
                                      )
                                    ),
                                    onChanged: (String value) {
                                      this.member.password = value;
                                      this.password = value;
                                      print(this.password);
                                    },
                                    validator: this._validatePassword,
                                    onSaved: (String value) {
                                      this.member.password = value;
                                      this.password = value;
                                    }
                                  ),
                                ),
                              ],
                            ),
                            widget.isUpdate==true ? new Container() : Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 8,
                                    child:  new TextFormField(
                                      initialValue: widget.isUpdate!=null ? widget.updateUser.password : '',
                                      obscureText: _isShowButtonConfirmPassword, // Use secure text for passwords.
                                      decoration: new InputDecoration(
                                        labelText: 'Confirm Password',
                                        labelStyle: new TextStyle(fontSize: 15.0),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye, color: Colors.grey, ),
                                          onPressed: () {
                                            setState(() {
                                              _isShowButtonConfirmPassword = !_isShowButtonConfirmPassword;
                                            });
                                        }
                                        )
                                      ),
                                      validator: this._validateConfirmPassword,
                                    ),    
                                  ),
                                ],
                              )
                          ],
                        )
                      ),
                    ),
                    new Container(
                      width: screenSize.width,
                      child: new RaisedButton(
                        color: Colors.teal,
                        padding: EdgeInsets.all(15.0),
                        child: new Text(
                          widget.isUpdate==true ? 'Update' : 'Register',
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
                    )                
                  )
                ),
            ),




            )
      ),
      )
      
      
       
    );
  }
}


