import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets/AppBar/appbar.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';

class AllergyPage extends StatefulWidget{
  final AuthService auth;
  final Map userAllergies;
  const AllergyPage({Key key, this.auth, this.userAllergies}): super(key: key);
  
  @override
  _AllergyPageState createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: "Edit Allergies", actions: [updateAllergies(context, widget.auth, widget.userAllergies)]),
      body: ListView.builder(
        itemCount: widget.userAllergies.length,
        itemBuilder: (context, index){
          String _key = widget.userAllergies.keys.elementAt(index);
          return ListTile(
            title: Text(_key),
            trailing: Visibility(
              visible: widget.userAllergies[_key],
              child: Icon(Icons.check, color: Pallete.humanGreen        
            )),
            onTap: (){setState(() {
              widget.userAllergies[_key] = !widget.userAllergies[_key];
            });},
          );
        }
    ));
  }
}

Widget updateAllergies(BuildContext context, AuthService auth, Map userAllergies){
  return FlatButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onPressed: () async {
      await DatabaseService(uid: auth.user.uid).updateAllergyData(userAllergies);
      Navigator.of(context).pop();},
    //color: Pallete.humanGreen,
    child: Text("Update", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)));
}