import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class contact_member extends StatefulWidget {
  const contact_member({super.key});

  @override
  State<contact_member> createState() => _contact_memberState();
}

class _contact_memberState extends State<contact_member> {
  Future<bool> _onWillPop() async {
    return (_selectedIndex == 0 ? true : set_index_to_zero());
  }

  bool set_index_to_zero() {
    setState(() {
      _selectedIndex = 0;
    });
    return false;
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    teachers(),
    staff(),
    cr(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.black45),
          selectedIconTheme: IconThemeData(
            color: Colors.redAccent,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.blueGrey,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Teachers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Staffs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'CRs',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// contact reachers page

class teachers extends StatefulWidget {
  const teachers({Key? key}) : super(key: key);

  @override
  State<teachers> createState() => _teachersState();
}

class _teachersState extends State<teachers> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  File? _image;
  var file_name;
  final image_picker = ImagePicker();
  String? download_url;
  Timestamp? doc_time;

  Future pick_image() async {
    final pick = await image_picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        setState(() {
          file_name = basename(_image!.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'Please select an image');
      }
    });
  }

  Future upload_image() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('cse/contact member/teacher/$doc_time');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teachers", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: teacher_widget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Fluttertoast.showToast(msg: 'Please log in to add a teacher');
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Center(
                        child: Text(
                      'Add  Teacher',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'Name',
                                icon:
                                    ImageIcon(AssetImage('images/heading.png')),
                              ),
                              controller: name_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'email',
                                icon: Icon(Icons.email),
                              ),
                              controller: email_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'contact number',
                                icon: Icon(Icons.phone),
                              ),
                              controller: contact_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                                // pick image
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(color: Colors.black45)),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () {
                                  pick_image();
                                },
                                child: const Text(
                                  'Pick an image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          child: const Text("Submit"),
                          onPressed: () async {
                            if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: 'Please choose an image');
                            } else {
                              Navigator.of(context)
                                  .pop(); // popping the dialog box. Notice will update in the background if device is not online
                              doc_time = Timestamp.now();
                              await upload_image();
                              var id = FirebaseFirestore.instance
                                  .collection('cse')
                                  .doc('information')
                                  .collection('contact member')
                                  .doc('post')
                                  .collection('teacher')
                                  .doc('$doc_time');

                              id.set({
                                'name': name_controller.text,
                                'email': email_controller.text,
                                'contact': contact_controller.text,
                                'image': download_url,
                                'time': doc_time,
                              }).then((value) => Fluttertoast.showToast(
                                          msg: "Teacher Added Successfully")
                                      .catchError((e) {
                                    Fluttertoast.showToast(msg: e!.massage);
                                    name_controller.clear();
                                    email_controller.clear();
                                  }));
                              name_controller.clear();
                              contact_controller.clear();
                              email_controller.clear();
                              setState(() {
                                _image = null;
                              });
                            }
                          })
                    ],
                  );
                });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

class teacher_widget extends StatefulWidget {
  const teacher_widget({super.key});

  @override
  State<teacher_widget> createState() => _teacher_widgetState();
}

class _teacher_widgetState extends State<teacher_widget> {
  Timestamp? timestamp;
  DateTime date = DateTime.now();
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  var get_id = '',
      get_name = '',
      get_email = '',
      get_image_link = '',
      get_contact = '';
  File? _image;
  var file_name;
  final image_picker = ImagePicker();
  String? download_url;

