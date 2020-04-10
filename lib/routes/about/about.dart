import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets/appBar/humanaty_appbar.dart';

class About extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: 'About Us'),
      body: Placeholder()
    );
  }
}