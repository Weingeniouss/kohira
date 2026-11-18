// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:kohira/view/utils/app_url.dart';

import '../../../modal/credentials/login.dart';
import 'package:kohira/api/api_call.dart';

class LoginService {
  Future<Login?> loginUser(String email, String password) async {
    final url = AppUrl.login;
    print("Sending request to: $url");

    try {
      final response = await ApiCall.postRequest(url,
          data: jsonEncode({'email': email, 'password': password}),
          useAuth: false);

      if (response != null) {
        final login = loginFromJson(jsonEncode(response));
        print('Login success:- ${login.toJson()}');
        print('Login success: ${login.message}');
        return login;
      } else {
        print('Login failed with status: ${200}');
        print('Response body: $response');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
