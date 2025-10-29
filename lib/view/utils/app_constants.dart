// ignore_for_file: non_constant_identifier_names, strict_top_level_inference, prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

//SharedPreference
SharedPreferences? pref;

//Login & Sinup
String Fristname = '';
String Lastname = '';
String Email = '';
String Countrycode = '';
String Mobile = '';
String Password = '';

//Login True or flase
bool islogin = false;

//get Tokan
String tokans =  '';

var existingItemsCart;
var existingItemsWish;
String cartCount = '';
String wishCount = '';