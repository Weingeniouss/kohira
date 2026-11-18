import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_encryption.dart';
import 'package:kohira/view/utils/dio_client.dart';

class ApiService {
  static Future<Map<String, dynamic>> getApi(String url,
      {Map<String, dynamic>? queryParameters, bool useAuth = true}) async {
    return _request('GET', url,
        queryParameters: queryParameters, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> postApi(String url,
      {dynamic data, bool useAuth = true}) async {
    return _request('POST', url, data: data, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> putApi(String url,
      {dynamic data, bool useAuth = true}) async {
    return _request('PUT', url, data: data, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> deleteApi(String url,
      {dynamic data, bool useAuth = true}) async {
    return _request('DELETE', url, data: data, useAuth: useAuth);
  }

  static Future<Map<String, dynamic>> _request(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool useAuth = true,
  }) async {
    try {
      final headers = {
        ApiHeaders.heading: ApiHeaders.peramitters,
      };

      if (useAuth && tokans.isNotEmpty) {
        headers[ApiHeaders.authorization] = tokans;
      }

      final options = Options(
        method: method,
        headers: headers,
      );

      final response = await DioClient.dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData;
        if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data);
        } else if (response.data is String) {
          responseData = jsonDecode(response.data);
        } else {
          responseData = jsonDecode(jsonEncode(response.data));
        }

        // Auto-decrypt encrypted payload if present
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          final dataMap = responseData['data'] as Map;
          if (dataMap.containsKey('payload')) {
            final decrypted = AppEncryption.decryptResponse(
              dataMap['payload']?.toString(),
              dataMap['signature']?.toString(),
            );
            if (decrypted != null) {
              if (decrypted is Map) {
                responseData['data'] = Map<String, dynamic>.from(decrypted);
              } else if (decrypted is String) {
                try {
                  responseData['data'] = jsonDecode(decrypted);
                } catch (_) {
                  responseData['data'] = decrypted;
                }
              } else if (decrypted is List) {
                responseData['data'] = {'items': decrypted};
              }
            }
          }
        } else if (responseData.containsKey('payload')) {
          final decrypted = AppEncryption.decryptResponse(
            responseData['payload']?.toString(),
            responseData['signature']?.toString(),
          );
          if (decrypted != null) {
            if (decrypted is Map) {
              responseData = Map<String, dynamic>.from(decrypted);
            } else if (decrypted is String) {
              try {
                responseData = jsonDecode(decrypted);
              } catch (_) {}
            }
          }
        }

        return responseData;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      log('DioException in ApiService [$method $url]: $e');
      throw Exception('Failed to connect: ${e.message}');
    } catch (e) {
      log('Exception in ApiService [$method $url]: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
