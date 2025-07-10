// ignore_for_file: avoid_print, camel_case_types

import 'package:kohira/view/utils/appconstants.dart';

class localdatabase {
  void sinupstore({
    required String fristname,
    required String lastname,
    required String email,
    required String mobile,
    required String password,
    required String countrycode,
  }) {
    pref!.setString('fristname', fristname);
    pref!.setString('lastname', lastname);
    pref!.setString('email', email);
    pref!.setString('mobile', mobile);
    pref!.setString('password', password);
    pref!.setString('countrycode', countrycode);

    Fristname = pref!.getString('fristname')!;
    Lastname = pref!.getString('lastname')!;
    Email = pref!.getString('email')!;
    Mobile = pref!.getString('mobile')!;
    Password = pref!.getString('password')!;
    Countrycode = pref!.getString('countrycode')!;

    print('fristname :- $Fristname');
    print('lastname :- $Lastname');
    print('email :- $Email');
    print('mobile :- $Mobile');
    print('password :- $Password');
    print('countrycode :- $Countrycode');
  }

  void loginstrore({required String email, required String password}){
    pref!.setString('email', email);
    pref!.setString('password', password);

    Email = pref!.getString('email')!;
    Password = pref!.getString('password')!;

    print('email :- $Email');
    print('password :- $Password');

    pref!.setBool('login', true);
    islogin = pref!.getBool('login')?? false;

    print('tokan :- $tokans');
    print('isLogin :- $islogin');

    // if(Email == email && Password == password){
    //   pref!.setBool('login', true);
    //   islogin = pref!.getBool('login')!;
    //
    //   print('isLogin :- $islogin');
    // }
  }

  //Product details
  // Save to SharedPreferences
  Future<void> saveToWishlist(storageKey) async {
    try {
      List<String> currentList = pref!.getStringList(storageKey) ?? [];
      if (!currentList.contains(storageKey)) {
        currentList.add(storageKey);
        await pref!.setStringList(storageKey, currentList);
      }
      print('Saved wishlist: ${pref!.getStringList(storageKey)}');
    } catch (e) {
      print('Error saving to wishlist: $e');
    }
  }
}
