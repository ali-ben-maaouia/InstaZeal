class loginModel{
  String name;
  User user;
  String token;
  loginModel({
    this.name="",required this.user, this.token="token"
});
  factory loginModel.fromJson(Map<String, dynamic> json) => loginModel(
    user: User.fromJson(json["user"]),
    token: json["token"], name: '',
  );
}
class User{
  int id;
  String name;
  String email;
  User({
    this.id=0,
    this.name="name",
    this.email="email"
});
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );
}
