// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_string.dart';
import '../../../view/utils/app_encryption.dart';
import '../../../view/utils/app_url.dart';
import '../../../view/utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../database/local/localstore.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;
  var otpDataShow = {}.obs;

  RxInt minutes = 10.obs;
  RxInt seconds = 0.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else if (minutes.value > 0) {
        minutes.value--;
        seconds.value = 59;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<void> otpSubmit({
    String? firstname,
    String? lastname,
    String? mobileno,
    String? countrycode,
  }) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.otp);
      final body = {
        'firstname': firstname ?? '',
        'lastname': lastname ?? '',
        'mobileno': mobileno ?? '',
        'countrycode': countrycode ?? '',
      };
      final response = await http.post(url, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        otpDataShow.value = jsonDecode(response.body);
        log('Otp Data :- ${otpDataShow.value}');
      } else {
        throw Exception('Otp failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Otp Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class VerifyOtpController extends GetxController {
  var isLoading = false.obs;
  var verifyOtpData = {}.obs;

  Future<void> verifyOtp({
    String? mobileno,
    String? otp_code,
  }) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.verifyotp);
      final body = {
        'mobileno': mobileno ?? '',
        'otp_code': otp_code ?? '',
      };
      final response = await http.post(url, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        log('${AppString.rawResponse} :- $jsonResponse');

        if (jsonResponse['success'] == true) {
          final decryptedData = AppEncryption.decryptResponse(
            jsonResponse['data']['payload'],
            jsonResponse['data']['signature'],
          );

          if (decryptedData != null) {
            verifyOtpData.value = decryptedData;
            log('${AppString.decryptedData} :- ${verifyOtpData.value}');

            // Try to find the token in different possible locations
            String? token = verifyOtpData.value['token'] ??
                verifyOtpData.value['data']?['token'] ??
                verifyOtpData.value['access_token'];

            if (token != null) {
              localdatabase().saveToken(token);
              log(AppString.navigatingtoHome);
              Get.offAll(() => Bottom());
            } else {
              log(AppString.decryption);
            }
          } else {
            log(AppString.decryptionfailed);
          }
        }
      } else {
        throw Exception('Verify Otp failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Verify Otp Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
