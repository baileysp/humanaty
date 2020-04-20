import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/util/size_config.dart';


class ProfileDisplay extends StatelessWidget{
  final Profile profile;
  final int guests;
  ProfileDisplay({this.profile, this.guests});  
  
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      appBar: HumanatyAppBar(displayCloseBtn: true,),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            _header(profile.displayName, profile.photoUrl),
            SizedBox(height: SizeConfig.screenHeight * .025),
            _aboutMe(profile.aboutMe),
            Divider(),
            _guests(guests)
          ],
        ),
      )
    );
  }

  Widget _header(String displayName, String photoUrl) {
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipOval(
            child: Material(
              child: CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(photoUrl),
                backgroundColor: Pallete.humanGreen54,
              ),
            ),
          ),
        Text('$displayName', style: TextStyle(fontSize: 20)) 
        ],
      ),
    );
  }

  Widget _aboutMe(String aboutMe) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('AboutMe', style: TextStyle(color: Colors.black54)),
            Text('$aboutMe'),
          ],
        ));
  }

  Widget _guests(int guests){
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Guests', style: TextStyle(color: Colors.black54)),
            Text('Bringing $guests of their friends'),
          ],
        ));
  
  }
}