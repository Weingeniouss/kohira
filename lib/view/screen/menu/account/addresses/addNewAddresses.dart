// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/credentials/country.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';
import '../../../../../modal/credentials/country.dart';
import '../../../../utils/app_gif.dart';
import '../../../../utils/app_string.dart';

class AddNewAddresses extends StatefulWidget {
  const AddNewAddresses({super.key});

  @override
  State<AddNewAddresses> createState() => _AddNewAddressesState();
}

class _AddNewAddressesState extends State<AddNewAddresses> {
  final fech = Get.put(Fechaddresses());
  final add = Get.put(Addaddresses());
  final Country = Get.put(CountryCalling());
  final setDeflut = Get.put(SetDeflutAddress());

  final TextEditingController searchController = TextEditingController();

  TextEditingController fristname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController countrycode = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController city =  TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fech.fechaddresses();
    });
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.back();
        await fech.fechaddresses();
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          onTaplefticon: ()async{
             fech.fechaddresses();
             Get.back();
            },
          hedingname: 'Add New ${AppString.Addresses}',
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: AppColor.white_color,
            height: Get.height * 0.080,
            child: Obx((){
              if(fech.isLoading.value) SizedBox();

              return horizontalpadding(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async{
                          await add.addfechaddresses(
                            firstname: fristname.text,
                            lastname: lastname.text,
                            mobileno: mobile.text,
                            address: address.text,
                            countrycode: Country.selectedCountry.value.toString(),
                            state: state.text,
                            email: mail.text,
                            city: city.text,
                            zip: zip.text,
                            country: country.text,
                          );

                          if(add.data['type'] == 'success') ToastificationSuccess.Success(add.data['message']);

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
                        },
                        child: button("${AppString.save} ${AppString.Addresses}"),
                      ),
                      SizedBox(height: Get.height / 50),
                    ],
                  ),
                ),
              );
            })
          ),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (fech.isLoading.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen != true) {
                  Get.dialog(
                    Center(child: Lottie.asset(AppJson.loading2)),
                    barrierDismissible: false,
                  );
                }
              });
              return Scaffold(backgroundColor: Colors.transparent);
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen == true) {
                  Get.back();
                }
              });
            }

            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    inputField(icon: AppIcon.parson, hintText: 'Frist Name',controller: fristname),
                    inputField(icon: AppIcon.parson, hintText: 'Last Name',controller: lastname),
                    inputField(icon: AppIcon.parson, hintText: 'Address',controller: address),
                    inputField(icon: AppIcon.parson, hintText: 'country',controller: country),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                      child: Row(
                        children: [
                          Image.asset(AppGif.earth, scale: 1.5),
                          SizedBox(width: Get.width / 50),
                          Expanded(
                            child: DropdownButton2<Data>(
                              value: Country.selectedCountry.value,
                              dropdownSearchData: DropdownSearchData(
                                searchController: searchController,
                                searchInnerWidgetHeight: 40,
                                searchInnerWidget: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                                },
                              ),
                              underline: SizedBox(),
                              isExpanded: true,
                              items: Country.countries.map((item) => DropdownMenuItem(value: item, child: Text("${item.label} (${item.countrycode})"))).toList(),
                              onChanged: (newValue) => Country.selectedCountry.value = newValue!,
                              dropdownStyleData: DropdownStyleData(
                                offset: Offset(0, -10),
                                maxHeight: Get.height / 3,
                                decoration: BoxDecoration(color: AppColor.white_color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height / 50),
                    inputField(icon: AppIcon.parson, hintText: 'Selected State',controller: state),
                    inputField(icon: AppIcon.parson, hintText: 'city',controller: city),
                    inputField(icon: AppIcon.parson, hintText: 'Zipcode',controller: zip),
                    inputField(icon: AppIcon.parson, hintText: 'Email',controller: mail),
                    inputField(icon: AppIcon.parson, hintText: 'Phone Numbers',controller: mobile),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.pink_color,
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                              if (isChecked ==  true) setDeflut.setDefult(id: fech.data['userAdddress'][0]['id'].toString());
                              print(fech.data['userAdddress'][0]['id'].toString());
                            });
                          },
                        ),
                        Text(AppString.setdefult,style: TextStyle(fontSize: Get.width / 25)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
