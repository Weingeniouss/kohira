// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';

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
      final responce = await DioClient.dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.multipart,
            ApiHeaders.authorization: tokans,
          },
        ),
      );
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        data.value = jsonDecode(responce.data.toString());
        print("Profile Detail : $data");
      } else {
        throw {
          'Profile Detail this Error :- ${responce.statusCode}, ${responce.data}',
          print('CountCart data this :- ${responce.statusCode}, ${responce.data}'),
        };
      }
    } catch (e) {
      print("Profile Detail this Error :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
