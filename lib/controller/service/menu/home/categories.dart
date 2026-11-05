// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../modal/menu/home/categories.dart';

class CategoriesModal {
  final url = AppUrl.categories;

  Future<Categories?> categories_Service() async {
    print("Sending request to: $url");
    try {
      final responce = await DioClient.dio.get(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final categories = categoriesFromJson(responce.data.toString());
        print('categories Data :- $categories');
        return categories;
      } else {
        throw {
          'categories Data Error : - ${responce.statusCode}, ${responce.data}'
        };
      }
    } catch (e) {
      print('categories Data Error :- $e');
    }
    return null;
  }
}
