import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class RatingStars extends StatefulWidget {
  double rating;
  final RatingChangeCallback onRated;

  RatingStars({this.rating, this.onRated});

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  @override
  double rating;

  void initState() {
    // TODO: implement initState
    super.initState();
    this.rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getStar(1),
          getStar(2),
          getStar(3),
          getStar(4),
          getStar(5),
        ],
      ),
    );
  }

  Widget getStar(double rate) {
    bool shouldBeLighted = rate <= rating;

    return GestureDetector(
      child: (shouldBeLighted)
          ? Icon(
              Icons.star,
              color: Colors.yellow,
              size: 30,
            )
          : Icon(
              Icons.star_border,
              color: Colors.black,
              size: 30,
            ),
      onTap: () {
        setState(() {
          this.rating = rate;
          widget.onRated(this.rating);
        });
      },
    );
  }
}
