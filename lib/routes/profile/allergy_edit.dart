import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';
class AllergyEdit extends StatefulWidget{
  final Map allergyMap;
  final bool updateUserProfile;
  const AllergyEdit({Key key, this.allergyMap, this.updateUserProfile=true}): super(key: key);
  
  @override
  _AllergyEditState createState() => _AllergyEditState();
}
class _AllergyEditState extends State<AllergyEdit> {
  AuthService auth;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: HumanatyAppBar(displayCloseBtn: true, title: 'Edit Allergies', actions: widget.updateUserProfile ? [updateAllergiesBtn(context, auth, widget.allergyMap)] : [returnAllergiesBtn(widget.allergyMap)]),
      body: ListView.builder(
        itemCount: widget.allergyMap.length,
        itemBuilder: (context, index){
          String _key = widget.allergyMap.keys.elementAt(index);
          return ListTile(
            title: Text(_key),
            trailing: Visibility(
              visible: widget.allergyMap[_key],
              child: Icon(Icons.check, color: Pallete.humanGreen)),
            onTap:() {setState((){widget.allergyMap[_key] = !widget.allergyMap[_key];});},
          );
        }
    ));
  }
}


Widget returnAllergiesBtn(Map userAllergies){
  return FlatButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onPressed: () async{
      Navigator.pop(Allergy().allergyListFromMap(userAllergies));
    },
    child: Text('UPDATE', style: TextStyle(color: Pallete.humanGreen))
  );
}

Widget updateAllergiesBtn(BuildContext context, AuthService auth, Map userAllergies){
  return FlatButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onPressed: () async {
      
      await DatabaseService(uid: auth.user.uid).updateAllergyData(userAllergies);
      Navigator.of(context).pop();},
    child: Text('UPDATE', style: TextStyle(color: Pallete.humanGreen)));
}