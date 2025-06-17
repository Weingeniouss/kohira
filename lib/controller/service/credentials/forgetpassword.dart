// ignore_for_file: avoid_print

import 'package:kohira/modal/credentials/forgetpassword.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_url.dart';

class ForgetpasswordService {
  Future<Forgetpassword?> forgetpassworduser({String? email}) async {
    final url = Uri.parse(AppUrl.forgetpassword);
    print("Sending request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
         final forgetpassword = forgetpasswordFromJson(response.body);
         print('forgetpassword success: ${forgetpassword.message}');
         return forgetpassword;
      } else {
         print('forgetpassword failed with status: ${response.statusCode}');
         print('Response body: ${response.body}');
         return null;
      }
    } catch (e) {
      print('forgetpassword error: $e');
      return null;
    }
  }
}
