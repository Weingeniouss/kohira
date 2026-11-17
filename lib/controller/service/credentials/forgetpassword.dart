// ignore_for_file: avoid_print

import 'package:kohira/modal/credentials/forgetpassword.dart';
import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class ForgetpasswordService {
  Future<Forgetpassword?> forgetpassworduser({String? email}) async {
    final url = AppUrl.forgetpassword;
    print("Sending request to: $url");

    try {
      final response = await ApiCall.postRequest(url,
          data: {'email': email}, useAuth: false);

      if (response != null) {
        final forgetpassword = forgetpasswordFromJson(jsonEncode(response));
        print('forgetpassword success: ${forgetpassword.message}');
        return forgetpassword;
      } else {
        print('forgetpassword failed with status: ${200}');
        print('Response body: ${response}');
        return null;
      }
    } catch (e) {
      print('forgetpassword error: $e');
      return null;
    }
  }
}
