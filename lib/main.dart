import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ruet_cse_management/screens/home.dart';
import 'package:ruet_cse_management/screens/home_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login.dart';

import 'package:auto_size_text/auto_size_text.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blueGrey,
        focusColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.blueGrey),
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Colors.blueGrey,
          iconColor: Colors.blueGrey,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey)),
        ),
      ),
      home: AnimatedSplashScreen(
          duration: 1500,
          splash: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Image.asset(
                    "images/ruet.png",
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Department of Computer Science & Engineering",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  const AutoSizeText(
                    "Rajshahi University of Engineering & Technology",
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          nextScreen: email == null ? app() : admin_home(),
          splashIconSize: 450,
          splashTransition: SplashTransition.scaleTransition,
          // pageTransitionType:  Animation(),
          backgroundColor: Colors.white)

      //

      ));
}

class app extends StatelessWidget {
  app({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            //color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/ruet.png",
                  height: 350,
                  width: 350,
                ),
                const SizedBox(
                  height: 10,
                ),
                const AutoSizeText(
                  "Rajshahi University of Engineering & Technology",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Department of Computer Science & Engineering",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),

                          //color:

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => login()),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const admin_home()),
                            );
                          },
                          child: const Text(
                            "Explore",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void load() {}

class get_image extends StatefulWidget {
  const get_image({super.key});

  @override
  State<get_image> createState() => _get_imageState();
}

class _get_imageState extends State<get_image> {
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
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => sample_pic(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
