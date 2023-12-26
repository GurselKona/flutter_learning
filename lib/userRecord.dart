/// ID : 0
/// FIRST_NAME : ""
/// LAST_NAME : ""

class UserRecord {
  UserRecord({
    num? id,
    String? firstname,
    String? lastname,
  }) {
    _id = id;
    _firstname = firstname;
    _lastname = lastname;
  }

  UserRecord.fromJson(dynamic json) {
    _id = json['ID'];
    _firstname = json['FIRST_NAME'];
    _lastname = json['LAST_NAME'];
  }
  num? _id;
  String? _firstname;
  String? _lastname;
  UserRecord copyWith({
    num? id,
    String? firstname,
    String? lastname,
  }) =>
      UserRecord(
        id: id ?? _id,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname,
      );
  num? get id => _id;
  String? get firstname => _firstname;
  String? get lastname => _lastname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['FIRST_NAME'] = _firstname;
    map['LAST_NAME'] = _lastname;
    return map;
  }
}
