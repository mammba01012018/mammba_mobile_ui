import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/register_page.dart';

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({ Key key, this.icon, this.children }) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: themeData.accentColor))
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                width: 72.0,
                child: Icon(icon, color: themeData.primaryColor)
              ),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({ Key key, this.icon, this.lines, this.tooltip, this.onPressed })
    : assert(lines.length > 1),
      super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines.sublist(0, lines.length - 1).map<Widget>((String line) => Text(line)).toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren
        )
      )
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
        width: 72.0,
        child: IconButton(
          icon: Icon(icon),
          color: themeData.primaryColor,
          onPressed: onPressed
        )
      ));
    }
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren
        )
      ),
    );
  }
}

class ContactsDemo extends StatefulWidget {
  static const String routeName = '/contacts';

  final Member user;

  ContactsDemo({Key key, this.user}) : super(key: key);

  @override
  ContactsDemoState createState() => ContactsDemoState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class ContactsDemoState extends State<ContactsDemo> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 400.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: 'Edit',
                  onPressed: () {
                    // _scaffoldKey.currentState.showSnackBar(const SnackBar(
                    //   content: Text("Editing isn't supported in this screen.")
                    // ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage(updateUser: widget.user, isUpdate: true)),
                    );
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text("${widget.user.firstName}" + ' ' + "${widget.user.lastName}" ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // new NetworkImage("https://scontent.fceb1-1.fna.fbcdn.net/v/t1.0-1/c0.0.160.160a/p160x160/1558408_695435787164136_943786540553257078_n.jpg?_nc_cat=104&_nc_ht=scontent.fceb1-1.fna&oh=2cd0ecbc3a0edcaddef834f799cb6cbd&oe=5CD44282")
                    // Image.asset(
                      
                    //   // package: 'flutter_gallery_assets',
                    //   fit: BoxFit.cover,
                    //   height: _appBarHeight,
                    // ),
                    Image.network(
                      'https://scontent.fceb1-1.fna.fbcdn.net/v/t1.0-9/1558408_695435787164136_943786540553257078_n.jpg?_nc_cat=104&_nc_eui2=AeFYXKx3v-4zMtMZv16CBzX7fZCn9ikYOzGYoNTG1qL-QwApsu0UBUX8Wchx6UprGKDb8yDadCevEU164ESra4JypgT6VdRQcuXUqU3soKKnug&_nc_ht=scontent.fceb1-1.fna&oh=7d61fe0021a9584483f43c69ed015acf&oe=5CC04FB3',
                      fit: BoxFit.cover,
                      height: _appBarHeight,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: _ContactCategory(
                    icon: Icons.mobile_screen_share,
                    children: <Widget>[
                      _ContactItem(
                        onPressed: () {
                          _scaffoldKey.currentState.showSnackBar(const SnackBar(
                            content: Text('Pretend that this opened your SMS application.')
                          ));
                          print(widget.user);
                        },
                        lines: [
                          "${widget.user.mobileNumber}",
                          'Mobile',
                        ],
                      ),
                    ],
                  ),
                ),
                _ContactCategory(
                  icon: Icons.email,
                  children: <Widget>[
                    _ContactItem(
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text('Here, your e-mail application would open.')
                        ));
                      },
                      lines: <String>[
                        "${widget.user.emailAddress}",
                        'E-mail',
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.home,
                  children: <Widget>[
                    _ContactItem(
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text('This would show a map of Mountain View.')
                        ));
                      },
                      lines: <String>[
                         "${widget.user.address1}" + ' '  + "${widget.user.address2}" + ', ' + "${widget.user.province}",
                        "${widget.user.country}",
                        'Address',
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.cake,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        "${widget.user.birthDate}",
                        'Birthday',
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}