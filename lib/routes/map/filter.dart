import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black54,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text('Filters',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
                IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.black54,
                    ),
                    onPressed: () => Navigator.of(context).pop())
              ],
            ),
          ),
          _priceTile(context, _values),
          _allergyTile(context, _auth),
          //_seatsAvailable(context)
        ],
      ),
    );
  }

  Widget _priceTile(BuildContext context, RangeValues _values) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Price per guest',
              style: TextStyle(fontSize: 16),
            ),
            Text(_roundedRange(_values))
          ],
        ),
        RangeSlider(
            values: _values,
            onChanged: (value) {
              setState(() {
                this._values = value;
              });
            },
            min: 0,
            max: 100,
            activeColor: Pallete.humanGreen,
            inactiveColor: Pallete.humanGreen54),
      ]),
    );
  }

  Widget _allergyTile(BuildContext context, AuthService _auth) {
    return ListTile(
      title: Text('Allergies'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        //AllergyPage(userAllergies: allergies, auth: _auth))
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return AllergyEdit(
                userAllergies: Allergy().allergyMapFromList([]),
                auth: _auth,
                updateDatabase: false,
              );
            },
            backgroundColor: Colors.white);
      },
    );
  }

  Widget _seatsAvailable(BuildContext context) {
    String dropdownValue = '1';
    return ListTile(
      title: Text('Available Seats'),
      trailing: DropdownButton(
        value: dropdownValue,
        items: <String>['1', '2', '3', '4']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
      ),
    );
  }

  String _roundedRange(RangeValues _values) {
    int startRounded = _values.start.floor();
    int endRounded = _values.end.floor();
    String range = '\$$startRounded-$endRounded';
    if (endRounded == 100) range = range + '+';
    return range;
  }
}
