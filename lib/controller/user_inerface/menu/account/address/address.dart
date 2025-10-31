import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';

import '../../../../../view/screen/menu/account/addresses/editaddresses.dart';

class AddressUserInterface extends GetxController {
  final fech = Get.put(Fechaddresses());
  final delet = Get.put(DeletAddress());
  final setDeflut = Get.put(SetDeflutAddress());

  var selectedIndex = Rx<int?> (null);

  void deflutvalue(int index) async {
    final String id = fech.data['userAdddress'][index]['id'].toString();
    await setDeflut.setDefult(id: id);
    await fech.fechaddresses();
    final defaultIndex = fech.data['userAdddress'].indexWhere((addr) => addr['isdefault'] == 1);
    selectedIndex.value = defaultIndex != -1 ? defaultIndex : null;
    update();
  }

  void isPopSelected(value,fechs,index){
    if (value == 'edit') {
      Get.to(() => Editaddresses(id: fechs['id'].toString()));
    } else if (value == 'delete') {
      delet.deletaddress(id: fech.data['userAdddress'][index]['id'].toString()).then((_) {
        fech.fechaddresses().then((_) {
          update();
        });
      });
    }
  }

  void deleteAddress(fechs) {
    DeletAddress().deletaddress(id: fechs['id'].toString()).then((_){
      fech.fechaddresses().then((_){
        update();
      });
    });
  }
}
