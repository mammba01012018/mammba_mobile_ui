class SecurityQuestion {
  int userId;
  int questionId;
  String answer;
  Map toJson() {
    return {"userId": this.userId, "questionId": this.questionId, "answer": this.answer };
  }
}