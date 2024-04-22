import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ruet_cse_management/custom_widget.dart';
import 'package:ruet_cse_management/screens/home_drawer.dart';
import 'package:ruet_cse_management/screens/vacation.dart';

class first_year_home_page extends StatefulWidget {
  @override
  State<first_year_home_page> createState() => _first_year_home_pageState();
}

class _first_year_home_pageState extends State<first_year_home_page> {
  String day = 'saturday';
  var hour = 0;
  var minute = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    day = DateFormat('EEEE').format(DateTime.now());
    TimeOfDay time = TimeOfDay.now();
    hour = time.hour;
    minute = time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Year'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const first_year_drawer(),
      body: ongoing_classes('first year', day, hour, minute),
    );
  }
}

class second_year_home_page extends StatefulWidget {
  @override
  State<second_year_home_page> createState() => _second_year_home_pageState();
}

class _second_year_home_pageState extends State<second_year_home_page> {
  String day = 'saturday';
  var hour = 0;
  var minute = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    day = DateFormat('EEEE').format(DateTime.now());
    TimeOfDay time = TimeOfDay.now();
    hour = time.hour;
    minute = time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Year'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const second_year_drawer(),
      body: ongoing_classes('second year', day, hour, minute),
    );
  }
}

class third_year_home_page extends StatefulWidget {
  const third_year_home_page({super.key});

  @override
  State<third_year_home_page> createState() => _third_year_home_pageState();
}

class _third_year_home_pageState extends State<third_year_home_page> {
  String day = 'saturday';
  var hour = 0;
  var minute = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    day = DateFormat('EEEE').format(DateTime.now());
    TimeOfDay time = TimeOfDay.now();
    hour = time.hour;
    minute = time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Year'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const third_year_drawer(),
      body: ongoing_classes('third year', day, hour, minute),
    );
  }
}

class fourth_year_home_page extends StatefulWidget {
  const fourth_year_home_page({super.key});

  @override
  State<fourth_year_home_page> createState() => _fourth_year_home_pageState();
}

class _fourth_year_home_pageState extends State<fourth_year_home_page> {
  String day = 'saturday';
  var hour = 0;
  var minute = 0;

  @override
  void initState() {
    super.initState();
    day = DateFormat('EEEE').format(DateTime.now());
    TimeOfDay time = TimeOfDay.now();
    hour = time.hour;
    minute = time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fourth Year'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const fourth_year_drawer(),
      body: ongoing_classes('fourth year', day, hour, minute),
    );
  }
}

String ongoing_class_period_ckecker(String day, int hour, int minute) {
  if (day.toUpperCase() == 'FRIDAY' ||
      day.toUpperCase() == 'THURSDAY' ||
      (day.toUpperCase() == 'WEDNESDAY' && hour > 17)) {
    return 'off_day';
  } else if (hour > 17) {
    return '0';
  } else if (hour < 8) {
    return '-11';
  } else if (hour == 8 && minute <= 50) {
    return '1';
  } else if ((hour == 8 && minute > 50) || (hour == 9 && minute <= 40)) {
    return '2';
  } else if ((hour == 9 && minute > 40) || (hour == 10 && minute <= 30)) {
    return '3';
  } else if ((hour == 10 && minute > 30) && (hour == 10 && minute <= 50)) {
    return 'tiffin';
  } else if ((hour == 10 && minute > 50) || (hour == 11 && minute <= 40)) {
    return '4';
  } else if ((hour == 11 && minute > 40) || (hour == 12 && minute <= 30)) {
    return '5';
  } else if ((hour == 12 && minute > 30) || (hour == 13 && minute <= 20)) {
    return '6';
  } else if ((hour == 13 && minute > 20) || (hour == 14 && minute <= 30)) {
    return 'lunch';
  } else if ((hour == 14 && minute > 30) || (hour == 15 && minute <= 20)) {
    return '7';
  } else if ((hour == 15 && minute > 20) || (hour == 16 && minute <= 10)) {
    return '8';
  } else if ((hour == 16 && minute > 10) || (hour == 17 && minute <= 00)) {
    return '9';
  } else {
    return 'undefined';
  }
}

