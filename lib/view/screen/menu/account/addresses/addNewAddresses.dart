// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final State = Get.put(StateCalling());
  final setDeflut = Get.put(SetDeflutAddress());

  String selectedState = 'Selected State';
  String selectedCountry = 'Selected Country';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => fech.fechaddresses());
  }

  String? countryLabal;
  String? countryValue;
  String? stateLabel;
  String? stateId;

  bool isChecked = false;
  bool isDefault = false;

  String get isDefaultValue => isChecked ? '1' : '0';

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
          onTaplefticon: () async {
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
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async{
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
                    inputField(icon: AppIcon.parson, hintText: 'First Name',controller: fristname),
                    inputField(icon: AppIcon.parson, hintText: 'Last Name',controller: lastname),
                    inputField(icon: AppIcon.location, hintText: 'Address',controller: address,iconcolor: AppColor.pink_color),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                      child: Row(
                        children: [
                          SizedBox(width: Get.width / 150),
                          SvgPicture.asset(AppIcon.location,fit: BoxFit.cover,color: AppColor.pink_color,width: 28,height: 28),

                          //Country
                          Expanded(
                            child: Obx(() {
                              return DropdownButton2<Data>(
                                value: Country.selectedCountry.value,
                                hint: Text(
                                  'Select Country',
                                  style: TextStyle(
                                    color: AppColor.black_color,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                items: Country.countries.map((item) {
                                  return DropdownMenuItem<Data>(
                                    value: item,
                                    child: Text(item.label.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  Country.selectedCountry.value = newValue!;
                                  State.stateList(newValue.id.toString());

                                  /// ✅ here you can extract id & label
                                  countryValue = newValue.id.toString();      // <-- this is your `countryid`
                                  countryLabal = newValue.label;   // <-- this is label

                                  print("Country ID: $countryValue");
                                  print("Country Label: $countryLabal");

                                  /// ✅ Now call your state API using countryid
                                  Get.find<StateCalling>().stateList(countryValue!);
                                },
                                dropdownStyleData: DropdownStyleData(
                                  offset: Offset(0, -10),
                                  maxHeight: Get.height / 3,
                                  decoration: BoxDecoration(color: AppColor.white_color),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor),
                                  iconSize: 24,
                                ),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: searchController,
                                  searchInnerWidgetHeight: 40,
                                  searchInnerWidget: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search Country...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return item.value?.label
                                        ?.toLowerCase()
                                        .contains(searchValue.toLowerCase()) ??
                                        false;
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height / 80),
                    // inputField(icon: AppIcon.location, hintText: 'Selected State',controller: state,iconcolor: AppColor.pink_color),

                    //State
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                    child: Row(
                        children: [
                    SizedBox(width: Get.width / 150),
                    SvgPicture.asset(AppIcon.location,fit: BoxFit.cover,color: AppColor.pink_color,width: 28,height: 28),
                     Expanded(
                      child: DropdownButton2<Map<String, dynamic>>(
                        value: State.selectedState.value,
                        hint: Text(
                          'Select State',
                          style: TextStyle(
                            color: AppColor.black_color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        items: State.states.map((item) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Text(item["label"]),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          State.selectedState.value = newValue;

                          /// ✅ Access id & label
                          stateId = newValue?["id"].toString();
                          stateLabel = newValue?["label"];
                          print("Selected State ID: $stateId, Label: $stateLabel");
                        },
                        dropdownStyleData: DropdownStyleData(
                          offset: Offset(0, -10),
                          maxHeight: Get.height / 3,
                          decoration: BoxDecoration(color: AppColor.white_color),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor),
                          iconSize: 24,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: searchController,
                          searchInnerWidgetHeight: 40,
                          searchInnerWidget: Padding(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search State...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            final map = item.value as Map<String, dynamic>;
                            return map["label"]
                                .toLowerCase()
                                .contains(searchValue.toLowerCase());
                          },
                        ),
                      ),
                    ),
          ])),
                    SizedBox(height: Get.height / 80),
                    inputField(icon: AppIcon.location, hintText: 'City',controller: city,iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.earth, hintText: 'Zipcode',controller: zip,iconwidth: 20,iconheight: 20,iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.mail, hintText: 'Email',controller: mail),
                    inputField(icon: AppIcon.mobile, hintText: 'Phone Numbers',controller: mobile),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.pink_color,
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;

                              if (isChecked) {
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
