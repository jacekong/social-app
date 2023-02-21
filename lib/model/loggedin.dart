import 'dart:convert';

class LoggedIn {
  final int id;
  final int userid;
  LoggedIn({
    required this.id,
    required this.userid,
  });

  LoggedIn copyWith({
    int? id,
    int? userid,
  }) {
    return LoggedIn(
      id: id ?? this.id,
      userid: userid ?? this.userid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userid': userid,
    };
  }

  factory LoggedIn.fromMap(Map<String, dynamic> map) {
    return LoggedIn(
      id: map['id'].toInt() as int,
      userid: map['userid'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoggedIn.fromJson(String source) => LoggedIn.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoggedIn(id: $id, userid: $userid)';

  @override
  bool operator ==(covariant LoggedIn other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userid == userid;
  }

  @override
  int get hashCode => id.hashCode ^ userid.hashCode;
}