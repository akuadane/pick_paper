import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    SharedUser user = Provider.of<SharedUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NOTIFICATIONS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
