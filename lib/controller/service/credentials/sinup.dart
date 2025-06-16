// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../modal/credentials/sinup.dart';
import '../../../view/utils/app_url.dart';

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
      final response = await http.post(
        Uri.parse(AppUrl.sinup),
        body: {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'mobileno': mobileno,
          'captcha': captcha,
          'countrycode': countrycode,
          'country_shortname': country_shortname,
          'login_type':login_type,
        },
      );
      print(AppUrl.sinup);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Sinup.fromJson(jsonData);
      } else {
        print('Signup failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Signup Exception: $e');
    }
    return null;
  }
}