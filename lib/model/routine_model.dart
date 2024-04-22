import 'package:flutter/material.dart';

import '../custom_widget.dart';

class routine_model extends StatefulWidget {
  String year;
  String day;

  routine_model(this.year, this.day);

  @override
  State<routine_model> createState() => _routine_modelState();
}

class _routine_modelState extends State<routine_model> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.day.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.rectangle,
                              color: Color.fromARGB(
                                255,
                                51,
                                190,
                                74,
                              )),
                          Text('  First 30')
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.rectangle,
                              color: Color.fromARGB(255, 99, 132, 252)),
                          Text('  Second 30')
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Table(
                children: [
                  TableRow(children: [
                    // heading of the table
                    TableCell(
                        child: Container(
                      margin: EdgeInsets.fromLTRB(2.5, 5.1, 2.5, 5.1),
                      padding: const EdgeInsets.fromLTRB(4.0, 4.1, 4.0, 4.1),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 242, 102, 195),
                        border: Border.all(
                          width: 3,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Icon(Icons.alarm),
                    )),
                    table_heading(
                        "Section A", Color.fromARGB(255, 242, 102, 195)),
                    table_heading(
                        "Section B", Color.fromARGB(255, 242, 102, 195)),
                    table_heading(
                        "Section C", Color.fromARGB(255, 242, 102, 195))
                  ]),
                  TableRow(children: [
                    // first period
                    period_time("8.00", "8.50",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '1'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '1'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '1'), // section C
                  ]),
                  TableRow(children: [
                    // second period
                    period_time("8.50", "9.40",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '2'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '2'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '2'), // section C
                  ]),
                  TableRow(children: [
                    // third period
                    period_time("9.40", "10.30",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '3'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '3'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '3'), // section C
                  ]),
                  TableRow(children: [
                    // fourth period
                    period_time("10.50", "11.40",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '4'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '4'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '4'), // section C
                  ]),
                  TableRow(children: [
                    // fifth period
                    period_time("11.40", "12.30",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '5'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '5'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '5'), // section C
                  ]),
                  TableRow(children: [
                    // sixth period
                    period_time("12.30", "1.20",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '6'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '6'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '6'), // section C
                  ]),
                  TableRow(children: [
                    // seventh period
                    period_time("2.30", "3.20",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '7'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '7'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '7'), // section C
                  ]),
                  TableRow(children: [
                    // eighth period
                    period_time("3.20", "4.10",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '8'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '8'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '8'), // section C
                  ]),
                  TableRow(children: [
                    // nineth period
                    period_time("4.10", "5.00",
                        Color.fromARGB(255, 245, 113, 103)), // class time
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section a', '9'), // section A
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section b', '9'), // section B
                    subject_teacher_and_room_no(
                        widget.year, widget.day, 'section c', '9'), // section C
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
