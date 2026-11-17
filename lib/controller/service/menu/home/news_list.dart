// ignore_for_file: avoid_print

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/news_list.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class NewsListService {
  final url = AppUrl.homenewslist;

  Future<NewsListModel?> fetchNewsList() async {
    try {
      print("Sending POST request to: $url");
      final body = {
        'page_no': '1',
        'per_page': '12',
      };
      final response =
          await ApiCall.postRequest(url, data: body, useAuth: false);

      print("News List Response Status: ${200}");
      print("News List Response Body: ${response}");

      if (response != null) {
        final newsListModel = newsListModelFromJson(jsonEncode(response));
        print('News List Data fetched successfully');
        return newsListModel;
      } else {
        print('News List Error status: ${200}');
      }
    } catch (e) {
      print('News List Error: $e');
    }
    return null;
  }
}
