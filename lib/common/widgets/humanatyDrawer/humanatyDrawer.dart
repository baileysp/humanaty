import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets/loading/loading.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/home/home.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/routes/profile/profile.dart';

class HumanatyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: _auth.user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData || _auth.status == Status.Anon) {
          UserData userData = snapshot.data;
          return drawer(_auth, userData, context);
        }
        //Navigator.pop(context);
        //_auth.signOut();
        return Loading();
      });
  }

  Widget drawer(AuthService _auth, UserData userData, BuildContext context) {
    return Drawer(
        child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
        DrawerHeader(
          child: Text(_auth.status == Status.Anon ? 'Welcome Anon' : 'Welcome '+ userData.displayName,
          style: TextStyle(fontSize: 16),),
        ),
        ListTile(
          title: Text('Profile'),
          onTap: () {
            if (_auth.status == Status.Anon) {
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Please Log-In to view your profile"),
              ));
            } else {
              print("We at least get to here");
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            }
          },
        ),
        ListTile(
          title: Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          title: Text(_auth.status == Status.Anon ? "Login" : "Sign Out"),
          onTap: () {
            Navigator.pop(context);
            _auth.signOut();
            //Provider.of<AuthService>(context, listen: false).signOut();
          },
        ),
        Divider(),
        ListTile(
          title: Text('About'),
          onTap: () {},
        ),
      ],
    ));
  }
}
