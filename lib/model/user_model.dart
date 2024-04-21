class User {
  int user_id;
  String user_name;
  String user_phone;
  String user_address;
  String user_password;

  User(
    this.user_id,
    this.user_name,
    this.user_phone,
      this.user_address,
      this.user_password,

  );
  factory User.fromJson(Map<String,dynamic> json) => User(
    int.parse(json["user_id"]),
    json["user_name"],
    json["user_phone"],
    json["user_password"],
    json["user_address"],
  );
  Map<String,dynamic> toJson() => {
    'user_id': user_id.toString(),
    'user_name': user_name,
    'user_phone': user_phone,
    'user_password': user_password,
    'user_address' : user_address,
  };
}
