import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  final QueryDocumentSnapshot request;

  Request(this.request);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(4, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("10/12/2021"),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(-1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pick up date: - ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Size: ~",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "2kg",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    "images/paper.jpg",
                    width: 100,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
