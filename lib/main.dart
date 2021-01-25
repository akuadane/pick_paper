import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:pick_paper/screens/index.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SharedUser(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: MaterialColor(0XFF0CE69C, <int, Color>{
            50: Color.fromRGBO(12, 230, 156, .1),
            100: Color.fromRGBO(12, 230, 156, .2),
            200: Color.fromRGBO(12, 230, 156, .3),
            300: Color.fromRGBO(12, 230, 156, .4),
            400: Color.fromRGBO(12, 230, 156, .5),
            500: Color.fromRGBO(12, 230, 156, .6),
            600: Color.fromRGBO(12, 230, 156, .7),
            700: Color.fromRGBO(12, 230, 156, .8),
            800: Color.fromRGBO(12, 230, 156, .9),
            900: Color.fromRGBO(12, 230, 156, 1),
          }),
        ),
        home: Index(),
      ),
    );
  }
}