String get_cause(String year) {
  FirebaseFirestore.instance
      .collection("cse")
      .doc("routine")
      .snapshots()
      .listen((event) {
    final data = event.data() as Map<String, dynamic>;
    vacation_cause = data['$year cause'];
  }, onError: (error) => Fluttertoast.showToast(msg: "Listen failed: $error"));
  return vacation_cause;
}

Widget show_ongoing_class(
    String year, String day, String period, String cause) {
  String title, subtitle;
  if (period == '-1') {
    title = 'Class is off due to $cause';
    subtitle = '';
  } else if (period == 'off_day') {
    title = 'No ongoing class';
    subtitle = 'Class will start from Saturday 8.00 AM';
  } else if (period == '-11') {
    title = 'No ongoing class';
    subtitle = 'Class will start from 8.00 AM';
  } else if (period == 'tiffin') {
    title = 'No ongoing class';
    subtitle = 'Class will start from 10.50 AM';
  } else if (period == 'lunch') {
    title = 'No ongoing class';
    subtitle = 'Class will start from 2.30 PM';
  } else if (period == '0') {
    title = 'No ongoing class';
    subtitle = 'Class will start from tomorrow 8.00 AM';
  } else if (period == 'undefined') {
    title = 'No ongoing class';
    subtitle = '';
  } else {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(children: [
            TableRow(children: [
              table_heading(
                  "Section A", const Color.fromARGB(255, 51, 190, 74)),
              table_heading(
                  "Section B", const Color.fromARGB(255, 99, 132, 252)),
              table_heading(
                  "Section C", const Color.fromARGB(255, 242, 102, 195))
            ]),
            TableRow(children: [
              subject_teacher_and_room_no(
                  year, day.toLowerCase(), 'section a', period), // section A
              subject_teacher_and_room_no(
                  year, day.toLowerCase(), 'section b', period), // section B
              subject_teacher_and_room_no(
                  year, day.toLowerCase(), 'section c', period), // section C
            ]),
          ]),
        ),
      ],
    );
  }
  return Card(
    borderOnForeground: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 3,
    shadowColor: Colors.blueGrey,
    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: ListTile(
      leading: const Icon(Icons.celebration_rounded),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            fontStyle: FontStyle.italic),
      ),
      subtitle: Text(subtitle),
    ),
  );
}

class home_page_ongoing_classes extends StatefulWidget {
  String day;
  int hour;
  int minute;
  String period = '0';

  home_page_ongoing_classes(this.day, this.hour, this.minute);
  @override
  State<home_page_ongoing_classes> createState() =>
      _home_page_ongoing_classesState();
}

class _home_page_ongoing_classesState extends State<home_page_ongoing_classes> {

