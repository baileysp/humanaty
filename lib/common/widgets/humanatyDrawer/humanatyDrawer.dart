import 'package:flutter/material.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';

class HumanatyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);
    return Drawer(
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget> [
            DrawerHeader(child: Text("Drawer"),),
            ListTile(
              title: Text('First Menu Item'),
              onTap: () {},
            ),
            ListTile(
              title: Text(user.status == Status.Anon ? "Login" : "Sign Out"),
              onTap: () {
                Navigator.pop(context);
                user.signOut();
                //Provider.of<AuthService>(context, listen: false).signOut();
              },
            ),
            Divider(),
            ListTile(
              title: Text('About'),
              onTap: () {},
            ),
          ],
        )
      );
  }
}