import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:humanaty/common/design.dart';

class FilterDate extends StatefulWidget {
  List<DateTime> selectedDates;
  FilterDate({this.selectedDates});
  _FilterDateState createState() => _FilterDateState();
}

class _FilterDateState extends State<FilterDate> {
  DateTime _currentDate;
  EventList<Event> _marked;
  
  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _marked = _createMarked();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black54),
                  onPressed:() => Navigator.of(context).pop(),),
                Text('Selected Dates', style: TextStyle(fontSize: 20, color: Colors.black)),
                IconButton(
                  icon: Icon(Icons.check, color: Colors.black54,),
                  onPressed:() => Navigator.of(context).pop(markedDates))],),
          ),
          Container(
            height: 300, 
            width: double.infinity,
            child: _calendar(context))],
      ),
    );
  }

  Widget _calendar(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: CalendarCarousel(
        headerMargin: EdgeInsets.only(top: 8.0, bottom: 16.0),
        todayButtonColor: Colors.transparent,
        todayTextStyle: TextStyle(color: Colors.black),
        weekendTextStyle: TextStyle(color: Colors.black),
        headerTextStyle: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Nuninto_Sans'),
        iconColor: Pallete.humanGreen,
        weekdayTextStyle: TextStyle(color: Colors.black),
        onDayPressed: (DateTime date, List _){
          if(_marked.removeAll(date).isEmpty) _marked.add(date, Event(date: date));  
          this.setState((){_currentDate = date;});
        },
        markedDateShowIcon: true,
        markedDatesMap: _marked,
        showIconBehindDayText: true,
        markedDateCustomTextStyle: TextStyle(color: Colors.white),  
        markedDateIconBuilder: _markedDate,
      ),
    ); 
  }

  Widget _markedDate(Event event){
    return Container(
      decoration: BoxDecoration(
        color: Pallete.humanGreen,
        shape: BoxShape.circle
      ),
    );
  }
  
  List<DateTime> get markedDates => _marked.events.keys.toList();
  
  EventList<Event> _createMarked(){
    EventList<Event> _intialMarked = EventList<Event>(events: {});
    if(widget.selectedDates == null) return _intialMarked;
    for(int i = 0; i < widget.selectedDates.length; i++){
      DateTime _date = widget.selectedDates[i];
      _intialMarked.add(_date, Event(date: _date));
    }
    print('test');
    print(_intialMarked.events);
    return _intialMarked;
  }

}