  String first_cause = ' ',
      second_cause = ' ',
      third_cause = ' ',
      fourth_cause = ' ';
  DateTime fourth_start = DateTime(1991),
      fourth_end = DateTime(1991),
      first_start = DateTime(1991),
      first_end = DateTime(1991),
      second_start = DateTime(1991),
      second_end = DateTime(1991),
      third_start = DateTime(1991),
      third_end = DateTime(1991);
  Timestamp? timestamp;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("cse")
        .doc("routine")
        .snapshots()
        .listen(
      (event) {
        final data = event.data() as Map<String, dynamic>;
        setState(() {
          first_cause = data['first year cause'];
          second_cause = data['second year cause'];
          third_cause = data['third year cause'];
          fourth_cause = data['fourth year cause'];
          timestamp = data['first year start'];
          first_start = timestamp!.toDate();
          timestamp = data['first year end'];
          first_end = timestamp!.toDate();
          timestamp = data['second year start'];
          second_start = timestamp!.toDate();
          timestamp = data['second year end'];
          second_end = timestamp!.toDate();
          timestamp = data['third year start'];
          third_start = timestamp!.toDate();
          timestamp = data['third year end'];
          third_end = timestamp!.toDate();
          timestamp = data['fourth year start'];
          fourth_start = timestamp!.toDate();
          timestamp = data['fourth year end'];
          fourth_end = timestamp!.toDate();

          widget.period = ((DateTime.now().isAfter(first_start)) &&
                  (DateTime.now().isBefore(first_end)))
              ? '-1'
              : ongoing_class_period_ckecker(
                  widget.day, widget.hour, widget.minute);
        });
      },
      onError: (error) => Fluttertoast.showToast(msg: "Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            const Text(
              'Ongoing Classes',
              style: TextStyle(
                  color: Color.fromARGB(255, 122, 55, 86),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              widget.day.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              DateFormat('h:mm a').format(DateTime.now()),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            if (widget.period != 'off_day' &&
                widget.period != '0' &&
                widget.period != 'tiffin' &&
                widget.period != 'lunch' &&
                widget.period != '-1' &&
                widget.period != '-11' &&
                widget.period != 'undefined')
              Text(
                'Period ${widget.period}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'First Year',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            show_ongoing_class(
                'first year',
                widget.day,
                ((DateTime.now().compareTo(first_start)) >= 0 &&
                        (DateTime.now().compareTo(first_end)) <= 0)
                    ? '-1'
                    : ongoing_class_period_ckecker(
                        widget.day, widget.hour, widget.minute),
                first_cause),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Second Year',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            show_ongoing_class(
                'second year',
                widget.day,
                ((DateTime.now().compareTo(second_start)) >= 0 &&
                        (DateTime.now().compareTo(second_end)) <= 0)
                    ? '-1'
                    : ongoing_class_period_ckecker(
                        widget.day, widget.hour, widget.minute),
                second_cause),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Third Year',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            show_ongoing_class(
                'third year',
                widget.day,
                ((DateTime.now().compareTo(third_start)) >= 0 &&
                        (DateTime.now().compareTo(third_end)) <= 0)
                    ? '-1'
                    : ongoing_class_period_ckecker(
                        widget.day, widget.hour, widget.minute),
                third_cause),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Fourth Year',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            show_ongoing_class(
                'fourth year',
                widget.day,
                ((DateTime.now().compareTo(fourth_start)) >= 0 &&
                        (DateTime.now().compareTo(fourth_end)) <= 0)
                    ? '-1'
                    : ongoing_class_period_ckecker(
                        widget.day, widget.hour, widget.minute),
                fourth_cause),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ongoing_classes extends StatefulWidget {
  String year;
  String day;
  int hour;
  int minute;
  String period = '0';

  ongoing_classes(this.year, this.day, this.hour, this.minute);

  @override
  State<ongoing_classes> createState() => _ongoing_classesState();
}

class _ongoing_classesState extends State<ongoing_classes> {
  String cause = ' ';
  DateTime start = DateTime(1991), end = DateTime(1991);
  Timestamp timestamp = Timestamp(500, 500);
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("cse")
        .doc("routine")
        .snapshots()
        .listen(
      (event) {
        final data = event.data() as Map<String, dynamic>;
        setState(() {
          cause = data['${widget.year} cause'];
          timestamp = data['${widget.year} start'];
          start = timestamp.toDate();
          timestamp = data['${widget.year} end'];
          end = timestamp.toDate();

          widget.period = ((DateTime.now().isAfter(start)) &&
                  (DateTime.now().isBefore(end)))
              ? '-1'
              : ongoing_class_period_ckecker(
                  widget.day, widget.hour, widget.minute);
        });
      },
      onError: (error) => Fluttertoast.showToast(msg: "Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Ongoing Classes',
                style: TextStyle(
                    color: Color.fromARGB(255, 122, 55, 86),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                widget.day.toUpperCase(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                DateFormat('h:mm a').format(DateTime.now()),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              if (widget.period != 'off_day' &&
                  widget.period != '0' &&
                  widget.period != 'tiffin' &&
                  widget.period != 'lunch' &&
                  widget.period != '-1' &&
                  widget.period != '-11' &&
                  widget.period != 'exam')
                Text(
                  'Period ${widget.period}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              show_ongoing_class(widget.year, widget.day, widget.period,
                  get_cause(widget.year)), //   need to see this
              // very  urgent
            ],
          ),
        ),
      ),
    );
  }
}
