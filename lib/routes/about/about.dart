import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets/appBar/humanaty_appbar.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: HumanatyAppBar(displayBackBtn: true, title: 'About Us'),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('huMANAty', style: TextStyle(fontSize: 24)),
              Text(
                  'connects communities to the Farm to Table ecosystem to improve farm sustainability, drive social impact, economic development and entrepreneurship building a more humane world.'),
              SizedBox(height: SizeConfig.screenHeight * .04),
              Text(
                  'Transforming the future for foodies, positive growth for local farmers, connecting people and cultures around the world through one common ground … FOOD /food/mana. Savoring one fork, meal, conversation and shared experience at a time.'),
              SizedBox(height: SizeConfig.screenHeight * .08),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Pallete.humanGreen,
                    onPressed: () {},
                    child: Text('Join the huMANAty community today!',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image(
                            width: SizeConfig.screenWidth * .2,
                            image: AssetImage(
                                'assets/images/world_central_kitchen/wck_horizontal.png'),
                          ),
                          Container(
                            width: SizeConfig.screenWidth * .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Proud Sponsor of World Central Kitchen')
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }


  void _launchUrl() async{
    var url = 'www.wck.org';
    if(await canLaunch(url)) await launch(url);
  }
  
}
