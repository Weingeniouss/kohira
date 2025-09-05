
// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/errorcode.dart';

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
        if(firstname != null) 'firstname' : firstname,
        if(lastname != null) 'lastname' : lastname,
        if(email != null) 'email' : email,
        if(companyname != null) 'companyname' : companyname,
        if(address != null) 'address' : address,
        if(city != null) 'city' : city,
        if(state != null) 'state' : state,
        if(state_name != null) 'state_name' : state_name,
        if(country != null) 'country' : country,
        if(country_name != null) 'country_name' : country_name,
        if(countrycode != null) 'countrycode' : countrycode,
        if(zip != null) 'zip' : zip,
        if(mobileno != null) 'mobileno' : mobileno,
        if(samebilling != null) 'samebilling' : samebilling,
        if(billing_firstname != null) 'billing_firstname' : billing_firstname,
        if(billing_lastname != null) 'billing_lastname' : billing_lastname,
        if(billing_email != null) 'billing_email' : billing_email,
        if(billing_companyname != null) 'billing_companyname' : billing_companyname,
        if(billing_address != null) 'billing_address' : billing_address,
        if(billing_city != null) 'billing_city' : billing_city,
        if(billing_state != null) 'billing_state' : billing_state,
        if(billing_zip != null) 'billing_zip' : billing_zip,
        if(billing_mobileno != null) 'billing_mobileno' : billing_mobileno,
        if(ip_address != null) 'ip_address' : ip_address,
        if(Payment_method != null) 'Payment_method' : Payment_method,
        if(nonce != null) 'nonce' : nonce,
        if(device_data != null) 'device_data' : device_data,
        if(CardExpireDate != null) 'CardExpireDate' : CardExpireDate,
        if(CardNo != null) 'CardNo' : CardNo,
        if(braintree_customer_id != null) 'braintree_customer_id' : braintree_customer_id,
        if(coupon_id != null) 'coupon_id' : coupon_id,
        if(coupon_amount != null) 'coupon_amount' : coupon_amount,
        if(grossamt != null) 'grossamt' : grossamt,
        if(discountamt != null) 'discountamt' : discountamt,
        if(totalamount != null) 'totalamount' : totalamount,
        if(totalamount != null) 'netamount' : netamount,
        if(netamount != null) 'iswallet' : iswallet,
        if(walletAmount != null) 'walletAmount' : walletAmount,
        if(remainingAmount != null) 'remainingAmount' : remainingAmount,
        if(globaltaxper != null) 'globaltaxper' : globaltaxper,
        if(globaltaxper != null) 'globaltaxcharge' : globaltaxcharge,
        if(Amount != null) 'Amount' : Amount,
        if(MerchantId != null) 'MerchantId' : MerchantId,
        if(BankId != null) 'BankId' : BankId,
        if(TerminalId != null) 'TerminalId' : TerminalId,
        if(Version != null) 'Version' : Version,
        if(Currency != null) 'Currency' : Currency,
        if(user_id != null) 'user_id' : user_id,
        if(order_item != null) 'order_item' : order_item,
        if(password != null) 'password' : password,
      }..removeWhere((key,value) => value == null);
      final response = await http.post(url,body: body,headers: {ApiHeaders.heading : ApiHeaders.peramitters, ApiHeaders.authorization : tokans});
      print('Sending request to: $url');
      print('Paymant body :- $body');
      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
        log("Paymant Data :- ${data.value}");
      // } else if (response.statusCode == 302) {
      //   final redirectUrl = response.headers['location'];
      //   print("Redirect to: $redirectUrl");
      //   if (redirectUrl != null) {
      //     await launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.inAppWebView);
      //   }
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