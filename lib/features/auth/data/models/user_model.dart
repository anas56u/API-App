import '../../domain/entities/user.dart'; 

class UserModel extends User {

  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
  });

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }
}