  Future pick_image() async {
    final pick = await image_picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        setState(() {
          file_name = basename(_image!.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'Please select an image');
      }
    });
  }

  Future upload_image() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('cse/contact member/teacher/$timestamp');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  final Stream<QuerySnapshot> _noticeStream = FirebaseFirestore.instance
      .collection('cse')
      .doc('information')
      .collection('contact member')
      .doc('post')
      .collection('teacher')
      .orderBy('time', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _noticeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListTile(
                    onLongPress: () {
                      setState(() {
                        // Fluttertoast.showToast(msg: '$date');
                        //get_id = data['id'];
                        timestamp = data['time'];
                        date = timestamp!.toDate();
                        get_name = data['name'];
                        get_email = data['email'];
                        get_contact = data['contact'];
                        get_image_link = data['image'];
                      });

                      if (FirebaseAuth.instance.currentUser != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Center(
                                    child: Text('Customize Contact Teacher')),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: const Text("Edit"),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(); // popping the dialog box. routine will update in the background if device is not online

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: const Center(
                                                        child: Text(
                                                      'Edit Contact Teacher',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Form(
                                                        child: Column(
                                                          children: <Widget>[
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Name',
                                                                icon: ImageIcon(
                                                                    AssetImage(
                                                                        'images/heading.png')),
                                                              ),
                                                              controller:
                                                                  name_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Email',
                                                                icon: Icon(Icons
                                                                    .email),
                                                              ),
                                                              controller:
                                                                  email_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Contact No',
                                                                icon: Icon(Icons
                                                                    .phone),
                                                              ),
                                                              controller:
                                                                  contact_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            MaterialButton(
                                                                // pick image
                                                                height: 60,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black45)),
                                                                padding: const EdgeInsets
                                                                        .fromLTRB(
                                                                    20, 15, 20, 15),
                                                                minWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                onPressed: () {
                                                                  pick_image();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Pick an image',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blueGrey,
                                                          ),
                                                          child: const Text(
                                                              "Submit"),
                                                          onPressed: () async {
                                                            if (name_controller
                                                                    .text ==
                                                                '') {
                                                              name_controller
                                                                      .text =
                                                                  get_name;
                                                            }
                                                            if (email_controller
                                                                    .text ==
                                                                '') {
                                                              email_controller
                                                                      .text =
                                                                  get_email;
                                                            }
                                                            if (contact_controller
                                                                    .text ==
                                                                '') {
                                                              contact_controller
                                                                      .text =
                                                                  get_contact;
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // popping the dialog box. Notice will update in the background if device is not online
                                                            if (_image ==
                                                                null) {
                                                              setState(() {
                                                                download_url =
                                                                    data[
                                                                        'image'];
                                                              });
                                                            } else {
                                                              await FirebaseStorage
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      'cse/contact member/teacher/$timestamp')
                                                                  .delete();
                                                              await upload_image();
                                                            }

                                                            var id = FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'cse')
                                                                .doc(
                                                                    'information')
                                                                .collection(
                                                                    'contact member')
                                                                .doc('post')
                                                                .collection(
                                                                    'teacher')
                                                                .doc(
                                                                    '$timestamp');

                                                            await id.update({
                                                              'name':
                                                                  name_controller
                                                                      .text,
                                                              'email':
                                                                  email_controller
                                                                      .text,
                                                              'contact':
                                                                  contact_controller
                                                                      .text,
                                                              'image':
                                                                  download_url,
                                                              'time': timestamp,
                                                            }).then((value) =>
                                                                Fluttertoast.showToast(
                                                                        msg:
                                                                            "Contact Teacher Updated Successfully")
                                                                    .catchError(
                                                                        (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg: e!
                                                                              .massage);
                                                                  name_controller
                                                                      .clear();
                                                                  email_controller
                                                                      .clear();
                                                                  contact_controller
                                                                      .clear();
                                                                }));
                                                            name_controller
                                                                .clear();
                                                            email_controller
                                                                .clear();
                                                            contact_controller
                                                                .clear();
                                                            setState(() {
                                                              _image = null;
                                                            });
                                                          })
                                                    ],
                                                  );
                                                });
                                          }),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: const Text("Delete"),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(); // popping the dialog box. routine will update in the background if device is not online

                                            FirebaseFirestore.instance
                                                .collection('cse')
                                                .doc('information')
                                                .collection('contact member')
                                                .doc('post')
                                                .collection('teacher')
                                                .doc('$timestamp')
                                                .delete();
                                            FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'cse/contact member/teacher/$timestamp')
                                                .delete();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Contact Teacher Deleted Successfully');
                                          }),
                                    ],
                                  ),
                                ],
                              );
                            });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please log in to edit Contact Teacher');
                      }
                      // long press to choose which 30 to attend the class
                    },
                    leading: CachedNetworkImage(
                      imageUrl: data['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(data['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['email'] ?? ''),
                        Text(data['contact'] ?? '')
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                                  ClipboardData(text: data['contact']))
                              .then((value) => Fluttertoast.showToast(
                                  msg: 'Contact number copied'));
                        },
                        icon: Icon(Icons.copy)),
                  ),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}

