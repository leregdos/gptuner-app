class Prompt {
  late String? uid;
  late String? content;

  Prompt({this.uid, this.content});
  Prompt.fromJson(Map<String, dynamic> json) {
    uid = json["_id"] ?? '';
    content = json["content"] ?? '';
  }
}
