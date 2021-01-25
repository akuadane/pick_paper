import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_paper/handlers/firebase_auth_helper.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:pick_paper/screens/login.dart';
import 'package:pick_paper/screens/notifications.dart';
import 'package:pick_paper/screens/requests_page.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final String _uid;

  Home(this._uid);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreHelper.getUserStream(widget._uid),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                QueryDocumentSnapshot user = snapshots.data.docs[0];
                SharedUser sharedUser = Provider.of<SharedUser>(context);
                sharedUser.user = user;
                return PageView(
                  controller: this._pageController,
                  children: [
                    RequestsPage(),
                    Notifications(),
                  ],
                  onPageChanged: (currentPage) {
                    setState(() {
                      this._currentPage = currentPage;
                    });
                  },
                  physics: NeverScrollableScrollPhysics(),
                );
              } else if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                child: Center(
                  child:
                      Text("We are having trouble connecting to the internet"),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            this._pageController.jumpToPage(index);
          },
          currentIndex: this._currentPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 30,
              ),
              title: Text("Notifications"),
            ),
          ],
        ),
      ),
    );
  }
}