class staff extends StatefulWidget {
  const staff({super.key});

  @override
  State<staff> createState() => _staffState();
}

class _staffState extends State<staff> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  File? _image;
  var file_name;
  final image_picker = ImagePicker();
  String? download_url;
  Timestamp? doc_time;

  Future pick_image() async {
    final pick = await image_picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        setState(() {
          file_name = basename(_image!.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'Please select an image');
      }
    });
  }

  Future upload_image() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('cse/contact member/staff/$doc_time');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Staffs", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: staff_widget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Fluttertoast.showToast(msg: 'Please log in to add a staff');
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Center(
                        child: Text(
                      'Add  Staff',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'Name',
                                icon:
                                    ImageIcon(AssetImage('images/heading.png')),
                              ),
                              controller: name_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'email',
                                icon: Icon(Icons.email),
                              ),
                              controller: email_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'contact number',
                                icon: Icon(Icons.phone),
                              ),
                              controller: contact_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                                // pick image
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(color: Colors.black45)),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () {
                                  pick_image();
                                },
                                child: const Text(
                                  'Pick an image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          child: const Text("Submit"),
                          onPressed: () async {
                            if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: 'Please choose an image');
                            } else {
                              Navigator.of(context)
                                  .pop(); // popping the dialog box. Notice will update in the background if device is not online
                              doc_time = Timestamp.now();
                              await upload_image();
                              var id = FirebaseFirestore.instance
                                  .collection('cse')
                                  .doc('information')
                                  .collection('contact member')
                                  .doc('post')
                                  .collection('staff')
                                  .doc('$doc_time');

                              id.set({
                                'name': name_controller.text,
                                'email': email_controller.text,
                                'contact': contact_controller.text,
                                'image': download_url,
                                'time': doc_time,
                              }).then((value) => Fluttertoast.showToast(
                                          msg: "Staff Added Successfully")
                                      .catchError((e) {
                                    Fluttertoast.showToast(msg: e!.massage);
                                    name_controller.clear();
                                    email_controller.clear();
                                  }));
                              name_controller.clear();
                              contact_controller.clear();
                              email_controller.clear();
                              setState(() {
                                _image = null;
                              });
                            }
                          })
                    ],
                  );
                });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

class staff_widget extends StatefulWidget {
  const staff_widget({super.key});

  @override
  State<staff_widget> createState() => _staff_widgetState();
}

class _staff_widgetState extends State<staff_widget> {
  Timestamp? timestamp;
  DateTime date = DateTime.now();
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  var get_id = '',
      get_name = '',
      get_email = '',
      get_image_link = '',
      get_contact = '';
  File? _image;
  var file_name;
  final image_picker = ImagePicker();
  String? download_url;

