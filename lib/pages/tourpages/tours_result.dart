import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mammba/models/TourResult.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ToursResult extends StatefulWidget {
  static String tag = '/tours-result';
  @override
  _ToursResultState createState() => _ToursResultState();
}

const jsonCodec = const JsonCodec();

class _ToursResultState extends State<ToursResult> {

  Future<List<TourResult>> getTours() async {
    final data =await http.get("http://www.mocky.io/v2/5d460586300000d05dc5c991");
    final parsed = json.decode(data.body).cast<Map<String, dynamic>>();
    print(parsed);
    List<TourResult> tours = parsed.map<TourResult>((json) => TourResult.fromJson(json)).toList();
    print(tours);
    return tours;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Colors.teal
      ),
      body: Container(
        child: FutureBuilder(
          future: getTours(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data==null) {
              return SpinKitWave(
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.teal : Colors.teal,
                      ),
                    );
                  },
                );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                padding: new EdgeInsets.all(10.0),
                itemBuilder:  (BuildContext context, int index) {
                  // return ListTile(
                  //   title: Text(snapshot.data[index].travelAgency),
                  //   subtitle: Text(snapshot.data[index].price.toString()),
                  // );
                  return Card(
                      elevation: 2.5,
                      child: new Container(
                      padding: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 20.0),
                      child: Column(
                          
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 2.0, 5.0, 2.0),
                                    child: SizedBox(
                                      height: 50.0,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: Image.network(
                                              snapshot.data[index].photoUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                                //const SizedBox(width: 12.0),
                                Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "${snapshot.data[index].travelAgency.toString()}",
                                            style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w500
                                            )
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: <Widget>[
                                              const SizedBox(width: 10.0),
                                              StarRating(rating: 4.0, starConfig: StarConfig(
                                                size: 10,
                                                strokeWidth:0
                                                // other props
                                              )),
                                              const SizedBox(width: 10.0),
                                              Text('5.0')
                                            ],
                                          ),
                                        ],
                                      ),
                                ),
                                Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
                                        child: Column(
                                        textDirection: TextDirection.rtl,
                                        children: <Widget>[
                                          Text(
                                            "P ${snapshot.data[index].price.toString()}",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.black87,
                                            )
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                     padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                                     child:Column(
                                        textDirection: TextDirection.ltr,
                                        children: <Widget>[
                                          Text("Inclusions", style: new TextStyle(fontWeight: FontWeight.w500 , fontSize: 14.0, color: Colors.teal),),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.place),
                                              const SizedBox(width: 5.0),
                                              Expanded(child: 
                                                Text(
                                                  "Free Pickup and Drop-off within Metro Manila",
                                                  textDirection: TextDirection.ltr,
                                                  style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.directions_car),
                                              const SizedBox(width: 5.0),
                                              Expanded(child: 
                                                Text(
                                                  "Transportation for the tour",
                                                  textDirection: TextDirection.ltr,
                                                  style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.fastfood),
                                              const SizedBox(width: 5.0),
                                              Expanded(child: 
                                                Text(
                                                  "Free breakfast for two days",
                                                  textDirection: TextDirection.ltr,
                                                  style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                         
                                        ],
                                      ),
                                  )
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                     padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 2.0),
                                     child:Column(
                                        textDirection: TextDirection.ltr,
                                        children: <Widget>[
                                          const SizedBox(height: 28.0),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.hotel),
                                              const SizedBox(width: 5.0),
                                              Expanded(child: 
                                                Text(
                                                  "Accommodations for 2 nights",
                                                  textDirection: TextDirection.ltr,
                                                  style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.map),
                                              const SizedBox(width: 5.0),
                                              Expanded(child: 
                                                Text(
                                                  "Places to Visit",
                                                  textDirection: TextDirection.ltr,
                                                  style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  )
                                )
                              ]
                            )
                           ],
                        )
                      ),
                    );
                }
              );
            }
          }
        ),
      )
    );
  }

  
}
    
// class TourTileItem extends StatelessWidget {
//   TourTileItem({ Key key, @required this.destination, this.shape })
//     : assert(destination != null && destination.isValid),
//       super(key: key);

//   static const double height = 300.0;
//   final TourTile destination;
//   final ShapeBorder shape;

//   @override
//   Widget build(BuildContext context) {

//     final ThemeData theme = Theme.of(context);
//     final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);
//     final TextStyle descriptionStyle = theme.textTheme.subhead;

//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: Container(
//         padding: const EdgeInsets.all(15.0),
//         height: height,
//         child: Card(
//           shape: shape,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // photo and title
//               SizedBox(
//                 height: 184.0,
//                 child: Stack(
//                   children: <Widget>[
//                     Positioned.fill(
//                       child: Image.network(
//                         destination.assetPackage.toString(),
//                         fit: BoxFit.cover,
//                       ),
                      
//                     ),
//                     Positioned(
//                       bottom: 10.0,
//                       left: 10.0,
//                       right: 10.0,
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         alignment: Alignment.centerLeft,
//                         // child: Text(destination.title,
//                         //   style: titleStyle,
//                         // ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // description and share/explore buttons
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
//                   child: DefaultTextStyle(
//                     softWrap: false,
//                     overflow: TextOverflow.ellipsis,
//                     style: descriptionStyle,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         // three line description
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Text(
//                             destination.description[0],
//                             style: descriptionStyle.copyWith(color: Colors.black54),
//                           ),
//                         ),
//                         // Text(destination.description[1]),
//                         // Text(destination.description[2]),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
