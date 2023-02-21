import 'dart:convert';

class UserPost {
  final String post_img;
  UserPost({
    required this.post_img,
  });

  UserPost copyWith({
    String? post_img,
  }) {
    return UserPost(
      post_img: post_img ?? this.post_img,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_img': post_img,
    };
  }

  factory UserPost.fromMap(Map<String, dynamic> map) {
    return UserPost(
      post_img: map['post_img'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPost.fromJson(String source) => UserPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserPost(post_img: $post_img)';

  @override
  bool operator ==(covariant UserPost other) {
    if (identical(this, other)) return true;
  
    return 
      other.post_img == post_img;
  }

  @override
  int get hashCode => post_img.hashCode;
}