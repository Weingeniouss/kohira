// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import '../../../modal/credentials/sinup.dart';
import '../../../view/utils/app_url.dart';
import 'package:kohira/api/api_call.dart';

class SinupService {
  Future<Sinup?> sinupUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String mobileno,
    required String captcha,
    required String countrycode,
    required String country_shortname,
    required String login_type,
  }) async {
    try {
      final response = await ApiCall.postRequest(AppUrl.sinup,
          data: {
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
            'password_confirmation': passwordConfirmation,
            'mobileno': mobileno,
            'captcha': captcha,
            'countrycode': countrycode,
            'country_shortname': country_shortname,
            'login_type': login_type,
          },
          useAuth: false);
      print(AppUrl.sinup);
      if (response != null) {
        final jsonData = json.decode(jsonEncode(response));
        return Sinup.fromJson(jsonData);
      } else {
        print('Signup failed with status: ${200}');
      }
    } catch (e) {
      print('Signup Exception: $e');
    }
    return null;
  }
}
