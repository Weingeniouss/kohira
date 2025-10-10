// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';

class Clarity extends GetxController {
  var isLoading = false.obs;
  var clarity_data = {}.obs;

  Future<void> clarity() async {
    try {
      isLoading(true);
      final url = Uri.parse(AppUrl.clarity);
      print('Sending To Url :- $url');
      final response = await http.post(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (response.statusCode == 200 || response.statusCode == 201) {
        clarity_data(jsonDecode(response.body));
        log('Sending to clarity Data :- $clarity_data');
      } else {
        throw Exception('${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Sending to clarity Data Error :- $e');
    } finally {
      isLoading(false);
    }
  }
}