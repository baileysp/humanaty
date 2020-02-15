import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:humanaty/common/design.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100, height: 100,
        //color: Pallete.humanGreen,
        child: Center(
          child: SpinKitWanderingCubes(
            color: Pallete.humanGreen,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}