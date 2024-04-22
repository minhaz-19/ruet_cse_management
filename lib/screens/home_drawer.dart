import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ruet_cse_management/main.dart';
import 'package:ruet_cse_management/schedule/routine.dart';
import 'package:ruet_cse_management/schedule/routine_home_pages.dart';
import 'package:ruet_cse_management/screens/achievements.dart';
import 'package:ruet_cse_management/screens/alumni.dart';
import 'package:ruet_cse_management/screens/contact_member.dart';
import 'package:ruet_cse_management/screens/faculty_member.dart';
import 'package:ruet_cse_management/screens/home.dart';
import 'package:ruet_cse_management/screens/login.dart';
import 'package:ruet_cse_management/screens/notice.dart';
import 'package:ruet_cse_management/screens/routine.dart';
import 'package:ruet_cse_management/screens/update_admin.dart';
import 'package:ruet_cse_management/screens/vacation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class admin_home_drawer extends StatefulWidget {
  const admin_home_drawer({Key? key}) : super(key: key);

  @override
  State<admin_home_drawer> createState() => _admin_home_drawerState();
}

class _admin_home_drawerState extends State<admin_home_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            show_description(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const admin_home(),
                    ),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text(
                "Routine",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => routine()),
                );
              },
            ),
            if (FirebaseAuth.instance.currentUser != null)
              ListTile(
                leading: const ImageIcon(
                  AssetImage('images/sunbed.png'),
                  color: Colors.black45,
                ),
                title: const Text(
                  "Declare Vacation",
                  style: TextStyle(fontSize: 17),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => declare_vacation()),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text(
                "Notice",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => notice()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.celebration),
              title: const Text(
                "Achievements",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => achievements()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text(
                "Faculty Members",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => faculty_member()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.boy),
              title: const Text(
                "Students",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text(
                "Alumni",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => alumni()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text(
                "Contact A Member",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => contact_member()),
                );
              },
            ),
            if (FirebaseAuth.instance.currentUser != null)
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text(
                  "Update Admin",
                  style: TextStyle(fontSize: 17),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const add_admin()),
                  );
                },
              ),
            FirebaseAuth.instance.currentUser == null
                ? ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text(
                      "Log in",
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                  )
                : ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(child: Text('Log Out')),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    const Text(
                                      'Do you want to log out?',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'No',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            app()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                            FirebaseAuth.instance.signOut();
                                            setState(() {
                                              uid = null;
                                              email = 'cse.ruet.ac.bd';
                                              name = 'RUET CSE';
                                              image = '';
                                            });
                                            Fluttertoast.showToast(
                                                msg: 'Signed Out');
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.remove('email');
                                          },
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class first_year_drawer extends StatefulWidget {
  const first_year_drawer({Key? key}) : super(key: key);

  @override
  State<first_year_drawer> createState() => _first_year_drawerState();
}

class _first_year_drawerState extends State<first_year_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            show_description(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    (this.context),
                    MaterialPageRoute(builder: (context) => admin_home()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/ongoing.png')),
              title: const Text(
                "Ongoing Classes",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => first_year_home_page()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/saturday.png')),
              title: const Text(
                "Saturday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const first_saturday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/sunday.png')),
              title: const Text(
                "Sunday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const first_sunday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/monday.png')),
              title: const Text(
                "Monday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const first_monday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/tuesday.png')),
              title: const Text(
                "Tuesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const first_tuesday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/wednesday.png')),
              title: const Text(
                "Wednesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const first_wednesday_routine()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class second_year_drawer extends StatefulWidget {
  const second_year_drawer({Key? key}) : super(key: key);

  @override
  State<second_year_drawer> createState() => _second_year_drawerState();
}

class _second_year_drawerState extends State<second_year_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            show_description(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    (this.context),
                    MaterialPageRoute(builder: (context) => admin_home()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/ongoing.png')),
              title: const Text(
                "Ongoing Classes",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => second_year_home_page()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/saturday.png')),
              title: const Text(
                "Saturday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const second_saturday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/sunday.png')),
              title: const Text(
                "Sunday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const second_sunday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/monday.png')),
              title: const Text(
                "Monday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const second_monday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/tuesday.png')),
              title: const Text(
                "Tuesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const second_tuesday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/wednesday.png')),
              title: const Text(
                "Wednesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const second_wednesday_routine()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class third_year_drawer extends StatefulWidget {
  const third_year_drawer({Key? key}) : super(key: key);

  @override
  State<third_year_drawer> createState() => _third_year_drawerState();
}

class _third_year_drawerState extends State<third_year_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            show_description(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    (this.context),
                    MaterialPageRoute(builder: (context) => admin_home()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/ongoing.png')),
              title: const Text(
                "Ongoing Classes",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => third_year_home_page()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/saturday.png')),
              title: const Text(
                "Saturday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const third_saturday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/sunday.png')),
              title: const Text(
                "Sunday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const third_sunday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/monday.png')),
              title: const Text(
                "Monday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const third_monday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/tuesday.png')),
              title: const Text(
                "Tuesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const third_tuesday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/wednesday.png')),
              title: const Text(
                "Wednesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const third_wednesday_routine()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class fourth_year_drawer extends StatefulWidget {
  const fourth_year_drawer({Key? key}) : super(key: key);

  @override
  State<fourth_year_drawer> createState() => _fourth_year_drawerState();
}

class _fourth_year_drawerState extends State<fourth_year_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            show_description(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    (this.context),
                    MaterialPageRoute(builder: (context) => admin_home()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/ongoing.png')),
              title: const Text(
                "Ongoing Classes",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => fourth_year_home_page()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/saturday.png')),
              title: const Text(
                "Saturday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const fourth_saturday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/sunday.png')),
              title: const Text(
                "Sunday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const fourth_sunday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/monday.png')),
              title: const Text(
                "Monday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const fourth_monday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/tuesday.png')),
              title: const Text(
                "Tuesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const fourth_tuesday_routine()),
                );
              },
            ),
            ListTile(
              leading: const ImageIcon(AssetImage('images/wednesday.png')),
              title: const Text(
                "Wednesday",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const fourth_wednesday_routine()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class sample_pic extends StatelessWidget {
  const sample_pic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage('images/ruet_white.jpg'))),
    );
  }
}

class show_description extends StatefulWidget {
  const show_description({super.key});

  @override
  State<show_description> createState() => _show_descriptionState();
}

class _show_descriptionState extends State<show_description> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.blueGrey,
      child: Center(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          uid == null
              ? sample_pic()
              : CachedNetworkImage(
                  imageUrl: image,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    // color: Colors.white,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
          SizedBox(
            height: 10,
          ),
          Text(
            name != '' ? name : 'RUET CSE',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            email != '' ? email : 'cse.ruet.ac.bd',
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      )),
    );
  }
}
