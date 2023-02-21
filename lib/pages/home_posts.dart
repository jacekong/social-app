// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:borderless/utils/comments_page.dart';
import 'package:borderless/utils/login.dart';
import 'package:borderless/model/imagePost.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late bool _isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // camera icon
              const Icon(Icons.camera_alt_outlined, color: Colors.black),
              // title
              const Text("Discover", style: TextStyle(color: Colors.black)),
              // message
              GestureDetector(
                onTap: () {
                  // go to login page
                  //move to new creen
                  setState(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  });
                },
                child: const Icon(Icons.logout_rounded, color: Colors.black),
              ),
            ],
          ),
          actions: const []),
      body: FutureBuilder<List<ImagePost>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //return progress
            return SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Row(
                              children: [
                                //avatar
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 11, left: 11, bottom: 11),
                                  child: CircleAvatar(
                                      radius: 26,
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                      )),
                                ),
                                // name and place
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      //name
                                      // ignore: prefer_const_constructors
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 7),
                                        child: Container(
                                          height: 20,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                        ),
                                      ),
                                      // location
                                      Container(
                                        height: 20,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // right dot icon
                          ],
                        ),
                        // image post
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 11, right: 11, bottom: 7),
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        // like / comments / adding to favorite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // ignore: prefer_const_constructors
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                // ignore: prefer_const_constructors
                                // favorite button
                                Padding(
                                  padding: const EdgeInsets.only(left: 11,right: 7),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(30)),
                                  ),
                                ),
                                // comments

                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ],
                            ),
                            //
                            Padding(
                              padding: const EdgeInsets.only(right: 11),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ],
                        ),                  
                        // caption
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 11, right: 11, bottom: 11,top: 7),
                          child: Container(
                            height: 30,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7)),
                          ),
                        ),
                        // post date
                        Padding(
                          padding: const EdgeInsets.only(left: 11, bottom: 11),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Row(
                              children: [
                                //avatar
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 11, left: 11, bottom: 11),
                                  child: CircleAvatar(
                                      radius: 26,
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                      )),
                                ),
                                // name and place
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      //name
                                      // ignore: prefer_const_constructors
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 7),
                                        child: Container(
                                          height: 20,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                        ),
                                      ),
                                      // location
                                      Container(
                                        height: 20,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // right dot icon
                          ],
                        ),
                        // image post
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 11, right: 11, bottom: 7),
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        // like / comments / adding to favorite
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // ignore: prefer_const_constructors
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                // ignore: prefer_const_constructors
                                // favorite button
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                // comments

                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ],
                            ),
                            //
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ],
                        ),
                        // comments count
                        Container(
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(30)),
                        ),

                        // like counts
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, bottom: 11, top: 11),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, bottom: 11, top: 11),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ],
                        ),
                        // caption
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 11, right: 11, bottom: 11),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        // post date
                        Padding(
                          padding: const EdgeInsets.only(left: 11, bottom: 11),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          } else {
            //return widget
            return RefreshIndicator(
              onRefresh: () async {
                //put your code hre
                
              },
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Row(
                                    children: [
                                      //avatar
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 11, left: 11, bottom: 11),
                                        child: CircleAvatar(
                                          radius: 26,
                                          child: Container(
                                              height: 150,
                                              width: 150,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.memory(
                                                      base64Decode(posts[index]
                                                          .profile_img),
                                                      fit: BoxFit.cover))),
                                        ),
                                      ),
                                      // name and place
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            //name
                                            // ignore: prefer_const_constructors
                                            Text(posts[index].nickname,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            // location
                                            Text(posts[index].location,
                                                style: TextStyle(
                                                    color: Colors.grey[600])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // right dot icon
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Icon(Icons.more_vert),
                                  )
                                ],
                              ),
                              // image post
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 11, right: 11, bottom: 7),
                                child: Container(
                                  //height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // decode image here
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.memory(
                                          base64Decode(posts[index].post_img))),
                                ),
                              ),
                              // like / comments / adding to favorite
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  // ignore: prefer_const_constructors
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      // ignore: prefer_const_constructors
                                      // favorite button

                                      IconButton(
                                          onPressed: (() {
                                            setState(() {
                                              _isFav = !_isFav;
                                            });
                                          }),
                                          icon: Icon(
                                              _isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red)),

                                      // comments

                                      IconButton(
                                        onPressed: () {
                                          //move to new creen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CommentPage(
                                                  posts: posts[index]),
                                            ),
                                          );
                                          // send post id
                                          sendData(posts[index].id);
                                        },
                                        icon: const Icon(Icons.comment),
                                      ),
                                    ],
                                  ),
                                  //
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(Icons.bookmark_border),
                                  ),
                                ],
                              ),
                              // comments count
                              const Padding(
                                padding: EdgeInsets.only(left: 11),
                                child: Text(
                                  "view comments...",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),

                              // like counts
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 11.0, bottom: 11, top: 11),
                                    child: Text(
                                      posts[index].liked.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, bottom: 11, top: 11),
                                    child: Text(
                                      "Likes",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // caption
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 11, right: 11, bottom: 11),
                                child: Text(posts[index].caption),
                              ),
                              // post date
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 11, bottom: 11),
                                child: Text(posts[index].date.substring(0, 19)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            );
          }
        },
      ),
      // select pictures from gallery to post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //move to new creen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPost(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  // send post id to server
  Future<void> sendData(id) async {
    //1. define url
    var url = "http://192.168.80.168:1880/sendpostid";
    //3. send request along with the data
    //headers is required
    //data need to be encoded to json text
    final response = await http.post(
      Uri.parse(url),
      //headers: {'Content-type': 'application/json'},
      body: {
        "id": id.toString(),
      },
    );
    print(response.body);
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
      print(res.statusCode);
      return Future<String>.value(null);
    }
  } //ef

  // fetch images from server
  List<ImagePost> posts = [];
  List<ImagePost> get _posts => posts;
  void setPost(List<ImagePost> posts) {
    setState(() {
      posts = _posts;
    });
  } //ef

  Future<List<ImagePost>> fetchData() async {
      var url = "http://192.168.80.168:1880/getPost";

      var res = await get(url);
      var imagePost = json.decode(res.toString()) as List;
      posts = imagePost.map((e) => ImagePost.fromMap(e)).toList();
      return posts;
  } //ef
}

