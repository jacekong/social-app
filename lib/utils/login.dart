// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:borderless/utils/home_page.dart';
import 'package:borderless/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // var to show or hide password
  bool _isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                // login
                const Text("Login",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 50,
                        fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 100,
                ),
                // username
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _usernameController,
                        autofocus: false,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String text) {},
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // password
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _passwordController,
                        autofocus: false,
                        obscureText: _isObsecure,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String text) {},
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                _isObsecure = !_isObsecure;
                              }), 
                              icon: Icon(
                                _isObsecure ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // button forget passqord and register
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // forget password
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () {},
                      child: const Text('Forget password?'),
                    ),
                    // register
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        // move to register page
                        //move to new creen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                // button login
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            loginHttp();
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // get data from server
  Future<String> get(url) async {
    //1. convert param dict to json

    //2. send post request
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return res.body;
    }
    //no success
    else {
      //print(res.statusCode);
      // ignore: null_argument_to_non_null_type
      return Future<String>.value(null);
    }
  } //ef

  //Login function
  Future loginHttp() async {
    try {
      var dict1 = json.encode({
        "username": _usernameController.text,
        "password": _passwordController.text,
      });

      final response = await http.post(
          Uri.parse("http://192.168.80.168:1880/login"),
          headers: {"Content-Type": "application/json"},
          body: dict1);
      //print(response.statusCode);
      //print(response.body);
      var result = json.decode(response.body);
      print(result);

      //move to new creen
      // ignore: use_build_context_synchronously
      return await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

    } catch(e){
      print(e);
      return _showDialogLogin();
    }
  } //ef

  // futrue can return
  Future _showDialogLogin() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Woops...🥲"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      "user name or password is incorrect, please try again!"),
                  const SizedBox(
                    height: 20,
                  ),
                  // button
                  MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
