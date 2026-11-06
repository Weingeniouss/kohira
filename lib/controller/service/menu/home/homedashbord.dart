// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../modal/menu/home/dashboard.dart';

class HomeDashboardService {
  final url = AppUrl.homeDashbord;

  Future<HomeDashboardModel?> fetchHomeDashboard() async {
    try {
      print("Sending request to: $url");
      final response = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.contect: ApiHeaders.peramitters,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dashboard = homeDashboardModelFromJson(response.data.toString());
        print('Home Dashboard Data fetched successfully');
        return dashboard;
      } else {
        print('Home Dashboard Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('Home Dashboard Error: $e');
    }
    return null;
  }
}
