class User {
  late String? uid;
  late String? email;
  late String? name;
  late bool? emailVerified;
  late int? validations;
  late int? promptSubmitted;
  late int? answerSubmitted;

  User({this.uid, this.email, this.name});
  User.fromJson(Map<String, dynamic> json) {
    uid = json["_id"] ?? '';
    email = json["email"] ?? '';
    name = json["name"] ?? '';
    emailVerified = json["emailVerified"] ?? '';
  }
}
