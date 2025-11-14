// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/overstore/overstoredetails.dart';

class OverstoredetailsController extends GetxController {
  final String slug;
   OverstoredetailsController({required this.slug});

  final overstoredetails = Get.put(OverStoreDetails());
  final String siteKey = "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF";
  final String baseUrl = "https://next.weingenious.in";

  TextEditingController dateController = TextEditingController();
  TextEditingController enterfullname = TextEditingController();
  TextEditingController emailaddress = TextEditingController();
  TextEditingController talkabout = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  var isCheck = false.obs;
  DateTime? selectedDate;
  var tokanRecaptcha = '';

  static const platform = MethodChannel('com.example.recaptcha');
  String _verificationStatus = 'Not Verified';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => overstoredetails.getOverStoreDetails(slug));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void isCheckValue(bool? val) async {
    if (val == true) {
      bool verified = await _verifyRecaptcha();
      isCheck.value = verified;
    } else {
      isCheck.value = false;
    }
  }

  Future<bool> _verifyRecaptcha() async {
    try {
      final String token = await platform.invokeMethod('verifyRecaptcha');
      _verificationStatus = 'Verified! Token: ${token.substring(0, 20)}...';
      tokanRecaptcha = token;
      print('Full reCAPTCHA Token: $token');
      return true;
    } on PlatformException catch (e) {
      _verificationStatus = 'Failed: ${e.message}';
      print('Recaptcha failed: ${e.message}');
      return false;
    } catch (e) {
      _verificationStatus = 'Error: $e';
      print('Unexpected error: $e');
      return false;
    }
  }
}