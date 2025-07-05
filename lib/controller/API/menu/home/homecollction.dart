// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/widget/pop.dart';

class Homecollction extends GetxController {
  var isLoading = false.obs;
  var data = <String, dynamic>{}.obs;

  Future<void> homecollction({String? section_no}) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.homecollcation);
      final body = {'section_no': section_no};
      final response = await http.post(url, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        data[section_no.toString()] = decoded;
        // ToastificationSuccess.Success('homecollction data add Successfully');
        log("homecollction data :- $data");
      } else {
        throw {
          'homecollction data Error :- ${response.body}, ${response.statusCode}',
          ToastificationError.Error('homecollction data Error :- ${response.statusCode}'),
        };
      }
    } catch (e) {
      print('homecollction data Error :-  $e');
      ToastificationError.Error('homecollction data Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