  Future pick_image() async {
    final pick = await image_picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        setState(() {
          file_name = basename(_image!.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'Please select an image');
      }
    });
  }

  Future upload_image() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('cse/contact member/staff/$timestamp');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  final Stream<QuerySnapshot> _noticeStream = FirebaseFirestore.instance
      .collection('cse')
      .doc('information')
      .collection('contact member')
      .doc('post')
      .collection('staff')
      .orderBy('time', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _noticeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListTile(
                    onLongPress: () {
                      setState(() {
                        // Fluttertoast.showToast(msg: '$date');
                        //get_id = data['id'];
                        timestamp = data['time'];
                        date = timestamp!.toDate();
                        get_name = data['name'];
                        get_email = data['email'];
                        get_contact = data['contact'];
                        get_image_link = data['image'];
                      });

                      if (FirebaseAuth.instance.currentUser != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Center(
                                    child: Text('Customize Contact Staff')),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: const Text("Edit"),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(); // popping the dialog box. routine will update in the background if device is not online

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: const Center(
                                                        child: Text(
                                                      'Edit Contact Staff',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Form(
                                                        child: Column(
                                                          children: <Widget>[
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Name',
                                                                icon: ImageIcon(
                                                                    AssetImage(
                                                                        'images/heading.png')),
                                                              ),
                                                              controller:
                                                                  name_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Email',
                                                                icon: Icon(Icons
                                                                    .email),
                                                              ),
                                                              controller:
                                                                  email_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Contact No',
                                                                icon: Icon(Icons
                                                                    .phone),
                                                              ),
                                                              controller:
                                                                  contact_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            MaterialButton(
                                                                // pick image
                                                                height: 60,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black45)),
                                                                padding: const EdgeInsets
                                                                        .fromLTRB(
                                                                    20, 15, 20, 15),
                                                                minWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                onPressed: () {
                                                                  pick_image();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Pick an image',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blueGrey,
                                                          ),
                                                          child: const Text(
                                                              "Submit"),
                                                          onPressed: () async {
                                                            if (name_controller
                                                                    .text ==
                                                                '') {
                                                              name_controller
                                                                      .text =
                                                                  get_name;
                                                            }
                                                            if (email_controller
                                                                    .text ==
                                                                '') {
                                                              email_controller
                                                                      .text =
                                                                  get_email;
                                                            }
                                                            if (contact_controller
                                                                    .text ==
                                                                '') {
                                                              contact_controller
                                                                      .text =
                                                                  get_contact;
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // popping the dialog box. Notice will update in the background if device is not online
                                                            if (_image ==
                                                                null) {
                                                              setState(() {
                                                                download_url =
                                                                    data[
                                                                        'image'];
                                                              });
                                                            } else {
                                                              await FirebaseStorage
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      'cse/contact member/staff/$timestamp')
                                                                  .delete();
                                                              await upload_image();
                                                            }

                                                            var id = FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'cse')
                                                                .doc(
                                                                    'information')
                                                                .collection(
                                                                    'contact member')
                                                                .doc('post')
                                                                .collection(
                                                                    'staff')
                                                                .doc(
                                                                    '$timestamp');

                                                            await id.update({
                                                              'name':
                                                                  name_controller
                                                                      .text,
                                                              'email':
                                                                  email_controller
                                                                      .text,
                                                              'contact':
                                                                  contact_controller
                                                                      .text,
                                                              'image':
                                                                  download_url,
                                                              'time': timestamp,
                                                            }).then((value) =>
                                                                Fluttertoast.showToast(
                                                                        msg:
                                                                            "Contact Staff Updated Successfully")
                                                                    .catchError(
                                                                        (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg: e!
                                                                              .massage);
                                                                  name_controller
                                                                      .clear();
                                                                  email_controller
                                                                      .clear();
                                                                  contact_controller
                                                                      .clear();
                                                                }));
                                                            name_controller
                                                                .clear();
                                                            email_controller
                                                                .clear();
                                                            contact_controller
                                                                .clear();
                                                            setState(() {
                                                              _image = null;
                                                            });
                                                          })
                                                    ],
                                                  );
                                                });
                                          }),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: const Text("Delete"),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(); // popping the dialog box. routine will update in the background if device is not online

                                            FirebaseFirestore.instance
                                                .collection('cse')
                                                .doc('information')
                                                .collection('contact member')
                                                .doc('post')
                                                .collection('staff')
                                                .doc('$timestamp')
                                                .delete();
                                            FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'cse/contact member/staff/$timestamp')
                                                .delete();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Contact Staff Deleted Successfully');
                                          }),
                                    ],
                                  ),
                                ],
                              );
                            });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please log in to edit Contact Staff');
                      }
                      // long press to choose which 30 to attend the class
                    },
                    leading: CachedNetworkImage(
                      imageUrl: data['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(data['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['email'] ?? ''),
                        Text(data['contact'] ?? '')
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                                  ClipboardData(text: data['contact']))
                              .then((value) => Fluttertoast.showToast(
                                  msg: 'Contact number copied'));
                        },
                        icon: Icon(Icons.copy)),
                  ),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}

