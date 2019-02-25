
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class TravelDestination {
  const TravelDestination({
    this.assetName,
    this.assetPackage,
    this.title,
    this.description,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final List<String> description;

  bool get isValid => assetName != null && title != null && description?.length == 3;
}

final List<TravelDestination> destinations = <TravelDestination>[
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'https://sa.kapamilya.com/absnews/abscbnnews/media/2018/news/04/22/042218_palawan2.jpg',
    title: 'El Nido',
    description: <String>[
      'El Nido',
      'Thanjavur',
      'Thanjavur, Tamil Nadu',
    ],
  ),
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'http://static.asiawebdirect.com/m/phuket/portals/philippines-hotels-ws/homepage/boracay-island/pagePropertiesImage/boracay.jpg',
    title: 'Boracay',
    description: <String>[
      'Boracay',
      'Chettinad',
      'Sivaganga, Tamil Nadu',
    ],
  ),
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'https://villageconnectph.com/wp-content/uploads/2017/12/batanes.jpg',
    title: 'Batanes',
    description: <String>[
      'Batanes',
      'Chettinad',
      'Sivaganga, Tamil Nadu',
    ],
  ),
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'http://3.bp.blogspot.com/-ZrW7eQzEKvU/UbNcdTn5ugI/AAAAAAAAJQ4/bDVnaEpfpFo/s1600/CALAGUAS+%252825%2529.JPG',
    title: 'Calaguas',
    description: <String>[
      'Calaguas',
      'Chettinad',
      'Sivaganga, Tamil Nadu',
    ],
  )
];

class TravelDestinationItem extends StatelessWidget {
  TravelDestinationItem({ Key key, @required this.destination, this.shape })
    : assert(destination != null && destination.isValid),
      super(key: key);

  static const double height = 300.0;
  final TravelDestination destination;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        height: height,
        child: Card(
          shape: shape,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // photo and title
              SizedBox(
                height: 184.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(
                        destination.assetPackage.toString(),
                        fit: BoxFit.cover,
                      ),
                      
                    ),
                    Positioned(
                      bottom: 12.0,
                      left: 16.0,
                      right: 16.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        // child: Text(destination.title,
                        //   style: titleStyle,
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              // description and share/explore buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: DefaultTextStyle(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: descriptionStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // three line description
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            destination.description[0],
                            style: descriptionStyle.copyWith(color: Colors.black54),
                          ),
                        ),
                        // Text(destination.description[1]),
                        // Text(destination.description[2]),
                      ],
                    ),
                  ),
                ),
              ),
              // share, explore buttons
              // ButtonTheme.bar(
              //   child: ButtonBar(
              //     alignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       FlatButton(
              //         child: const Text('SHARE'),
              //         textColor: Colors.amber.shade500,
              //         onPressed: () { /* do nothing */ },
              //       ),
              //       FlatButton(
              //         child: const Text('EXPLORE'),
              //         textColor: Colors.amber.shade500,
              //         onPressed: () { /* do nothing */ },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


class MyBookings extends StatefulWidget {
  static String tag = 'my-bookings';

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  ShapeBorder _shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
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
    );
  }
}