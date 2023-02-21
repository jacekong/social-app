import 'dart:convert';
import 'dart:io';
import 'package:borderless/utils/login.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  final picker = ImagePicker();

  // text controller
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Create a new account",
            style: TextStyle(color: Colors.black),
          ),
          actions: const []),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // avatar picture
          Stack(
            children: [
              _image != null
                  ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      // ignore: todo
                      //TODO: dispalay avatar image here
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )),
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      //TODO: dispalay avatar image here
                      child: null),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: const Icon(Icons.camera_alt_outlined),
                ),
              )
            ],
          ),

          const SizedBox(
            height: 100,
          ),
          // user name
          //const Text("User name"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
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
                        suffixIcon: Icon(Icons.person),
                        //hintText: 'Username',
                        labelText: "Username",
                        //hintStyle: TextStyle(color: Colors.grey),
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
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          // nickname
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nicknameController,
                    autofocus: false,
                    //obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String text) {},
                    decoration: const InputDecoration(

                        //hintText: 'Password',
                        labelText: "Nickname",
                        //hintStyle: TextStyle(color: Colors.grey),
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
          ),
          // password
          // password
          //const Text("Password"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _passwordController,
                    autofocus: false,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String text) {},
                    decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.black,
                        ),
                        //hintText: 'Password',
                        labelText: "Password",
                        //hintStyle: TextStyle(color: Colors.grey),
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
          ),

          const SizedBox(
            height: 100,
          ),
          // comfirm button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        _showDialog();
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // get image ftom user from gallery
  Future getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });
  }

  // upload image to db server
  Future uploadImg() async {
    String endpoint = "http://192.168.80.168:1880/register";

    if (_image == null) {
      return _showDialog2();
    } else {
      final image = File(_image!.path);

      String base64Image = base64Encode(await image.readAsBytes());
      //print(base64Image);
      //String fileName = image.path.split("/").last;
      //print(fileName);

      final response = await http.post(
        Uri.parse(endpoint),
        //headers: {'Content-type': 'application/json'},
        body: {
          "username": _usernameController.text,
          "nickname": _nicknameController.text,
          "password": _passwordController.text,
          "image": base64Image,
        },
      );
      print(response.statusCode);
      //Navigator.of(context).pop();

      //move to new creen
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      //print(response.body);
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ShowDialogPage(
            username: _usernameController.text,
            password: _passwordController.text,
            cancel: () => Navigator.of(context).pop(),
            register: uploadImg,
          );
        });
  }

  Future _showDialog2() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text("Woops😢"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                      "your personal information seems not completed, maybe try it one more time🙂"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(onSurface: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'),
                  )
                ],
              ),
            ),
          );
        });
  }
} //ec

// ignore: must_be_immutable
class ShowDialogPage extends StatelessWidget {
  final username;
  final password;

  VoidCallback register;
  VoidCallback cancel;

  ShowDialogPage(
      {required this.username,
      super.key,
      this.password,
      required this.register,
      required this.cancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("confirm your user name and password"),
      content: Container(
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  const Text("User Name: "),
                  Text(username),
                ],
              ),
            ),
            Row(
              children: [
                const Text("Password:   "),
                Text(password),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            // buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // confirm
                MaterialButton(
                  onPressed: () {
                    register();
                  },
                  child: Text("Confirm", style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                ),
                const SizedBox(width: 7),
                // discard
                MaterialButton(
                  onPressed: () {
                    cancel();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
