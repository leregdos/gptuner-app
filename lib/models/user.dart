class User {
  late String? uid;
  late String? email;
  late String? name;

  User({this.uid, this.email, this.name});
  User.fromJson(Map<String, dynamic> json) {
    uid = json["_id"] ?? '';
    email = json["email"] ?? '';
    email = json["name"] ?? '';
  }
}
