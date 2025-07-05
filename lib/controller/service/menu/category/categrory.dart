// ignore_for_file: avoid_print

import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../modal/menu/category/category.dart';
import 'package:http/http.dart' as http;

class CategroryModal {
  final url = Uri.parse(AppUrl.category);

  Future<Category?> categroryservice() async {
    try {
      final responce = await http.post(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        final categrory = categoryFromJson(responce.body);
        print('categrory data :- $categrory');
        return categrory;
      } else {
        throw {
          'categrory Data Error : - ${responce.statusCode}, ${responce.body}'
        };
      }
    } catch (e) {
      print('categrory Data Error :- $e');
    }
    return null;
  }
}
