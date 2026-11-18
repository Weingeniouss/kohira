// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';

class MetalType {
  final int id;
  final String name;
  final String? slug;

  MetalType({required this.id, required this.name, this.slug});

  factory MetalType.fromJson(Map<String, dynamic> json) {
    return MetalType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
    );
  }
}

class MetalStamp {
  final int id;
  final String name;
  final String? slug;

  MetalStamp({required this.id, required this.name, this.slug});

  factory MetalStamp.fromJson(Map<String, dynamic> json) {
    return MetalStamp(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
    );
  }
}

class JewelleryList extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;
  var metalTypes = <MetalType>[].obs;
  var metalStamp = <MetalStamp>[].obs;

  Future<void> jewellerylist() async {
    try {
      isLoading.value = true;
      final url = AppUrl.jewellery_filter;
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        data.value = jsonDecode(jsonEncode(response));
        log('Jewellery List :- $data');

        final List<dynamic> metalTypesData = data['data']['Metal_Type'] ?? [];
        metalTypes.value = metalTypesData
            .map((item) => MetalType.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        final List<dynamic> metalTypesStamp = data['data']['Metal_Stamp'] ?? [];
        metalStamp.value = metalTypesStamp
            .map((item) => MetalStamp.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        throw Exception('Error Jewellery List: ${200}, $response');
      }
    } catch (e) {
      log('Error Jewellery List: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
