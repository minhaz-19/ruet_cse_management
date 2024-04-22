import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ruet_cse_management/schedule/routine_home_pages.dart';
import 'package:ruet_cse_management/screens/home_drawer.dart';
var name = '', email = '', image = '', uid, password = '';

class admin_home extends StatefulWidget {
  const admin_home({Key? key}) : super(key: key);

  @override
  State<admin_home> createState() => _admin_homeState();
}

class _admin_homeState extends State<admin_home> {
  String day = 'saturday';
  var hour = 0;
  var minute = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        uid = FirebaseAuth.instance.currentUser!.uid;

        FirebaseFirestore.instance
            .collection('admin')
            .doc(uid)
            .snapshots()
            .listen(
          (event) {
            final data = event.data() as Map<String, dynamic>;
            setState(() {
              name = data['name'];
              email = data['email'];
              image = data['image'];
              password = data['password'];
            });
          },
          onError: (error) =>
              Fluttertoast.showToast(msg: "Listen failed: $error"),
        );
      });
    }

    day = DateFormat('EEEE').format(DateTime.now());
    TimeOfDay time = TimeOfDay.now();
    hour = time.hour;
    minute = time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RUET CSE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: admin_home_drawer(),
      body: home_page_ongoing_classes(day, hour, minute),
    );
  }
}
