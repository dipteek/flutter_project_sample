class PostModel {
  late String uid;
  late String id;
  late String username;
  late String description;
  late String date;
  late String imgLink;
  late int likes;

  PostModel(
      {required this.uid,
      required this.id,
      required this.username,
      required this.description,
      required this.date,
      required this.imgLink,
      required this.likes});

  PostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    id = json['id'];
    username = json['username'];
    description = json['description'];
    date = json['date'];
    imgLink = json['img_link'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['id'] = this.id;
    data['username'] = this.username;
    data['description'] = this.description;
    data['date'] = this.date;
    data['img_link'] = this.imgLink;
    data['likes'] = this.likes;
    return data;
  }
}
