// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import '../../../../view/utils/errorcode.dart';

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
      final url = Uri.parse(AppUrl.profileDetail);
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
      final responce = await http.post(
        url,
        body: body,
        headers: {
          ApiHeaders.heading: ApiHeaders.multipart,
          ApiHeaders.authorization: tokans,
        },
      );
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        data.value = jsonDecode(responce.body);
        print("Profile Detail : $data");
      } else {
        throw {
          'Profile Detail this Error :- ${responce.statusCode}, ${responce.body}',
          print('CountCart data this :- ${responce.statusCode}, ${responce.body}'),
          // ToastificationError.Error(data['message']),
          // handleHttpError(responce.statusCode),
        };
      }
    } catch (e) {
      print("Profile Detail this Error :- $e");
      // ToastificationError.Error('$e');
    } finally {
      isLoading.value = false;
    }
  }
}
