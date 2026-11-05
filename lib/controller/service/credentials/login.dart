// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../modal/credentials/login.dart';

class LoginService {
  Future<Login?> loginUser(String email, String password) async {
    final url = AppUrl.login;
    print("Sending request to: $url");

    try {
      final response = await DioClient.dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final login = loginFromJson(response.data.toString());
        print('Login success:- ${login.toJson()}');
        print('Login success: ${login.message}');
        return login;
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
