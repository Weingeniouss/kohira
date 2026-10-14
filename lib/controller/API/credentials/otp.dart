// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/modal/credentials/otp.dart';
import 'package:kohira/view/utils/app_string.dart';
import '../../../view/utils/app_encryption.dart';
import '../../../view/utils/app_url.dart';
import '../../../view/utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../../view/utils/widget/pop.dart';
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
      print('Sending To url :- $url');
      log('Sending To url :- $url');
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
        final model = VerifyOtpModel.fromJson(otpDataShow.value);
        if (model.status == false && model.message != null) {
          ToastificationError.Error(model.message!);
        }
      } else {
        throw Exception('Otp failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Otp Error: $e');
      ToastificationError.Error('Otp Error: $e');
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
      print('Sending To url :- $url');
      log('Sending To url :- $url');
      final body = {
        'mobileno': mobileno ?? '',
        'otp_code': otp_code ?? '',
      };
      final response = await http.post(url, body: body);
      final jsonResponse = jsonDecode(response.body);
      log('${AppString.rawResponse} :- $jsonResponse');

      final otpModel = VerifyOtpModel.fromJson(jsonResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (otpModel.status == true || otpModel.success == true) {
          final dataObj = jsonResponse['data'];
          if (dataObj != null && dataObj is Map && dataObj.containsKey('payload')) {
            final decryptedData = AppEncryption.decryptResponse(
              dataObj['payload'],
              dataObj['signature'],
            );

            if (decryptedData != null) {
              verifyOtpData.value = decryptedData;
              log('${AppString.decryptedData} :- ${verifyOtpData.value}');

              String? token = verifyOtpData.value['token'] ??
                  verifyOtpData.value['data']?['token'] ??
                  verifyOtpData.value['access_token'];

              if (token != null) {
                localdatabase().saveToken(token);
                log(AppString.navigatingtoHome);
                if (otpModel.message != null && otpModel.message!.isNotEmpty) {
                  ToastificationSuccess.Success(otpModel.message!);
                }
                Get.offAll(() => Bottom());
              } else {
                log(AppString.decryption);
              }
            } else {
              log(AppString.decryptionfailed);
            }
          } else if (dataObj != null && dataObj is Map && dataObj['token'] != null) {
            String token = dataObj['token'];
            localdatabase().saveToken(token);
            if (otpModel.message != null && otpModel.message!.isNotEmpty) {
              ToastificationSuccess.Success(otpModel.message!);
            }
            Get.offAll(() => Bottom());
          } else {
            ToastificationSuccess.Success(otpModel.message ?? "Verified");
            Get.offAll(() => Bottom());
          }
        } else {
          // Status / success is false (e.g. "Invalid or expired OTP")
          ToastificationError.Error(otpModel.message ?? "Invalid or expired OTP");
        }
      } else {
        ToastificationError.Error(otpModel.message ?? "Verify Otp failed: ${response.statusCode}");
      }
    } catch (e) {
      print('Verify Otp Error: $e');
      ToastificationError.Error("Invalid or expired OTP");
    } finally {
      isLoading.value = false;
    }
  }
}

