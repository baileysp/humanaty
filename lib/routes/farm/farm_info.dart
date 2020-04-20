import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/logger.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class FarmInfo extends StatefulWidget {
  final String farmID;
  FarmInfo({this.farmID});
  @override
  _FarmInfoState createState() => _FarmInfoState();
}

class _FarmInfoState extends State<FarmInfo>{
  AuthService auth;
  DatabaseService database;
  Logger log;
  
  @override
  void initState() {
    log = getLogger('FarmInfo');
    super.initState();
  }
  
 @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    database = DatabaseService(uid: auth.user.uid);
    SizeConfig().init(context);

    return StreamBuilder<HumanatyFarm>(
      stream: database.getFarm(widget.farmID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _build(snapshot.data);
        } else {
          return Scaffold(
            appBar: HumanatyAppBar(backgroundColor: Pallete.humanGreen, displayBackBtn: true),
            body: Loading());
        }
      }
    );
  }

  Widget _build(HumanatyFarm farm){
    return Scaffold(
      appBar: HumanatyAppBar(backgroundColor: Pallete.humanGreen, displayBackBtn: true, title: '${farm.name}', titleStyle: TextStyle(color: Colors.white)),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
        child: Column(
          children: <Widget>[
            _location(farm.location.address, farm.location.city, farm.location.state),
            Divider(),
            _contact(farm.website),
            _affiliate()
          ],
        ),
      )
    );
  }

  Widget _location(String address, String city, String state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Location', style: TextStyle(fontSize: 17)),
            Row(
              children: <Widget>[
                Icon(Icons.location_on, color: Pallete.humanGreen54),
                Text('$city, $state')
              ],
            )
          ],
        ),
        Text('$address')
      ],
    );
  }

  Widget _contact(String website){
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: <Widget>[
          Text('Contact Info', style: TextStyle(fontSize: 17)),
          Text('$website')
        ],
      ),
    );
  }

  Widget _affiliate(){
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text('Proud huMANAty Farm Affiliate since 2020')),
    );
  }
}