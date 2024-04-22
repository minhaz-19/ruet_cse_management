import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class achievements extends StatefulWidget {
  const achievements({Key? key}) : super(key: key);

  @override
  State<achievements> createState() => _achievementsState();
}

class _achievementsState extends State<achievements> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController post_controller = TextEditingController();
  File? _image;
  var doc_time;
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
    Reference ref =
        FirebaseStorage.instance.ref().child('cse/achievement/$doc_time');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Achievements", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: achievements_widget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Fluttertoast.showToast(msg: 'Please log in to add achievements');
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Center(
                        child: Text(
                      'Add Achievements',
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
                                hintText: 'Heading',
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
                                hintText: 'Description',
                                icon: ImageIcon(
                                    AssetImage('images/description.png')),
                              ),
                              controller: post_controller,
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
                                  .collection('achievement')
                                  .doc('$doc_time');

                              await id.set({
                                'name': name_controller.text,
                                'post': post_controller.text,
                                'image': download_url,
                                'time': doc_time,
                              }).then((value) => Fluttertoast.showToast(
                                          msg: "Achievement Added Successfully")
                                      .catchError((e) {
                                    Fluttertoast.showToast(msg: e!.massage);
                                    name_controller.clear();
                                    post_controller.clear();
                                  }));
                              name_controller.clear();
                              post_controller.clear();
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

class achievements_widget extends StatefulWidget {
  const achievements_widget({super.key});

  @override
  State<achievements_widget> createState() => _achievements_widgetState();
}

class _achievements_widgetState extends State<achievements_widget> {
  Timestamp? timestamp;
  DateTime date = DateTime.now();
  TextEditingController name_controller = TextEditingController();
  TextEditingController post_controller = TextEditingController();
  var get_id = '', get_name = '', get_post = '', get_image_link = '';
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
    Reference ref =
        FirebaseStorage.instance.ref().child('cse/achievement/$timestamp');
    await ref.putFile(_image!);
    download_url = await ref.getDownloadURL();
  }

  final Stream<QuerySnapshot> _noticeStream = FirebaseFirestore.instance
      .collection('cse')
      .doc('information')
      .collection('achievement')
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
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        // Fluttertoast.showToast(msg: '$date');
                        //get_id = data['id'];
                        timestamp = data['time'];
                        date = timestamp!.toDate();
                        get_name = data['name'];
                        get_post = data['post'];
                        get_image_link = data['image'];
                      });

                      if (FirebaseAuth.instance.currentUser != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Center(
                                    child: Text('Customize Achievement')),
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
                                                      'Edit Achievement',
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
                                                                    'Heading',
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
                                                                    'Description',
                                                                icon: ImageIcon(
                                                                    AssetImage(
                                                                        'images/description.png')),
                                                              ),
                                                              controller:
                                                                  post_controller,
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
                                                            if (post_controller
                                                                    .text ==
                                                                '') {
                                                              post_controller
                                                                      .text =
                                                                  get_post;
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
                                                                      'cse/achievement/$timestamp')
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
                                                                    'achievement')
                                                                .doc(
                                                                    '$timestamp');

                                                            await id.update({
                                                              'name':
                                                                  name_controller
                                                                      .text,
                                                              'post':
                                                                  post_controller
                                                                      .text,
                                                              'image':
                                                                  download_url,
                                                              'time': timestamp,
                                                            }).then((value) =>
                                                                Fluttertoast.showToast(
                                                                        msg:
                                                                            "Achievement Updated Successfully")
                                                                    .catchError(
                                                                        (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg: e!
                                                                              .massage);
                                                                  name_controller
                                                                      .clear();
                                                                  post_controller
                                                                      .clear();
                                                                }));
                                                            name_controller
                                                                .clear();
                                                            post_controller
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
                                                .collection('achievement')
                                                .doc('$timestamp')
                                                .delete();
                                            FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    'cse/achievement/$timestamp')
                                                .delete();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Achievement Deleted Successfully');
                                          }),
                                    ],
                                  ),
                                ],
                              );
                            });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please log in to edit achievements');
                      }
                      // long press to choose which 30 to attend the class
                    },
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: data['image'],
                          imageBuilder: (context, imageProvider) => Container(
                            width: double.infinity,
                            height: 400,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        ListTile(
                          title: Text(data['name'] ?? ''),
                          subtitle: Text(data['post'] ?? ''),
                        ),
                      ],
                    ),
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
