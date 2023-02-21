import 'dart:convert';
import 'package:borderless/model/comment_model.dart';
import 'package:borderless/model/imagePost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CommentPage extends StatelessWidget {
  ImagePost posts;
  CommentPage({required this.posts, super.key});

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // add comment
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: TextField(
                    controller: _commentController,
                    autofocus: false,
                    style: TextStyle(color: Colors.grey[800]),
                    onChanged: (String text) {},
                    decoration: const InputDecoration(
                      labelText: "comment.......",
                    ),
                  ),
                ),
              ),
              // pot button
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Expanded(
                  flex: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      sendData();
                    },
                    child: const Text("post"),
                  ),
                ),
              ),
            ],
          ),
          // show comments
          Expanded(
            flex: 1,
            child: FutureBuilder<List<CommentModel>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  //return progress
                  return Column(
                    children: [
                      Row(
                        children: [
                          //avatar
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          // content
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 7),
                              child: Text(
                                "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  //return widget
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //avatar
                              Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      base64Decode(comments[index].profile_img),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              // nickname
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comments[index].nickname, style: const TextStyle(fontWeight: FontWeight.bold),),
                                    const SizedBox(height: 3,),
                                    // content
                                    Padding(
                                      padding: const EdgeInsets.only(right: 7),
                                      child: Expanded(
                                        flex: 1,
                                        child: Text(
                                          comments[index].comment,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: Text(
                              comments[index].date.substring(0, 19),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //ef
  Future<void> sendData() async {
    if (_commentController.text.length == "") {
      _commentController.clear();
    } else {
      //1. define url
      var url = "http://192.168.80.168:1880/comments";
      //3. send request along with the data
      //headers is required
      //data need to be encoded to json text
      final response = await http.post(
        Uri.parse(url),
        //headers: {'Content-type': 'application/json'},
        body: {
          "id": posts.id.toString(),
          "comment": _commentController.text.replaceAll("'", "''"),
          "date": DateTime.now().toString(),
        },
      );
      print(response.body);
    }
    _commentController.clear();
  }

  // get comments
  Future<String> get(url) async {
    //1. convert param dict to json

    //2. send post request
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return res.body;
    }
    //no success
    else {
      print(res.statusCode);
      return Future<String>.value(null);
    }
  } //ef

  List<CommentModel> comments = [];

  Future<List<CommentModel>> fetchData() async {
    var url = "http://192.168.80.168:1880/getcomments";

    var res = await get(url);
    var comment = json.decode(res.toString()) as List;
    comments = comment.map((e) => CommentModel.fromMap(e)).toList();
    //print(comments);
    return comments;
  } //ef

}//ec
