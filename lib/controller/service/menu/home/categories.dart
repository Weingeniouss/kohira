// ignore_for_file: avoid_print, non_constant_identifier_names


import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../modal/menu/home/categories.dart';

class CategoriesModal {
  final url = Uri.parse(AppUrl.categories);

  Future<Categories?> categories_Service() async {
    try {
      final responce = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final categories = categoriesFromJson(responce.body);
        print('categories Data :- $categories');
        return categories;
      } else {
        throw {
          'categories Data Error : - ${responce.statusCode}, ${responce.body}'
        };
      }
    } catch (e) {
      print('categories Data Error :- $e');
    }
    return null;
  }
}
