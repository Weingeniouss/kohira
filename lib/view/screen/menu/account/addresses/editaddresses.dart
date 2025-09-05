// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_null_comparison, deprecated_member_use, non_constant_identifier_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import '../../../../../controller/API/credentials/country.dart';
import '../../../../../modal/credentials/country.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';

class Editaddresses extends StatefulWidget {
  final String id;

  const Editaddresses({super.key, required this.id});

  @override
  State<Editaddresses> createState() => _EditaddressesState();
}

class _EditaddressesState extends State<Editaddresses> {
  final fech = Get.put(Fechaddresses());
  final fechedit = Get.put(EditFechaddresses());
  final add = Get.put(Addaddresses());
  final Country = Get.put(CountryCalling());
  final State = Get.put(StateCalling());
  final setDeflut = Get.put(SetDeflutAddress());

  String? countryLabal;
  String? countryValue;
  String? stateLabel;
  String? stateId;

  String selectedState = 'Selected State';
  String selectedCountry = 'Selected Country';

  //Address defalt
  bool isChecked = false;
  bool isDefault = false;
  String get isDefaultValue => isChecked ? '1' : '0';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fechedit.editfechaddresses(id: widget.id);
      final userData = fechedit.data['userAdddress'][0];
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
    });
  }

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
        appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.editAddresses),
        bottomNavigationBar:Obx((){
          if(fechedit.isLoading.value){
            return SizedBox();
          }
          final userData = fechedit.data['userAdddress'][0];
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
          return SafeArea(
            child: Container(
              color: AppColor.white_color,
              height: Get.height * 0.080,
              child: horizontalpadding(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async{
                            await add.addfechaddresses(
                              id: widget.id,
                              firstname: (firstname != null) ? firstname!.text : firstname!.text,
                              lastname: (lastname != null) ? lastname!.text : lastname!.text,
                              mobileno: (mobile != null) ? mobile!.text : mobile!.text,
                              address: (address != null) ? address!.text : address!.text,
                              state: (stateId != null) ? stateId.toString() : stateID!.text,
                              email: (mail != null) ? mail!.text : mail!.text,
                              city: (city != null) ? city!.text : city!.text,
                              zip: (zip != null) ? zip!.text : zip!.text,
                              countrycode: (countryValue != null) ? countryValue : countrycode!.text,
                              country: (countryValue != null) ? countryValue : countrycode!.text,
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
                          },
                          child: button("${AppString.save} ${AppString.Addresses}"),
                        ),
                        SizedBox(height: Get.height / 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (fechedit.isLoading.value) {
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
            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    inputField(icon: AppIcon.parson, controller: firstname),
                    inputField(icon: AppIcon.parson, controller: lastname),
                    inputField(icon: AppIcon.location, controller: address,iconcolor: AppColor.pink_color),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                        child: Row(children: [
                          SizedBox(width: Get.width / 150),
                          SvgPicture.asset(AppIcon.location,fit: BoxFit.cover,color: AppColor.pink_color,width: 28,height: 28),
                          Expanded(
                            child: Obx(() {
                              return DropdownButton2<Data>(
                                value: Country.selectedCountry.value,
                                hint: Text(
                                  userData['country_data']?['name'] ?? '',
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
                                  countryValue = newValue.id.toString();
                                  countryLabal = newValue.label;
                                  print("Country ID: $countryValue");
                                  print("Country Label: $countryLabal");
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
                                    return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                                  },
                                ),
                              );
                            }),
                          ),
                        ])),
                    SizedBox(height: Get.height / 80),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                        child: Row(children: [
                          SizedBox(width: Get.width / 150),
                          SvgPicture.asset(AppIcon.location,fit: BoxFit.cover,color: AppColor.pink_color,width: 28,height: 28),
                          Expanded(
                            child: DropdownButton2<Map<String, dynamic>>(
                              value: State.selectedState.value,
                              hint: Text(
                                userData['state_data']?['name'] ?? '',
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
                                searchController: statesearchController,
                                searchInnerWidgetHeight: 40,
                                searchInnerWidget: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextField(
                                    controller: statesearchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search State...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  final map = item.value as Map<String, dynamic>;
                                  return map["label"].toLowerCase().contains(searchValue.toLowerCase());
                                },
                              ),
                            ),
                          ),
                        ])),
                    SizedBox(height: Get.height / 80),
                    // inputField(icon: AppIcon.location, controller: state,iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.location,controller: city,iconcolor: AppColor.pink_color),
                    inputField(icon: AppIcon.earth, controller: zip,iconheight: 20,iconcolor: AppColor.pink_color,textInputType: TextInputType.number,maxLength: 6),
                    inputField(icon: AppIcon.mail, controller: mail),
                    inputField(icon: AppIcon.mobile, controller: mobile,maxLength: 10,textInputType: TextInputType.number),
                    fechedit.data['userAdddress']['isdefault'] ==  1 ? Column(
                      children: [
                        SizedBox(height: Get.height / 80),
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: AppColor.pink_color),
                                  child: Icon(Icons.check,size: 10),
                                ),
                                Text(AppString.setdefult,style: TextStyle(fontSize: Get.width / 25)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ) : SizedBox(),

                    fechedit.data['userAdddress']['isdefault'] == 0 ?  Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.pink_color,
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                              final fech = Get.put(EditFechaddresses());
                              if (isChecked) {
                                final userAddresses = fech.data['userAdddress'];
                                if (userAddresses != null && userAddresses.isNotEmpty) {
                                  final id = widget.id.toString();
                                  if (id != null) {
                                    setDeflut.setDefult(id: id);
                                    print("✅ Default set for ID: $id");
                                  }
                                } else {
                                  print("⚠️ No addresses available");
                                }
                              }
                            });
                          },
                        ),
                        Text(AppString.setdefult,style: TextStyle(fontSize: Get.width / 25)),
                      ],
                    ) : SizedBox(),
                  ],
                ),
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}