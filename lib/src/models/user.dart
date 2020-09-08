class User {
  User({
    this.isOnline,
    this.name,
    this.email,
    this.uid,
  });

  bool isOnline;
  String name;
  String email;
  String uid;

  factory User.fromJson(Map<String, dynamic> json) => User(
    isOnline: json["isOnline"],
    name: json["name"],
    email: json["email"],
    uid: json["uid"]
  );

  Map<String, dynamic> toJson() => {
    "isOnline": isOnline,
    "name": name,
    "email": email,
    "uid": uid
  };
}