import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

// heading row for the table
class table_heading extends StatelessWidget {
  String show;
  var background_color;
  table_heading(this.show, this.background_color);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        margin: EdgeInsets.fromLTRB(2.5, 5, 2.5, 5),
        decoration: BoxDecoration(
            color: background_color,
            border: Border.all(
              width: 3,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
          child: Column(
            children: [
              AutoSizeText(
                show,
                maxLines: 1,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// updating the routine from taking information from the admin and aslo sending it to database

class subject_teacher_and_room_no extends StatefulWidget {
  String year;
  String day;
  String section;
  dynamic period;

  subject_teacher_and_room_no(
    this.year,
    this.day,
    this.section,
    this.period,
  );

  @override
  State<subject_teacher_and_room_no> createState() =>
      _subject_teacher_and_room_noState();
}

class _subject_teacher_and_room_noState
    extends State<subject_teacher_and_room_no> {
  String course_name = 'subject';
  String course_teacher = 'teacher';
  String room_no = 'room';
  var preference = 3;

  TextEditingController course_controller = TextEditingController();
  TextEditingController teacher_controller = TextEditingController();
  TextEditingController room_controller = TextEditingController();

  // reading data from server

  @override
  void initState() {
    super.initState();
    setState(() {
      final docRef = firebaseFirestore
          .collection("cse")
          .doc("routine")
          .collection(widget.year)
          .doc(widget.day)
          .collection(widget.section)
          .doc('period ${widget.period}');
      docRef.snapshots().listen(
        (event) {
          final data = event.data() as Map<String, dynamic>;
          setState(() {
            course_name = data['course'];
            course_teacher = data['teacher'];
            room_no = data['room'];
            preference = data['preference'];
          });
        },
        onError: (error) =>
            Fluttertoast.showToast(msg: "Listen failed: $error"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          onLongPress: () {
            if (FirebaseAuth.instance.currentUser != null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Center(child: Text('Set preference')),
                      content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Who will attend the class?')),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                ),
                                child: const Text("1st 30"),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // popping the dialog box. routine will update in the background if device is not online

                                  await firebaseFirestore
                                      .collection('cse')
                                      .doc('routine')
                                      .collection(widget.year)
                                      .doc(widget.day)
                                      .collection(widget.section)
                                      .doc('period ${widget.period}')
                                      .update({
                                    'preference': 1,
                                  }).then((value) => Fluttertoast.showToast(
                                                  msg:
                                                      "Routine Updated Successfully")
                                              .catchError((e) {
                                            Fluttertoast.showToast(
                                                msg: e!.massage);
                                          }));
                                }),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                ),
                                child: const Text("2nd 30"),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // popping the dialog box. routine will update in the background if device is not online

                                  await firebaseFirestore
                                      .collection('cse')
                                      .doc('routine')
                                      .collection(widget.year)
                                      .doc(widget.day)
                                      .collection(widget.section)
                                      .doc('period ${widget.period}')
                                      .update({'preference': 2}).then((value) =>
                                          Fluttertoast.showToast(
                                                  msg:
                                                      "Routine Updated Successfully")
                                              .catchError((e) {
                                            Fluttertoast.showToast(
                                                msg: e!.massage);
                                          }));
                                }),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                ),
                                child: const Text("All"),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // popping the dialog box. routine will update in the background if device is not online

                                  await firebaseFirestore
                                      .collection('cse')
                                      .doc('routine')
                                      .collection(widget.year)
                                      .doc(widget.day)
                                      .collection(widget.section)
                                      .doc('period ${widget.period}')
                                      .update({'preference': 3}).then((value) =>
                                          Fluttertoast.showToast(
                                                  msg:
                                                      "Routine Updated Successfully")
                                              .catchError((e) {
                                            Fluttertoast.showToast(
                                                msg: e!.massage);
                                          }));
                                })
                          ],
                        ),
                      ],
                    );
                  });
            } else {
              Fluttertoast.showToast(msg: 'Please log in to edit routine');
            }
            // long press to choose which 30 to attend the class
          },
          onDoubleTap: () {
            if (FirebaseAuth.instance.currentUser != null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Center(child: Text('Update Routine')),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.subject),
                                    hintText: 'Subject'),
                                controller: course_controller,
                                textInputAction: TextInputAction.next,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.person),
                                    hintText: 'Teacher'),
                                controller: teacher_controller,
                                textInputAction: TextInputAction.next,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.room),
                                    hintText: 'Room no'),
                                controller: room_controller,
                                textInputAction: TextInputAction.done,
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
                                  .pop(); // popping the dialog box. routine will update in the background if device is not online
                              if (teacher_controller.text == '') {
                                teacher_controller.text = course_teacher;
                              }
                              if (course_controller.text == '') {
                                course_controller.text = course_name;
                              }
                              if (room_controller.text == '') {
                                room_controller.text = room_no;
                              }
                              await firebaseFirestore
                                  .collection('cse')
                                  .doc('routine')
                                  .collection(widget.year)
                                  .doc(widget.day)
                                  .collection(widget.section)
                                  .doc('period ${widget.period}')
                                  .update({
                                'course': course_controller.text,
                                'teacher': teacher_controller.text,
                                'room': room_controller.text,
                              }).then((value) => Fluttertoast.showToast(
                                              msg:
                                                  "Routine Updated Successfully")
                                          .catchError((e) {
                                        Fluttertoast.showToast(msg: e!.massage);
                                      }));
                            })
                      ],
                    );
                  });
            } else {
              Fluttertoast.showToast(msg: 'Please log in to edit routine');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: preference == 1
                  ? Color.fromARGB(255, 51, 190, 74)
                  : (preference == 2
                      ? Color.fromARGB(255, 99, 132, 252)
                      : Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
              child: Column(
                children: [
                  AutoSizeText(
                    course_name.toString(),
                    maxLines: 1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  AutoSizeText(
                    course_teacher.toString(),
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black),
                  ),
                  AutoSizeText(
                    room_no.toString(),
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class period_time extends StatelessWidget {
  String start, end;
  var background_color;
  period_time(this.start, this.end, this.background_color, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
                color: background_color,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
              child: Column(
                children: [
                  AutoSizeText(
                    start,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const AutoSizeText(
                    'to',
                  ),
                  AutoSizeText(
                    end,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
