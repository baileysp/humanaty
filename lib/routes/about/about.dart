import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/size_config.dart';

class About extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);

    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: 'About Us'),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('huMANAty', style: TextStyle(fontSize: 24)),
            Text('connects communities to the Farm to Table ecosystem to improve farm sustainability, drive social impact, economic development and entrepreneurship building a more humane world.'),
            SizedBox(height: SizeConfig.screenHeight * .04),
            Text('Transforming the future for foodies, positive growth for local farmers, connecting people and cultures around the world through one common ground … FOOD /food/mana. Savoring one fork, meal, conversation and shared experience at a time.'),
            SizedBox(height: SizeConfig.screenHeight * .08),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Pallete.humanGreen,
                  onPressed:() => auth.isAnonUser() ? _btnAction(context, auth) : null,
                  child: Text('Join the huMANAty community today!',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            _wck()
          ],
        ),
      )
    );
  }

  Widget _wck(){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
          onTap:() => _launchUrl(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image(
                width: SizeConfig.screenWidth * .2,
                image: AssetImage('assets/images/world_central_kitchen/wck_horizontal.png'),),
              Container(
                width: SizeConfig.screenWidth * .65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Proud Sponsor of World Central Kitchen'),
                    Text('A percentage of all proceeds is donated to WCK', style: TextStyle(color: Colors.black54,fontSize: 12))
                  ],
                ),
              )
            ],
          ),
          )
        ],
      ),
    );
  }

  void _btnAction(BuildContext context, AuthService auth){
    auth.signOut();
    Navigator.pop(context);
  }

  void _launchUrl() async{
    var url = 'www.wck.org';
    if(await canLaunch(url)) await launch(url);
  }
  
}
