import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_paper/handlers/firebase_auth_helper.dart';
import 'package:pick_paper/handlers/firebase_storage_helper.dart';
import 'package:pick_paper/screens/login.dart';
import 'package:pick_paper/user/bloc/bloc.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final badges = ["Beginner", "Intermediate", "Expert"];
  String name, badge, phoneNumber;
  int paperRecycled;
  bool profilePicExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROFILE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuthHelper.logout();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LogIn()));
              })
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is SignedIn) {
                  QueryDocumentSnapshot user = userState.user;

                  name = user["name"];
                  phoneNumber = user["phone"];
                  paperRecycled = user["paperRecycled"];
                  profilePicExists = (user["profilePictureURL"] == "" ||
                          user["profilePictureURL"] == null)
                      ? false
                      : true;

                  int tempBadgeIndex = (paperRecycled / 5).round();

                  if (tempBadgeIndex > badges.length - 1) {
                    tempBadgeIndex = badges.length - 1;
                  }

                  badge = badges[tempBadgeIndex];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Stack(
                        children: [
                          Visibility(
                            visible: profilePicExists,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  NetworkImage(user["profilePictureURL"]),
                            ),
                            replacement: CircleAvatar(
                              radius: 80,
                              child: Icon(
                                Icons.perm_identity,
                                size: 90,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: 55,
                            child: IconButton(
                              onPressed: () async {
                                File image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                                String photoUrl = await FirebaseStorageHelper
                                    .uploadProfilePicture(image, user.id);
                                if (photoUrl.isNotEmpty) {
                                  BlocProvider.of<UserBloc>(context).add(
                                      UploadProfilePicture(
                                          image: image,
                                          userDocId: user.id,
                                          uid: user["uid"]));
                                }
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: name,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "This can't be empty";
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Name',
                                      suffixIcon: Icon(Icons.edit),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onChanged: (value) => name = value,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final form = this._formKey.currentState;
                                  if (form.validate()) {
                                    BlocProvider.of<UserBloc>(context).add(
                                        UpdateUser(
                                            tobeUpdated: {"name": name},
                                            userDocId: user.id,
                                            uid: user["uid"]));

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "User name changed to $name")));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Update",
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
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: badge,
                          decoration: InputDecoration(
                              labelText: 'Badge',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: phoneNumber,
                          decoration: InputDecoration(
                              labelText: 'Phone number',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: "$paperRecycled Kg",
                          decoration: InputDecoration(
                              labelText: 'Amount of paper recycled',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: Text("There is some error loading user."),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}