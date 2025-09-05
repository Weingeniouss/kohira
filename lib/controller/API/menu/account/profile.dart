// ignore_for_file: avoid_print, non_constant_identifier_names, invalid_use_of_protected_member

import 'dart:convert';

import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_constants.dart';

class ProfileEdit extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<Map<String, dynamic>> profileedit({
    String? firstname,
    String? lastname,
    String? email,
    String? mobileno,
    required String change_password,
    String? old_password,
    String? password,
    String? confirm_password,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.profile);
      print('Sending request to: $url');

      final body = {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'mobileno': mobileno,
        'change_password': change_password,
        'old_password': old_password,
        'password': password,
        'confirm_password': confirm_password,
      }..removeWhere((key, value) => value == null);

      print('Sending request to Profile Edit:- $body');

      final response = await http.post( url,body: body, headers: {ApiHeaders.heading: ApiHeaders.peramitters,ApiHeaders.authorization: tokans});

      final responseData = jsonDecode(response.body);
      print('Profile Edit Raw Response: $responseData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = responseData;
        return responseData;
      } else {
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          print('Validation Errors:');
          errors.forEach((key, value) {
            print('$key => ${value[0]}');
          });
        } else {
          print('Error message: ${responseData['message']}');
        }

        return {
          'success': false,
          'message': responseData['message'] ?? 'Something went wrong',
          'errors': responseData['errors'] ?? {},
        };
      }
    } catch (e) {
      print('Profile Edit Exception :- $e');
      return {
        'success': false,
        'message': 'Exception occurred',
        'errors': {},
      };
    } finally {
      isLoading.value = false;
    }
  }
}
