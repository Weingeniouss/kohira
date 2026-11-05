// ignore_for_file: invalid_use_of_protected_member, avoid_print, non_constant_identifier_names, equal_keys_in_map

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import 'package:kohira/view/utils/widget/pop.dart';

class SubmitCustomJewelley extends GetxController {
  var isLoading = false.obs;
  var customData = {}.obs;

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
    final String? captcha,
  }) async {
    final apiUrl = AppUrl.addcustom;
    print('📤 Sending To Url :- $apiUrl');

    try {
      isLoading(true);

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

      final Map<String, dynamic> formMap = {
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
        'captcha': captcha,
        'sideStone': jsonEncode(sideStoneData),
      }..removeWhere((key, value) => value == null);

      if (image != null) {
        formMap['image'] = await dio_pkg.MultipartFile.fromFile(image.path);
      }
      if (video != null) {
        formMap['video'] = await dio_pkg.MultipartFile.fromFile(video.path);
      }

      final formData = dio_pkg.FormData.fromMap(formMap);

      print('🚀 Uploading request with Dio...');
      final response = await DioClient.dio.post(
        apiUrl,
        data: formData,
        options: dio_pkg.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token ?? ""}',
            ApiHeaders.heading: ApiHeaders.peramitters,
          },
        ),
      );

      print('📩 Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        customData.value = jsonDecode(response.data.toString());
        print('✅ Custom Jewellery Response :- $customData');
        ToastificationSuccess.Success(customData.value['message']);
      } else {
        throw Exception('${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      print('❌ Error sending custom jewellery request :- $e');
    } finally {
      isLoading(false);
    }
  }
}
