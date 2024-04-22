import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ruet_cse_management/screens/home.dart';

DateTime starting_date = DateTime(1990);
DateTime ending_date = DateTime(1990);
String vacation_cause = 'cause';
final List<String> dropdown_list = [
  'First Year',
  'Second Year',
  'Third Year',
  'Fourth Year'
];

class declare_vacation extends StatefulWidget {
  const declare_vacation({super.key});

  @override
  State<declare_vacation> createState() => _declare_vacationState();
}

class _declare_vacationState extends State<declare_vacation> {
  TextEditingController vacation_controller = TextEditingController();
  String? dropdown_value;
  final _formKey = GlobalKey<FormState>();
  var show_in_starting_date = 'Pick starting date';
  var show_in_ending_date = 'Pick ending date';

  @override
  // void initState() {
  //   super.initState();
  //   starting_date = null;
  //   ending_date = null;
  //   vacation_cause = null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Vacation', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: vacation_controller,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Cause of vacation ',
                  hintStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSaved: (newValue) {
                  setState(() {
                    vacation_controller.text = newValue!;
                  });
                },
                // validator: (value) {
                //   if (value == null || value == ' ') {
                //     return ('Please enter the cause of vacation');
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField2(
                  decoration: InputDecoration(
                    //Add isDense true and zero Padding.
                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  isExpanded: true,
                  hint: const Text(
                    'Select Year',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                  buttonHeight: 60,
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  items: dropdown_list
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                      .toList(),
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Please select year.';
                  //   }
                  // },
                  onChanged: (value) {
                    dropdown_value = value.toString();
                  },
                  onSaved: (value) {
                    dropdown_value = value.toString();
                  }),
              const SizedBox(height: 30),
              MaterialButton(
                  // pick starting date button
                  height: 60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black45)),
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100))
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          setState(() {
                            starting_date = value;
                            show_in_starting_date = DateFormat.yMMMMd('en_US')
                                .format(value as DateTime);
                          });
                        }
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        show_in_starting_date,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.black45,
                      )
                    ],
                  )),
              const SizedBox(height: 30),
              MaterialButton(
                  // pick ending date button
                  height: 60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black45)),
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100))
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          setState(() {
                            ending_date = value;
                            show_in_ending_date = DateFormat.yMMMMd('en_US')
                                .format(value as DateTime);
                          });
                        }
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        show_in_ending_date,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.black45,
                      )
                    ],
                  )),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    vacation_cause = vacation_controller.text;
                  });
                  if (vacation_cause == null ||
                      vacation_cause == ' ' ||
                      vacation_cause == '') {
                    Fluttertoast.showToast(
                        msg: 'Please enter the cause of vacation');
                  } else {
                    if (dropdown_value == null) {
                      Fluttertoast.showToast(msg: 'Please select a year');
                    } else {
                      if (starting_date == null) {
                        Fluttertoast.showToast(
                            msg: 'Please select a starting date');
                      } else {
                        if (ending_date == null) {
                          Fluttertoast.showToast(
                              msg: 'Please select an ending date');
                        } else {
                          FirebaseFirestore.instance
                              .collection('cse')
                              .doc('routine')
                              .update({
                            '${dropdown_value!.toLowerCase()} cause':
                                vacation_cause,
                            '${dropdown_value!.toLowerCase()} start':
                                starting_date,
                            '${dropdown_value!.toLowerCase()} end':
                                ending_date.add(const Duration(days: 1)),
                          }).then((value) => Fluttertoast.showToast(
                                          msg:
                                              "Schedule of off day added successfully")
                                      .catchError((e) {
                                    Fluttertoast.showToast(msg: e!.massage);
                                  }));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => admin_home()),
                          );
                        }
                      }
                    }
                  }
                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState!.save();
                  //   vacation_cause = vacation_controller.toString();

                  // }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
