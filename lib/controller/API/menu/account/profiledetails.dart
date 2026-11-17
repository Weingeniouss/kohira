// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';

import 'package:kohira/api/api_call.dart';

class ProfiledetailsController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> profiledetailscall({
    String? firstname,
    String? lastname,
    String? email,
    String? mobileno,
    String? change_password,
    String? old_password,
    String? password,
    String? confirm_password,
  }) async {
    try {
      isLoading.value = true;
      final url = AppUrl.profileDetail;
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
      print('Sending request profiledetail :- $body');
      final responce =
          await ApiCall.postRequest(url, data: body, useAuth: true);
      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
        print("Profile Detail : $data");
      } else {
        throw {
          'Profile Detail this Error :- ${200}, ${responce}',
          print('CountCart data this :- ${200}, ${responce}'),
        };
      }
    } catch (e) {
      print("Profile Detail this Error :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
