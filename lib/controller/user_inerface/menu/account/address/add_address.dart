// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, must_call_super, avoid_print, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../view/utils/widget/pop.dart';
import '../../../../API/credentials/country.dart';
import '../../../../API/menu/account/addresses.dart';

class AddAddressController extends GetxController {
  final fech = Get.put(Fechaddresses());
  final add = Get.put(Addaddresses());
  final Country = Get.put(CountryCalling());
  final State = Get.put(StateCalling());
  final setDeflut = Get.put(SetDeflutAddress());

  TextEditingController searchController = TextEditingController();
  TextEditingController statesearchController = TextEditingController();

  TextEditingController fristname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController countrycode = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController city = TextEditingController();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) => fech.fechaddresses());
  }

  var countryLabal = ''.obs;
  var countryValue = ''.obs;
  var stateLabel = ''.obs;
  var stateId = ''.obs;

  var isChecked = false.obs;
  var isDefault = false.obs;
  String get isDefaultValue => isChecked.value ? '1' : '0';

  var selectedState = 'Selected State'.obs;
  var selectedCountry = 'Selected Country'.obs;

  void addAddress() async {
    await add.addfechaddresses(
      firstname: fristname.text,
      lastname: lastname.text,
      mobileno: mobile.text,
      address: address.text,
      state: stateId.toString(),
      email: mail.text,
      city: city.text,
      zip: zip.text,
      country: countryValue.toString(),
      isdefault: isDefaultValue,
    );
    if (add.data['success'] == false) {
      final errors = add.data['errors'];
      if (errors != null && errors.containsKey('zip')) ToastificationError.Error(errors['zip'][0]);
      if (errors != null && errors.containsKey('firstname')) ToastificationError.Error(errors['firstname'][0]);
      if (errors != null && errors.containsKey('lastname')) ToastificationError.Error(errors['lastname'][0]);
      if (errors != null && errors.containsKey('email')) ToastificationError.Error(errors['email'][0]);
      if (errors != null && errors.containsKey('address')) ToastificationError.Error(errors['address'][0]);
      if (errors != null && errors.containsKey('city')) ToastificationError.Error(errors['city'][0]);
      if (errors != null && errors.containsKey('state')) ToastificationError.Error(errors['state'][0]);
      if (errors != null && errors.containsKey('country')) ToastificationError.Error(errors['country'][0]);
      if (errors != null && errors.containsKey('countrycode')) ToastificationError.Error(errors['countrycode'][0]);
      if (errors != null && errors.containsKey('mobileno')) ToastificationError.Error(errors['mobileno'][0]);
      if (errors != null && errors.containsKey('id')) ToastificationError.Error(errors['mobileno'][0]);
      if (errors != null && errors.containsKey('isdefault')) ToastificationError.Error(errors['isdefault'][0]);
    }
    if (add.data['type'] == 'success') {
      ToastificationSuccess.Success(add.data['message']);
      Get.back();
      fech.fechaddresses();
    }
  }

  void countryCalling(newValue) async {
    Country.selectedCountry.value = newValue!;
    State.stateList(newValue.id.toString());
    countryValue.value = newValue.id.toString();
    countryLabal.value = newValue.label;
    print("Country ID: $countryValue");
    print("Country Label: $countryLabal");
    Get.find<StateCalling>().stateList(countryValue.value);
  }

  void stateCalling(newValue) async {
    State.selectedState.value = newValue;
    stateId.value = newValue!["id"].toString();
    stateLabel.value = newValue?["label"];
    print("Selected State ID: $stateId, Label: $stateLabel");
  }

  void setDefaultAddress(bool? value) async {
    isChecked.value = value ?? false;
    if (isChecked.value) {
      final userAddresses = fech.data['userAdddress'];
      if (userAddresses != null && userAddresses.isNotEmpty) {
        final id = userAddresses[0]['id']?.toString();
        if (id != null) {
          setDeflut.setDefult(id: id);
          print(id);
        } else {
          print("⚠️ ID is null");
        }
      } else {
        print("⚠️ userAdddress list is empty or null");
      }
    }
  }
}
