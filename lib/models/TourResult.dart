class TourResult {
   int tourId;
  //  String travelAgency;
  //  int price;
  //  String photoUrl;
  //  List<String> places;
  //  Inclusions inclusions;
   String tourPackageName;
   String tourType;
   String startDate;
   String endDate;

  //TourResult({this.tourId, this.travelAgency, this.price, this.photoUrl, this.places, this.inclusions, String tourPackageName, String tourType, String endDate, String startDate});
    TourResult({String tourPackageName, String tourType, String endDate, this.tourId,  String startDate});

  factory TourResult.fromJson(Map<String, dynamic> json) {
    return TourResult(
      // travelAgency: json['travelAgency'] as String,
      tourPackageName: json['tourPackageName'] as String,
      tourType: json['tourType'] as String,
      endDate: json['endDate'] as String,
      tourId: json['tourId'] as int,
      startDate: json['startDate'] as String,
      // price: json['price'] as int,
      // photoUrl: json['photoUrl'] as String,
      // places: parsePlaces(json['places']),
      // inclusions: Inclusions.fromJson(json),
    );
  }

  static List<String> parsePlaces(json) {
      List<String> placeList = new List<String>.from(json);
      return placeList;
  }
}

class Inclusions {
  bool isFreePickUp;
  bool isTranspo;
  bool isMeal;
  bool isAccomodation;
  
  Inclusions({this.isFreePickUp, this.isTranspo, this.isMeal, this.isAccomodation});

   factory Inclusions.fromJson(Map<String, dynamic> json) {
    return Inclusions(
      isFreePickUp: json['isFreePickUp'] as bool,
      isTranspo: json['isTranspo'] as bool,
      isMeal: json['isMeal'] as bool,
      isAccomodation: json['isAccomodation'] as bool,
    );
  }

}