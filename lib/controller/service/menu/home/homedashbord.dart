// ignore_for_file: avoid_print

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/dashboard.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class HomeDashboardService {
  final url = AppUrl.homeDashbord;

  Future<HomeDashboardModel?> fetchHomeDashboard() async {
    try {
      print("Sending request to: $url");
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        final dashboard = homeDashboardModelFromJson(jsonEncode(response));
        print('Home Dashboard Data fetched successfully');
        return dashboard;
      } else {
        print('Home Dashboard Error status: ${200}');
      }
    } catch (e) {
      print('Home Dashboard Error: $e');
    }
    return null;
  }
}
