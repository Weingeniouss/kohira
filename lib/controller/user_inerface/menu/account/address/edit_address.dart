// ignore_for_file: avoid_print, strict_top_level_inference, non_constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../view/utils/widget/pop.dart';
import '../../../../API/credentials/country.dart';
import '../../../../API/menu/account/addresses.dart';

class EditAddressUserIntrface extends GetxController{
  final String ids;

  EditAddressUserIntrface({required this.ids});

  final fech = Get.put(Fechaddresses());
  final fechedit = Get.put(EditFechaddresses());
  final add = Get.put(Addaddresses());
  final Country = Get.put(CountryCalling());
  final State = Get.put(StateCalling());
  final setDeflut = Get.put(SetDeflutAddress());

  var countryLabal = ''.obs;
  var countryValue = ''.obs;
  var stateLabel = ''.obs;
  var stateId = ''.obs;

  var selectedState = 'Selected State'.obs;
  var selectedCountry = 'Selected Country'.obs;

  //Address defalt
  var isChecked = false.obs;
  var isDefault = false.obs;
  String get isDefaultValue => isChecked.value ? '1' : '0';

  TextEditingController? firstname;
  TextEditingController? lastname;
  TextEditingController? address;
  TextEditingController? country;
  TextEditingController? state;
  TextEditingController? stateID;
  TextEditingController? city;
  TextEditingController? countrycode;
  TextEditingController? mail;
  TextEditingController? mobile;
  TextEditingController? zip;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController statesearchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fechedit.editfechaddresses(id: ids);
    final userData = fechedit.data['userAdddress'];
    if (userData != null && firstname == null) {
      firstname = TextEditingController(text: userData['firstname'] ?? '');
      lastname = TextEditingController(text: userData['lastname'] ?? '');
      address = TextEditingController(text: userData['address'] ?? '');
      country = TextEditingController(text: userData['country_data']?['name'] ?? '');
      state = TextEditingController(text: userData['state_data']?['name'] ?? '');
      stateID = TextEditingController(text: userData['state_data']?['id'].toString() ?? '');
      city = TextEditingController(text: userData['city'] ?? '');
      countrycode = TextEditingController(text: userData['country_data']?['countrycode'] ?? '');
      mail = TextEditingController(text: userData['email'] ?? '');
      mobile = TextEditingController(text: userData['mobileno'] ?? '');
      zip = TextEditingController(text: userData['pincode'] ?? '');
    }
  }

  void editfechaddresses()async{
    await add.addfechaddresses(
      id: ids,
      firstname: (firstname != null) ? firstname!.text : firstname!.text,
      lastname: (lastname != null) ? lastname!.text : lastname!.text,
      mobileno: (mobile != null) ? mobile!.text : mobile!.text,
      address: (address != null) ? address!.text : address!.text,
      state: (stateId != null) ? stateId.toString() : stateID!.text,
      email: (mail != null) ? mail!.text : mail!.text,
      city: (city != null) ? city!.text : city!.text,
      zip: (zip != null) ? zip!.text : zip!.text,
      countrycode: (countryValue.value != null) ? countryValue.value : countrycode!.text,
      country: (countryValue.value != null) ? countryValue.value : countrycode!.text,
      isdefault: isDefaultValue,
    );
    if(add.data['type'] == 'success'){
      ToastificationSuccess.Success(add.data['message']);
    }
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
    Get.back();
    await fech.fechaddresses();
  }

  void facedataedit(){
    final userData = fechedit.data['userAdddress'];
    if (userData != null && firstname == null) {
      firstname = TextEditingController(text: userData['firstname'] ?? '');
      lastname = TextEditingController(text: userData['lastname'] ?? '');
      address = TextEditingController(text: userData['address'] ?? '');
      country = TextEditingController(text: userData['country_data']?['name'] ?? '');
      state = TextEditingController(text: userData['state_data']?['name'] ?? '');
      stateID = TextEditingController(text: userData['state_data']?['id'].toString() ?? '');
      city = TextEditingController(text: userData['city'] ?? '');
      countrycode = TextEditingController(text: userData['country_data']?['countrycode'] ?? '');
      mail = TextEditingController(text: userData['email'] ?? '');
      mobile = TextEditingController(text: userData['mobileno'] ?? '');
      zip = TextEditingController(text: userData['pincode'] ?? '');
    }
  }

  void changeCountryvalue(newValue){
    Country.selectedCountry.value = newValue!;
    State.stateList(newValue.id.toString());
    countryValue.value = newValue.id.toString();
    countryLabal.value = newValue.label.toString();
    print("Country ID: $countryValue");
    print("Country Label: $countryLabal");
    Get.find<StateCalling>().stateList(countryValue.value);
  }

  void changeStatevalue(newValue){
    State.selectedState.value = newValue;
    stateId.value = newValue!["id"].toString();
    stateLabel.value = newValue?["label"];
    print("Selected State ID: $stateId, Label: $stateLabel");
  }

  void setDefaultvalue(value){
      isChecked.value = value ?? false;
      final fech = Get.put(EditFechaddresses());
      if (isChecked.value) {
        final userAddresses = fech.data['userAdddress'];
        if (userAddresses != null && userAddresses.isNotEmpty) {
          final id = ids.toString();
          if (id != null) {
            setDeflut.setDefult(id: id);
            print("✅ Default set for ID: $id");
          }
        } else {
          print("⚠️ No addresses available");
        }
      }
  }
}