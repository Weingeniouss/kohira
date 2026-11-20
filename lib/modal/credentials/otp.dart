import 'dart:convert';

/// status : false
/// message : "Invalid or expired OTP"

VerifyOtpModel verifyOtpModelFromJson(String str) =>
    VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  VerifyOtpModel({
    bool? status,
    bool? success,
    String? message,
    dynamic data,
  }) {
    _status = status;
    _success = success;
    _message = message;
    _data = data;
  }

  VerifyOtpModel.fromJson(dynamic json) {
    _status = json['status'];
    _success = json['success'];
    _message = json['message'];
    _data = json['data'];
  }

  bool? _status;
  bool? _success;
  String? _message;
  dynamic _data;

  VerifyOtpModel copyWith({
    bool? status,
    bool? success,
    String? message,
    dynamic data,
  }) =>
      VerifyOtpModel(
        status: status ?? _status,
        success: success ?? _success,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status ?? _success;

  bool? get success => _success ?? _status;

  String? get message => _message;

  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['success'] = _success;
    map['message'] = _message;
    map['data'] = _data;
    return map;
  }
}
