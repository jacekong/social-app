import 'dart:convert';

class TextPost {
  final int id;
  final String name;
  final String post;
  final String date;
  TextPost({
    required this.id,
    required this.name,
    required this.post,
    required this.date,
  });

  TextPost copyWith({
    int? id,
    String? name,
    String? post,
    String? date,
  }) {
    return TextPost(
      id: id ?? this.id,
      name: name ?? this.name,
      post: post ?? this.post,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'post': post,
      'date': date,
    };
  }

  factory TextPost.fromMap(Map<String, dynamic> map) {
    return TextPost(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      post: map['post'] as String,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TextPost.fromJson(String source) => TextPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TextPost(id: $id, name: $name, post: $post, date: $date)';
  }

  @override
  bool operator ==(covariant TextPost other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.post == post &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      post.hashCode ^
      date.hashCode;
  }
}