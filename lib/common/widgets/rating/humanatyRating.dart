import 'package:flutter/material.dart';

class HumanatyRating extends StatelessWidget {

  final int rating;
  final double starSize;

  const HumanatyRating({
    Key key, 
    this.rating = 0,
    this.starSize
    }) : assert(rating != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: starSize ?? 24,
        );
      }),
    );
  }
}