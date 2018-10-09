import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {
  String id;
  String name;
  String phone;
  String address;
  String photo;


  User({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.photo
  });

  factory User.fromJson(Map<String, dynamic> map) => _$UserFromJson(map);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
