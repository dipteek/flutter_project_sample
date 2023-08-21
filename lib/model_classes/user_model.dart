class UserModel {
  late String uid;
  late String? name;
  late String? email;
  late String? username;
  late String? bio;
  late String? addLink;
  late String? profileImage;
  late int? posts;
  late int? followers;
  late int? following;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.username,
      required this.bio,
      required this.addLink,
      required this.profileImage,
      required this.posts,
      required this.followers,
      required this.following});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    bio = json['bio'];
    addLink = json['add_link'];
    profileImage = json['profile_image'];
    posts = json['posts'];
    followers = json['followers'];
    following = json['following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['username'] = this.username;
    data['bio'] = this.bio;
    data['add_link'] = this.addLink;
    data['profile_image'] = this.profileImage;
    data['posts'] = this.posts;
    data['followers'] = this.followers;
    data['following'] = this.following;
    return data;
  }
}
