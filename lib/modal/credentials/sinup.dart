
/// code : 200
/// status : false
/// type : "validation_error"
/// message : "Please enter the correct captcha."

// ignore_for_file: non_constant_identifier_names, dangling_library_doc_comments

class Sinup {
  final int? code;
  final bool? status;
  final String? type;
  final String? message;
  final UserData? data;

  Sinup({
    this.code,
    this.status,
    this.type,
    this.message,
    this.data,
  });

  factory Sinup.fromJson(Map<String, dynamic> json) {
    return Sinup(
      code: json['code'],
      status: json['status'] is bool ? json['status'] : json['status'] == "true",
      type: json['type'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String? email;
  final String? firstname;
  final String? lastname;
  final String? password;
  final String? passwordConfirmation;
  final String? mobileno;
  final String? captcha;
  final String? countrycode;
  final String? country_shortname;
  final String? login_type;


  UserData({
    this.email,
    this.firstname,
    this.lastname,
    this.password,
    this.passwordConfirmation,
    this.mobileno,
    this.captcha,
    this.countrycode,
    this.country_shortname,
    this.login_type,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      password: json['password'],
      passwordConfirmation: json['password_confirmation'],
      mobileno: json['mobileno'],
    );
  }
}