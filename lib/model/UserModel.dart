import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserModel {
  int? id;
  int? is_premium_user;
  String? name;
  String? email;
  String? picture;
  String? phone;
  String? description;

  UserModel({
    this.id,
    this.is_premium_user,
    this.name,
    this.email,
    this.picture,
    this.phone,
    this.description,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    is_premium_user: json["is_premium_user"] == null ? null : json["is_premium_user"],
    email: json["email"] == null ? null : json["email"],
    picture: json["picture"] == null ? null : json["picture"],
    phone: json["phone"] == null ? null : json["phone"],
  );
}
