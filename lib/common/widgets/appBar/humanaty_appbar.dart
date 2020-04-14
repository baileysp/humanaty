import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';

class HumanatyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final List<Widget> actions;
  final Color backgroundColor;
  final bool displayBackBtn;
  final bool displayCloseBtn;
  final double elevation;  
  final String title;  
  final TextStyle titleStyle;

  HumanatyAppBar({
    this.actions,
    this.backgroundColor, 
    this.displayBackBtn = false,
    this.displayCloseBtn = false,
    this.elevation,   
    this.title = '',    
    this.titleStyle
  }) : preferredSize = Size.fromHeight(60.0);

  @override 
  final Size preferredSize;

  @override 
  Widget build(BuildContext context){
    assert(!(displayBackBtn && displayCloseBtn));

    return AppBar(
      title: Text('$title', style: titleStyle ?? TextStyle(color: Colors.black)),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0.0,
      leading: displayBackBtn ? _backButton(context) : displayCloseBtn ? _closeButton(context) : SizedBox.shrink(),
      actions: actions ?? []
    );
  }

  Widget _backButton(BuildContext context){
    return IconButton(
        onPressed:() => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.grey)
    );
  }

  Widget _closeButton(BuildContext context){
    return IconButton(
      onPressed:() => Navigator.pop(context),
      icon: Icon(Icons.close, color: Pallete.humanGreen)
    );
  }
}