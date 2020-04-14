import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:humanaty/util/validator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  final DateTime eventDate;
  const CreateEvent({Key key, this.eventDate}) : super(key: key);
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _menuController;
  TextEditingController _capacityController;
  TextEditingController _costController;
    
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _menuFocus = FocusNode();
  final FocusNode _capacityFocus = FocusNode();
  final FocusNode _pricePerGuestFocus = FocusNode();

  final _createEventFormKey = GlobalKey<FormState>();

  DateTime _eventDate;
  List<String> _allergies;
  HumanatyLocation _location;
  bool _accessibilityAccommodations;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _menuController = TextEditingController();  
    _eventDate = widget.eventDate;
    _allergies = [];
    _capacityController = TextEditingController(text: '0');
    _costController = TextEditingController(text: '0');
    _location = HumanatyLocation();
    _accessibilityAccommodations = false;
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);
    return Scaffold(
        appBar: HumanatyAppBar(displayBackBtn: true, title: 'Create Event'),
        body: ListView(
          children: <Widget>[
            Form(
              key: _createEventFormKey,
              child: Column(
              children: <Widget>[
                _titleTile(),
                _descriptionTile(),
                _dateTile(),
                _menuTile(),
                _allergiesTile(_auth),
                _capacityTile(),
                _costTile(),
                _accessibilityTile(),
                _locationTile(),
                _createEvent(context,  _auth)
              ],
            ))
          ],
        ));
  }

  Widget _titleTile() {
    return ListTile(
      title: Text('Event Title'),
      trailing: SizedBox(
          width: SizeConfig.screenWidth * .5,
          child: TextFormField(
            controller: _titleController,
            cursorColor: Pallete.humanGreen,
            decoration: eventInputDecoration,
            focusNode: _titleFocus,
            onFieldSubmitted: (term) {_fieldFocusChange(context, _titleFocus, _descriptionFocus);},
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.next,
            validator: notEmpty,
          )),
      onTap: () => FocusScope.of(context).requestFocus(_titleFocus),
    );
  }

  Widget _descriptionTile() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Description'),
          onTap: () => FocusScope.of(context).requestFocus(_descriptionFocus),
        ),
        SizedBox(
          width: SizeConfig.screenWidth - 32,
          child: TextFormField(
              controller: _descriptionController,
              decoration: eventInputDecoration,
              focusNode: _descriptionFocus,
              keyboardType: TextInputType.multiline,
              maxLines: 4, minLines: 2,              
              textInputAction: TextInputAction.done),
        )
      ],
    );
  }

  Widget _dateTile() {
    var f = DateFormat.yMMMd().add_jm();
    return ListTile(
      title: Text('Event Date'),
      trailing: Text('${f.format(_eventDate)}'),
      onTap: () {
        DatePicker.showTimePicker(context,
            currentTime: _eventDate,
            showSecondsColumn: false, onConfirm: (date) {
          setState(() {
            _eventDate = date;
          });
        },
            theme: DatePickerTheme(
                itemStyle: TextStyle(color: Colors.black),
                doneStyle: TextStyle(color: Pallete.humanGreen)));
      },
    );
  }

  Widget _menuTile() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Menu'),
          onTap: () => FocusScope.of(context).requestFocus(_menuFocus),
        ),
        SizedBox(
          //height: SizeConfig.screenHeight * .3,
          width: SizeConfig.screenWidth - 32,
          child: TextFormField(
              controller: _menuController,
              decoration: eventInputDecoration,
              focusNode: _menuFocus,
              keyboardType: TextInputType.multiline,
              maxLines: 8,minLines: 4,              
              textInputAction: TextInputAction.done,              
              validator: notEmpty,),
        )
      ],
    );
  }

  Widget _allergiesTile(AuthService _auth) {
    return ListTile(
      title: Text('Allergens present'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () async {
        List<String> selectedAllergies = await Navigator.of(context).pushNamed('/allergy_edit', 
        arguments: {'allergyMap': Allergy().allergyMapFromList(_allergies),
                    'updateUserProfile': false});
        if (selectedAllergies != null) {
          setState(() {
            _allergies = selectedAllergies;
          });
        }
      },
    );
  }

  Widget _capacityTile() {
    return ListTile(
      title: Text('Maximum number of Guests'),
      trailing: SizedBox(
        width: SizeConfig.screenWidth * .13,
        child: TextFormField(
          controller: _capacityController,
          cursorColor: Pallete.humanGreen,
          decoration: eventInputDecoration,
          focusNode: _capacityFocus,
          keyboardType: TextInputType.number,
          onFieldSubmitted: (term) {_fieldFocusChange(context, _capacityFocus, _pricePerGuestFocus);},      
          textAlign: TextAlign.right,
          textInputAction: TextInputAction.next,
          validator: notZero,
        ),
      ),
      onTap: () => FocusScope.of(context).requestFocus(_capacityFocus),
    );
  }

  Widget _costTile() {
    return ListTile(
      title: Text('Price Per Guest'),
      trailing: SizedBox(
        width: SizeConfig.screenWidth * .13,
        child: TextFormField(
          controller: _costController,
          cursorColor: Pallete.humanGreen,
          decoration: eventInputDecoration,
          focusNode: _pricePerGuestFocus,
          maxLines: 1,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.right,
          validator: notZero,
        ),
      ),
      isThreeLine: true,
      subtitle: Text('*Compensation received for each attending guest'),
      onTap: () => FocusScope.of(context).requestFocus(_pricePerGuestFocus),
    );
  }

  Widget _accessibilityTile(){
    return ListTile(
      title: Text('Event Space WheelChair Accesibility'),
      trailing: Icon(
        _accessibilityAccommodations
            ? Icons.accessible_forward
            : Icons.accessibility,
        color: _accessibilityAccommodations
            ? Pallete.humanGreen
            : Colors.black45),
        onTap: () {setState((){ _accessibilityAccommodations = !_accessibilityAccommodations;});},
    );
  }

  Widget _locationTile() {
    return ListTile(
      title: Text('Location'),
      trailing: Text(_location.isEmpty() ? 'Event needs Location' : ''),
      isThreeLine: _location.isEmpty(),
      subtitle: Visibility(visible: _location.isNotEmpty(), child: Text('${_location.address}')),
      onTap: () async{
        String location = await showSearch(context: context, delegate: MapSearch());
        if(location == null) return;
        setState((){_location = HumanatyLocation.fromString(location);});
      },
    );
  }

  Widget _createEvent(BuildContext context, AuthService _auth) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: RaisedButton(
          color: Pallete.humanGreen,
          child: Text(
            'Create Event',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          onPressed: () {
            if(_createEventFormKey.currentState.validate()){
              if(_location.isNotEmpty()){
                 DatabaseService(uid: _auth.user.uid).createEvent(
                  _accessibilityAccommodations,
                  _allergies,
                  double.parse(_costController.text.trim()),
                  _eventDate,
                  _descriptionController.text.trim(),
                  int.parse(_capacityController.text.trim()),
                  _location,
                  _menuController.text.trim(),
                  _titleController.text.trim()
                );
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

   @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _menuController.dispose();
    _capacityFocus.dispose();
    _pricePerGuestFocus.dispose();
    super.dispose();
  }

}




