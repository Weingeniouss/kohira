// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';

class ClarityItem {
  final String? slug;
  final String? name;

  ClarityItem({this.slug, this.name});

  factory ClarityItem.fromJson(Map<String, dynamic> json) {
    return ClarityItem(
      slug: json['slug'],
      name: json['name'],
    );
  }
}

class ColorItem {
  final String? slug;
  final String? name;

  ColorItem({this.slug, this.name});

  factory ColorItem.fromJson(Map<String, dynamic> json) {
    return ColorItem(
      slug: json['slug'],
      name: json['name'],
    );
  }
}

class Clarity extends GetxController {
  var isLoading = false.obs;
  var clarity_data = {}.obs;
  var clarityData = <ClarityItem>[].obs;

  Future<void> clarity() async {
    try {
      isLoading(true);
      final url = AppUrl.clarity;
      print('Sending To Url :- $url');
      final response = await ApiCall.postRequest(url, useAuth: false);

      if (response != null) {
        final responseData = jsonDecode(jsonEncode(response));
        clarity_data(responseData);
        final List<dynamic> dataList = responseData['data'] ?? [];

        clarityData.value =
            dataList.map((item) => ClarityItem.fromJson(item)).toList();
        log('Sending to clarity Data :- $clarity_data');
      } else {
        throw Exception('${200}, ${response}');
      }
    } catch (e) {
      print('Sending to clarity Data Error :- $e');
    } finally {
      isLoading(false);
    }
  }
}
