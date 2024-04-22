import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class notice extends StatefulWidget {
  @override
  State<notice> createState() => _noticeState();
}

class _noticeState extends State<notice> {
  Timestamp? timestamp;
  TextEditingController heading_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: notice_widget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Fluttertoast.showToast(msg: 'Please log in to add notice');
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Center(
                        child: Text(
                      'Add Notice',
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
                              controller: heading_controller,
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
                              controller: description_controller,
                              textInputAction: TextInputAction.next,
                            ),
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
                            Navigator.of(context)
                                .pop(); // popping the dialog box. Notice will update in the background if device is not online
                            var doc_time = Timestamp.now();
                            var id = FirebaseFirestore.instance
                                .collection('cse')
                                .doc('information')
                                .collection('notice')
                                .doc('$doc_time');

                            await id.set({
                              'heading': heading_controller.text,
                              'description': description_controller.text,
                              'time': doc_time,
                            }).then((value) => Fluttertoast.showToast(
                                        msg: "Notice Added Successfully")
                                    .catchError((e) {
                                  Fluttertoast.showToast(msg: e!.massage);
                                  heading_controller.clear();
                                  description_controller.clear();
                                }));
                            heading_controller.clear();
                            description_controller.clear();
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

class notice_widget extends StatefulWidget {
  const notice_widget({super.key});

  @override
  State<notice_widget> createState() => _notice_widgetState();
}

class _notice_widgetState extends State<notice_widget> {
  Timestamp? timestamp;
  DateTime date = DateTime.now();
  TextEditingController heading_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  var get_id = '', get_heading = '', get_description = '';
  final Stream<QuerySnapshot> _noticeStream = FirebaseFirestore.instance
      .collection('cse')
      .doc('information')
      .collection('notice')
      .orderBy('time', descending: true)
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
                        get_heading = data['heading'];
                        get_description = data['description'];
                      });

                      if (FirebaseAuth.instance.currentUser != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Center(
                                    child: Text('Customize Notice')),
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
                                                      'Edit Notice',
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
                                                                  heading_controller,
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
                                                                  description_controller,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                            ),
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // popping the dialog box. Notice will update in the background if device is not online

                                                            if (heading_controller
                                                                    .text ==
                                                                '') {
                                                              heading_controller
                                                                      .text =
                                                                  get_heading;
                                                            }
                                                            if (description_controller
                                                                    .text ==
                                                                '') {
                                                              description_controller
                                                                      .text =
                                                                  get_description;
                                                            }

                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'cse')
                                                                .doc(
                                                                    'information')
                                                                .collection(
                                                                    'notice')
                                                                .doc(
                                                                    '$timestamp')
                                                                .update({
                                                              'heading':
                                                                  heading_controller
                                                                      .text,
                                                              'description':
                                                                  description_controller
                                                                      .text,
                                                            }).then((value) =>
                                                                    Fluttertoast.showToast(
                                                                            msg:
                                                                                "Notice Updated Successfully")
                                                                        .catchError(
                                                                            (e) {
                                                                      Fluttertoast.showToast(
                                                                          msg: e!
                                                                              .massage);
                                                                      heading_controller
                                                                          .clear();
                                                                      description_controller
                                                                          .clear();
                                                                    }));
                                                            heading_controller
                                                                .clear();
                                                            description_controller
                                                                .clear();
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

                                            Fluttertoast.showToast(
                                                msg:
                                                    'Notice Deleted Successfully');
                                            FirebaseFirestore.instance
                                                .collection('cse')
                                                .doc('information')
                                                .collection('notice')
                                                .doc('$timestamp')
                                                .delete();
                                          }),
                                    ],
                                  ),
                                ],
                              );
                            });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please log in to edit Notice');
                      }
                      // long press to choose which 30 to attend the class
                    },
                    title: Text(data['heading'] ?? ''),
                    subtitle: Text(data['description'] ?? ''),
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
