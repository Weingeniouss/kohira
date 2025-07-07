// ignore_for_file: prefer_const_constructors, avoid_print
// Registered a new Firebase ios app on Firebase project kohira-2ac25.
// Firebase configuration file lib\firebase_options.dart generated successfully with the following Firebase apps:
//
// Platform  Firebase App Id
// android   1:346758579783:android:cbbe85b0324c7a6ba45362
// ios       1:346758579783:ios:d1a15726b5fabe9ea45362

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart' show Bottom;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  pref = await SharedPreferences.getInstance();

  Fristname = pref!.getString('fristname') ?? '';
  Lastname = pref!.getString('lastname') ?? '';
  Mobile = pref!.getString('mobile') ?? '';
  Email = pref!.getString('email') ?? '';
  Countrycode = pref!.getString('countrycode') ?? '';
  Password = pref!.getString('password') ?? '';

  islogin = pref!.getBool('login') ?? false;

  print('Fristname $Fristname');
  print('Lastname $Lastname');
  print('Mobile $Mobile');
  print('Email $Email');
  print('Countrycode $Countrycode');
  print('Password $Password');


  print('Is Login :- $islogin');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        home: Bottom(),
      ),
    );
  }
}
