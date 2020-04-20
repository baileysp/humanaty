import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/humanaty_mode.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/logger.dart';
class HumanatyDrawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    HumanatyMode mode = Provider.of<HumanatyMode>(context);
    Logger log = getLogger('HumanatyDrawer');
    SizeConfig().init(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: auth.user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData || auth.isAnonUser()) {
            UserData userData = snapshot.data;
            return _drawer(context, auth, userData, mode, log);
          }
          else return Drawer();
        });
  }

  Widget _drawer(BuildContext context, AuthService auth, UserData userData,
      HumanatyMode mode, Logger log) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                DrawerHeader(
                  child: auth.isAnonUser()
                    ? _anonHeader()
                    : _userHeader(context, userData),
              ),
              _profileTile(context, auth, userData),
              _settingsTile(context, userData),
              _aboutTile(context),
              _contactTile(context),
              auth.isAnonUser() 
                ? _loginTile(context, auth)
                : SizedBox.shrink(),
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _switchModeTile(context, mode, log)))
        ],
      ),
    ));
  }

  Widget _anonHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(image: AssetImage('assets/images/logo/temporary_logo.png'), color: Pallete.humanGreen,),
          Text('Welcome to huMANAty', style: TextStyle(fontSize: 20)),
        ],
      )
    );
  }

  Widget _userHeader(BuildContext context, UserData userData) {
    String _displayName = userData.displayName;
    String _firstName = _displayName.substring(0, _displayName.contains(' ') ? _displayName.indexOf(' ') : _displayName.length);
    int cutoff = _firstName.length > 20 ? 20 : _firstName.length;
    _firstName = _firstName.substring(0, cutoff);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed('/profile');
          },
          child: CircleAvatar(
              radius: 70,
              backgroundColor: Pallete.humanGreen54,
              backgroundImage: NetworkImage(userData.photoUrl)),
        ),
        SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth * .3,
              child: FittedBox(child: Text(_firstName, style: TextStyle(fontSize: 24), textAlign: TextAlign.center,)),
            ),
            HumanatyRating(rating: userData.guestRating, starSize: 15)
          ],
        )
      ],
    );
  }

  Widget _profileTile(
      BuildContext context, AuthService auth, UserData userData) {
    return ListTile(
      title: Text('Profile', style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        auth.isAnonUser()
            ? Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red.withOpacity(.54),
                content: Text('Please Log-In to view your profile')))
            : Navigator.of(context).pushNamed('/profile');
      },
    );
  }

  Widget _settingsTile(BuildContext context, UserData userData) {
    return ListTile(
      title: Text('Settings', style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.of(context).pushNamed('/settings');
      },
    );
  }

  Widget _loginTile(BuildContext context, AuthService auth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          RaisedButton(
            color: Pallete.humanGreen,
            child: Text('Login',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              auth.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _aboutTile(BuildContext context) {
    return ListTile(
      title: Text('About', style: TextStyle(fontSize: 16)),
      onTap: () => Navigator.of(context).pushNamed('/about'),
    );
  }

  Widget _contactTile(BuildContext context) {
    return ListTile(
        title: Text('Contact Us', style: TextStyle(fontSize: 16)),
        onTap: () => Navigator.of(context).pushNamed('/contact')
        //uploadFarms()
        );
  }

  Widget _switchModeTile(BuildContext context, HumanatyMode mode, Logger log) {
    SvgPicture chefHat = SvgPicture.asset('assets/chef-hat.svg',
        width: 24, color: Colors.black54);
    return Container(
      color: Pallete.humanGreen54,
      child: ListTile(
        trailing: mode.isHostMode() ? chefHat : Icon(Icons.local_dining),
        title: Text(
            mode.isHostMode()
                ? 'Switch to Guest'
                : mode.isConsumerMode() ? 'Switch to Host' : '',
            style: TextStyle(fontSize: 16)),
        onTap: () {
          log.v('User switching mode');
          Navigator.pop(context);
          mode.switchMode();
        },
      ),
    );
  }
}
