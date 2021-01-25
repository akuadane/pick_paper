import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/screens/create_request.dart';
import 'package:pick_paper/widgets/request.dart';

class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HOME",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper.getUsers(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return Container(
              child: ListView.builder(
                  itemCount: snapshots.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Request(snapshots.data.docs[index]),
                    );
                  }),
            );
          } else if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Center(
              child: Text("We are having trouble connecting to the internet"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateRequest()));
        },
        tooltip: "Make a request",
      ),
    );
  }
}
