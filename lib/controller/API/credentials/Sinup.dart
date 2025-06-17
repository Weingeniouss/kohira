// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'package:get/get.dart';
import 'package:kohira/controller/service/credentials/sinup.dart';
import '../../../modal/credentials/sinup.dart';
import '../../../view/utils/widget/pop.dart';

class SinupCalling extends GetxController {
  var isLoading = false.obs;
  var response = Rxn<Sinup>();

  Future<void> registerUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String mobileno,
    required String captcha,
    required String countrycode,
    required String country_shortname,
    required String login_type,
  }) async {
    isLoading.value = true;
    final service = SinupService();

    final result = await service.sinupUser(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      mobileno: mobileno,
      captcha: captcha,
      countrycode: countrycode,
      country_shortname: country_shortname,
      login_type: login_type,
    );

    print("Signup Response: ${result?.message}");

    if (result != null && result.status == true) {
      response.value = result;
      ToastificationSuccess.Success("'Success', ${result.message}");
      print({
        '\n Frist Name :-$firstname \n'
            'Last Name:- $lastname \n'
            'Email :- $email \n'
            'Password:-  $password \n'
            'PasswordConfirmation:- $passwordConfirmation \n'
            'Mobile  :-$mobileno \n'
            'captcha :- $captcha \n'
            'countrycode:- $countrycode \n'
            'country_shortname :- $country_shortname \n'
            'login_type :-$login_type \n'
      });
    } else {
      ToastificationError.Error("Error, ${result?.message}");

      print({
        '\n Frist Name :-$firstname \n'
            'Last Name:- $lastname \n'
            'Email :- $email \n'
            'Password:-  $password \n'
            'PasswordConfirmation:- $passwordConfirmation \n'
            'Mobile  :-$mobileno \n'
            'captcha :- $captcha \n'
            'countrycode:- $countrycode \n'
            'country_shortname :- $country_shortname \n'
            'login_type :-$login_type \n'
      });

      print('code :- ${result?.code}');
      print('status :- ${result?.status}');
      print('type :- ${result?.type}');
      print('message :- ${result?.message}');
    }
    isLoading.value = false;
  }
}
