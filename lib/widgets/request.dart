import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Request extends StatelessWidget {
  final QueryDocumentSnapshot request;
  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Request(this.request);

  @override
  Widget build(BuildContext context) {
    int mass = this.request["mass"];
    int status = this.request["status"];
    DateTime dateOfRequest = this.request["dateOfRequest"].toDate();
    DateTime dateOfPickup;
    DocumentSnapshot collector;

    String dateOfPickupStr = " - ";

    if (this.request["dateOfAcceptance"] != null) {
      dateOfPickup = this.request["dateOfAcceptance"].toDate();
      dateOfPickupStr =
          "${months[dateOfPickup.month - 1]} ${dateOfPickup.day}, ${dateOfPickup.year}";
    }

    String dateOfRequestStr =
        "${months[dateOfRequest.month - 1]} ${dateOfRequest.day}, ${dateOfRequest.year}";

    return Builder(builder: (context) {
      if (this.request["acceptedByCollector"] != null) {
        return FutureBuilder<DocumentSnapshot>(
          future: this.request["acceptedByCollector"].get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              collector = snapshot.data;
              return getMainContainer(
                  mass, status, dateOfRequestStr, dateOfPickupStr, collector);
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      }
      return getMainContainer(
          mass, status, dateOfRequestStr, dateOfPickupStr, collector);
    });
  }

  Widget getMainContainer(int mass, int status, String dateOfRequestStr,
      String dateOfPickupStr, DocumentSnapshot collector) {
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
                Text(dateOfRequestStr),
                Visibility(
                  visible: status == 0,
                  child: Text(
                    "Pending...",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (status == 0)
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(-1, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            FirestoreHelper.cancleRequest(this.request.id);
                          },
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
                      );
                    else if (status == 1) {
                      return Text(
                        "Accepted by ${collector["name"]}",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      );
                    } else if (status == 2)
                      return Text(
                        "Picked up by ${collector["name"]}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      );

                    return Container();
                  },
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
                      "Pick up date: $dateOfPickupStr ",
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
                      "$mass Kg",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Visibility(
                      visible: status == 2,
                      child: SmoothStarRating(
                        rating: this.request["rating"]["rating"].toDouble(),
                        isReadOnly: false,
                        size: 30,
                        color: Colors.yellow,
                        filledIconData: Icons.star,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: false,
                        spacing: 2.0,
                        onRated: (value) async {
                          var rating = this.request["rating"];
                          if (rating["rated"]) {
                            await FirestoreHelper.changeRatingForCollector(
                                collector,
                                value,
                                this.request.id,
                                rating["rating"]);
                          } else {
                            await FirestoreHelper.rateCollectorForTheFirstTime(
                                collector, value, this.request.id);
                          }
                        },
                      ),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    "${this.request["photoURL"]}",
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
