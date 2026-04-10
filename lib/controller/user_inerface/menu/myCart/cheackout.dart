// ignore_for_file: unused_local_variable, prefer_const_constructors, deprecated_member_use, camel_case_types, avoid_print

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../view/utils/widget/pop.dart';
import '../../../API/menu/myCart/process-payment.dart';

class Cheackout_Controller extends GetxController {
  final processpayment = Get.put(Processpayment());
  bool get shouldScroll => !billing.value || !shipping.value || !shippingtype.value;

  final shipping = ValueNotifier<bool>(true);
  var billing = true.obs;
  var shippingtype = true.obs;
  var showItems = false.obs;

  void isbilling() => billing.value =! billing.value;
  void isshippingtype() => shippingtype.value =! shippingtype.value;
  void showitems() => showItems.value =! showItems.value;

  var isLoading = false.obs;

 void paymantProess() async{
   try {
     isLoading(true);
     // await the API call
     await processpayment.processpayment(
       firstname: 'Sager',  //1
       lastname: 'Patil',  //2
       email: 'navin.dholariya@weingenious.com', //3
       companyname: 'Company name', //4
       address: 'Weingeniou uppp', //5
       city: 'America', //6
       state: '1564', //7
       state_name: 'Badakhshan', //8
       country: '103', //9
       countrycode: '+91', //10
       zip: '395009', //11
       mobileno: '6161616161', //12
       samebilling: 'true', //13
       Payment_method: 'icici', //14
       coupon_id: '0', //15
       coupon_amount: '0', //16
       grossamt: '92657', //17
       discountamt: '0', //18
       totalamount: '95437', //19
       netamount: '95437', //20
       iswallet: 'no', //21
       walletAmount: '0', //22
       remainingAmount: '95437', //23
       globaltaxper: '3', //24
       globaltaxcharge: '2780', //25
       amount: '95437', //26
       merchant_id: '100000000005859', //27
       BankId: '24520', //28
       TerminalId: 'EG000488', //29
       Version: '1', //30
       Currency: '356', //31
       user_id: '346', //32
       paymenttype: 'ccavanue', //33
     );

     // ensure data exists
     // safe parse of code (could be int or string)
     final dynamic codeRaw = processpayment.data['code'];
     final int code = (codeRaw is int)
         ? codeRaw
         : int.tryParse(codeRaw?.toString() ?? '') ?? 0;

     // safe extraction of gatewayUrl
     final String? gatewayUrlRaw = processpayment.data['gatewayUrl']?.toString();
     if (gatewayUrlRaw != null && gatewayUrlRaw.isNotEmpty) {
       final Uri? url = Uri.tryParse(gatewayUrlRaw);
       if (url != null) {
         await launchUrl(url, mode: LaunchMode.externalApplication);
       } else {
         ToastificationError.Error('Invalid payment URL');
       }
     } else {
       ToastificationError.Error('Payment gateway URL not provided');
     }
      } catch (e, st) {
     if (kDebugMode) print('Payment error: $e\n$st');
     ToastificationError.Error('Payment failed. Try again.');
   }finally{
     isLoading(false);
   }
 }
}
