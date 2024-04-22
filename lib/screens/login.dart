
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ruet_cse_management/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool obsecure_text = true;
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance; // need to un comment it

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        cursorColor: Colors.blueGrey,
        decoration: const InputDecoration(
          focusColor: Colors.blueGrey,
          iconColor: Colors.blueGrey,
          floatingLabelStyle: TextStyle(color: Colors.blueGrey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey)),
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: 'Email',
          hintText: "Email",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        cursorColor: Colors.blueGrey,
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Colors.blueGrey),
          focusColor: Colors.blueGrey,
          iconColor: Colors.blueGrey,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey)),
          prefixIcon: const Icon(
            Icons.vpn_key,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  obsecure_text = !obsecure_text;
                });
              },
              icon: const Icon(
                Icons.remove_red_eye,
              )),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          labelText: 'Password',
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueGrey,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text,
                passwordController.text); //need to uncomment this
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset(
                          "images/ruet.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Forgot password? "),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Reset Password",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 240, 74, 163),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function                                                           // need to uncomment below this line
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Authcontrol.AutoLogin(emailController
                      .toString()), // used to keep users logged in after re-openning the app
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pop(),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const admin_home())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
  }
}

class Authcontrol {
  // this is used to keep users signed in when app reopens after it closes
  static AutoLogin(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }
}
