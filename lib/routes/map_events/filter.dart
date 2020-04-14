import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/size_config.dart';


class Filter extends StatefulWidget {
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  RangeValues _values;
  List<String> _allergies;
  int _availableSeats;
  int _maxSeats;
  bool _access;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(0, 100);
    _allergies = [];
    _availableSeats = 1;
    _maxSeats = 20;
    _access = false;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);

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
                      color: Pallete.humanGreen,
                    ),
                    onPressed: () => Navigator.of(context).pop())
              ],
            ),
          ),
          _priceTile(_values),
          _seatsAvailable(),
          _allergyTile(auth),
          _accessibility(_access),
          _reset()
        ],
      ),
    );
  }

  Widget _priceTile(RangeValues values) {
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
            Text(_roundedRange(values))
          ],
        ),
        RangeSlider(
            values: values,
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

  Widget _allergyTile(AuthService auth) {
    return ListTile(
      title: Text('Allergies'),
      trailing: Icon(Icons.arrow_forward),
      subtitle: Text('${Allergy().formattedStringFromList(_allergies)}'),
      isThreeLine: _allergies.isNotEmpty,
      onTap: () async {
        List allergies = await showModalBottomSheet<List>(
            context: context,
            builder: (context) {
              return AllergyEdit(
                allergyMap: Allergy().allergyMapFromList(_allergies),
                updateUserProfile: false,
              );
            },
            backgroundColor: Colors.white);
        if (allergies != null) {
          setState(() {
            _allergies = allergies;
          });
        }
      },
    );
  }

  Widget _seatsAvailable() {
    return ListTile(
        title: Text('Available Seats: $_availableSeats'),
        trailing: Container(
          width: SizeConfig.screenWidth * .5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 30,
                child: IconButton(
                    onPressed: () {
                      if (_availableSeats < _maxSeats) {
                        setState(() {
                          _availableSeats += 1;
                        });
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    icon: Icon(
                      Icons.add,
                      color: Pallete.humanGreen,
                      size: 24,
                    )),
              ),
              Container(
                width: 30,
                child: IconButton(
                  
                    onPressed: () {
                      if (_availableSeats - 1 > 0) {
                        setState(() {
                          _availableSeats -= 1;
                        });
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    icon: Icon(Icons.remove, color: Pallete.humanGreen, size: 24)),
              )
            ],
          ),
        ));
  }

  Widget _accessibility(bool access){
    return ListTile(
      title: Text('Accessibility Accomodations'),
      trailing: Icon(access ? Icons.accessible_forward : Icons.accessibility_new,
                color: access ? Pallete.humanGreen : Colors.black54),
      onTap: (){
        setState(() {
          _access = !_access;
        });
      },
    );
  }
 
  Widget _reset(){
    return RaisedButton(
      color: Pallete.humanGreen,
      onPressed: (){
        setState(() {
          _values = RangeValues(0, 100);
          _allergies = [];
          _availableSeats = 1;
          _maxSeats = 20;
          _access = false;
        });
      },
      child: Text('Reset Filters', style: TextStyle(fontSize: 16.0, color: Colors.white))
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
