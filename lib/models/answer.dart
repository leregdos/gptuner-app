class Answer {
  late String? uid;
  late String? content;

  Answer({this.uid, this.content});
  Answer.fromJson(Map<String, dynamic> json) {
    uid = json["_id"] ?? '';
    content = json["content"] ?? '';
  }
}
