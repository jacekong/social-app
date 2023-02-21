import 'dart:convert';
import 'dart:math';
import 'package:borderless/model/secret_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class SecretePage extends StatefulWidget {
  const SecretePage({Key? key}) : super(key: key);

  @override
  State<SecretePage> createState() => _SecretePageState();
}

class _SecretePageState extends State<SecretePage> {
  void savePost() {
    Navigator.of(context).pop();
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialogbox(
            date: DateTime.now(),
            onPost: savePost,
            onDiscard: () => Navigator.of(context).pop(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Warm up yourself",
            style: TextStyle(color: Colors.blue),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: const []),
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: FutureBuilder<List<TextPost>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //return progress
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //return widget
            return RefreshIndicator(
              onRefresh: () async {
                //put your code hre
                fetchData(refresh: true);
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: txtPost.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      key: UniqueKey(),                   
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {
                          setState(() {
                            txtPost.removeAt(index);
                          });
                        }),
                        children: [
                          SlidableAction(           
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            icon: Icons.delete,
                            label: 'Delete',
                            onPressed: (context) {},
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color:
                              Colors.primaries[Random().nextInt(colors.length)],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // post name
                              Padding(
                                padding: const EdgeInsets.only(left: 7, top: 7),
                                child: Text(
                                  txtPost[index].name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              // post
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 25, top: 7),
                                child: Text(
                                  txtPost[index].post,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),

                              // date
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  txtPost[index].date.substring(0, 19),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),

      // post your mood
    );
  }

  // fetch data from server
  Future<String> get(url) async {
    //1. convert param dict to json
    //2. send post request
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return res.body;
    }
    //no success
    else {
      // ignore: avoid_print
      print(res.statusCode);
      return Future<String>.value(null);
    }
  } //ef

  //fetch data
  List<TextPost> txtPost = [];
  List<TextPost> get _txtPost => txtPost;
  void setPost(List<TextPost> posts) {
    setState(() {
      posts = _txtPost;
    });
  } //ef

  Future<List<TextPost>> fetchData({bool refresh = false}) async {
    if (txtPost.isEmpty || refresh == true) {
      txtPost = [];
      var url = "http://192.168.80.168:1880/getTxtPost";

      var res = await get(url);
      var dict = json.decode(res.toString()) as List;
      txtPost = dict.map((e) => TextPost.fromMap(e)).toList();
      return txtPost;
    } else {
      return txtPost;
    }
  } //ef

}

// dialog box
// ignore: must_be_immutable
class Dialogbox extends StatelessWidget {
  final _nameController = TextEditingController();
  final _postController = TextEditingController();
  final DateTime date;

  VoidCallback onPost;
  VoidCallback onDiscard;

  Dialogbox(
      {Key? key,
      required this.date,
      required this.onPost,
      required this.onDiscard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              // make title
              const Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Text(
                  "Make a title:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "type something.....",
                ),
              ),
              const SizedBox(height: 20),
              // get post contetn
              TextField(
                controller: _postController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "what\'s on your mind?",
                ),
              ),
              const SizedBox(height: 50),
              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // post
                  MaterialButton(
                    onPressed: () {
                      onPost();
                      sendData(
                          _nameController.text.replaceAll("'", "''"),
                          _postController.text.replaceAll("'", "''"),
                          date.toString());
                    },
                    child: Text("Post", style: TextStyle(color: Colors.white)),
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 7),
                  // discard
                  MaterialButton(
                    onPressed: () {
                      onDiscard();
                    },
                    child:
                        Text("Discard", style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// list colors
List colors = [
  const Color.fromRGBO(101, 164, 218, 1),
  const Color.fromRGBO(255, 130, 128, 1),
  const Color.fromRGBO(143, 152, 253, 1),
  const Color.fromRGBO(70, 177, 131, 1),
  const Color.fromRGBO(232, 106, 65, 1),
  const Color.fromRGBO(230, 127, 127, 1),
  const Color.fromRGBO(196, 196, 196, 1)
];

// upload data to db
Future<void> sendData(name, post, date) async {
  //1. define url
  var url = "http://192.168.80.168:1880/secret";

  //2. convert list of objects to list of dictionary
  var data1 = {"name": name, "post": post, "date": date};

  //3. send request along with the data
  //headers is required
  //data need to be encoded to json text
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-type': 'application/json'},
    body: json.encode(data1),
  );
  print(response.body);
} //ef

