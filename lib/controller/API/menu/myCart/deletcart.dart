// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../view/utils/API_headers.dart';
import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/app_constants.dart';
import '../../../../view/utils/widget/pop.dart';

class Deletcart extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future deletcartcall({
    required String id,
    required String jewelryid,
    String? diamondid,
  }) async {
    try {
      isLoading.value = true;

      final url = AppUrl.deletcart;
      final body = {
        'id': id,
        'jewelryid': jewelryid,
        'diamondid': diamondid,
      }..removeWhere((key, value) => value == null);

      print('Sending request to: $url');
      print('Deletcart sendingbody :- $body');

      final responses = await DioClient.dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans,
          },
        ),
      );

      if (responses.statusCode == 200 || responses.statusCode == 201) {
        data.value = jsonDecode(responses.data.toString());
        log('Deletcart data :- $data');
      } else {
        throw {
          'Deletcart data Error This :- ${responses.statusCode}, ${responses.data}',
          print('Deletcart data this :- ${responses.statusCode}, ${responses.data}'),
          ToastificationError.Error("CountCart data this :- ${responses.statusCode}, ${responses.data}"),
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
