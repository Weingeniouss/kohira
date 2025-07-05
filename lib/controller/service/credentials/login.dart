// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_url.dart';

import '../../../modal/credentials/login.dart';

class LoginService {
  Future<Login?> loginUser(String email, String password) async {
    final url = Uri.parse(AppUrl.login);
    print("Sending request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final login = loginFromJson(response.body);
        print('Login success:- ${login.toJson()}');
        print('Login success: ${login.message}');
        return login;
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
