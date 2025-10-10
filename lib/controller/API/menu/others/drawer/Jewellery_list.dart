
// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;

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
      final url = Uri.parse(AppUrl.jewellery_filter);
      final response = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
        log('Jewellery List :- $data');

        // Convert metal types from JSON to MetalType objects
        final List<dynamic> metalTypesData = data['data']['Metal_Type'] ?? [];
        metalTypes.value = metalTypesData.map((item) => MetalType.fromJson(Map<String, dynamic>.from(item))).toList();

        // Convert metal Stamp from JSON to MetalType objects
        final List<dynamic> metalTypesStamp = data['data']['Metal_Stamp'] ?? [];
        metalStamp.value = metalTypesStamp.map((item) => MetalStamp.fromJson(Map<String,dynamic>.from(item))).toList();


      } else {
        throw Exception('Error Jewellery List: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('Error Jewellery List: $e');
    } finally {
      isLoading.value = false;
    }
  }
}