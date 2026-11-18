// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';

import 'package:kohira/view/utils/errorcode.dart';
import 'package:kohira/api/api_call.dart';

class Processpayment extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> processpayment({
    String? firstname,
    String? lastname,
    String? email,
    String? companyname,
    String? address,
    String? city,
    String? state,
    String? state_name,
    String? country,
    String? countrycode,
    String? zip,
    String? mobileno,
    String? samebilling,
    String? Payment_method,
    String? coupon_id,
    String? coupon_amount,
    String? grossamt,
    String? discountamt,
    String? totalamount,
    String? netamount,
    String? iswallet,
    String? walletAmount,
    String? remainingAmount,
    String? globaltaxper,
    String? globaltaxcharge,
    String? amount,
    String? merchant_id,
    String? BankId,
    String? TerminalId,
    String? Version,
    String? Currency,
    String? user_id,
    String? paymenttype,
  }) async {
    try {
      isLoading.value = true;
      final url = AppUrl.payment;
      final body = {
        if (firstname != null) 'firstname': firstname,
        if (lastname != null) 'lastname': lastname,
        if (email != null) 'email': email,
        if (companyname != null) 'companyname': companyname,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (state_name != null) 'state_name': state_name,
        if (country != null) 'country': country,
        if (countrycode != null) 'countrycode': countrycode,
        if (zip != null) 'zip': zip,
        if (mobileno != null) 'mobileno': mobileno,
        if (samebilling != null) 'samebilling': samebilling,
        if (coupon_id != null) 'coupon_id': coupon_id,
        if (coupon_amount != null) 'coupon_amount': coupon_amount,
        if (grossamt != null) 'grossamt': grossamt,
        if (discountamt != null) 'discountamt': discountamt,
        if (totalamount != null) 'totalamount': totalamount,
        if (totalamount != null) 'netamount': netamount,
        if (netamount != null) 'iswallet': iswallet,
        if (walletAmount != null) 'walletAmount': walletAmount,
        if (remainingAmount != null) 'remainingAmount': remainingAmount,
        if (globaltaxper != null) 'globaltaxper': globaltaxper,
        if (globaltaxper != null) 'globaltaxcharge': globaltaxcharge,
        if (amount != null) 'amount': amount,
        if (merchant_id != null) 'merchant_id': merchant_id,
        if (BankId != null) 'BankId': BankId,
        if (TerminalId != null) 'TerminalId': TerminalId,
        if (Version != null) 'Version': Version,
        if (Currency != null) 'Currency': Currency,
        if (user_id != null) 'user_id': user_id,
        if (paymenttype != null) 'paymenttype': paymenttype,
      }..removeWhere((key, value) => value == null);
      final response =
          await ApiCall.postRequest(url, data: body, useAuth: true);
      print('Sending request to: $url');
      print('Paymant body :- $body');
      print('Paymant tokans :- $tokans');
      if (response != null) {
        data.value = jsonDecode(jsonEncode(response));
        log("Paymant Data :- ${data.value}");
      } else {
        throw {
          'Paymant Error :-  $response, ${200}',
          handleHttpError(200),
        };
      }
    } catch (e) {
      log('This Error of Paymanet Proress :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