// adding post page
class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

// write new post
class _AddPostState extends State<AddPost> {
  File? _image;
  final picker = ImagePicker();

  final _captionController = TextEditingController();
  final _locationController = TextEditingController();
  final date = DateTime.now();

  // get image ftom user from gallery
  Future getImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });
  }

  // upload image to db server
  Future uploadImg() async {
    String endpoint = "http://192.168.80.168:1880/uploadImg";

    // to cehck if the image is null
    if (_image == null) {
      return _showDialog();
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
          "image": base64Image,
          "caption": _captionController.text.replaceAll("'", "''"),
          "location": _locationController.text.replaceAll("'", "''"),
          "date": date.toString()
        },
      );
      print(response.statusCode);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      //print(response.body);
    }
  }

  Future _showDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Woops 😌, seems you forgot to choose the picture, select a new one again 😄"),
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

  String location = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            "New Post",
            style: TextStyle(color: Colors.black),
          ),
          actions: const []),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image display
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: _image == null
                  ? Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(child: Text("Select a image")),
                    )
                  : Image.file(_image!),
            ),
            // image pick button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.red.withOpacity(0.38),
                  disabledBackgroundColor: Colors.red.withOpacity(0.12)),
              onPressed: () {
                getImage();
              },
              child: const Text('Choose a image'),
            ),
            const SizedBox(
              height: 30,
            ),
            // caption
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: TextField(
                //controller: TextEditingController(text:'data'),
                autofocus: false,
                controller: _captionController,
                style: TextStyle(color: Colors.grey[800]),
                onChanged: (String text) {},
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "write something..."),
              ),
            ),
            // location pick
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      //controller: TextEditingController(text:'data'),
                      autofocus: false,
                      maxLines: null,
                      controller: _locationController,
                      style: TextStyle(color: Colors.grey[800]),
                      onChanged: (String text) {},
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "location"),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.green[500]),
                      onPressed: () async {
                        Position p = await _determinePosition();
                        double lat = p.latitude;
                        double lon = p.longitude;
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(lat, lon);
                        if (placemarks.isNotEmpty) {
                          setState(() {
                            location =
                                '${placemarks[0].country},${placemarks[0].administrativeArea},\r\n${placemarks[0].locality},${placemarks[0].subLocality}';
                          });
                        }
                        _locationController.text = location;
                      },
                      child: const Text('pick location'),
                    ),
                  )
                ],
              ),
            ),
            // post button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.red.withOpacity(0.38),
                  disabledBackgroundColor: Colors.red.withOpacity(0.12)),
              onPressed: () {
                // ignore: unnecessary_null_comparison
                uploadImg();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Text('post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
