// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
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
  final fech = Get.put(EditFechaddresses());
  final add = Get.put(Addaddresses());
  final setDeflut = Get.put(SetDeflutAddress());

  TextEditingController? fristname;
  TextEditingController? lastname;
  TextEditingController? address;
  TextEditingController? country;
  TextEditingController? state;
  TextEditingController? countrycode;
  TextEditingController? mail;
  TextEditingController? mobile;
  TextEditingController? zip;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fech.editfechaddresses(id: widget.id);
    });
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.editAddresses),
      bottomNavigationBar:Obx((){
        if(fech.isLoading.value){
          return SizedBox();
        }

        final userData = fech.data['userAdddress'];

        if (userData != null && fristname == null) {
          fristname = TextEditingController(text: userData['firstname'] ?? '');
          lastname = TextEditingController(text: userData['lastname'] ?? '');
          address = TextEditingController(text: userData['address'] ?? '');
          country = TextEditingController(text: userData['country_data']?['name'] ?? '');
          state = TextEditingController(text: userData['state_data']?['name'] ?? '');
          countrycode = TextEditingController(text: userData['country_data']?['countrycode'] ?? '');
          mail = TextEditingController(text: userData['email'] ?? '');
          mobile = TextEditingController(text: userData['mobileno'] ?? '');
          zip = TextEditingController(text: userData['pincode']);
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
                           firstname: fristname!.text,
                           lastname: lastname!.text,
                           mobileno: mobile!.text,
                           address: address!.text,
                           country: country!.text,
                           countrycode: countrycode!.text,
                           state: state!.text,
                           email: mail!.text,
                           zip: userData['pincode'],
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

            final userData = fech.data['userAdddress'];

            if (userData != null && fristname == null) {
              fristname = TextEditingController(text: userData['firstname'] ?? '');
              lastname = TextEditingController(text: userData['lastname'] ?? '');
              address = TextEditingController(text: userData['address'] ?? '');
              country = TextEditingController(text: userData['country_data']?['name'] ?? '');
              state = TextEditingController(text: userData['state_data']?['name'] ?? '');
              countrycode = TextEditingController(text: userData['country_data']?['countrycode'] ?? '');
              mail = TextEditingController(text: userData['email'] ?? '');
              mobile = TextEditingController(text: userData['mobileno'] ?? '');
            }

            return horizontalpadding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    inputField(icon: AppIcon.parson, controller: fristname),
                    inputField(icon: AppIcon.parson, controller: lastname),
                    inputField(icon: AppIcon.parson, controller: address),
                    inputField(icon: AppIcon.parson, controller: country),
                    inputField(icon: AppIcon.parson, controller: state),
                    inputField(icon: AppIcon.parson, controller: countrycode),
                    inputField(icon: AppIcon.parson, controller: mail),
                    inputField(icon: AppIcon.parson, controller: mobile),
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
          },
        ),
      ),
    );
  }
}
