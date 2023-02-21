import 'dart:convert';

class ImagePost {
  final int id;
  final String nickname;
  final String profile_img;
  final String location;
  final String post_img;
  final String caption;
  int liked;
  final String date;
  ImagePost({
    required this.id,
    required this.nickname,
    required this.profile_img,
    required this.location,
    required this.post_img,
    required this.caption,
    required this.liked,
    required this.date,
  });

  ImagePost copyWith({
    int? id,
    String? nickname,
    String? profile_img,
    String? location,
    String? post_img,
    String? caption,
    int? liked,
    String? date,
  }) {
    return ImagePost(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      profile_img: profile_img ?? this.profile_img,
      location: location ?? this.location,
      post_img: post_img ?? this.post_img,
      caption: caption ?? this.caption,
      liked: liked ?? this.liked,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nickname': nickname,
      'profile_img': profile_img,
      'location': location,
      'post_img': post_img,
      'caption': caption,
      'liked': liked,
      'date': date,
    };
  }

  factory ImagePost.fromMap(Map<String, dynamic> map) {
    return ImagePost(
      id: map['id'].toInt() as int,
      nickname: map['nickname'] as String,
      profile_img: map['profile_img'] as String,
      location: map['location'] as String,
      post_img: map['post_img'] as String,
      caption: map['caption'] as String,
      liked: map['liked'].toInt() as int,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImagePost.fromJson(String source) => ImagePost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ImagePost(id: $id, nickname: $nickname, profile_img: $profile_img, location: $location, post_img: $post_img, caption: $caption, liked: $liked, date: $date)';
  }

  @override
  bool operator ==(covariant ImagePost other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nickname == nickname &&
      other.profile_img == profile_img &&
      other.location == location &&
      other.post_img == post_img &&
      other.caption == caption &&
      other.liked == liked &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nickname.hashCode ^
      profile_img.hashCode ^
      location.hashCode ^
      post_img.hashCode ^
      caption.hashCode ^
      liked.hashCode ^
      date.hashCode;
  }
}