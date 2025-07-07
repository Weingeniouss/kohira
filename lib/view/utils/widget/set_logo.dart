// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';

import '../app_logo.dart';

Widget setLogo() {
  return Padding(
    padding: EdgeInsets.all(30),
    child: Image.asset(AppLogo.logo, scale: 10),
  );
}
