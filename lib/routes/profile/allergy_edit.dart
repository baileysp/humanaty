import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';

class AllergyEdit extends StatefulWidget {
  final Map allergyMap;
  final bool updateUserProfile;
  final bool updateEvent;
  final String eventID;
  const AllergyEdit({Key key, this.allergyMap, this.updateUserProfile, this.updateEvent, this.eventID})
      : super(key: key);

  @override
  _AllergyEditState createState() => _AllergyEditState();
}

class _AllergyEditState extends State<AllergyEdit> {
  AuthService auth;
  DatabaseService database;
 
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    database = DatabaseService(uid: auth.user.uid);
    if(widget.updateEvent) assert(widget.eventID.isNotEmpty);
    
    return Scaffold(
        appBar: HumanatyAppBar(
            displayCloseBtn: true,
            title: 'Edit Allergies',
            actions: widget.updateUserProfile
                ? [_updateUserAllergiesBtn(widget.allergyMap)]
                : widget.updateEvent
                  ? [_updateEventAllergensBtn(widget.eventID, widget.allergyMap)]
                  : [_returnAllergiesBtn(widget.allergyMap)]),
        body: ListView.builder(
            itemCount: widget.allergyMap.length,
            itemBuilder: (context, index) {
              String _key = widget.allergyMap.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
                trailing: Visibility(
                    visible: widget.allergyMap[_key],
                    child: Icon(Icons.check, color: Pallete.humanGreen)),
                onTap: () {
                  setState(() {
                    widget.allergyMap[_key] = !widget.allergyMap[_key];
                  });
                },
              );
            }));
  }

  Widget _returnAllergiesBtn(Map userAllergies) {
    return FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          Navigator.of(context)
              .pop(Allergy().allergyListFromMap(userAllergies));
        },
        child: Text('SAVE', style: TextStyle(color: Pallete.humanGreen)));
  }

  Widget _updateUserAllergiesBtn(Map userAllergies) {
    return FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          await database.updateUserAllergy(userAllergies);
          Navigator.of(context).pop();
        },
        child: Text('SAVE', style: TextStyle(color: Pallete.humanGreen)));
  }

  Widget _updateEventAllergensBtn(String eventID, Map allergens){
    return FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          await database.updateEventAllergens(eventID, allergens);
          Navigator.of(context).pop();
        },
        child: Text('SAVE', style: TextStyle(color: Pallete.humanGreen)));
  }
}
