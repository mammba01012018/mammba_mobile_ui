import 'package:flutter/material.dart';
import 'package:mammba/models/TourForm.dart';
import 'dart:async';
import 'package:mammba/pages/tourpages/tours_result.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mammba/tabs/my_bookings.dart';

class Tours extends StatefulWidget {
  @override
  _Tours createState() => _Tours();
}

class _Tours extends State<Tours> {

  List<DropdownMenuItem<String>> tourTypes = [] ;
  List<String> _toursType = new List<String>() ;
  List<DropdownMenuItem<String>> pickUpLocation = [] ;
  DateTime _dateNow = new DateTime.now();
  var tourForm = new TourForm();
  List pickUpLocations;
   List<String> _genders = <String>['Male', 'Female'];
     var _gender = "Male";
     ShapeBorder _shape;

  
  Future<Null> _selectDate(BuildContext context, String date) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateNow,
      firstDate: new DateTime(_dateNow.year),
      lastDate: new DateTime(_dateNow.year + 1)
    );
    if(picked!=null && picked!=_dateNow) {
      if(date=='startDate') {
        setState(() {
            tourForm.startDate = picked;    
        });
      } else {
        setState(() {
            tourForm.endDate = picked;    
        });
      }
     
    }
  }

  void loadData(){
    tourTypes =[];
    tourTypes.addAll([
      new DropdownMenuItem(child: new Text("Exclusive"), value: "Exclusive"),
      new DropdownMenuItem(child: new Text("Joiner"), value: "Joiner")
    ]);
  }

  void setValue(var value) {
      print(tourForm.tourType);
  }

  String getDate(var dateorig) {
    String date;
    String month = getmonth(dateorig.month);
    String day = dateorig.day.toString();
    String year = dateorig.year.toString();
    return month+'  '+day+', '+year;
  }

  String getmonth(var mon) {
    switch (mon) {
      case 1:return 'January'; break;
      case 2:return 'February'; break;
      case 3:return 'March'; break;
      case 4:return 'April'; break;
      case 5:return 'May'; break;
      case 6:return 'June'; break;
      case 7:return 'July'; break;
      case 8:return 'August'; break;
      case 9:return 'September'; break;
      case 10:return 'October'; break;
      case 11:return 'November'; break;
      case 12:return 'December'; break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    int _currValue = 1;
    return SingleChildScrollView(
        padding: const EdgeInsets.only(top:10.0, left: 0.0, right: 0.0, bottom: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                  elevation: 2.5,
                  child: new Form(
                    child: new Container(
                    padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 20.0),
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Text("Type of tour", style: new TextStyle(fontSize: 15.0, color: Colors.teal),),
                                RadioButtonGroup(
                                  margin: const EdgeInsets.only(top:0.0, left: 0.0, right: 0.0, bottom: 0.0),
                                  padding: const EdgeInsets.only(top:0.0, left: 0.0, right: 0.0, bottom: 0.0),
                                  orientation: GroupedButtonsOrientation.HORIZONTAL,
                                  labels: <String>[
                                    "Joiners",
                                    "Exclusive",
                                  ],
                                  onSelected: (String selected) => print(selected),
                                  itemBuilder: (Radio rb, Text txt, int i){
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            rb,
                                            txt
                                        ],)
                                      ,
                                      ],
                                    );
                                  },
                                )
                              ]
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'From',
                                      labelStyle: TextStyle(fontSize: 20.0, color: Colors.teal),
                                      contentPadding: EdgeInsets.only(top:5.0, left: 0.0, right: 0.0, bottom: 10.0),
                                      enabledBorder: UnderlineInputBorder(      
                                          borderSide: BorderSide(color: Colors.black26),   
                                      )
                                    ),
                                    child: InkWell(
                                        child: Text('Select Pickup Location', style: new TextStyle(fontSize: 16.0, color: Colors.black)),
                                        onTap: () {print('hjghgj');},
                                    )
                                  )
                                ),
                              ]
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Destination',
                                      labelStyle: TextStyle(fontSize: 20.0, color: Colors.teal),
                                      contentPadding: EdgeInsets.only(top:5.0, left: 0.0, right: 0.0, bottom: 10.0),
                                      enabledBorder: UnderlineInputBorder(      
                                          borderSide: BorderSide(color: Colors.black26),   
                                      )
                                    ),
                                    child: InkWell(
                                        child: Text('Select Destination', style: new TextStyle(fontSize: 16.0, color: Colors.black)),
                                        onTap: () {print('hjghgj');},
                                    )
                                  )
                                ),
                              ]
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Second Destination',
                                      labelStyle: TextStyle(fontSize: 20.0, color: Colors.teal),
                                      contentPadding: EdgeInsets.only(top:5.0, left: 0.0, right: 0.0, bottom: 10.0),
                                      enabledBorder: UnderlineInputBorder(      
                                          borderSide: BorderSide(color: Colors.black26),   
                                      )
                                    ),
                                    child: InkWell(
                                        child: Text('Select Another Destination', style: new TextStyle(fontSize: 16.0, color: Colors.black)),
                                        onTap: () {print('hjghgj');},
                                    )
                                  )
                                ),
                              ]
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Travel Dates',
                                      labelStyle: TextStyle(fontSize: 20.0, color: Colors.teal),
                                      contentPadding: EdgeInsets.only(top:5.0, left: 0.0, right: 0.0, bottom: 10.0),
                                      enabledBorder: UnderlineInputBorder(      
                                          borderSide: BorderSide(color: Colors.black26),   
                                      )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(height: 8.0),
                                        Text('From', style: new TextStyle(fontSize: 14.0, color: Colors.grey)),
                                        InkWell(
                                            child: Text('Select Another Destination', style: new TextStyle(fontSize: 16.0, color: Colors.black)),
                                            onTap: () {print('hjghgj');},
                                        ),
                                        const SizedBox(height: 15.0),
                                        Text('To', style: new TextStyle(fontSize: 14.0, color: Colors.grey)),
                                        InkWell(
                                            child: Text('Select Another Destination', style: new TextStyle(fontSize: 16.0, color: Colors.black)),
                                            onTap: () {print('hjghgj');},
                                        )
                                      ]
                                  )
                                )
                                )
                              ]
                            ),
                            new Divider(height: 24.0),
                            SizedBox(
                              width: double.infinity,
                              height: 35.0,
                              child:  RaisedButton(
                                        child: new Text(
                                          "Search",
                                          style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                              ),
                                        ),
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                        onPressed: () => 
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ToursResult()),
                                          )
                                      )
                              )
                          ]
                      )
                    ),
                  )
              ), 
              Card(
                  elevation: 2.5,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 0.0, bottom: 0.0),
                        child: Text('Tour Deals' , style: new TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 23.0,
                                                color: Colors.black,
                                              ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:0.0, left: 10.0, right: 0.0, bottom: 0.0),
                        child: Text('check the hottest tour deals' , style: new TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),),
                      ),
                      
                      Container(
                          padding: const EdgeInsets.only(top:0.0, left: 0.0, right: 0.0, bottom: 20.0),
                          child:  Container(
                                    height:250.0,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        itemExtent: TravelDestinationItem.height,
                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                        children: destinations.map<Widget>((TravelDestination destination) {
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 8.0),
                                            child: TravelDestinationItem(
                                              destination: destination,
                                              shape: _shape,
                                            ),
                                          );
                                        }).toList()
                                      )
                                  ),
                        )
                    ],
                  )
              ),
              Card(
                  elevation: 2.5,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 0.0, bottom: 0.0),
                        child: Text('Promos' , style: new TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 23.0,
                                                color: Colors.black,
                                              ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:0.0, left: 10.0, right: 0.0, bottom: 0.0),
                        child: Text('tour promos' , style: new TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),),
                      ),
                      
                      Container(
                          padding: const EdgeInsets.only(top:0.0, left: 0.0, right: 0.0, bottom: 20.0),
                          child:  Container(
                                    height:250.0,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        itemExtent: TravelDestinationItem.height,
                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                        children: promos.map<Widget>((TravelDestination destination) {
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 8.0),
                                            child: TravelDestinationItem(
                                              destination: destination,
                                              shape: _shape,
                                            ),
                                          );
                                        }).toList()
                                      )
                                  ),
                        )
                    ],
                  )
              )
            ]
          )
        )
    );
  }
}
