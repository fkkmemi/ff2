import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()

class User {
  final String email;
  int level;
  User(this.email, this.level);
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this); 
}