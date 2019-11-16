
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

final List<TravelDestination> promos = <TravelDestination>[
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'https://scontent.fmnl6-1.fna.fbcdn.net/v/t1.0-9/17499009_1955072948054035_1593631715129417268_n.jpg?_nc_cat=102&_nc_oc=AQlb69bEqfY3SKa8AhLDWT7C2574mQApLtOHMREhmzv4CZtpqMZZHAsadm4sVuyX4NI&_nc_ht=scontent.fmnl6-1.fna&oh=a400f78f257003916a2ebae768b8f629&oe=5DE82D3D',
    title: 'Pulag',
    description: <String>[
      'Pulag',
      'Thanjavur',
      'Thanjavur, Tamil Nadu',
    ],
  ),
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'https://cdn11.bigcommerce.com/s-bv9wyhhu/images/stencil/500x659/products/130/20/baguio-destination__11340.1541234563.1280.1280__19420.1555172705.jpg?c=2&imbypass=on',
    title: 'Baguio',
    description: <String>[
      'Baguio',
      'Chettinad',
      'Sivaganga, Tamil Nadu',
    ],
  ),
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'https://www.thepoortraveler.net/wp-content/uploads/2012/08/Taal-Volcano.jpg',
    title: 'Taal',
    description: <String>[
      'Taal',
      'Chettinad',
      'Sivaganga, Tamil Nadu',
    ],
  ),
  const TravelDestination(
    assetName: 'assets/el-nido.jpg',
    assetPackage: 'https://d1sttufwfa12ee.cloudfront.net/uploads/deal/thumb/90310.jpg',
    title: 'Ilocos',
    description: <String>[
      'Ilocos',
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
          color: Colors.teal,
          shape: shape,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // photo and title
              SizedBox(
                height: 150.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(
                        destination.assetPackage.toString(),
                        fit: BoxFit.cover,
                      ),
                      
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      right: 10.0,
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
                            style: descriptionStyle.copyWith(color: Colors.white),
                          ),
                        ),
                        // Text(destination.description[1]),
                        // Text(destination.description[2]),
                      ],
                    ),
                  ),
                ),
              ),
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