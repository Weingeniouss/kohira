// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../modal/menu/home/news_list.dart';

class NewsListService {
  final url = AppUrl.homenewslist;

  Future<NewsListModel?> fetchNewsList() async {
    try {
      print("Sending POST request to: $url");
      final body = {
        'page_no': '1',
        'per_page': '12',
      };
      final response = await DioClient.dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.contect: ApiHeaders.peramitters,
          },
        ),
      );

      print("News List Response Status: ${response.statusCode}");
      print("News List Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newsListModel = newsListModelFromJson(response.data.toString());
        print('News List Data fetched successfully');
        return newsListModel;
      } else {
        print('News List Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('News List Error: $e');
    }
    return null;
  }
}
