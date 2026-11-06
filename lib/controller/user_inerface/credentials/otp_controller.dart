// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import '../../../view/utils/app_string.dart';
import '../../../view/utils/widget/pop.dart';
import '../../API/credentials/otp.dart';

class OtpUiController extends GetxController {
  final OtpController otpApi = Get.put(OtpController());
  final VerifyOtpController verifyOtpApi = Get.put(VerifyOtpController());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final OtpFieldController otpFieldController = OtpFieldController();

  var firstnameType = false.obs;
  var lastnameType = false.obs;
  var mobileType = false.obs;

  void submitOtp() {
    firstnameType.value = firstNameController.text.trim().isEmpty;
    lastnameType.value = lastNameController.text.trim().isEmpty;
    mobileType.value = mobileController.text.trim().isEmpty;

    if (firstnameType.value || lastnameType.value || mobileType.value) {
      ToastificationError.Error("Please fill all required fields");
      return;
    }

    if (mobileController.text.trim().length < 10) {
      ToastificationError.Error("Please enter a valid mobile number");
      mobileType.value = true;
      return;
    }

    otpApi.otpSubmit(
      countrycode: AppString.defaultCountryCode,
      firstname: firstNameController.text.trim(),
      lastname: lastNameController.text.trim(),
      mobileno: mobileController.text.trim(),
    );
  }

  void verifyOtpCode() {
    if (otpController.text.trim().isEmpty) {
      ToastificationError.Error("Please enter OTP");
      return;
    }

    verifyOtpApi.verifyOtp(
      mobileno: mobileController.text.trim(),
      otp_code: otpController.text.trim(),
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
