class StoriesModel {
  late String uid;
  late String id;
  late String username;
  late String profileImage;
  late String image;
  late String text;
  late String type;
  late String date;

  StoriesModel(
      {required this.uid,
      required this.id,
      required this.username,
      required this.profileImage,
      required this.image,
      required this.text,
      required this.type,
      required this.date});

  StoriesModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    id = json['id'];
    username = json['username'];
    profileImage = json['profile_image'];
    image = json['image'];
    text = json['text'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['id'] = this.id;
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    data['image'] = this.image;
    data['text'] = this.text;
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}