class cr extends StatefulWidget {
  const cr({super.key});

  @override
  State<cr> createState() => _crState();
}

class _crState extends State<cr> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  File? _image;
  var file_name;
  final image_picker = ImagePicker();
  String? download_url;
  Timestamp? doc_time;

  Future pick_image() async {
    final pick = await image_picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        setState(() {
          file_name = basename(_image!.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'Please select an image');
      }
    });
  }

  Future upload_image() async {
    Reference ref =
        FirebaseStorage.instance.ref().child('cse/contact member/cr/$doc_time');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRs", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: cr_widget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Fluttertoast.showToast(msg: 'Please log in to add a CR');
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Center(
                        child: Text(
                      'Add  CR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'Name',
                                icon:
                                    ImageIcon(AssetImage('images/heading.png')),
                              ),
                              controller: name_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'email',
                                icon: Icon(Icons.email),
                              ),
                              controller: email_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusColor: Colors.blueGrey,
                                iconColor: Colors.blueGrey,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey)),
                                hintText: 'contact number',
                                icon: Icon(Icons.phone),
                              ),
                              controller: contact_controller,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                                // pick image
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(color: Colors.black45)),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () {
                                  pick_image();
                                },
                                child: const Text(
                                  'Pick an image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          child: const Text("Submit"),
                          onPressed: () async {
                            if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: 'Please choose an image');
                            } else {
                              Navigator.of(context)
                                  .pop(); // popping the dialog box. Notice will update in the background if device is not online
                              doc_time = Timestamp.now();
                              await upload_image();
                              var id = FirebaseFirestore.instance
                                  .collection('cse')
                                  .doc('information')
                                  .collection('contact member')
                                  .doc('post')
                                  .collection('cr')
                                  .doc('$doc_time');

                              id.set({
                                'name': name_controller.text,
                                'email': email_controller.text,
                                'contact': contact_controller.text,
                                'image': download_url,
                                'time': doc_time,
                              }).then((value) => Fluttertoast.showToast(
                                          msg: "CR Added Successfully")
                                      .catchError((e) {
                                    Fluttertoast.showToast(msg: e!.massage);
                                    name_controller.clear();
                                    email_controller.clear();
                                  }));
                              name_controller.clear();
                              contact_controller.clear();
                              email_controller.clear();
                              setState(() {
                                _image = null;
                              });
                            }
                          })
                    ],
                  );
                });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

class cr_widget extends StatefulWidget {
  const cr_widget({super.key});

  @override
  State<cr_widget> createState() => _cr_widgetState();
}

class _cr_widgetState extends State<cr_widget> {
  Timestamp? timestamp;
  DateTime date = DateTime.now();
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  var get_id = '',
      get_name = '',
      get_email = '',
      get_image_link = '',
      get_contact = '';
  File? _image;
  var file_name;
  final image_picker = ImagePicker();
  String? download_url;

