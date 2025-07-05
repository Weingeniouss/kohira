import 'dart:convert';
/// message : "Email id not found.Please check your email id."
/// status : false

Forgetpassword forgetpasswordFromJson(String str) => Forgetpassword.fromJson(json.decode(str));
String forgetpasswordToJson(Forgetpassword data) => json.encode(data.toJson());

class Forgetpassword {
  Forgetpassword({String? message, bool? status, String? email}) {
    _message = message;
    _status = status;
    _email = email;
  }

  Forgetpassword.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _email = json['email'];
  }

  String? _message;
  bool? _status;
  String? _email;

  Forgetpassword copyWith({String? message, bool? status, String? email,}) => Forgetpassword(
    message: message ?? _message,
    status: status ?? _status,
    email: email ?? _email,
  );

  String? get message => _message;
  bool? get status => _status;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    map['email'] = _email;
    return map;
  }
}