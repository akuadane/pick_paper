import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/models/message.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with AutomaticKeepAliveClientMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("On message, $message");
        final notification = message["notification"];
        setState(() {
          messages.add(Message(notification['title'], notification['body']));
        });
      },
      onResume: (Map<String, dynamic> message) {
        print("On message, $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("On message, $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

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
      body: Builder(
        builder: (context) {
          if (messages.length != 0) {
            ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(messages[index].title),
                        subtitle: Text(messages[index].body),
                      ),
                    ));
          }
          return Center(
            child: Text("No notifications so far."),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
