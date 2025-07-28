// ignore_for_file: avoid_print, invalid_use_of_protected_member, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/errorcode.dart';
import 'package:kohira/view/utils/widget/pop.dart';

//Fech
class Fechaddresses extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future fechaddresses() async{
    try{
      isLoading.value = true;
      final url = Uri.parse(AppUrl.addressesfeach);
      print("Sending Request To :- $url");
      final responce =  await http.get(url,headers: {ApiHeaders.heading: ApiHeaders.peramitters,ApiHeaders.authorization : tokans});

      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log("Addresses :- ${data.value}");
      }else{
        throw{
          'Addresses Error this :-  ${responce.statusCode}, ${responce.body}',
          handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print("Addresses Error this :- $e");
    }finally{
      isLoading.value = false;
    }
  }
}

//Edit
class EditFechaddresses extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future editfechaddresses({String? id}) async{
    try{
      isLoading.value = true;
      final url = Uri.parse("${AppUrl.addressesfeach}/$id");
      print("Sending Request To :- $url");
      final responce =  await http.get(url,headers: {ApiHeaders.heading: ApiHeaders.peramitters,ApiHeaders.authorization : tokans});
      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log("Addresses :- ${data.value}");
      }else{
        throw{
          'Addresses Error this :-  ${responce.statusCode}, ${responce.body}',
          handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print("Addresses Error this :- $e");
    }finally{
      isLoading.value = false;
    }
  }
}

//Add
class Addaddresses extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future addfechaddresses({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? companyname,
    String? address,
    String? city,
    String? state,
    String? country,
    String? countrycode,
    String? zip,
    String? mobileno,
    String? ip_address,
    String? isdefault,
  }) async{
    try{
      isLoading.value = true;
      final url = Uri.parse(AppUrl.addressesfeach);
      final body =  {
        'id' : id,
        'firstname' : firstname,
        'lastname' : lastname,
        'email' : email,
        'companyname' : companyname,
        'address' : address,
        'city' : city,
        'state' : state,
        'country' : country,
        'countrycode' : country,
        'zip' : zip,
        'mobileno' : mobileno,
        'ip_address' : ip_address,
        'isdefault' : isdefault,
      }..removeWhere((key,value) => value == null);
      print("Sending Add_addresses body :- $body");
      print("Sending Request To :- $url");
      final responce =  await http.post(url,body: body,headers: {ApiHeaders.heading: ApiHeaders.peramitters,ApiHeaders.authorization : tokans});
      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log("Addresses :- ${data.value}");
      }else{
        throw{
          'Addresses Error this :-  ${responce.statusCode}, ${responce.body}',
          handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print("Addresses Error this :- $e");
    }finally{
      isLoading.value = false;
    }
  }
}

//SetDefult
class SetDeflutAddress extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;
  Future setDefult({String? id}) async{
    try{
      isLoading.value = true;
      final url = Uri.parse('${AppUrl.setdefault}/$id');
      final responce = await http.get(url,headers: {ApiHeaders.heading : ApiHeaders.peramitters, ApiHeaders.authorization : tokans});

      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log('SetDefult data :- ${data.value}');
      }else{
        throw{
          'SetDefult data Error :- ${responce.statusCode}, ${responce.body}',
          handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print('SetDefult data Error :- $e');
    }finally{
      isLoading.value =  false;
    }
  }
}

//Delet
class DeletAddress extends GetxController{
  var isLoading = false.obs;
  var data = {}.obs;

  Future deletaddress({required String id})async{
    isLoading.value =  true;
    try{
      final url =  Uri.parse(AppUrl.deleteaddress);
      final body =  {
        'id' : id
      };
      print("Sending Request To :-  $url");
      print("Sending Request deleted body :- $body");
      final responce = await http.post(url,body: body,headers: {ApiHeaders.heading : ApiHeaders.peramitters, ApiHeaders.authorization :  tokans});

      if(responce.statusCode == 200 || responce.statusCode == 201){
        data.value = jsonDecode(responce.body);
        log("Delet Address To :-  ${data.value}");
        ToastificationSuccess.Success(data['message']);
      }else{
        throw{
          'Delet Address Error to :- ${responce.statusCode}, ${responce.body}',
           handleHttpError(responce.statusCode),
        };
      }
    }catch(e){
      print("Delet Address Error to  :- $e");
    }finally{
      isLoading.value = false;
    }
  }
}