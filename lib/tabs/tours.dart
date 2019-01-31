import 'package:flutter/material.dart';
import 'package:mammba/models/TourForm.dart';
import 'dart:async';


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
  // final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  // final timeFormat = DateFormat("h:mm a");

  
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
    loadData();
    
    return Container(
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Column (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            new Row(
              children: <Widget>[
                new Icon(Icons.my_location),
                new Divider(height: 0.0, indent: 20.0,),
                new DropdownButton(
                      value: tourForm.tourType,
                      items: tourTypes,
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      hint: new Text("Select Type of Tour"),
                      onChanged: (value) {
                        setState(() {
                          tourForm.tourType = value;    
                      });
                    }
                ),
              ],
            ),
            // new Row(
            //   children: <Widget>[
            //     new Icon(Icons.local_taxi),
            //     new Divider(height: 0.0, indent: 20.0,),
            //     new DropdownButton(
            //           value: tourForm.tourType,
            //           items: _toursType.map((String value) {
            //             return new DropdownMenuItem(child: new Text(value), value: value);
            //           }).toList(),
            //           hint: new Text("Select Type of Tour"),
            //           onChanged: (value) {
            //             setState(() {
            //               tourForm.tourType = value;    
            //           });
            //         }
            //     ),
            //   ],
            // ),
            // new Row(
            //   children: <Widget>[
            //     new Icon(Icons.my_location),
            //     new Divider(height: 0.0, indent: 20.0,),
            //     new Text(tourForm.pickUpLocation==null ? "Select Pickup Location": tourForm.pickUpLocation)
            //   ],
            // ),
            new Row(
              children: <Widget>[
                new Icon(Icons.my_location),
                new Divider(height: 0.0, indent: 20.0,),
                new DropdownButton(
                     style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      value: tourForm.pickUpLocation,
                      items: tourTypes,
                      hint: new Text("Select Pickup Location"),
                      onChanged: (value) {
                        setState(() {
                          tourForm.pickUpLocation = value;    
                      });
                    }
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Icon(Icons.pin_drop),
                new Divider(height: 0.0, indent: 20.0,),
                new DropdownButton(
                      style: new TextStyle(
                        fontSize: 14.0,
                         color: Colors.black,
                      ),
                      value: tourForm.firstDestination,
                      items: tourTypes,
                      hint: new Text("Select Destination"),
                      onChanged: (value) {
                        setState(() {
                          tourForm.firstDestination = value;    
                      });
                    }
                ),
              ],
            ),
            tourForm.isMultiDestination ? Row(
              children: <Widget>[
                new Icon(Icons.add_location),
                new Divider(height: 0.0, indent: 20.0,),
                new DropdownButton(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      value: tourForm.secondDestination,
                      items: tourTypes,
                      hint: new Text("Select Another Destination"),
                      onChanged: (value) {
                        setState(() {
                          tourForm.secondDestination = value;    
                      });
                    }
                ),
              ],
            ): new Container(),
            new Row(
              children: <Widget>[
                new Divider(height: 0.0, indent: 35.0,),
                new Checkbox(
                  value: tourForm.isMultiDestination, 
                  onChanged: (bool value) {
                      setState(() {
                          tourForm.isMultiDestination = value;    
                      });
                  }
                ),
                new Text("Multi-Destination")
              ],
            ),
            new Divider(height: 24.0),
            new Text(
              "Travel Dates",
               style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
                ),
            ),
            new Divider(height: 12.0),
            new Row(
              children: <Widget>[
                new Divider(height: 0.0, indent: 0.0,),
                new Text("Start Date: "),
                new Divider(height: 0.0, indent: 70.0,),
                new Text("End Date: ")
              ],
            ),
            new Divider(height: 12.0),
            new Row(
              children: <Widget>[
                new RaisedButton(
                   child: new Text(
                      tourForm.startDate==null ? "Select Start Date" : getDate(tourForm.startDate),
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  color: Colors.purple[500],
                  onPressed: () {_selectDate(context, 'startDate');},
                ),
                new Divider(height: 0.0, indent: 20.0,),
                new RaisedButton(
                   child: new Text(
                      tourForm.endDate==null ? "Select End Date" : getDate(tourForm.endDate),
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  color: Colors.purple[500],
                  onPressed: () {_selectDate(context, 'endDate');},
                ),
              ],
            ),
            new Divider(height: 24.0,),
            new RaisedButton(
              child: new Text(
                "Search",
              
                style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
              ),
              color: Colors.purple[500],
              onPressed: () => setState(() {
                  tourForm.tourType=null;
                })
            )
          //  DateTimePickerFormFierld(
          //           format: dateFormat,
          //           resetIcon: null,
          //           onChanged: (date) {
          //             print(date);
          //             setState(() {
          //                 tourForm.startDate = date;
          //             });
          //           },
          //         ),
            
           
            // new Divider(height: 6.0,),
            // new RaisedButton(
            //   child: new Text(tourForm.endDate==null ? "Select Start Date" : tourForm.endDate.toString()),
            //   color: Colors.purple[500],
            //   onPressed: () {_selectDate(context, 'endDate');},
            // ),
            
           
          ],
        ),
      )
    );
  }
}
