// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['email'] as String, json['level'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) =>
    <String, dynamic>{'email': instance.email, 'level': instance.level};
