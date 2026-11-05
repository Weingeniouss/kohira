// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';

class Homecollction extends GetxController {
  var isLoading = false.obs;
  var data = <String, dynamic>{}.obs;

  Future<void> homecollction({String? section_no}) async {
    try {
      isLoading.value = true;

      final url = AppUrl.homecollcation;
      final body = {'section_no': section_no};
      final response = await DioClient.dio.post(url, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.data.toString());
        data[section_no.toString()] = decoded;
        log("homecollction data :- $data");
      } else {
        throw {
          'homecollction data Error :- ${response.data}, ${response.statusCode}',
          print('homecollction data Error :- ${response.statusCode}'),
        };
      }
    } catch (e) {
      print('homecollction data Error :-  $e');
    } finally {
      isLoading.value = false;
    }
  }
}
