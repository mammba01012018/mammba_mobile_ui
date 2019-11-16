import 'dart:convert';
import 'dart:io';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mammba/common/common-fields.dart';
import 'package:http/http.dart' as http;
import 'package:mammba/models/LogInUser.dart';
import 'package:mammba/models/LoginResponse.dart';
import 'package:mammba/models/Member.dart';
import 'package:mammba/pages/home_page.dart';
import 'package:mammba/pages/others/reset_password_page.dart';
import 'package:mammba/pages/others/security_questions_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:requests/requests.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intro_slider/intro_slider.dart';


class IntroSliderPage extends StatefulWidget {
  static String tag = '/intro-slider';
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

const jsonCodec = const JsonCodec();

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "TOUR",
        description: "Exciting places and destinations",
        pathImage: "images/tour.gif",
        backgroundColor: Color.fromRGBO(242, 211, 82, 1.0),
      ),
    );
    slides.add(
      new Slide(
        title: "TRANSPO",
        description: "Joiners or Exclusive!",
        pathImage: "images/transpo.gif",
        backgroundColor: Color.fromRGBO(0, 195, 128, 1.0),
      ),
    );
    slides.add(
      new Slide(
        title: "HOTEL",
        description: "Hotels to stay in!",
        pathImage: "images/hotel.gif",
        backgroundColor: Color.fromRGBO(255, 127, 39, 1.0),
      ),
    );
    slides.add(
      new Slide(
        title: "FLIGHTS",
        description: "Book your flight!",
        pathImage: "images/flights.gif",
        backgroundColor: Color.fromRGBO(30, 179, 244, 1.0),
      ),
    );
    // slides.add(
    //   new Slide(
    //     title: "RULER",
    //     description:
    //         "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
    //     pathImage: "images/photo_ruler.png",
    //     backgroundColor: Color(0xff9932CC),
    //   ),
    // );
  }


  donePress(BuildContext context) {
     Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: ()=>  Navigator.pop(context, true) 
    );
  }
 
}
    
