// ignore_for_file: unused_local_variable, prefer_const_constructors, deprecated_member_use, camel_case_types, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../view/utils/app_constants.dart';
import '../../../../view/utils/widget/pop.dart';
import '../../../API/menu/myCart/process-payment.dart';

class Cheackout_Controller extends GetxController {
  final processpayment = Get.put(Processpayment());

  bool get shouldScroll =>
      !billing.value || !shipping.value || !shippingtype.value;

  final shipping = ValueNotifier<bool>(true);
  var billing = true.obs;
  var shippingtype = true.obs;
  var showItems = false.obs;

  var showOrderSummary = true.obs;
  var expandedItemDetails = <int>{}.obs;
  var giftWrapOrder = true.obs;
  var sameAsBillingAddress = true.obs;
  var useKohiraCoins = false.obs;

  var selectedState = RxnString();
  var selectedBillingState = RxnString();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final noteController = TextEditingController();

  final billingFirstNameController = TextEditingController();
  final billingLastNameController = TextEditingController();
  final billingAddressController = TextEditingController();
  final billingPincodeController = TextEditingController();
  final billingEmailController = TextEditingController();
  final billingMobileController = TextEditingController();

  final List<String> statesList = [
    "Gujarat",
    "Maharashtra",
    "Delhi",
    "Karnataka",
    "Tamil Nadu",
    "Rajasthan",
    "Uttar Pradesh",
    "Madhya Pradesh",
    "West Bengal",
    "Punjab",
    "Haryana",
    "Kerala",
    "Telangana",
    "Andhra Pradesh"
  ];

  @override
  void onInit() {
    super.onInit();
    if (pref != null) {
      firstNameController.text = Fristname;
      lastNameController.text = Lastname;
      emailController.text = Email;
      mobileController.text = Mobile;

      billingFirstNameController.text = Fristname;
      billingLastNameController.text = Lastname;
      billingEmailController.text = Email;
      billingMobileController.text = Mobile;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    emailController.dispose();
    mobileController.dispose();
    noteController.dispose();

    billingFirstNameController.dispose();
    billingLastNameController.dispose();
    billingAddressController.dispose();
    billingPincodeController.dispose();
    billingEmailController.dispose();
    billingMobileController.dispose();
    super.onClose();
  }

  void toggleOrderSummary() => showOrderSummary.value = !showOrderSummary.value;

  void toggleItemDetail(int index) {
    if (expandedItemDetails.contains(index)) {
      expandedItemDetails.remove(index);
    } else {
      expandedItemDetails.add(index);
    }
    expandedItemDetails.refresh();
  }

  void toggleGiftWrap() => giftWrapOrder.value = !giftWrapOrder.value;

  void toggleSameAsBilling() =>
      sameAsBillingAddress.value = !sameAsBillingAddress.value;

  void toggleKohiraCoins() => useKohiraCoins.value = !useKohiraCoins.value;

  void isbilling() => billing.value = !billing.value;

  void isshippingtype() => shippingtype.value = !shippingtype.value;

  void showitems() => showItems.value = !showItems.value;

  var isLoading = false.obs;

  void paymantProess() async {
    try {
      isLoading(true);
      await processpayment.processpayment(
        firstname: firstNameController.text.isNotEmpty
            ? firstNameController.text
            : 'Sager',
        lastname: lastNameController.text.isNotEmpty
            ? lastNameController.text
            : 'Patil',
        email: emailController.text.isNotEmpty
            ? emailController.text
            : 'navin.dholariya@weingenious.com',
        companyname: 'Company name',
        address: addressController.text.isNotEmpty
            ? addressController.text
            : 'Weingeniou uppp',
        city: 'America',
        state: '1564',
        state_name: selectedState.value ?? 'Badakhshan',
        country: '103',
        countrycode: '+91',
        zip: pincodeController.text.isNotEmpty
            ? pincodeController.text
            : '395009',
        mobileno: mobileController.text.isNotEmpty
            ? mobileController.text
            : '6161616161',
        samebilling: sameAsBillingAddress.value ? 'true' : 'false',
        Payment_method: 'icici',
        coupon_id: '0',
        coupon_amount: '0',
        grossamt: '92657',
        discountamt: '0',
        totalamount: '95437',
        netamount: '95437',
        iswallet: useKohiraCoins.value ? 'yes' : 'no',
        walletAmount: '0',
        remainingAmount: '95437',
        globaltaxper: '3',
        globaltaxcharge: '2780',
        amount: '95437',
        merchant_id: '100000000005859',
        BankId: '24520',
        TerminalId: 'EG000488',
        Version: '1',
        Currency: '356',
        user_id: '346',
        paymenttype: 'ccavanue',
      );

      final dynamic codeRaw = processpayment.data['code'];
      final int code = (codeRaw is int)
          ? codeRaw
          : int.tryParse(codeRaw?.toString() ?? '') ?? 0;

      final String? gatewayUrlRaw =
          processpayment.data['gatewayUrl']?.toString();
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
    } finally {
      isLoading(false);
    }
  }
}
