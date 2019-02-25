
import 'package:mammba/models/Member.dart';

class LoginResponse {
    Member user;
    String csrf;

    LoginResponse() {

   }
   

   LoginResponse.toSave(Member member, String csrf)
      : user = member,
         csrf =csrf
       ;

}