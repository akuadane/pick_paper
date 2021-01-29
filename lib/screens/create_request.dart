import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_paper/handlers/firebase_storage_helper.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:pick_paper/screens/requests_page.dart';
import 'package:provider/provider.dart';

class CreateRequest extends StatefulWidget {
  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  int _paperMass = 1;
  QueryDocumentSnapshot _user;
  File _image;

  @override
  Widget build(BuildContext context) {
    this._user = Provider.of<SharedUser>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("REQUEST"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Size ~ (Kg)",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "${this._paperMass}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, top: 15, right: 15, bottom: 15),
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(1000),
                                  onTap: () {
                                    if (this._paperMass > 1) {
                                      setState(() {
                                        this._paperMass--;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(1000),
                                  onTap: () {
                                    if (this._paperMass < 15) {
                                      setState(() {
                                        this._paperMass++;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), // Mass input
                SizedBox(
                  height: 20,
                ), // Separator
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Add a picture",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "A recent photograph of the paper to be recycled. Use either the camera or choose pre-taken picture"
                          "from your gallery.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0XFFEEEEEE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () async {
                                  File tempImage = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);

                                  setState(() {
                                    this._image = tempImage;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 60,
                                      ),
                                      Text(
                                        "Gallery",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0XFFEEEEEE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () async {
                                  File tempImage = await ImagePicker.pickImage(
                                      source: ImageSource.camera);

                                  setState(() {
                                    this._image = tempImage;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.camera_enhance_outlined,
                                        size: 60,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: this._image != null,
                        child: Builder(
                          builder: (context) {
                            if (this._image != null)
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(this._image));
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ), // Add a picture
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Pick-Up Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Saved Location",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFEEEEEE),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(4, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Map",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFEEEEEE),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(4, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "My current location",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Color(0XFFEEEEEE),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) => InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      if (this._image != null) {
                        showDialog(
                          context: context,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        String photoURL =
                            await FirebaseStorageHelper.uploadPaperPhoto(
                                this._image, this._user.id);

                        if (photoURL.isNotEmpty) {
                          await FirestoreHelper.createRequest(this._user.id,
                              _paperMass, photoURL, GeoPoint(2.3, 43.1));
                        }

                        Navigator.pop(
                            context); // removes the circular progress bar
                        Navigator.pop(
                            context); // goes back to the previous page
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please choose an image"),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "SEND",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0XFF85FF40),
                              Color(0XFF0CE69C),
                            ],
                            begin: const FractionalOffset(0.0, 1.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
