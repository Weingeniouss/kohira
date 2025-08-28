
// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/errorcode.dart';
import 'package:url_launcher/url_launcher.dart';

class Processpayment extends GetxController{
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
    String? country_name,
    String? zip,
    String? mobileno,
    String? samebilling,
    String? billing_firstname,
    String? billing_lastname,
    String? billing_email,
    String? billing_companyname,
    String? billing_address,
    String? billing_city,
    String? billing_state,
    String? billing_zip,
    String? billing_mobileno,
    String? ip_address,
    String? Payment_method,
    String? nonce,
    String? device_data,
    String? CardExpireDate,
    String? CardNo,
    String? braintree_customer_id,
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
    String? Amount,
    String? MerchantId,
    String? BankId,
    String? TerminalId,
    String? Version,
    String? Currency,
    String? user_id,
    String? order_item,
    String? password,
})async{
    try{
      isLoading.value = true;
      final url =  Uri.parse(AppUrl.payment);
      final body = {
        'firstname' : firstname,
        'lastname' : lastname,
        'email' : email,
        'companyname' : companyname,
        'address' : address,
        'city' : city,
        'state' : state,
        'state_name' : state_name,
        'country' : country,
        'country_name' : country_name,
        'countrycode' : countrycode,
        'zip' : zip,
        'mobileno' : mobileno,
        'samebilling' : samebilling,
        'billing_firstname' : billing_firstname,
        'billing_lastname' : billing_lastname,
        'billing_email' : billing_email,
        'billing_companyname' : billing_companyname,
        'billing_address' : billing_address,
        'billing_city' : billing_city,
        'billing_state' : billing_state,
        'billing_zip' : billing_zip,
        'billing_mobileno' : billing_mobileno,
        'ip_address' : ip_address,
        'Payment_method' : Payment_method,
        'nonce' : nonce,
        'device_data' : device_data,
        'CardExpireDate' : CardExpireDate,
        'CardNo' : CardNo,
        'braintree_customer_id' : braintree_customer_id,
        'coupon_id' : coupon_id,
        'coupon_amount' : coupon_amount,
        'grossamt' : grossamt,
        'discountamt' : discountamt,
        'totalamount' : totalamount,
        'netamount' : netamount,
        'iswallet' : iswallet,
        'walletAmount' : walletAmount,
        'remainingAmount' : remainingAmount,
        'globaltaxper' : globaltaxper,
        'globaltaxcharge' : globaltaxcharge,
        'Amount' : Amount,
        'MerchantId' : MerchantId,
        'BankId' : BankId,
        'TerminalId' : TerminalId,
        'Version' : Version,
        'Currency' : Currency,
        'user_id' : user_id,
        'order_item' : order_item,
        'password' : password,
      }..removeWhere((key,value) => value == null);
      final response = await http.post(url,body: jsonEncode(body),headers: {ApiHeaders.heading : ApiHeaders.peramitters, ApiHeaders.authorization : tokans});
      print('Sending request to: $url');
      print('Paymant body :- $body');
      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
        log("Paymant Data :- ${data.value}");
      } else if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        print("Redirect to: $redirectUrl");
        if (redirectUrl != null) {
          await launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.inAppWebView);
        }
      } else {
        throw {
          'Paymant Error :-  ${response.body}, ${response.statusCode}',
          handleHttpError(response.statusCode),
        };
      }
    }catch(e){
      print('This Error of Paymanet Proress :- $e');
    }finally{
      isLoading.value = false;
    }
  }
}