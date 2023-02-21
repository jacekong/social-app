import 'dart:convert';

class CommentModel {
  // ignore: non_constant_identifier_names
  final String profile_img;
  final String nickname;
  final String comment;
  final String date;
  CommentModel({
    // ignore: non_constant_identifier_names
    required this.profile_img,
    required this.nickname,
    required this.comment,
    required this.date,
  });

  CommentModel copyWith({
    // ignore: non_constant_identifier_names
    String? profile_img,
    String? nickname,
    String? comment,
    String? date,
  }) {
    return CommentModel(
      profile_img: profile_img ?? this.profile_img,
      nickname: nickname ?? this.nickname,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profile_img': profile_img,
      'nickname': nickname,
      'comment': comment,
      'date': date,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      profile_img: map['profile_img'] as String,
      nickname: map['nickname'] as String,
      comment: map['comment'] as String,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(profile_img: $profile_img, nickname: $nickname, comment: $comment, date: $date)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.profile_img == profile_img &&
      other.nickname == nickname &&
      other.comment == comment &&
      other.date == date;
  }

  @override
  int get hashCode {
    return profile_img.hashCode ^
      nickname.hashCode ^
      comment.hashCode ^
      date.hashCode;
  }
}