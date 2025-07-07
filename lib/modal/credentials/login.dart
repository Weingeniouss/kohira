import 'dart:convert';
/// token : "1094|bvuJYkfi3j8Y4UjBLf5MH9x8tT1vdXUpxg2waSCb"
/// success : true
/// message : "User Successfully Login."
/// data : {"userid":36,"firstname":"Navinbhai","lastname":"Dholariya","email":"vats.mehta01@gmail.com","is_addresses":14,"isapproved":1}

Login loginFromJson(String str) => Login.fromJson(json.decode(str));
String loginToJson(Login data) => json.encode(data.toJson());
class Login {
  Login({
      String? token, 
      bool? success, 
      String? message, 
      Data? data,}){
    _token = token;
    _success = success;
    _message = message;
    _data = data;
}

  Login.fromJson(dynamic json) {
    _token = json['token'];
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _token;
  bool? _success;
  String? _message;
  Data? _data;
Login copyWith({  String? token,
  bool? success,
  String? message,
  Data? data,
}) => Login(  token: token ?? _token,
  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  String? get token => _token;
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// userid : 36
/// firstname : "Navinbhai"
/// lastname : "Dholariya"
/// email : "vats.mehta01@gmail.com"
/// is_addresses : 14
/// isapproved : 1

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? userid, 
      String? firstname, 
      String? lastname, 
      String? email, 
      num? isAddresses, 
      num? isapproved,}){
    _userid = userid;
    _firstname = firstname;
    _lastname = lastname;
    _email = email;
    _isAddresses = isAddresses;
    _isapproved = isapproved;
}

  Data.fromJson(dynamic json) {
    _userid = json['userid'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _email = json['email'];
    _isAddresses = json['is_addresses'];
    _isapproved = json['isapproved'];
  }
  num? _userid;
  String? _firstname;
  String? _lastname;
  String? _email;
  num? _isAddresses;
  num? _isapproved;
Data copyWith({  num? userid,
  String? firstname,
  String? lastname,
  String? email,
  num? isAddresses,
  num? isapproved,
}) => Data(  userid: userid ?? _userid,
  firstname: firstname ?? _firstname,
  lastname: lastname ?? _lastname,
  email: email ?? _email,
  isAddresses: isAddresses ?? _isAddresses,
  isapproved: isapproved ?? _isapproved,
);
  num? get userid => _userid;
  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get email => _email;
  num? get isAddresses => _isAddresses;
  num? get isapproved => _isapproved;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userid;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['email'] = _email;
    map['is_addresses'] = _isAddresses;
    map['isapproved'] = _isapproved;
    return map;
  }

}