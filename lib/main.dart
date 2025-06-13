// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kohira/view/screen/splace/logo/logo.dart';
import 'package:toastification/toastification.dart';

void main() {runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        home: Logo(),
      ),
    );
  }
}
