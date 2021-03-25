import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/routes.dart';
import 'package:pick_paper/screens/create_request.dart';
import 'package:pick_paper/screens/home.dart';
import 'package:pick_paper/screens/index.dart';
import 'package:pick_paper/screens/profile.dart';
import 'user/screen/login.dart';

class OnRouteGenerateRouter {
  static Route onGenerateRouter(RouteSettings settings) {
    if (settings.name == INDEX) {
      return MaterialPageRoute(builder: (context) => Index());
    } else if (settings.name == HOME) {
      return MaterialPageRoute(builder: (context) => Home("ad"));
    } else if (settings.name == LOGIN) {
      return MaterialPageRoute(builder: (context) => LogIn());
    } else if (settings.name == PROFILE) {
      return MaterialPageRoute(builder: (context) => Profile());
    } else if (settings.name == CREATE_REQUEST) {
      return MaterialPageRoute(builder: (context) => CreateRequest());
    }
    return MaterialPageRoute(builder: (context) => LogIn());
  }
}
