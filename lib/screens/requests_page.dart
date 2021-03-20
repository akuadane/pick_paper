import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:pick_paper/screens/create_request.dart';
import 'package:pick_paper/screens/profile.dart';
import 'package:pick_paper/widgets/request.dart';
import 'package:provider/provider.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with AutomaticKeepAliveClientMixin {
  QueryDocumentSnapshot _user;

  @override
  Widget build(BuildContext context) {
    this._user = Provider.of<SharedUser>(context).user;
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
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper.getUserRequests(this._user.id),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            if (snapshots.data.docs.length != 0) {
              return Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshots.data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: Request(snapshots.data.docs[index]),
                      );
                    }),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You have created zero requests so far."),
                  Text(
                      "To create a request press + on the bottom-right corner.")
                ],
              ),
            );
          } else if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Center(
              child: Text("We are having trouble connecting to the internet."),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
