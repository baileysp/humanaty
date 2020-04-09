import 'package:flutter/material.dart';

class HumanatyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Color backgroundColor;
  final double elevation;
  final bool displayBackBtn;
  final String title;
  final List<Widget> actions;

  HumanatyAppBar({
    this.backgroundColor,
    this.elevation,
    this.displayBackBtn = false,
    this.title,
    this.actions
  }) : preferredSize = Size.fromHeight(60.0);

  @override 
  final Size preferredSize;

  @override 
  Widget build(BuildContext context){
    return AppBar(
      title: Text(title ?? "", style: TextStyle(color: Colors.black)),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0.0,
      leading: displayBackBtn ? backButton(context) : SizedBox.shrink(),
      actions: actions ?? []
    );
  }

  Widget backButton(BuildContext context){
    return IconButton(
        onPressed: (){Navigator.pop(context);},
        icon: Icon(Icons.arrow_back, color: Colors.grey)
    );
  }
}