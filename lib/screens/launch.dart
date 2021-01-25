import 'package:flutter/material.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                "Pick Papers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "From YNCCC",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
