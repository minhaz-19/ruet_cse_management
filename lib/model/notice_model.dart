import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class notice {
  final CollectionReference notice_reference = FirebaseFirestore.instance
      .collection('cse')
      .doc('information')
      .collection('notice');

  Future get_notice() async {
    List notice_list = [];

    try {
      await notice_reference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          notice_list.add(element.data());
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error! \n$e');
    }
  }
}
