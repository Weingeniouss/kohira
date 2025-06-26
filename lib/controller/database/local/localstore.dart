// ignore_for_file: avoid_print

import 'package:kohira/view/utils/appconstants.dart';

class localdatabase {
  void sinupstore({
    required String fristname,
    required String lastname,
    required String email,
    required String mobile,
    required String password,
    required String countrycode,
  }) async{
    await pref!.setString('fristname', fristname);
    await pref!.setString('lastname', lastname);
    await pref!.setString('email', email);
    await pref!.setString('mobile', mobile);
    await pref!.setString('password', password);
    await pref!.setString('countrycode', countrycode);
    
    pref!.get('fristname');
    pref!.get('lastname');
    pref!.get('email');
    pref!.get('mobile');
    pref!.get('password');
    pref!.get('countrycode');
    
    print('fristname :- $Fristname');
    print('lastname :- $Lastname');
    print('email :- $Email');
    print('mobile :- $Mobile');
    print('password :- $Password');
    print('countrycode :- $Countrycode');
  }
}
