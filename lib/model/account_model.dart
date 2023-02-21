import 'dart:convert';

class User {
  final String nickname;
  final String profile_img;
  User({
    required this.nickname,
    required this.profile_img,
  });

  User copyWith({
    String? nickname,
    String? profile_img,
  }) {
    return User(
      nickname: nickname ?? this.nickname,
      profile_img: profile_img ?? this.profile_img,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nickname': nickname,
      'profile_img': profile_img,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nickname: map['nickname'] as String,
      profile_img: map['profile_img'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(nickname: $nickname, profile_img: $profile_img)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.nickname == nickname &&
      other.profile_img == profile_img;
  }

  @override
  int get hashCode => nickname.hashCode ^ profile_img.hashCode;
}