import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/validator.dart';

class MealEdit extends StatefulWidget{
  final String eventID;
  final String meal;
  MealEdit({this.eventID, this.meal});

  @override
  _MealEditState createState() => _MealEditState();
}

class _MealEditState extends State<MealEdit>{
   TextEditingController _mealController;
  GlobalKey<FormState> _formKey;
  
  @override
  void initState() {
    _mealController = TextEditingController(text: widget.meal);
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final database = DatabaseService(uid: auth.user.uid);

    return Scaffold(
      appBar: HumanatyAppBar(
        displayCloseBtn: true,
        title: 'Update Meal',
        actions: [_save(auth, database)],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(key: _formKey, child: _editMeal()),
      ));
  }

  Widget _editMeal() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 8,minLines: 4, 
      controller: _mealController,
      decoration: textInputDecoration,
      validator: notEmpty,
    );
  }

   Widget _save(AuthService auth, DatabaseService database) {
    return FlatButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            database.updateEventMeal(widget.eventID, _mealController.text);
            Navigator.pop(context);
          }
        },
        child: Text(
          'SAVE',
          style: TextStyle(color: Pallete.humanGreen),
        ));
  }

  @override
  void dispose() {
    _mealController.dispose();
    super.dispose();
  }

}