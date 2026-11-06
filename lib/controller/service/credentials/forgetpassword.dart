// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/modal/credentials/forgetpassword.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';

class ForgetpasswordService {
  Future<Forgetpassword?> forgetpassworduser({String? email}) async {
    final url = AppUrl.forgetpassword;
    print("Sending request to: $url");

    try {
      final response = await DioClient.dio.post(
        url,
        data: {'email': email},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final forgetpassword = forgetpasswordFromJson(response.data.toString());
        print('forgetpassword success: ${forgetpassword.message}');
        return forgetpassword;
      } else {
        print('forgetpassword failed with status: ${response.statusCode}');
        print('Response body: ${response.data}');
        return null;
      }
    } catch (e) {
      print('forgetpassword error: $e');
      return null;
    }
  }
}