  Future pick_image() async {
    final pick = await image_picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        setState(() {
          file_name = basename(_image!.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'Please select an image');
      }
    });
  }

  Future upload_image() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('cse/contact member/cr/$timestamp');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  final Stream<QuerySnapshot> _noticeStream = FirebaseFirestore.instance
      .collection('cse')
      .doc('information')
      .collection('contact member')
      .doc('post')
      .collection('cr')
      .orderBy('time', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _noticeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListTile(
                    onLongPress: () {
                      setState(() {
                        // Fluttertoast.showToast(msg: '$date');
                        //get_id = data['id'];
                        timestamp = data['time'];
                        date = timestamp!.toDate();
                        get_name = data['name'];
                        get_email = data['email'];
                        get_contact = data['contact'];
                        get_image_link = data['image'];
                      });

                      if (FirebaseAuth.instance.currentUser != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Center(
                                    child: Text('Customize Contact Staff')),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: const Text("Edit"),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(); // popping the dialog box. routine will update in the background if device is not online

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: const Center(
                                                        child: Text(
                                                      'Edit Contact CR',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Form(
                                                        child: Column(
                                                          children: <Widget>[
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Name',
                                                                icon: ImageIcon(
                                                                    AssetImage(
                                                                        'images/heading.png')),
                                                              ),
                                                              controller:
                                                                  name_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Email',
                                                                icon: Icon(Icons
                                                                    .email),
                                                              ),
                                                              controller:
                                                                  email_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            TextFormField(
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusColor: Colors
                                                                    .blueGrey,
                                                                iconColor: Colors
                                                                    .blueGrey,
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blueGrey)),
                                                                hintText:
                                                                    'Contact No',
                                                                icon: Icon(Icons
                                                                    .phone),
                                                              ),
                                                              controller:
                                                                  contact_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            MaterialButton(
                                                                // pick image
                                                                height: 60,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black45)),
                                                                padding: const EdgeInsets
                                                                        .fromLTRB(
                                                                    20, 15, 20, 15),
                                                                minWidth:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                onPressed: () {
                                                                  pick_image();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Pick an image',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blueGrey,
                                                          ),
                                                          child: const Text(
                                                              "Submit"),
                                                          onPressed: () async {
                                                            if (name_controller
                                                                    .text ==
                                                                '') {
                                                              name_controller
                                                                      .text =
                                                                  get_name;
                                                            }
                                                            if (email_controller
                                                                    .text ==
                                                                '') {
                                                              email_controller
                                                                      .text =
                                                                  get_email;
                                                            }
                                                            if (contact_controller
                                                                    .text ==
                                                                '') {
                                                              contact_controller
                                                                      .text =
                                                                  get_contact;
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // popping the dialog box. Notice will update in the background if device is not online
                                                            if (_image ==
                                                                null) {
                                                              setState(() {
                                                                download_url =
                                                                    data[
                                                                        'image'];
                                                              });
                                                            } else {
                                                              await FirebaseStorage
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      'cse/contact member/cr/$timestamp')
                                                                  .delete();
                                                              await upload_image();
                                                            }

                                                            var id = FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'cse')
                                                                .doc(
                                                                    'information')
                                                                .collection(
                                                                    'contact member')
                                                                .doc('post')
                                                                .collection(
                                                                    'cr')
                                                                .doc(
                                                                    '$timestamp');

                                                            await id.update({
                                                              'name':
                                                                  name_controller
                                                                      .text,
                                                              'email':
                                                                  email_controller
                                                                      .text,
                                                              'contact':
                                                                  contact_controller
                                                                      .text,
                                                              'image':
                                                                  download_url,
                                                              'time': timestamp,
                                                            }).then((value) =>
                                                                Fluttertoast.showToast(
                                                                        msg:
                                                                            "Contact CR Updated Successfully")
                                                                    .catchError(
                                                                        (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg: e!
                                                                              .massage);
                                                                  name_controller
                                                                      .clear();
                                                                  email_controller
                                                                      .clear();
                                                                  contact_controller
                                                                      .clear();
                                                                }));
                                                            name_controller
                                                                .clear();
                                                            email_controller
                                                                .clear();
                                                            contact_controller
                                                                .clear();
                                                            setState(() {
                                                              _image = null;
                                                            });
                                                          })
                                                    ],
                                                  );
                                                });
                                          }),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: const Text("Delete"),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(); // popping the dialog box. routine will update in the background if device is not online

                                            FirebaseFirestore.instance
                                                .collection('cse')
                                                .doc('information')
                                                .collection('contact member')
                                                .doc('post')
                                                .collection('cr')
                                                .doc('$timestamp')
                                                .delete();
                                            FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'cse/contact member/cr/$timestamp')
                                                .delete();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Contact CR Deleted Successfully');
                                          }),
                                    ],
                                  ),
                                ],
                              );
                            });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please log in to edit Contact CR');
                      }
                      // long press to choose which 30 to attend the class
                    },
                    leading: CachedNetworkImage(
                      imageUrl: data['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(data['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['email'] ?? ''),
                        Text(data['contact'] ?? '')
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                                  ClipboardData(text: data['contact']))
                              .then((value) => Fluttertoast.showToast(
                                  msg: 'Contact number copied'));
                        },
                        icon: Icon(Icons.copy)),
                  ),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}
