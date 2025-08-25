// ignore_for_file: prefer_const_constructors, file_names, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../app_String.dart';
import '../app_color.dart';

Widget inputField({
  String? hintText,
  String? icon,
  Color? iconcolor,
  TextEditingController? controller,
  bool empty = false,
  bool isVis = false,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool _obscureText = isVis;
      return Column(
        children: [
          Builder(
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return TextField(
                    controller: controller,
                    obscureText: isVis ? _obscureText : false,
                    decoration: InputDecoration(
                      prefixIcon: icon != null ? Padding(
                        padding: const EdgeInsets.all(10),
                        child:
                        SvgPicture.asset(icon, fit: BoxFit.cover,color: iconcolor),
                      ) : null,
                      suffixIcon: isVis ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,color: AppColor.grey_color),
                      ) : null,
                      hintText: hintText,
                      hintStyle: TextStyle(color: AppColor.black_color),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 11),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: empty ? 2 : 1,
                          color: empty ? AppColor.pink_color : AppColor.textfild_color,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: empty ? 2 : 1,
                          color: empty ? AppColor.pink_color : AppColor.textfild_color,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: Get.height / 50),
        ],
      );
    },
  );
}

Widget searchField({
  void Function(String)? onChanged,
  void Function(String)? onSubmitted,
  void Function()? onTap,
  bool? readOnly,
  FocusNode? focusNode,
  TextInputAction? textInputAction
}){
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.textfild_color),
      borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
    ),
    child: Center(
      child: TextField(
        textInputAction: textInputAction,
        focusNode: focusNode,
        readOnly: readOnly ?? false,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Get.height / 60),
          prefixIcon: Icon(Icons.search, color: AppColor.hintColor),
          hintText: AppString.Searchs,
          hintStyle: TextStyle(color: AppColor.hintColor),
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    ),
  );
}
