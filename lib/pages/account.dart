import 'dart:convert';
import 'package:borderless/model/account_model.dart';
import 'package:borderless/model/user_post_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountPage extends StatelessWidget {
  AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            FutureBuilder<List<User>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  //return progress
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  //return widget
                  return Expanded(
                    flex: 0,
                    child: Column(children: [
                      Row(
                        children: [
                          // avatar
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(children: [
                              Container(
                                  height: 160,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(7),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(7),
                                    child: Image.memory(
                                      base64Decode(users[0].profile_img),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              // select profile image
                              const Positioned(
                                bottom: 0,
                                right: 3,
                                child: Icon(Icons.camera_alt_outlined),
                              ),
                            ]),
                          ),
                          // name
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: Text(
                                    users[0].nickname,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ]),
                  );
                }
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<List<UserPost>>(
                future: postData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //return progress
                    return GridView.count(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ],
                    );
                  } else {
                    //return widget
                    return GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      //section to define column number, x andy spacing
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0, //x spacing
                        mainAxisSpacing: 5.0, //y spacing
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        //put your item rendering here
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                base64Decode(posts[index].post_img),
                                fit: BoxFit.cover,
                              )),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

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

  // fetch images from server
  List<User> users = [];

  Future<List<User>> fetchData() async {
    var url = "http://192.168.80.168:1880/getuser";

    var res = await get(url);
    var user = json.decode(res.toString()) as List;
    users = user.map((e) => User.fromMap(e)).toList();
    //print(users);
    return users;
  } //ef

  // fetch images from server
  List<UserPost> posts = [];

  Future<List<UserPost>> postData() async {
    var url = "http://192.168.80.168:1880/getUserPost";

    var res = await get(url);
    var user = json.decode(res.toString()) as List;
    posts = user.map((e) => UserPost.fromMap(e)).toList();
    //print(users);
    return posts;
  } //ef
}
