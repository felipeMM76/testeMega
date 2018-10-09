// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return new User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      photo: json['photo'] as String);
}

abstract class _$UserSerializerMixin {
  String get id;
  String get name;
  String get phone;
  String get address;
  String get photo;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'phone': phone,
        'address': address,
        'photo': photo
      };
}
