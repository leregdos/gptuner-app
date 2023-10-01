class Answer {
  late String? uid;
  late String? content;
  late String? associatedPrompt;

  Answer({this.uid, this.content, this.associatedPrompt});
  Answer.fromJson(Map<String, dynamic> json) {
    uid = json["_id"] ?? '';
    content = json["content"] ?? '';
    associatedPrompt = json["associatedPrompt"] ?? '';
  }
}
