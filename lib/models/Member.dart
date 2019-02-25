class MammbaMember {
 

   


}

class Member {

   int memberId;
	 String firstName;
	 String lastName;
	 String middleInitial;
	 String gender;
	 String address2;
	 String rate;
	 String birthDate;
	 String province;
   String country;
    String address1;
    String password;
    String mobileNumber;
    String emailAddress;
    String username;
    String userType;
    int userId;
   Member() {

   }
   

   Member.fromJson(Map<String, dynamic> json)
      : lastName = json['lastName'],
        country = json['country'],
        gender = json['gender'],
        address1 = json['address1'],
        address2 = json['address2'],
        birthDate = json ['birthDate'],
        mobileNumber = json['mobileNumber'],
        firstName = json['firstName'],
        emailAddress = json['emailAddress'],
        password = json['password'],
        middleInitial = json['middleInitial'],
        province = json['province'],
        rate = json['rate'],
        userType = json['userType'],
        memberId = json['memberId'],
        username = json['username'],
        userId = json['userId'];


  //  Member.fromJson(Map<String, dynamic> json)
  //     : lastName = json['lastName'],
  //       email = json['email'];

  Map<String, dynamic> toJson() =>
    {
      'lastName': lastName,
      'country': country,
      'gender': gender,
      'address1': address1,
      'mobileNumber': mobileNumber,
      'firstName': firstName,
      'emailAddress': emailAddress,
      'password': password,
      'middleInitial': middleInitial,
      'province': province,
      'rate': rate,
      'userType': userType,
      'memberId': memberId,
      'username': username,
    };

}
