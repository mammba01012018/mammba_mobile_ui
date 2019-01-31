class LogInUser {
  String userEmail;
  String password;
  Map toJson() {
    return {"userEmail": this.userEmail, "password": this.password};
  }
}