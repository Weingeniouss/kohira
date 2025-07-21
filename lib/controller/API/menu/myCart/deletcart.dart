// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/API_headers.dart';
import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/appconstants.dart';
import '../../../../view/utils/widget/pop.dart';

class Deletcart extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future deletcartcall({required String id, required String jewelryid, String? diamondid}) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.deletcart);
      final body = {
        'id' : id,
        'jewelryid': jewelryid,
        'diamondid': diamondid,
      }..removeWhere((key,value) => value == null);

      print('Sending request to: $url');
      print('Deletcart sendingbody :- $body');

      final responses = await http.post(url,body: body, headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans});

      if (responses.statusCode == 200 || responses.statusCode == 201) {
        data.value = jsonDecode(responses.body);
        log('Deletcart data :- $data');
        ToastificationSuccess.Success(data['message']);
      } else {
        throw {
          'Deletcart data Error This :- ${responses.statusCode}, ${responses.body}',
          print('Deletcart data this :- ${responses.statusCode}, ${responses.body}'),
          ToastificationError.Error("CountCart data this :- ${responses.statusCode}, ${responses.body}"),
        };
      }
    } catch (e) {
      print("Deletcart data Error This :- $e");
      ToastificationError.Error("Deletcart data Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}