// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../modal/menu/category/category.dart';

class CategroryModal {
  final url = AppUrl.category;

  Future<Category?> categroryservice() async {
    print("Sending request to: $url");
    try {
      final responce = await DioClient.dio.post(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final categrory = categoryFromJson(responce.data.toString());
        print('categrory data :- $categrory');
        return categrory;
      } else {
        throw {
          'categrory Data Error : - ${responce.statusCode}, ${responce.data}'
        };
      }
    } catch (e) {
      print('categrory Data Error :- $e');
    }
    return null;
  }
}
