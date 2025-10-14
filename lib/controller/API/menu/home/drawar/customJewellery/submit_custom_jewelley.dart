// ignore_for_file: avoid_print, non_constant_identifier_names, equal_keys_in_map

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;

class SubmitCustomJewelley extends GetxController{
  var isLoading = false.obs;
  var customData = false.obs;

  Future<void> submitCustomJewelley({
    final String? jewelrytype,
    final String? subcategory_id,
    final String? userid,
    final String? metaltype,
    final String? metalstamp,
    final String? appxmetalWgt,
    final String? ringsize,
    final String? engraving,
    final String? referredby,
    final String? budget,
    final String? remark,
    final String? firstname,
    final String? lastname,
    final String? email,
    final String? password,
    final String? confirm_password,
    final String? mobileno,
    final String? centerStoneSelect,
    final String? selectedDiamShape,
    final String? selectedDiamColor,
    final String? selectedDiamClarity,
    final String? selectedDiamCarat,
    final String? diamMinSelectedCarat,
    final String? diamMaxSelectedCarat,
    final String? sideStoneSelect,
    final String? url,
    final File? image,
    final File? video,
    final String? currency_id,
    final List<String>? shape,
    final List<String>? color,
    final List<String>? clarity,
    final String? token,
  }) async {
    final apiUrl = Uri.parse(AppUrl.addcustom);
    print('📤 Sending To Url :- $apiUrl');

    try {
      isLoading(true);

      // ✅ Step 1: Build sideStone list dynamically
      List<Map<String, dynamic>> sideStoneData = [];
      if (shape != null && color != null) {
        for (int i = 0; i < shape.length; i++) {
          sideStoneData.add({
            "shape": shape[i],
            "color": color.length > i ? color[i] : "",
            "clarity": clarity != null && clarity.length > i ? clarity[i] : "",
          });
        }
      }

      print('💎 sideStone Data :- ${jsonEncode(sideStoneData)}');

      // ✅ Step 2: Build request body (same spelling)
      final body = {
        'jewelrytype': jewelrytype,
        'subcategory_id': subcategory_id,
        'userid': userid,
        'metaltype': metaltype,
        'metalstamp': metalstamp,
        'appxmetalWgt': appxmetalWgt,
        'ringsize': ringsize,
        'engraving': engraving,
        'referredby': referredby,
        'budget': budget,
        'remark': remark,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'confirm_password': confirm_password,
        'mobileno': mobileno,
        'centerStoneSelect': centerStoneSelect,
        'selectedDiamShape': selectedDiamShape,
        'selectedDiamColor': selectedDiamColor,
        'selectedDiamClarity': selectedDiamClarity,
        'selectedDiamCarat': selectedDiamCarat,
        'diamMinSelectedCarat': diamMinSelectedCarat,
        'diamMaxSelectedCarat': diamMaxSelectedCarat,
        'sideStoneSelect': sideStoneSelect,
        'currency_id': currency_id,
        'sideStone': jsonEncode(sideStoneData),
      }..removeWhere((key, value) => value == null);

      print('📦 Final Body (Cleaned) :- $body');

      // ✅ Step 3: Create Multipart Request
      var request = http.MultipartRequest('POST', apiUrl);
      request.fields.addAll(body.map((key, value) => MapEntry(key, value.toString())));

      // ✅ Step 4: Add Image & Video (if exist)
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      if (video != null) {
        request.files.add(await http.MultipartFile.fromPath('video', video.path));
      }

      // ✅ Step 5: Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token ?? ""}',
        ApiHeaders.heading: ApiHeaders.peramitters,
      });

      // ✅ Step 6: Send request
      print('🚀 Uploading request...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('📩 Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        customData = jsonDecode(response.body);
        print('✅ Custom Jewellery Response :- $customData');
      } else {
        throw Exception('${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending custom jewellery request :- $e');
    } finally {
      isLoading(false);
    }
  }
}